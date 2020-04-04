
module PFD (input TinP, input TinN, input rstb, output Tout, output sign, output arb_out_dmm);


reg TinP_sampled, TinN_sampled;
wire and_out, or_out;
wire ff_rst, and_out_delayed, arbiter_clk;

assign and_out = (TinP_sampled&TinN_sampled);
assign Tout = (TinP_sampled|TinN_sampled);
assign ff_rst = (and_out_delayed|~rstb);

//inv_chain #(.Ninv(2)) iinv_chain1(.in(and_out), .out(arbiter_clk));
//inv_chain #(.Ninv(2)) iinv_chain2(.in(arbiter_clk), .out(and_out_delayed));
inv_chain #(.Ninv(4)) iinv_chain(.in(and_out), .out(and_out_delayed));
assign arbiter_clk = and_out_delayed;

arbiter iarbiter (.in1(TinP_sampled), .in2(TinN_sampled), .clk(arbiter_clk), .out(sign), .out_dmm(arb_out_dmm));

always @(posedge TinP or posedge ff_rst) if (ff_rst) TinP_sampled <=0; else TinP_sampled <=1; 
always @(posedge TinN or posedge ff_rst) if (ff_rst) TinN_sampled <=0; else TinN_sampled <=1; 


endmodule

