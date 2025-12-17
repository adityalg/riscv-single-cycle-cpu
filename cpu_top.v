`timescale 1ns/1ps
module cpu_top (
    input clk,
    input rst
);

    wire [31:0] instruction;
    wire [7:0]  pc;
    reg [7:0]  next_pc;
    wire [7:0]  pc_plus_4;
    wire [7:0]  pc_plus_imm;
    wire [6:0] opcode;
    wire [2:0] funct3;
    wire [6:0] funct7;
    wire [4:0] rs1;
    wire [4:0] rs2;
    wire [4:0] rd;
    wire [2:0] alu_control;
    wire RegWrite;
    wire [1:0] immediate_type;
    wire [1:0] pc_type;
    wire alu_src;
    wire [1:0] writeBack_type;
    wire MemRead;
    wire MemWrite;
    wire [31:0] src1;
    wire [31:0] src2;
    wire [31:0] immediate_value;
    wire [31:0] alu_ans;
    wire zero;
    wire [31:0] alu_in2;
    wire [31:0] address;
    wire [31:0] writeData;
    wire [31:0] readData;
    reg  [31:0] writeBackData;
    assign opcode = instruction[6:0];
    assign rd     = instruction[11:7];
    assign funct3 = instruction[14:12];
    assign rs1    = instruction[19:15];
    assign rs2    = instruction[24:20];
    assign funct7 = instruction[31:25];
    assign pc_plus_4   = pc + 8'd4;
    assign pc_plus_imm = pc + immediate_value[7:0];

    always @(*) begin
        next_pc = pc_plus_4;

        if (opcode == 7'b1101111)         // JAL
            next_pc = pc_plus_imm;
        else if (opcode == 7'b1100011 && funct3 == 3'b000 && zero)      // BEQ
            next_pc = pc_plus_imm;
    end

    assign alu_in2 = (alu_src) ? immediate_value : src2;

    always @(*) begin
        case (writeBack_type)
            2'b00: writeBackData = alu_ans;
            2'b01: writeBackData = readData;
            2'b10: writeBackData = pc_plus_4;
            default: writeBackData = 32'b0;
        endcase
    end

    assign address   = alu_ans;
    assign writeData = src2;

    pc pc_inst(
        .clk (clk),
        .rst (rst),
        .next_pc (next_pc),
        .pc(pc)
    );

    instruction_memory instr_mem(
        .pc (pc),
        .instruction(instruction)
    );

    control_unit control_inst(
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .alu_control(alu_control),
        .RegWrite(RegWrite),
        .immediate_type (immediate_type),
        .pc_type(pc_type),
        .alu_src (alu_src),
        .writeBack_type (writeBack_type),
        .MemRead(MemRead),
        .MemWrite(MemWrite)
    );
    regfile regfile_inst(
        .clk(clk),
        .RegWrite(RegWrite),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .writeBackData(writeBackData),
        .src1(src1),
        .src2(src2)
    );

    imm_generator imm_gen(
        .immediate_type(immediate_type),
        .instruction(instruction),
        .immediate_value(immediate_value)
    );

    alu alu_inst(
        .alu_control(alu_control),
        .src1(src1),
        .src2(alu_in2),
        .alu_ans(alu_ans),
        .zero(zero)
    );

    data_memory data_mem(
        .clk(clk),
        .MemRead (MemRead),
        .MemWrite (MemWrite),
        .address(address),
        .writeData(writeData),
        .readData(readData)
    );

endmodule
