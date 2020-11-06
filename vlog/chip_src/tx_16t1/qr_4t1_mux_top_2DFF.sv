`timescale 100ps/1ps   //  unit_time / time precision

`default_nettype none

module qr_4t1_mux_top_2DFF (
    input wire logic clk_Q,
    input wire logic clk_QB,
    input wire logic clk_I,
    input wire logic clk_IB, // Four phase clock input from PI+MDLL
    input wire logic [3:0] din,
    input wire logic rst,
    output wire logic data
);

// Instantiate the data path for Q clk path, use the Q clock as the reference clock
wire D0DQ;
ff_c dff_Q0 (.D(din[3]), .CP(clk_Q), .Q(D0DQ));

// Instantiate the data path for I clk path
wire D0DI;
ff_c dff_I0 (.D(din[2]), .CP(clk_I), .Q(D0DI));

// Instantiate the data path for QB clk path
wire D0DQB;
wire D1DQB;
ff_c dff_QB0 (.D(din[1]), .CP(clk_Q), .Q(D0DQB)); // data captured using Q clk and gradually passed to QB clk.
ff_c dff_QB1 (.D(D0DQB), .CP(clk_QB), .Q(D1DQB));

// Instantiate the data path for QB clk path
wire D0DIB;
wire D1DIB;
ff_c dff_IB0 (.D(din[0]), .CP(clk_I), .Q(D0DIB)); // data captured using Q clk and gradually passed to IB clk.
ff_c dff_IB1 (.D(D0DIB), .CP(clk_IB), .Q(D1DIB));

// 4 to 1 mux

assign data = ((clk_Q  & clk_I  & D1DIB) |
               (clk_I  & clk_QB & D0DQ ) |
               (clk_QB & clk_IB & D0DI)  |
               (clk_IB & clk_Q  & D1DQB));



endmodule

`default_nettype wire
