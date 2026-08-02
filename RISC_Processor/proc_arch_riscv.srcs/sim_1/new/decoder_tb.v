`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/20/2026 02:26:26 PM
// Design Name: 
// Module Name: decoder_tb
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


module decoder_tb(

    );
    
    reg clock;
    reg rd_write_en_from_wb;
    reg [31:0] rd_write_data_from_wb;
    reg [31:0] inst;
    
    wire [31:0] d_au_in1, d_au_in2;	//operand -1 & operand -2 for data arithmetic unit
    wire d_au_in1_type, d_au_in2_type;	//type of operand -1 and  operand - 2 (unsigned/signed: 0/1)
    wire d_au_op;		//operation by data arithmetic unit (add/sub : 0/1)
    wire [31:0] logic_unit_in1, logic_unit_in2;	// input operands for logic unit
    wire [1:0] logic_unit_op;	//operation performed by logic unit
    wire [31:0] shift_unit_in1;	//operand to be shifted
    wire [4:0] shift_unit_in2;	//shift amount
    wire [1:0] shift_unit_op;		//type of shift to be performed
    wire [31:0] a_au_in1, a_au_in2;	//operand-1 & operand-2 for address arithmetic unit
    wire fmt_r, fmt_il, fmt_s;		//fmt r, fmt il, fmt s instruction (no/yes: 0/1)
    wire [2:0] funct3;			//funct3 bits: inst [14:12]
    wire[31:0] d_mem_write_data;	//data for write operation to data memory
    wire d_mem_en, d_mem_write_en;	//enable and write enable inputs for data memory
    wire [4:0] rd;				//destination register for the instruction
    wire write_ex_result_to_rd, write_d_mem_out_to_rd;

    decoder_r_ld_st decoder_block(.clock(clock),.rd_write_en_from_wb(rd_write_en_from_wb),.rd_write_data_from_wb(rd_write_data_from_wb),
    .inst(inst),.d_au_in1(d_au_in1),.d_au_in2(d_au_in2),.d_au_in1_type(d_au_in1_type),.d_au_in2_type(d_au_in2_type),.d_au_op(d_au_op),.logic_unit_in1(logic_unit_in1),
    .logic_unit_in2(logic_unit_in2),.logic_unit_op(logic_unit_op),.shift_unit_in1(shift_unit_in1),.shift_unit_in2(shift_unit_in2),.shift_unit_op(shift_unit_op),.a_au_in1(a_au_in1),
    .a_au_in2(a_au_in2),.fmt_r(fmt_r),.fmt_il(fmt_il),.fmt_s(fmt_s),.funct3(funct3),.d_mem_write_data(d_mem_write_data),.d_mem_en(d_mem_en),.d_mem_write_en(d_mem_write_en),
    .rd(rd),.write_ex_result_to_rd(write_ex_result_to_rd),.write_d_mem_out_to_rd(write_d_mem_out_to_rd));
    
    always #5 clock=~clock;
    
    initial begin 
        clock=0;
        rd_write_en_from_wb=0;
        rd_write_data_from_wb=0;
//        inst=32'b0000000_00010_00001_000_00011_0110011;
        inst=32'b0000000_00010_00001_011_00011_0110011; 
        #25;    
        $finish;
    end
endmodule
