`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.05.2023 11:01:07
// Design Name: 
// Module Name: convolute
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


module convolute #(parameter in_d_W=8, r=3, c=3, in_add_W=4, Timeperiod=10)(
    input clk,clk_en,rst,clr,en_wr,en_rd,wr,en_MAC,en_MAC_out,
    input [(c*r*in_d_W)-1:0] a, b,
    output[((2*in_d_W)+2)-1:0] y
    );
    
    wire [((2**in_add_W)*in_d_W)-1:0] wrow;
    wire [((2**in_add_W)*in_d_W)-1:0] wcol;
    wire [in_add_W-1:0] addr_com;
    wire [in_d_W-1:0] din_r, din_c;
    
    generate
    genvar j;
    for(j=0;j<((2**in_add_W)*in_d_W);j=j+in_d_W)
    begin
        if(j<r*c*in_d_W)
        begin 
            assign wrow[j+in_d_W-1:j] = a[j+in_d_W-1:j];
            assign wcol[j+in_d_W-1:j] = b[j+in_d_W-1:j];
        end
        
        else if(j >= r*c*in_d_W)
        begin 
            assign wrow[j+in_d_W-1:j] = 'd0;
            assign wcol[j+in_d_W-1:j] = 'd0;
        end 
    end
    endgenerate
    
    c_counter_binary_0 common(
      .CLK(clk),    // input wire CLK
      .CE(clk_en),      // input wire CE
      .SCLR(clr),  // input wire SCLR
      .Q(addr_com)        // output wire [3 : 0] Q
    );
    
    mux_g #((in_d_W*(2**in_add_W)), in_add_W) MUXrow(.A(Wrow),.S(addr_com),.Y(din_r));

    mux_g #((in_d_W*(2**in_add_W)),in_add_W) MUXcol(.A(Wcol),.S(addr_com),.Y(din_c));   
    
    matrix_multiplier #(in_d_W,in_add_W,r*c,Timeperiod) DUT(.clk(clk),.rst(rst),.clr(clr),.ena_r(en_wr),.ena_c(en_wr),.enb_r(en_rd),
    .enb_c(en_rd),.wea_r(wr),.wea_c(wr),.din_r(din_r),.din_c(din_c),.addra_r(addr_com),.addrb_r(addr_com),.addra_c(addr_com),
    .addrb_c(addr_com),.en_MAC(en_MAC),.en_MAC_out(en_MAC_out),.y(Y));

endmodule
