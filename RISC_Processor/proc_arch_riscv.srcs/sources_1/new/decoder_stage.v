`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/20/2026 01:25:14 PM
// Design Name: 
// Module Name: decoder_stage
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

//Instruction decoder for r-type, load and store instructions of RV32I ISA
module decoder_r_ld_st (inst, d_au_in1, d_au_in2, d_au_in1_type, d_au_in2_type, d_au_op, logic_unit_in1, logic_unit_in2, logic_unit_op,
                         shift_unit_in1, shift_unit_in2, shift_unit_op, a_au_in1, a_au_in2, fmt_r, fmt_il, fmt_s, funct3, d_mem_write_data, 
                         d_mem_en, d_mem_write_en, rd, write_ex_result_to_rd, write_d_mem_out_to_rd, rd_write_data_from_wb, rd_write_en_from_wb, clock);
                         
                         
    input [31:0] inst; 		//instruction (binary code) input
    input [31:0] rd_write_data_from_wb;	//write data for rd from write back stage 
    input rd_write_en_from_wb;		//register file write enable from write back stage
    input clock; 				//clock signal
    
    output [31:0] d_au_in1, d_au_in2;	//operand -1 & operand -2 for data arithmetic unit
    output d_au_in1_type, d_au_in2_type;	//type of operand -1 and  operand - 2 (unsigned/signed: 0/1)
    output d_au_op;		//operation by data arithmetic unit (add/sub : 0/1)
    output [31:0] logic_unit_in1, logic_unit_in2;	// input operands for logic unit
    output [1:0] logic_unit_op;	//operation performed by logic unit
    output [31:0] shift_unit_in1;	//operand to be shifted
    output [4:0] shift_unit_in2;	//shift amount
    output [1:0] shift_unit_op;		//type of shift to be performed
    output [31:0] a_au_in1, a_au_in2;	//operand-1 & operand-2 for address arithmetic unit
    output fmt_r, fmt_il, fmt_s;		//fmt r, fmt il, fmt s instruction (no/yes: 0/1)
    output [2:0] funct3;			//funct3 bits: inst [14:12]
    output[31:0] d_mem_write_data;	//data for write operation to data memory
    output d_mem_en, d_mem_write_en;	//enable and write enable inputs for data memory
    output [4:0] rd;				//destination register for the instruction
    output write_ex_result_to_rd, write_d_mem_out_to_rd;
    //write ex unit result to rd, write data memory read operation result to rd: (no/yes: 0/1)
    
    //DECLARATION OF REGISTERS CORRESPONDING TO OUTPUT PORTS
    reg [31:0] d_au_in1, d_au_in2;	//operand -1 & operand -2 for data arithmetic unit
    reg d_au_in1_type, d_au_in2_type;	//type of operand -1 and  operand - 2 (unsigned/signed: 0/1)
    reg d_au_op;		//operation by data arithmetic unit (add/sub : 0/1)
    reg [31:0] logic_unit_in1, logic_unit_in2;	// input operands for logic unit
    reg [1:0] logic_unit_op;	//operation performed by logic unit
    reg [31:0] shift_unit_in1;	//operand to be shifted
    reg [4:0] shift_unit_in2;	//shift amount
    reg [1:0] shift_unit_op;		//type of shift to be performed
    reg [31:0] a_au_in1, a_au_in2;
    reg fmt_r, fmt_il, fmt_s;
    reg [2:0] funct3;
    reg [31:0] d_mem_write_data;
    reg d_mem_en, d_mem_write_en;
    reg [4:0] rd;
    reg write_ex_result_to_rd, write_d_mem_out_to_rd;
    
    //DECLARATION OF INTERNAL REGISTERS
    reg [6:0] funct7, opcode;
    reg [4:0] rs2, rs1; 
    reg [31:0] imm_i;
    reg [31:0] imm_s;
    reg opcode_rr, opcode_ld, opcode_st;
    reg funct7_0, funct7_32;
    reg funct3_0, funct3_1, funct3_2, funct3_3, funct3_4, funct3_5, funct3_6, funct3_7;
    //reg fmt_r; 
    reg fmt_il_bhw, fmt_il_buhu,is_i_add,is_i_sub,is_i_slt,is_i_sltu,is_i_xor,is_i_or,is_i_and,is_i_sll,is_i_srl,is_i_sra;
    //reg is_i_lb,is_i_lh,is_i_lw,is_i_lbu,is_i_lhu; Commented Out
    //reg is_i_sb,is_i_sh,is_i_sw; Commented Out
    wire [31:0] d_rs1, d_rs2;		//contents of registers rs1, rs2		
    //BEGIN DECODING INSTRUCTION FORMATS
    
    always @(*) begin
        funct7 = inst[31:25];
        rs2 = inst [24:20];
        rs1 = inst [19:15];
        funct3 = inst [14:12];
        rd = inst [11:7];
        opcode = inst [6:0];
        
        imm_i = {{20{inst[31]}}, inst[31:20]};	//used by fmt_i_arith/logic/shift/load/jalr instr. 
        imm_s = {{20{inst[31]}}, inst[31:25], inst[11:7]};	//used by fmt_s (store) instr.
        opcode_rr = (opcode == 7 'b0110011);
        opcode_ld = (opcode == 7 'b0000011);
        opcode_st = (opcode == 7 'b0100011);
        funct7_0 = (funct7 == 7 'b0000000);
        funct7_32 = (funct7 == 7 'b0100000);
        funct3_0 = (funct3 == 3 'b000);
        funct3_1 = (funct3 == 3 'b001);
        funct3_2 = (funct3 == 3 'b010);
        funct3_3 = (funct3 == 3 'b011);
        funct3_4 = (funct3 == 3 'b100);
        funct3_5 = (funct3 == 3 'b101);
        funct3_6 = (funct3 == 3 'b110);
        funct3_7 = (funct3 == 3 'b111);
        
        
        fmt_r = opcode_rr && ( funct7_0 || (funct7_32 && (funct3_0 || funct3_5)));
        fmt_il_bhw = opcode_ld && (funct3_0 || funct3_1 ||funct3_2);
        fmt_il_buhu = opcode_ld && (funct3_4 || funct3_5);
        fmt_il = fmt_il_bhw || fmt_il_buhu;
        fmt_s = opcode_st && (funct3_0 || funct3_1 || funct3_2);
        
        //IDENTIFICATION OF
        //FORMAT_R INSTRUCTIONS WITH
        //OPERATIONS IN DATA ARITHMETIC UNIT
        is_i_add =  (fmt_r && funct7_0 && funct3_0);		//ADD impl: add_ss rs1, rs2, rd
        is_i_sub = (fmt_r && funct7_32 && funct3_0);		//SUB impl: sub_ss rs1, rs2, rd
        is_i_slt = (fmt_r && funct3_2);			//SLT impl: sub(comp)_ss rs1, rs2,  flag _lt
                                //rd = {31 'b0, flag_lt};
        is_i_sltu =  (fmt_r && funct3_3);		//SLTU impl: sub(comp)_uu rs1, rs2, flag_lt
                                //rd = {31 'b0, flag_lt};
        //IDENTIFICATION OF
        //FORMAT_R INSTRUCTIONS WITH 
        //OPERATIONS IN LOGIC UNIT
        is_i_xor = (fmt_r && funct3_4);			//XOR: funct3 = = 3 'b100 ? xor rs1, rs2, rd
        is_i_or =  (fmt_r && funct3_6); 			//OR: funct3 = = 3 'b110 ? or rs1, rs2, rd			
        is_i_and = (fmt_r && funct3_7); 		//AND: funct3 = = 3 'b111 ? and rs1, rs2, rd
                    
        //IDENTIFICATION OF
        //FORMAT_R INSTRUCTIONS WITH
        //OPERATIONS IN SHIFT UNIT
        is_i_sll = ( fmt_r && funct3_1); 			//SLL:  rs1 << rs2 [4:0] , rd			
        is_i_srl =  (fmt_r && funct7_0 && funct3_5);	//SRL:  rs1 >> rs2[4:0], rd
        is_i_sra =  (fmt_r && funct7_32 && funct3_5);	//SRA:  rs1 >>>  rs2, rd
        
//        //OPERATIONS IN  ADDRESS ARITHMETIC UNIT (rs1: unsigned; imm_il: signed)
//        is_i_lb = (fmt_il && funct3_0);		//LB: rs1 + imm_il -> mar; mdor -> rd
//        is_i_lh = (fmt_il && funct3_1);		//LH: rs1 + imm_il -> mar; mdor -> rd
//        is_i_lw = (fmt_il && funct3_2);		//LW: rs1 + imm_il -> mar; mdor -> rd
//        is_i_lbu = (fmt_il && funct3_4);  	//LBU: rs1 + imm_il -> mar; mdor -> rd
//        is_i_lhu = (fmt_il && funct3_5);		//LHU: rs1 + imm_il -> mar; mdor -> rd
//        //OPERATIONS IN  ADDRESS ARITHMETIC UNIT (rs1: unsigned; imm_sl: signed)
//        is_i_sb = (fmt_s && funct3_0);		//SB: rs1 + imm_s -> mar; rs2 -> mdir
//        is_i_sh = (fmt_s && funct3_1);		//SH: rs1 + imm_s -> mar; rs2 -> mdir
//        is_i_sw = (fmt_s && funct3_2);		//SW: rs1 + imm_s -> mar; rs2 -> mdir
    end
    
    
    // START INPUT GENERATION FOR DATA ARITHMETIC UNIT:
    //generate the first operand:  d_au_operand_1
     always @ (*)
    begin
    d_au_in1 = 0;
    if (is_i_add || is_i_sub || is_i_slt || is_i_sltu)
    d_au_in1 = d_rs1;
    end
    //generate the second operand: d_au_operand_2
    always @ (*)
    begin
    d_au_in2 = 0;
    if (is_i_add || is_i_sub || is_i_slt || is_i_sltu)
    d_au_in2 = d_rs2;
    end
    //specifying the representation type of d_au_operand_1
    //d_au_operand_1_type (0 = unsigned type; 1 = signed type)
    always @ (*)
    begin
    d_au_in1_type = 1;
    if (is_i_sltu ) d_au_in1_type = 0;
    end
    //specifying the representation type of d_au_operand_2
    //d_au_operand_2_type (0 = unsigned type; 1 = signed type)
    always @ (*)
    begin 
    d_au_in2_type = 1;
    if (is_i_sltu ) d_au_in2_type = 0;
    end
    //specifying  arithmetic operation to be performed on the operands 
    //0 = addition; 1 = subtraction
    always @ (*)
    begin
    d_au_op = 0;
    if (is_i_sub || is_i_slt || is_i_sltu) d_au_op = 1;
    end
    
    //END INPUT GENERATION FOR DATA ARITHMETIC UNIT
    //BEGIN INPUT GENERATION FOR LOGIC UNIT:
    //Generate operand_1
    always @ (*)
    begin
    logic_unit_in1 = 0;
    if (is_i_xor || is_i_or || is_i_and)  logic_unit_in1 = d_rs1;
    end 
    //Generate operand_2
    always @ (*)
    begin
    logic_unit_in2 =  0;
    if (is_i_xor || is_i_or || is_i_and) logic_unit_in2 = d_rs2;
    end
    //Generate operation code for logic unit (00 = no op, 01 = xor, 10 = or, 11 = and)
    always @ (*)
    begin
    logic_unit_op = 2 'b00;
    if (is_i_xor || is_i_or || is_i_and) 	// True for XOR/OR/AND
    casex (funct3)
    3 'b100 : logic_unit_op = 01;	//xor operation
    3 'b110 : logic_unit_op = 10;	//or operation
    3 'b111 : logic_unit_op = 11;	//and operation
    default : logic_unit_op = 00;	//LU NOP: output of LU = 0
    endcase
    end
    
    
    //END INPUT GENERATION FOR LOGIC UNIT
    //BEGIN INPUT GENERATION FOR SHIFT UNIT
    //generate operand_1
    always @ (*)
    begin
    shift_unit_in1 = 0;
    if (is_i_sll || is_i_srl || is_i_sra) shift_unit_in1 = d_rs1;
    end
    always @ (*)
    begin
    shift_unit_in2 = 5 'b00000;
    if (is_i_sll || is_i_srl || is_i_sra) shift_unit_in2 = d_rs2 [4:0];
    end
    //generate operation code 
    always @ (*)
    begin
    shift_unit_op = 2 'b00; 	//SHU NOP; output of SHU = 0
    
    if (is_i_sll || is_i_srl || is_i_sra)
    casex ({inst[30],funct3})
    4 'bx001 : shift_unit_op = 10;	//Shift left logical
    4 'bx101 : shift_unit_op = 01;	//shift right logical
    4 'b1101 : shift_unit_op = 11;	//shift right arithmetic
    default: shift_unit_op = 00;	//SHU NOP; output of SHU = 0
    endcase
    end
    
    
    //BEGIN INPUT GENERATION FOR ADDRESS ARITHMETIC UNIT
    //Generate the first operand for the address arithmetic unit
    always @ (*)
    begin
    a_au_in1 = 0;
    if (fmt_il ||fmt_s) a_au_in1 = d_rs1;
    end
    //Generate the second operand for the address arithmetic unit
    //Address Arithmetic Unit Operation is fixed (add unsigned operand_1 to signed operand_2)
    always @ (*)
    begin
    a_au_in2 = 0;
    if (fmt_il)
    a_au_in2 = imm_i;
    else if (fmt_s)
    a_au_in2 = imm_s;
    else 
    a_au_in2 = 0;
    end
    
    //INPUT GENERATION for the data memory control
    always @(*) begin
        d_mem_write_data=0;
        if(fmt_s) begin
            d_mem_write_data=d_rs2; 
        end
    end
    
    always @(*) begin
        d_mem_en=0;
        if(fmt_s||fmt_il) d_mem_en=1;
    end
    
    always @(*) begin 
        d_mem_write_en=0;
        if(fmt_s) d_mem_write_en=1;
    end
    
    //GENERATION OF RD WRITE CONTROL
    always @(*) begin
        write_ex_result_to_rd=0;
        if(fmt_r) write_ex_result_to_rd=1;
    end
    
    always @(*) begin
        write_d_mem_out_to_rd=0;
        if(fmt_il)write_d_mem_out_to_rd=1;
    end
    //Instantiate the register file module here 
    register_file  register_set (.source_reg_1 (rs1), .source_reg_2 (rs2), .dest_reg (rd), 
    .write_en (rd_write_en_from_wb), .clock (clock), .write_data (rd_write_data_from_wb), .source_reg_1_data (d_rs1), .source_reg_2_data (d_rs2));
endmodule