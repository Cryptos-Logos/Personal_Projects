`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/04/2026 01:29:57 PM
// Design Name: 
// Module Name: tb_memory_access
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


module tb_memory_access;
reg [13:0] address;           // 14-bit address input
reg clock;                    // Clock input
reg [31:0] write_data;        // 32-bit write data (for word access)
reg write_en;                 // Write enable
reg en;                       // Enable signal
reg [1:0]type;
wire [31:0] read_data;        // Read data (4 bytes output from the memory)

data_mem_16kx8 uut (
    .d_mem_address(address),         // Address input
    .d_mem_clock(clock),             // Clock input
    .d_mem_rw_size(type),
    .d_mem_data_in(write_data),   // Write data input
    .d_mem_write_en(write_en),       // Write enable
    .d_mem_en(en),                   // Enable signal
    .d_mem_out(read_data)      // Read data output
);

always begin
    #5 clock = ~clock; // Clock period of 10 units
end

initial begin
    clock = 0;
    write_en = 0;
    en = 0;
    address = 14'b0;
    write_data = 32'b0;
    type=2'b00;

    #10;
    en = 1;

    address = 14'b00000000000000;  // Address for byte access (aligned)
    write_data = 32'h000000AB;     // 1 byte of data to write
    write_en = 1;
    type=2'b00;

    #10;
    write_en = 0;
    type=2'b00;
    #10;

    address = 14'b00000000000000;  // Address for byte access
    #10;
    if (read_data[7:0] !== 8'hAB) $display("Error: Byte read mismatch");

    // Test 2: Write a half-word (aligned)
    // Write 0x1234 to address 0x0002 (half-word aligned)
    address = 14'b00000000000010;  // Address for half-word access (aligned)
    write_data = 32'h00001234;     // 2 bytes of data to write
    write_en = 1;
    type=2'b01;
    #10;
    write_en = 0;
    #10;

    // Read back half-word from address 0x0002 and check
    address = 14'b00000000000010;  // Address for half-word access
    #10;
    if (read_data[15:0] !== 16'h1234) $display("Error: Half-word read mismatch");

    // Test 3: Write a word (aligned)
    // Write 0x11223344 to address 0x0004 (word aligned)
    address = 14'b00000000000100;  // Address for word access (aligned)
    write_data = 32'h11223344;     // 4 bytes of data to write
    write_en = 1;
    type=2'b10;
    #10;
    write_en = 0;
    #10;

    // Read back word from address 0x0004 and check
    address = 14'b00000000000100;  // Address for word access
    #10;
    if (read_data !== 32'h11223344) $display("Error: Word read mismatch");

    // Test 4: Write and read across boundaries
    // Write 0x01 to address 0x0005 (non-aligned byte access)
//    address = 14'b00000000000101;  // Non-aligned address for byte access
//    write_data = 32'h00000001;     // Single byte data to write
//    write_en = 1;
//    #10;
//    write_en = 0;
//    #10;

//    // Read back byte from address 0x0005 and check
//    address = 14'b00000000000101;  // Address for byte access
//    #10;
//    if (read_data[7:0] !== 8'h01) $display("Error: Byte read mismatch at non-aligned address");

//    // End of test
    $finish;
end

endmodule
