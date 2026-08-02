`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/27/2026 01:57:53 PM
// Design Name: 
// Module Name: decod_and_EXEC
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


module TOP( reset,clock);
    input reset;
//    input [31:0] inst; 		//instruction (binary code) input
//    input [31:0] rd_write_data_from_wb;	//write data for rd from write back stage 
//    input rd_write_en_from_wb;		//register file write enable from write back stage
    input clock; 				//clock signal
    
//    output [31:0] d_au_in1, d_au_in2;	//operand -1 & operand -2 for data arithmetic unit
//    output d_au_in1_type, d_au_in2_type;	//type of operand -1 and  operand - 2 (unsigned/signed: 0/1)
//    output d_au_op;		//operation by data arithmetic unit (add/sub : 0/1)
//    output [31:0] logic_unit_in1, logic_unit_in2;	// input operands for logic unit
//    output [1:0] logic_unit_op;	//operation performed by logic unit
//    output [31:0] shift_unit_in1;	//operand to be shifted
//    output [4:0] shift_unit_in2;	//shift amount
//    output [1:0] shift_unit_op;		//type of shift to be performed
//    output [31:0] a_au_in1, a_au_in2;	//operand-1 & operand-2 for address arithmetic unit
//    output fmt_r, fmt_il, fmt_s;		//fmt r, fmt il, fmt s instruction (no/yes: 0/1)
//    output [2:0] funct3;			//funct3 bits: inst [14:12]
//    output[31:0] d_mem_write_data;	//data for write operation to data memory
//    output d_mem_en, d_mem_write_en;	//enable and write enable inputs for data memory
//    output [4:0] rd;				//destination register for the instruction
//    output write_ex_result_to_rd, write_d_mem_out_to_rd;
//    //write ex unit result to rd, write data memory read operation result to rd: (no/yes: 0/1)
    
    wire [31:0] d_au_in1, d_au_in2;	//operand -1 & operand -2 for data arithmetic unit
    wire d_au_in1_type, d_au_in2_type;	//type of operand -1 and  operand - 2 (unsigned/signed: 0/1)
    wire d_au_op;		//operation by data arithmetic unit (add/sub : 0/1)
    wire n_clock;
    wire [31:0] logic_unit_in1, logic_unit_in2;	// input operands for logic unit
    wire [1:0] logic_unit_op;	//operation performed by logic unit
    wire [31:0] shift_unit_in1;	//operand to be shifted
    wire [4:0] shift_unit_in2;	//shift amount
    wire [1:0] shift_unit_op;		//type of shift to be performed
    wire [31:0] a_au_in1, a_au_in2;
    wire fmt_r, fmt_il, fmt_s;
    wire [2:0] funct3;
    wire [31:0] d_mem_write_data;
    wire d_mem_en, d_mem_write_en;
    wire [4:0] rd;//Is internally used in Decoder
    wire write_ex_result_to_rd, write_d_mem_out_to_rd;
    
    wire [31:0] result_of_operation_data_block,result_of_operation_logic_block,result_of_operation_shift_block,result_of_operation_au_block,result_of_operation_final,data_mem_address;
    wire flag_lt;
    wire [31:0] inst;
    wire [31:0] rd_write_data;
    wire reg_file_write_en;
    wire [31:0] d_mem_out;
    wire [31:0] B_target, IF_ID_INS;
    wire [9:0] IF_ID_PC;
    wire B_dec, fetch_en;
    //wire [31:0] address_arith_result; 
    assign inst = IF_ID_INS; //Different names used
    
    assign n_clock=~clock;
    assign B_dec=0;
    assign fetch_en=1;
    assign B_target=0;
    
    
    IF if_unit (B_dec, fetch_en,B_target,clock,reset,IF_ID_PC,IF_ID_INS);
    
    decoder_r_ld_st decoder_block(inst, d_au_in1, d_au_in2, d_au_in1_type, d_au_in2_type, d_au_op, logic_unit_in1, logic_unit_in2, logic_unit_op, shift_unit_in1, shift_unit_in2, shift_unit_op, a_au_in1, a_au_in2, fmt_r, fmt_il, fmt_s, funct3, d_mem_write_data, d_mem_en, d_mem_write_en, rd, write_ex_result_to_rd, write_d_mem_out_to_rd, rd_write_data, reg_file_write_en, clock);
    
    arith_unit_data data_exec_block(d_au_in1, d_au_in2, d_au_in1_type, d_au_in2_type, d_au_op, result_of_operation_data_block, flag_lt);
    
    logic_unit logic_exec_block(logic_unit_in1, logic_unit_in2, logic_unit_op, result_of_operation_logic_block);
    
    shift_unit shift_exec_block(shift_unit_in1, shift_unit_in2, shift_unit_op, result_of_operation_shift_block);
    
    arith_unit_address addr_exec_block(a_au_in1, a_au_in2, result_of_operation_au_block);
    
    out_gen out_gen_block(result_of_operation_final, data_mem_address, fmt_r, fmt_il, fmt_s, funct3, result_of_operation_data_block, result_of_operation_logic_block, result_of_operation_shift_block, flag_lt, result_of_operation_au_block);
    
    data_mem_16kx8 data_mem (data_mem_address, d_mem_write_data, d_mem_en,d_mem_write_en, n_clock, funct3[1:0], d_mem_out);
    //result of au_block should be replaced with data_mem_address, d_write_mem_data should be in place of operation_final
    write_back_logic write_back_unit(result_of_operation_final, d_mem_out, write_ex_result_to_rd,write_d_mem_out_to_rd, funct3, result_of_operation_au_block[1:0], rd_write_data, reg_file_write_en);
    
    
    
    
    
endmodule
