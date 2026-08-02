`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/27/2026 01:47:40 PM
// Design Name: 
// Module Name: logic_unit
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


module logic_unit (operand_1, operand_2, operation, result_of_operation);
    input [31:0] operand_1, operand_2;	
    input [1:0]  operation;	
    output [31:0] result_of_operation;	// result of logic function computation
    reg [31:0] result_of_operation; 
    always @ (*)
        begin
        casex (operation)
        2 'b01 : result_of_operation = (operand_1) ^ (operand_2);
        2 'b10 : result_of_operation = (operand_1) | (operand_2);
        2 'b11 : result_of_operation = (operand_1) & (operand_2);
        default : result_of_operation = 0;
        endcase
    end
endmodule
//Instructions that use the logic_result for storing in rd (destination register) are
//XOR, OR, AND
