`timescale 1ns / 1ps

module TOP_tb;

    // -------------------------------------------------------------------------
    // DUT inputs
    // -------------------------------------------------------------------------
    reg clock;
    reg reset;

    // -------------------------------------------------------------------------
    // Instantiate DUT
    // -------------------------------------------------------------------------
    TOP dut (
        .reset (reset),
        .clock (clock)
    );

    // -------------------------------------------------------------------------
    // Clock generation: 10ns period (100 MHz)
    // -------------------------------------------------------------------------
    initial clock = 0;
    always #5 clock = ~clock;

    // -------------------------------------------------------------------------
    // Reset sequence
    // -------------------------------------------------------------------------
    initial begin
        reset = 1;
        @(posedge clock); #1;
        @(posedge clock); #1;
        reset = 0;
    end

    // -------------------------------------------------------------------------
    // Monitor key internal signals via hierarchical references
    // -------------------------------------------------------------------------
    initial begin
        $display("--------------------------------------------------------------");
        $display(" Time | PC       | Instruction | rd    | WB_data  | WB_en");
        $display("--------------------------------------------------------------");
        $monitor("%5t | %h | %h  | x%0d(%2d) | %h | %b",
            $time,
            dut.IF_ID_PC,
            dut.inst,
            dut.rd, dut.rd,
            dut.rd_write_data,
            dut.reg_file_write_en
        );
    end

    // -------------------------------------------------------------------------
    // Per-cycle display of execution unit results
    // -------------------------------------------------------------------------
    always @(posedge clock) begin
        if (!reset) begin
            $display("[%0t] fmt_r=%b fmt_il=%b fmt_s=%b | funct3=%b",
                $time,
                dut.fmt_r, dut.fmt_il, dut.fmt_s,
                dut.funct3
            );
            $display("       DAU: in1=%h in2=%h op=%b -> result=%h flag_lt=%b",
                dut.d_au_in1, dut.d_au_in2, dut.d_au_op,
                dut.result_of_operation_data_block, dut.flag_lt
            );
            $display("       LU:  in1=%h in2=%h op=%b -> result=%h",
                dut.logic_unit_in1, dut.logic_unit_in2, dut.logic_unit_op,
                dut.result_of_operation_logic_block
            );
            $display("       SHU: in1=%h in2=%h op=%b -> result=%h",
                dut.shift_unit_in1, dut.shift_unit_in2, dut.shift_unit_op,
                dut.result_of_operation_shift_block
            );
            $display("       AAU: in1=%h in2=%h -> addr=%h",
                dut.a_au_in1, dut.a_au_in2,
                dut.result_of_operation_au_block
            );
            $display("       MEM: en=%b we=%b addr=%h wdata=%h rdata=%h",
                dut.d_mem_en, dut.d_mem_write_en,
                dut.data_mem_address,
                dut.d_mem_write_data,
                dut.d_mem_out
            );
            $display("       FINAL result=%h -> WB to x%0d en=%b",
                dut.result_of_operation_final,
                dut.rd,
                dut.reg_file_write_en
            );
            $display("---");
        end
    end

    // -------------------------------------------------------------------------
    // Test sequence - run enough cycles to execute several instructions
    // then check register file contents via hierarchical path
    // -------------------------------------------------------------------------
    initial begin
        // Wait for reset to deassert
        @(negedge reset);

        // Run 20 cycles to execute instructions from ROM
        repeat(20) @(posedge clock);

        // ---------------------------------------------------------------
        // Spot-check register file contents
        // Adjust register numbers and expected values to match your ROM
        // ---------------------------------------------------------------
        $display("=== Register File Snapshot ===");
        $display("x0  = %h (expect 00000000)", dut.decoder_block.register_set.reg_file[0]);
        $display("x1  = %h", dut.decoder_block.register_set.reg_file[1]);
        $display("x2  = %h", dut.decoder_block.register_set.reg_file[2]);
        $display("x3  = %h", dut.decoder_block.register_set.reg_file[3]);
        $display("x4  = %h", dut.decoder_block.register_set.reg_file[4]);
        $display("x5  = %h", dut.decoder_block.register_set.reg_file[5]);
        $display("x10 = %h", dut.decoder_block.register_set.reg_file[10]);
        $display("x11 = %h", dut.decoder_block.register_set.reg_file[11]);

        $display("=== Test Complete ===");
        $finish;
    end

    // -------------------------------------------------------------------------
    // Waveform dump
    // -------------------------------------------------------------------------
    initial begin
        $dumpfile("TOP_tb.vcd");
        $dumpvars(0, TOP_tb);
    end

    // -------------------------------------------------------------------------
    // Timeout watchdog
    // -------------------------------------------------------------------------
    initial begin
        #10000;
        $display("TIMEOUT: simulation ran too long");
        $finish;
    end

endmodule