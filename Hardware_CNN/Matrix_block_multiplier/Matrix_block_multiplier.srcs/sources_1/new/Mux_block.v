`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.05.2023 10:46:36
// Design Name: 
// Module Name: Mux_block
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Mux_block#(parameter In_d_W=16*8, S_W=4)(
    input [In_d_W-1:0] a,
    input [S_W-1:0] S,
    output [(In_d_W-1/2**S_W)-1:0] y
    );
    parameter out_d_W=In_d_W/(2**S_W);
    wire [out_d_W-1:0] W [0:(2**S_W)];
    generate 
    genvar i;
    for(i=0; i<(2**S_W); i=i+1)
    begin
        assign W[i]=a[(i*out_d_W)+out_d_W-1 : i*out_d_W];
    end
    endgenerate
    assign y=W[S];
endmodule
