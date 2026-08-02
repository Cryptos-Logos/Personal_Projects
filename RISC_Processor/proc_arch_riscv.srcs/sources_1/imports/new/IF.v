`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/02/2026 02:40:17 PM
// Design Name: 
// Module Name: IF
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


module IF(
    input B_dec,fetch_enable,
    input [9:0] B_target,
    input clk,clear,
    output [9:0] IF_ID_PC,
    output [31:0] IF_ID_ins

    );
       
    reg [9:0] mux_out,adder_out;
    reg [31:0] ins_out_reg;
    reg [9:0] old_pc;
    reg fetch_enable_1;
    wire [31:0]ins_out;
    
    IF_rom ROM (
        .add(mux_out),
        .enable(fetch_enable),
        .clk(clk),
        .dout(ins_out)
    );
    assign IF_ID_ins=fetch_enable?ins_out:ins_out_reg;
    assign IF_ID_PC = old_pc;
    always @(*) begin
        adder_out=old_pc+{29'b0,( 1'b0),2'b01};
//        mux_out=(B_dec?B_target:(fetch_enable?adder_out:mux_out));
            mux_out=(B_dec?B_target:adder_out);
    end
    
    always @(posedge clk) begin 
        old_pc<= ((~clear)?(fetch_enable?mux_out:old_pc):10'd0);
        ins_out_reg<=clear?32'b0:(fetch_enable_1?ins_out:ins_out_reg);
        fetch_enable_1<=(clear)?1'b0:fetch_enable;
        
        //IF_ID_PC<=clear?10'b0:(fetch_enable_1?old_pc:IF_ID_PC);
    end
endmodule

//for prim registers enable
/*     synthesis implementation
LUT 17 17
FF 21 21
BRAM 1 1
WNS 6.108 6.131
WHS 0.15 0.223
Dyn P 0.106 0.105
STAt P 0.107 0.107 */     
