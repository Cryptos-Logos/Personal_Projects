`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/09/2026 04:05:42 PM
// Design Name: 
// Module Name: Data_memory
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
module data_mem_16kx8 (d_mem_address, d_mem_data_in, d_mem_en, d_mem_write_en, d_mem_clock, d_mem_rw_size, d_mem_out);
input [13:0] d_mem_address;	//byte address for a read/write operation
input [31:0] d_mem_data_in;	//data input for a write operation
input d_mem_en;			//memory: active (1); idle (0)
input d_mem_write_en;		// write (1); read (0)
       input d_mem_clock;		//clock 
input [1:0] d_mem_rw_size;	// read/write size: byte (00); half-word (01); word (10)
output [31:0] d_mem_out;    	//data output from a read operation (irrespective of size)
reg [7:0] write_data_0;		//write data for instance d_mem_byte_0 (MSB)
reg [7:0] write_data_1; 		//write data for instance d_mem_byte_1
reg [7:0] write_data_2;		//write data for instance d_mem_byte_2
reg [7:0] write_data_3;		//write data for instance d_mem_byte_3 (LSB)
reg [11:0] address_0;		//byte address for instance d_mem_byte_0
 reg [11:0] address_1;		//byte address for instance d_mem_byte_1
reg [11:0] address_2;		//byte address for instance d_mem_byte_2
reg [11:0] address_3;		//byte address for instance d_mem_byte_3
reg write_enable_0 ;		//write enable input for instance d_mem_byte_0
reg write_enable_1 ;		//write enable input for instance d_mem_byte_1
reg write_enable_2 ;		//write enable input for instance d_mem_byte_2
reg write_enable_3 ;		//write enable input for instance d_mem_byte_3
reg enable_0 ;			// enable input for instance d_mem_byte_0
reg enable_1 ;			//enable input for instance d_mem_byte_1
reg enable_2 ;			//enable input for instance d_mem_byte_2
reg enable_3 ;			//enable input for instance d_mem_byte_3
reg clock_0 ;			// clock input for instance d_mem_byte_0
reg clock_1 ;			//clock input for instance d_mem_byte_1
reg clock_2 ;			//clock input for instance d_mem_byte_2
reg clock_3 ;			//clock input for instance d_mem_byte_3
/* This module is to be  implemented by instantiating the 4k x 8bit single ported, synchronous read/write BRAM module four times using instance names: d_mem_byte_0, d_mem_byte_1, d_mem_byte_2, d_mem_byte_3. For each of these instances the required inputs are generated from the inputs to the top module - the logic for which is described below */
//Generation of write data input and write enable for the four instances of 4k x 8-bit BRAM
always @(*)
begin
//Generation of write data input and write enable for instance d_mem_byte_0:
casex ({d_mem_en, d_mem_write_en, d_mem_rw_size, d_mem_address [1:0]})
6 'b110000 : begin 
write_data_0 = d_mem_data_in [7:0];
write_en_0 = 1; 
end
6 'b110100 : begin 
write_data_0 = d_mem_data_in [15:8];
write_en_0 = 1; 
end
6 'b111000 : begin 
write_data_0 = d_mem_data_in [31;24];
write_en_0 = 1; 
end
default :        begin 
write_data_0 = 0;
write_en_0 = 0; 
end
endcase
//Generate enable signal en_0 for instance d_mem_byte_0
casex ({d_mem_en, d_mem_write_en, d_mem_rw_size, d_mem_address [1:0]})
6 'b1x0000 : en_0 = 1;
6 'b1x0100 : en_0 = 1;
6 'b1x1000 : en_0 = 1;
default : en_0 = 0;
endcase 
//Generation of write data input and write enable for instance d_mem_byte_1:
casex ({d_mem_en, d_mem_write_en, d_mem_rw_size, d_mem_address [1:0]})
6 'b110001 : begin 
write_data_1 = d_mem_data_in [7:0];
write_en_1 = 1; 
end
6 'b110100 : begin 


