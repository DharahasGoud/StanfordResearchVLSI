`timescale 1fs/1fs

`include "mLingua_pwl.vh"
`include "iotype.sv"

module test;

    import const_pack::*;
    import test_pack::*;
    import checker_pack::*;
    import jtag_reg_pack::*;

    localparam `real_t v_cm = 0.40;

    // Analog inputs
    `pwl_t ch_outp;
    `pwl_t ch_outn;
    `voltage_t v_cal;

    // clock inputs 
    logic clk_async;
    logic clk_jm_p;
    logic clk_jm_n;
    logic ext_clkp;
    logic ext_clkn;
    logic signed [Nadc-1:0] adcout_conv_signed [Nti-1:0];

    // clock outputs
    logic clk_out_p;
    logic clk_out_n;
    logic clk_trig_p;
    logic clk_trig_n;
    logic clk_retime;
    logic clk_slow;
    logic rstb;

    // dump control
    logic dump_start;
    logic clk_cdr;

    // JTAG
    jtag_intf jtag_intf_i();

    // Instantiate blocks per output

    logic test_start, test_stop;

    genvar i;
    generate
        for (i=0; i<Nout; i=i+1) begin : glitch_test_gen
            glitch_test #(
            	.freq(4e9),
            	.freq_tol(0.05),
            	.duty(0.5),
            	.duty_tol(0.20)
            ) glitch_test_i (
                .in(top_i.iacore.clk_interp_sw[i]),
                .start(test_start),
                .stop(test_stop)
            );
        end
    endgenerate

    // instantiate top module
    butterphy_top top_i (
        // analog inputs
        .ext_rx_inp(ch_outp),
        .ext_rx_inn(ch_outn),
        .ext_Vcm(v_cm),
        .ext_Vcal(v_cal),

        // clock inputs 
        .ext_clkp(ext_clkp),
        .ext_clkn(ext_clkn),

        // clock outputs
        .clk_out_p(clk_out_p),
        .clk_out_n(clk_out_n),
        .clk_trig_p(clk_trig_p),
        .clk_trig_n(clk_trig_n),

        // dump control
        .ext_dump_start(dump_start),
        .ext_rstb(rstb),

        // JTAG
        .jtag_intf_i(jtag_intf_i)
    );


    clock #(
        .freq(full_rate/2), // Depends on divider!
        .duty(0.5),
        .td(0)
    ) iEXTCLK (
        .ckout(ext_clkp),
        .ckoutb(ext_clkn)
    ); 

    jtag_drv jtag_drv_i (jtag_intf_i);

    // compute stimulus

    logic [Npi-1:0] pi_ctl_stim [Nout-1:0] [(2**Npi-1):0];

    initial begin
    	// fill the pi_ctl_stim array
        for (int i=0; i<2**Npi; i=i+1) begin
            for (int j=0; j<Nout; j=j+1) begin
                pi_ctl_stim[j][i] = i;
            end
        end

        // TODO: shuffle
    end

    // Main test logic

	logic [Npi-1:0] tmp3;
	logic [Npi-1:0] tmp2;
	logic [Npi-1:0] tmp1;
	logic [Npi-1:0] tmp0;

    initial begin
    	test_start = 1'b0;
    	test_stop = 1'b0;
        rstb = 1'b0;
        #(20ns);
        rstb = 1'b1;
        #(20ns);

        // Initialize JTAG
        jtag_drv_i.init();

        // Enable the input buffer
        force top_i.idcore.ddbg_intf_i.Ndiv_clk_cdr = 'd1;
        $display("Enabling input buffer.");
        force top_i.idcore.ddbg_intf_i.int_rstb = 'b1;       
        force top_i.idcore.adbg_intf_i.en_inbuf = 'b1;
         $display("Disabling internal reset.");
        $display("Enabling V2T.");
        force top_i.idcore.adbg_intf_i.en_v2t = 'b1;
        $display("Enabling glitch-free operation.");
        force top_i.idcore.adbg_intf_i.en_gf = 'b1;

        // wait a bit
        #(100ns);

        // run desired number of trials
        for (int i=0; i<2**Npi; i=i+1) begin
        	$display("Trial %0d/%0d", i, 2**Npi);

            // write PI codes (the temp variables are needed due to
            // a limitation in a commercial simulator)
            tmp3 = pi_ctl_stim[3][i];
            tmp2 = pi_ctl_stim[2][i];
            tmp1 = pi_ctl_stim[1][i];
            tmp0 = pi_ctl_stim[0][i];
            force top_i.idcore.ddbg_intf_i.ext_pi_ctl_offset = '{tmp3, tmp2, tmp1, tmp0};

            // wait
            #(10ns);

            // start monitoring
            test_start = 'b1;
            #0;
            test_start = 'b0;
            #0;

            // wait while monitoring
            #(20ns);

            // stop monitoring
            test_stop = 'b1;
            #0;
            test_stop = 'b0;
            #0;
        end

        $finish;
    end

endmodule