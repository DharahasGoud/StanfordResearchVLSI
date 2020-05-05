/****************************************************************

Copyright (c) #YEAR# #LICENSOR#. All rights reserved.

The information and source code contained herein is the 
property of #LICENSOR#, and may not be disclosed or
reproduced in whole or in part without explicit written 
authorization from #LICENSOR#.

* Filename   : mdll_latn_sr.sv
* Author     : Byongchan Lim (bclim@alumni.stanford.edu)
* Description:
  - D latch with active low enable signal, async set, reset

* Note       :
  -

* Todo       :
  -

* Fixme      :
  -

* Revision   :
  - 00/00/00: Initial commit

****************************************************************/


module mdll_latn_sr #(
// parameters here

) (
// I/Os here
    input D,
    input GN,
    input SETN,
    input RESETN,
    output Q
);

timeunit 1fs;
timeprecision 1fs;

//---------------------
// VARIABLES, WIRES
//---------------------


//---------------------
// INSTANTIATION
//---------------------

`ifndef SIMULATION
    LATN_SR_LVT uLAT ( .D(D), .GN(GN), .SETN(SETN), .RESETN(RESETN), .Q(Q) );
`endif

//---------------------
// COMBINATIONAL
//---------------------


//---------------------
// SEQ
//---------------------


//---------------------
// OTHERS
//---------------------

// synopsys translate_off

reg Q_reg;
assign Q = Q_reg;

always @* begin
    if (~SETN) Q_reg <= 1'b1;
    else if (~RESETN) Q_reg <= 1'b0;
    else if (~GN) Q_reg <= D;
end

// synopsys translate_on

endmodule

