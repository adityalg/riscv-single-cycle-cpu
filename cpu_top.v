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
    wire [3:0] alu_control;
    wire RegWrite;
    wire [2:0] immediate_type;
    wire [1:0] pc_type;
    wire alu_src2;
    wire alu_src1;
    wire [31:0] alu_in1;
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
    wire branch;
    wire [2:0]branch_type;
    reg  [31:0] writeBackData;
    reg [31:0] loadData;
    reg take; // if branch is tobe taken in b type 
    assign opcode = instruction[6:0];
    assign rd     = instruction[11:7];
    assign funct3 = instruction[14:12];
    assign rs1    = instruction[19:15];
    assign rs2    = instruction[24:20];
    assign funct7 = instruction[31:25];
    assign pc_plus_4   = pc + 8'd4;
    assign pc_plus_imm = pc + immediate_value[7:0];
parameter beq= 3'b000, bne =3'b001, blt=3'b010,  bge= 3'b011, bltu= 3'b100, bgeu=3'b101;


always @(*) begin
    take = 1'b0; 
    case (pc_type)
        2'b00: begin
            next_pc = pc_plus_4;
        end
            2'b01: begin
            if (branch) begin
                case(branch_type)
                    3'b000: take= zero;     // beq
                    3'b001: take= ~zero;    // bne
                    3'b010: take=(alu_ans == 1);  // blt
                    3'b011: take=(alu_ans == 0);// bge
                    3'b100: take=(alu_ans == 1); //  bltu
                    3'b101: take=(alu_ans == 0); //  bgeu
                    default: take =1'b0;
                endcase

                if (take)
                    next_pc =pc_plus_imm;
                else
                    next_pc =pc_plus_4;

            end else begin
                // jal
                next_pc = pc_plus_imm;
            end
        end

        2'b10: begin// jalr
            next_pc = alu_ans & 8'hFE;   // clear LSB
        end

        default: begin
            next_pc = pc_plus_4;
        end

    endcase
end




    assign alu_in2 = (alu_src2) ? immediate_value : src2;
    assign alu_in1 = (alu_src1) ? {24'b0, pc} : src1;
    always @(*) begin
        case (writeBack_type)
            2'b00: writeBackData = alu_ans;
            2'b01: writeBackData = loadData;
            2'b10: writeBackData = pc_plus_4;
            2'b11: writeBackData = immediate_value;
            default: writeBackData = 32'b0;
        endcase
    end

always @(*) begin
    case(funct3)
         3'b000: begin // lb
            case(address[1:0])
                2'b00: loadData={{24{readData[7]}}, readData[7:0]};
                2'b01: loadData ={{24{readData[15]}}, readData[15:8]};
                2'b10: loadData={{24{readData[23]}}, readData[23:16]};
                2'b11: loadData={{24{readData[31]}}, readData[31:24]};
            endcase
        end

        3'b100: begin // lbu
            case(address[1:0])
                2'b00: loadData = {24'b0, readData[7:0]};
                2'b01: loadData = {24'b0, readData[15:8]};
                2'b10: loadData = {24'b0, readData[23:16]};
                2'b11: loadData = {24'b0, readData[31:24]};
            endcase
        end

        3'b001: begin // lh
            if(address[1] == 1'b0)
                loadData = {{16{readData[15]}}, readData[15:0]};
            else
                loadData = {{16{readData[31]}}, readData[31:16]};
        end

        3'b101: begin // lhu
            if(address[1] == 1'b0)
                loadData = {16'b0, readData[15:0]};
            else
                loadData = {16'b0, readData[31:16]};
        end

        default: loadData = readData; // lw
    endcase
end





    assign address = alu_ans;
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
        .alu_src2 (alu_src2),
        .alu_src1(alu_src1),
        .writeBack_type (writeBack_type),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .branch(branch),
        .branch_type(branch_type)
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
        .src1(alu_in1),
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
        .readData(readData),
        .funct3(funct3)
    );

endmodule
