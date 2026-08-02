`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/27/2026 02:27:17 PM
// Design Name: 
// Module Name: output_gen
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


module out_gen (data_op_result, data_mem_address, is_fmt_r, is_fmt_il, is_fmt_s, i_funct3, data_arith_result, logic_result, shift_result, flag_lt, address_arith_result);
    //This module generates the final outputs from the execution stage logic.
    // To compute its outputs, the module uses two types of inputs:
    // (1) Instruction-type (output of the decoder)
    // (2) intermediate outputs produced by instances of other modules in the EX stage: 
    // arith_unit_data, arith_unit_address, logic_unit, shift_unit 
    input  is_fmt_r, is_fmt_il, is_fmt_s,flag_lt;
    input [2:0] i_funct3;	//funct3 bits
    input [31:0] address_arith_result, data_arith_result, logic_result, shift_result;
    output [31:0] data_op_result, data_mem_address;
    reg [31:0]data_op_result, data_mem_address;
    
    always @(*)
    begin
        data_op_result = 0;
        //assign value to module output data_op_result
        if (is_fmt_r)
        casex (i_funct3)
            3 'b000: data_op_result  = data_arith_result;
            3 'b01x: data_op_result = {{31{1 'b0}}, flag_lt};
            3 'b100: data_op_result = logic_result; 
            3 'b110: data_op_result = logic_result; 
            3 'b111: data_op_result = logic_result;
            3 'b001: data_op_result = shift_result;
            3 'b101: data_op_result = shift_result;
        endcase
        else 
            data_op_result = 0;
        end
        //end of assignments to module output data_op_result
        // Begin assigning data memory address
        always @(*)
        begin
        data_mem_address = 0;
        if (is_fmt_il || is_fmt_s)
            data_mem_address = address_arith_result;
        else
        data_mem_address = 0;
        //End of data memory address assignment
    end
endmodule
