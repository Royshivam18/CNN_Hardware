`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.05.2023 12:40:43
// Design Name: 
// Module Name: sliding_window
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


module sliding_window #(parameter in_d_w=8,in_add_w=4,r_n=5,c_n=5,r_f=3,c_f=3,p=0,s=1,Timeperiod=10)(
    input clk,clk_en,rst,clr,en_wr,en_rd,wr,en_MAC,en_MAC_out,
    input [(c_n*r_n*in_d_w)-1:0] N,
    input [(c_f*r_f*in_d_w)-1:0] F,
    output [((2*in_d_w)+2)*(((r_n+(2*p)-r_f)/s)+1)*(((c_n+(2*p)-c_f)/s)+1)-1:0] y
    );
    parameter r_o = (((r_n + (2*p) - r_f)/s)+1);
    parameter c_o = (((c_n + (2*p) - c_f)/s)+1);
    parameter out_d_w = ((2*in_d_w)+2);
    wire [(in_d_w*r_o)-1:0]z[0:(c_n-1)];
    wire [(in_d_w*r_f*c_f)-1:0]a[0:((r_o*c_o)-1)];
    wire [out_d_w-1:0] w [0:(r_o*c_o)-1];
    
    generate 
    genvar i,j;
    for(i=0;i<c_n;i=i+1)
        begin
            for(j=(r_o*i); j<(r_o+(r_o*i)); j=j+1)
            begin
                assign z[j] = N[((r_o*in_d_w)+(in_d_w*(j+(i*(r_f-1))))-1):(in_d_w*(j+(i*(r_f-1))))];
            end 
        end 
    endgenerate
    
    generate
    genvar q,r;
    for(q=0; q<(r_o*c_o); q=q+1)
    begin
        for(r=0; r<(r_f*c_f*in_d_w); r=r+(r_f*in_d_w))
        begin
            assign a[q][(r+(r_f*in_d_w)-1):r]=z[q+(r_o*r/(r_f*in_d_w))];
        end 
    end 
    endgenerate
    
    generate 
    genvar t;
    for(t=0; t<(r_o*c_o); t=t+1)
    begin
        assign y[(out_d_w+(t*out_d_w))-1 :(t*out_d_w)] = w[t];
    end 
    endgenerate
    
    
    generate
    genvar u;
    for(u=0; u<(r_o*c_o); u=u+1)
    begin
        conv #(in_d_w, r_f, c_f, in_add_w, Timeperiod)
        CV(.clk(clk),.clk_en(clk_en),.rst(rst),.clr(clr),.en_wr(en_wr),.en_rd(en_rd),.wr(wr),.en_MAC(en_MAC),
        .en_MAC_out(en_MAC_out),.A(a[r]),.B(F),.Y(w[r]));
    end
    endgenerate 
endmodule
