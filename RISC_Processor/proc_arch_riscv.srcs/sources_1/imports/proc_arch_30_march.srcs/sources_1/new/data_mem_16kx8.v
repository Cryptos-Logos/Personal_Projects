`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/30/2026 01:27:16 PM
// Design Name: 
// Module Name: data_mem_16kx8
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


module data_mem_16kx8 (d_mem_address, d_mem_data_in, d_mem_en,
        d_mem_write_en, d_mem_clock, d_mem_rw_size, d_mem_out);
        
input [13:0] d_mem_address; //byte address for a read/write operation
input [31:0] d_mem_data_in; //data input for a write operation
input d_mem_en; //memory: active (1); idle (0)
input d_mem_write_en; // write (1); read (0)
input d_mem_clock; //clock
input [1:0] d_mem_rw_size; // read/write size: byte (00); half-word (01); word (10)
output [31:0] d_mem_out; //data output from a read operation (irrespective of size)


reg [7:0] write_data_0; //write data for instance d_mem_byte_0 (MSB)
reg [7:0] write_data_1; //write data for instance d_mem_byte_1
reg [7:0] write_data_2; //write data for instance d_mem_byte_2
reg [7:0] write_data_3; //write data for instance d_mem_byte_3 (LSB)

reg [11:0] address_0; //byte address for instance d_mem_byte_0
reg [11:0] address_1; //byte address for instance d_mem_byte_1
reg [11:0] address_2; //byte address for instance d_mem_byte_2
reg [11:0] address_3; //byte address for instance d_mem_byte_3

reg write_en_0 ; //write enable input for instance d_mem_byte_0
reg write_en_1 ; //write enable input for instance d_mem_byte_1
reg write_en_2 ; //write enable input for instance d_mem_byte_2
reg write_en_3 ; //write enable input for instance d_mem_byte_3

reg en_0 ; // enable input for instance d_mem_byte_0
reg en_1 ; //enable input for instance d_mem_byte_1
reg en_2 ; //enable input for instance d_mem_byte_2
reg en_3 ; //enable input for instance d_mem_byte_3

reg clock_0 ; // clock input for instance d_mem_byte_0
reg clock_1 ; //clock input for instance d_mem_byte_1
reg clock_2 ; //clock input for instance d_mem_byte_2
reg clock_3 ; //clock input for instance d_mem_byte_3

blk_mem_gen_0 d_mem_byte_0 (.addra(address_0),.clka(clock_0),.dina(write_data_0),.douta(d_mem_out[31:24]),.ena(en_0),.wea(write_en_0));
blk_mem_gen_0 d_mem_byte_1 (.addra(address_1),.clka(clock_1),.dina(write_data_1),.douta(d_mem_out[23:16]),.ena(en_1),.wea(write_en_1));
blk_mem_gen_0 d_mem_byte_2 (.addra(address_2),.clka(clock_2),.dina(write_data_2),.douta(d_mem_out[15:8]),.ena(en_2),.wea(write_en_2));
blk_mem_gen_0 d_mem_byte_3 (.addra(address_3),.clka(clock_3),.dina(write_data_3),.douta(d_mem_out[7:0]),.ena(en_3),.wea(write_en_3));

/* This module is to be implemented by instantiating the 4k x 8bit single ported,
synchronous read/write BRAM module four times using instance names: d_mem_byte_0,
d_mem_byte_1, d_mem_byte_2, d_mem_byte_3. For each of these instances the required
inputs are generated from the inputs to the top module - the logic for which is described
below */

//Generation of write data input and write enable for the four instances of 4k x 8-bit BRAM
always @(*) begin
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
            write_data_0 = d_mem_data_in [31:24]; //; error
            write_en_0 = 1;
        end
        default : begin
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
            write_data_1 = d_mem_data_in [7:0];
            write_en_1 = 1;
        end
        6 'b111000 : begin
            write_data_1 = d_mem_data_in [23:16]; //; error and ; at end
            write_en_1 = 1;
        end
        default : begin
            write_data_1 = 0;
            write_en_1 = 0; //changed to 0
        end
    endcase
    
    casex ({d_mem_en, d_mem_write_en, d_mem_rw_size, d_mem_address [1:0]})
        6 'b1x0001 : en_1 = 1; 
        6 'b1x0100 : en_1 = 1;
        6 'b1x1000 : en_1 = 1;
        default : en_1 = 0;
    endcase
    
    //Generation of write data input and write enable for instance d_mem_byte_2:
    casex ({d_mem_en, d_mem_write_en, d_mem_rw_size, d_mem_address [1:0]})
        6 'b110010 : begin
            write_data_2 = d_mem_data_in [7:0];
            write_en_2 = 1;
        end
        6 'b110110 : begin
            write_data_2 = d_mem_data_in [15:8];
            write_en_2 = 1; //W instead of w
        end
        6 'b111000 : begin
            write_data_2 = d_mem_data_in [15:8]; //; error here
            write_en_2 = 1;
        end
        default : begin
            write_data_2 = 0;
            write_en_2 = 0;
        end
    endcase
    
    casex ({d_mem_en, d_mem_write_en, d_mem_rw_size, d_mem_address [1:0]})
        6 'b1x0010 : en_2 = 1;
        6 'b1x0110 : en_2 = 1;
        6 'b1x1000 : en_2 = 1;
        default : en_2 = 0;
    endcase

    //Generation of write data input and write enable for instance d_mem_byte_3:
    casex ({d_mem_en, d_mem_write_en, d_mem_rw_size, d_mem_address [1:0]})
        6 'b110011 : begin 
            write_data_3 = d_mem_data_in [7:0];
            write_en_3 = 1;
        end
        6 'b110110 : begin 
            write_data_3 = d_mem_data_in [7:0];
            write_en_3 = 1; 
        end
        6 'b111000 : begin 
            write_data_3 = d_mem_data_in [7:0];
            write_en_3 = 1; 
        end
        default : begin 
            write_data_3 = 0;
            write_en_3 = 0; 
        end 
    endcase
    
    casex ({d_mem_en, d_mem_write_en, d_mem_rw_size, d_mem_address [1:0]})
        6 'b1x0011 : en_3 = 1;
        6 'b1x0110 : en_3 = 1;
        6 'b1x1000 : en_3 = 1;
        default : en_3 = 0;
    endcase
    //Generation of address input and clock input for the four instances of the 4k x 8-bit BRAM
    address_0 = d_mem_address [13:2];
    address_1 = d_mem_address [13:2];
    address_2 = d_mem_address [13:2];
    address_3 = d_mem_address [13:2];
    
    //Generation of clock input for the four instances of the 4k x 8-bit BRAM
    clock_0 = d_mem_clock;
    clock_1 = d_mem_clock;
    clock_2 = d_mem_clock;
    clock_3 = d_mem_clock;
    
    /* You can now instantiate your 4k x 8-bit BRAM four times using instance names
    d_mem_byte_0, d_mem_byte_1, d_mem_byte_2, d_mem_byte_3 and connect the
    appropriate inputs required by each one of them (that have already been generated in the
    earlier part of the code). Also, connect the outputs of the four instances to the
    corresponding bytes of the output d_mem_out of the module data_mem_16kx8
    Please note that in Verilog a register can connect to an input port of an instance of a
    module.
    Please also note that in Verilog an output port of an instantiated module can be connected
    directly to an output port of the top level module without explicitly declaring an
    intermediate wire */
    end
endmodule

/*module tb_memory_access;

// Declare testbench signals
reg [13:0] address;           // 14-bit address input
reg clock;                    // Clock input
reg [31:0] write_data;        // 32-bit write data (for word access)
reg write_en;                 // Write enable
reg en;                       // Enable signal
wire [31:0] read_data;        // Read data (4 bytes output from the memory)

// Instantiate the memory module
memory_system uut (
    .address(address),         // Address input
    .clock(clock),             // Clock input
    .write_data(write_data),   // Write data input
    .write_en(write_en),       // Write enable
    .en(en),                   // Enable signal
    .read_data(read_data)      // Read data output
);

// Generate clock signal
always begin
    #5 clock = ~clock; // Clock period of 10 units
end

// Initialize the testbench
initial begin
    // Initialize signals
    clock = 0;
    write_en = 0;
    en = 0;
    address = 14'b0;
    write_data = 32'b0;

    // Apply reset and allow initialization
    #10;
    en = 1;

    // Test 1: Write a byte (aligned)
    // Write 0xAB to address 0x0000
    address = 14'b00000000000000;  // Address for byte access (aligned)
    write_data = 32'h000000AB;     // 1 byte of data to write
    write_en = 1;
    #10;
    write_en = 0;
    #10;

    // Read back byte from address 0x0000 and check
    address = 14'b00000000000000;  // Address for byte access
    #10;
    if (read_data[7:0] !== 8'hAB) $display("Error: Byte read mismatch");

    // Test 2: Write a half-word (aligned)
    // Write 0x1234 to address 0x0002 (half-word aligned)
    address = 14'b00000000000010;  // Address for half-word access (aligned)
    write_data = 32'h00001234;     // 2 bytes of data to write
    write_en = 1;
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
    #10;
    write_en = 0;
    #10;

    // Read back word from address 0x0004 and check
    address = 14'b00000000000100;  // Address for word access
    #10;
    if (read_data !== 32'h11223344) $display("Error: Word read mismatch");

    // Test 4: Write and read across boundaries
    // Write 0x01 to address 0x0005 (non-aligned byte access)
    address = 14'b00000000000101;  // Non-aligned address for byte access
    write_data = 32'h00000001;     // Single byte data to write
    write_en = 1;
    #10;
    write_en = 0;
    #10;

    // Read back byte from address 0x0005 and check
    address = 14'b00000000000101;  // Address for byte access
    #10;
    if (read_data[7:0] !== 8'h01) $display("Error: Byte read mismatch at non-aligned address");

    // End of test
    $finish;
end

endmodule*/