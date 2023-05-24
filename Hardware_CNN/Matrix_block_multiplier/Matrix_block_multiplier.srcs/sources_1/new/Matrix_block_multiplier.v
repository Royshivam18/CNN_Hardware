`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.05.2023 20:40:34
// Design Name: 
// Module Name: Matrix_block_multiplier
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


module Matrix_block_multiplier #(parameter I_W = 8,In_D_Add_W=4,In_Items=6,Timeperiod=10)(
    input clk,
    input ena_b, enc_f,
    input wea_b, wea_f,
    input [In_D_Add_W-1:0] addra_b, addra_f,
    input signed [I_W-1:0] dina_b, dina_f,
    input enb_b, enb_f,
    input [In_D_Add_W-1:0] addrb_b, addrb_f,
    input en_mac, en_mac_out, clr, rst,
    output signed [((2*I_W)+2)-1:0] y
    );
    
    wire [In_D_Add_W-1:0] addr_b,addr_f;
    wire [I_W-1:0] block_in,filter_in;
    
    blk_mem_gen_0 block (
        .clka(clk),    // input wire clka
        .ena(ena_b),      // input wire ena
        .wea(wea_b),      // input wire [0 : 0] wea
        .addra(addra_b),  // input wire [3 : 0] addra
        .dina(din_b),    // input wire [7 : 0] dina
        .clkb(clk),    // input wire clkb
        .enb(enb_b),      // input wire enb
        .addrb(addrb_b),  // input wire [3 : 0] addrb
        .doutb(block_in)  // output wire [7 : 0] doutb
    );
    
    blk_mem_gen_0 filter (
        .clka(clk),    // input wire clka
        .ena(ena_f),      // input wire ena
        .wea(wea_f),      // input wire [0 : 0] wea
        .addra(addra_f),  // input wire [3 : 0] addra
        .dina(din_f),    // input wire [7 : 0] dina
        .clkb(clk),    // input wire clkb
        .enb(enb_f),      // input wire enb
        .addrb(addrb_f),  // input wire [3 : 0] addrb
        .doutb(filter_in)  // output wire [7 : 0] doutb
    );
    
    Mac_multiplier #(I_W)
    MAC(.clk(clk),.rst(rst),.clr(clr),.en_MAC(en_MAC),.A(block_in),.B(filter_in),.en_MAC_out(en_MAC_out),.Y(y)); 
    

    
    
endmodule
