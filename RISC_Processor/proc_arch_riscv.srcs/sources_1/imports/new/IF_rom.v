`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/02/2026 01:17:41 PM
// Design Name: 
// Module Name: IF_rom
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


module IF_rom(
    input [9:0] add,
    input enable,
    input clk,
    output [31:0] dout
    );
    
    blk_mem_gen_4 block_rom (
        .addra(add),
        .clka(clk),
        .ena(enable),
        .douta(dout)
        );
    
endmodule
