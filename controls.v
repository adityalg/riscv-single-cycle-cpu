`timescale 1ns/1ps
module control_unit(
input [6:0]opcode,
input [2:0]funct3,
input [6:0] funct7,
output reg [3:0] alu_control,// 000 add,001 sub, 010 and, 011 or
output reg RegWrite,
output reg [2:0] immediate_type, // 001 I, 010 S, 011 B, 000 J, 100 u
output reg [1:0] pc_type, // 00 = pc+4, 01 = pc +imm(branch and jal), 10 = pc = rs1+imm (jalr)
output reg alu_src2,  // 0 rs2, 1 immediate
output reg [1:0] writeBack_type,// 00 alu result, 01 memory data, 10 pc+4(jal), 11 utype 
output reg MemRead,
output reg MemWrite,
output reg  branch, // 1 for conditional branch
output reg [2:0] branch_type,
output reg alu_src1 // 0 rs1, 1 pc
);

parameter beq= 3'b000, bne =3'b001, blt=3'b010,  bge= 3'b011, bltu= 3'b100, bgeu=3'b101;

always @(*)
begin

            alu_control=4'b0000;
            RegWrite=1'b0;
            immediate_type=3'b000;
            pc_type=2'b00;
            alu_src2=1'b0;
            alu_src1 = 1'b0;
            writeBack_type=2'b00;
            MemRead=1'b0;
            MemWrite=1'b0;
            branch = 1'b0;
            branch_type = 3'b000;

case (opcode)
(7'b1100111):begin  // jalr
    if (funct3 == 3'b000) begin
        RegWrite= 1'b1;
        immediate_type= 3'b001;   // I-type
        alu_src2 = 1'b1;// rs1 + imm
        alu_control= 4'b0000; 
        pc_type= 2'b10;   
        writeBack_type=2'b10;   
        branch= 1'b0;
    end
end





(7'b0110011): begin
    if(funct7 ==7'b0100000)
    begin
        if(funct3==3'b000)  // sub
        begin
            alu_control=4'b0001;
            RegWrite=1'b1;
        end
        if(funct3==3'b101)  // sra
        begin
            alu_control=4'b0111;
            RegWrite=1'b1;
        end


    end
    if(funct7==7'b0000000)
    begin

        if(funct3 ==3'b000)  // add 
        begin
            RegWrite=1'b1;
            alu_control=4'b0000;
        end
         else if (funct3==3'b100) //  xor
        begin
            alu_control=4'b0100;
            RegWrite=1'b1;
        end
         else if (funct3==3'b001) //  sll
        begin
            alu_control=4'b0101;
            RegWrite=1'b1;
        end
        else if (funct3==3'b111) //  and
        begin
            alu_control=4'b0010;
            RegWrite=1'b1;
        end
        else if (funct3==3'b010) //  slt
        begin
            alu_control=4'b1000;
            RegWrite=1'b1;
        end
        

        else if (funct3==3'b011) //  sltu
        begin
            alu_control=4'b1001;
            RegWrite=1'b1;
        end
        else if (funct3==3'b101) //  srl
        begin
            alu_control=4'b0110;
            RegWrite=1'b1;
        end
        else if(funct3==3'b110)   //  or
        begin
            alu_control=4'b0011;
            RegWrite=1'b1;
        end
    end

end
(7'b0010011): begin   // i type opcode
    if(funct3==3'b000)  // addi
    begin
            RegWrite=1'b1;
            immediate_type=3'b001;
            alu_src2=1'b1;
            alu_control=4'b0000;
    end
     else if(funct3==3'b100)  // xori
    begin
            RegWrite=1'b1;
            immediate_type=3'b001;
            alu_src2=1'b1;
            alu_control=4'b0100;
    end
    else if(funct3==3'b110)  // ori
    begin
            RegWrite=1'b1;
            immediate_type=3'b001;
            alu_src2=1'b1;
            alu_control=4'b0011;
    end
    else if(funct3==3'b111)  // andi
    begin
            RegWrite=1'b1;
            immediate_type=3'b001;
            alu_src2=1'b1;
            alu_control=4'b0010;
    end
     else if(funct3==3'b010)  // slti
    begin
            RegWrite=1'b1;
            immediate_type=3'b001;
            alu_src2=1'b1;
            alu_control=4'b1000;
    end
     else if(funct3==3'b011)  // sltui
    begin
            RegWrite=1'b1;
            immediate_type=3'b001;
            alu_src2=1'b1;
            alu_control=4'b1001;
    end
     else if(funct3==3'b001)  // slli
    begin
            RegWrite=1'b1;
            immediate_type=3'b001;
            alu_src2=1'b1;
            alu_control=4'b0101;
    end
    else if(funct3==3'b101)  // srli+srai
    begin
        if (funct7== 7'd0)  //srli
        begin
             RegWrite=1'b1;
            immediate_type=3'b001;
            alu_src2=1'b1;
            alu_control=4'b0110;

        end
        else if (funct7== 7'b0100000)  // srai
          begin   RegWrite=1'b1;
            immediate_type=3'b001;
            alu_src2=1'b1;
            alu_control=4'b0111;
          end
    end
end


(7'b0000011): begin //load instructions

    RegWrite= 1'b1;
    immediate_type= 3'b001;  //i type
    alu_src2 = 1'b1;
    writeBack_type= 2'b01; //memory
    MemRead= 1'b1;
end
(7'b0100011): begin  //store instructions
    immediate_type = 3'b010;   //s type
    alu_src2= 1'b1;  //rs1 +imm
    alu_control= 4'b0000; 
    MemWrite= 1'b1;
end

(7'b1100011): begin
     immediate_type=3'b011;
            pc_type=2'b01;
            branch=1'b1;
            alu_src2 = 1'b0;

    if (funct3==3'b000) begin   // beq
            alu_control=4'b0001;  
            branch_type= beq;    
        end
        else if(funct3== 3'b001)begin // bne
            alu_control=4'b0001; 
             branch_type=bne;
        end
         else if(funct3== 3'b100)begin// blt
            alu_control=4'b1000;
                 branch_type= blt;
        end
         else if(funct3== 3'b101)begin //bge 
            alu_control=4'b1000; 

             branch_type=bge;
        end
         else if(funct3== 3'b110)begin //bltu
            alu_control=4'b1001; 
             branch_type=bltu;
        end
         else if(funct3== 3'b111)begin// bgeu
            alu_control=4'b1001; 
             branch_type=bgeu;  
        end
        
end
(7'b1101111): begin   // jal
    
            RegWrite=1'b1;
            pc_type=2'b01;
            writeBack_type=2'b10;
            immediate_type=3'b000;// jtype
end
(7'b0110111): begin// lui
            
            RegWrite=1'b1;
            immediate_type=3'b100;
            writeBack_type=2'b11;
           
end
(7'b0010111): begin  // auipc
            alu_control=4'b0000;
            RegWrite=1'b1;
            immediate_type=3'b100;
            alu_src1=1'b1;
            alu_src2= 1'b1;
            writeBack_type=2'b00;
end 
default : begin
            alu_control=4'b0000;
            RegWrite=1'b0;
            immediate_type=3'b000;
            pc_type=2'b00;
            alu_src2=1'b0;
            writeBack_type=2'b00;
            MemRead=1'b0;
            MemWrite=1'b0;
            alu_src1 = 1'b0;

end
endcase
end
endmodule