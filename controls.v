`timescale 1ns/1ps
module control_unit(
input [6:0]opcode,
input [2:0]funct3,
input [6:0] funct7,
output reg [2:0] alu_control,
output reg RegWrite,
output reg [1:0] immediate_type,
output reg [1:0] pc_type,
output reg alu_src,
output reg [1:0] writeBack_type,
output reg MemRead,
output reg MemWrite
);


always @(*)
begin

            alu_control=3'b000;
            RegWrite=1'b0;
            immediate_type=2'b00;
            pc_type=2'b00;
            alu_src=1'b0;
            writeBack_type=2'b00;
            MemRead=1'b0;
            MemWrite=1'b0;

case (opcode)
(7'b0110011): begin
    if(funct7 ==7'b0100000)
    begin
        if(funct3==3'b000)  // sub
        begin
            alu_control=3'b001;
            RegWrite=1'b1;
        end
    end
    if(funct7==7'b0000000)
    begin
        if(funct3 ==3'b000)  // add 
        begin
            RegWrite=1'b1;
        end
        else if (funct3==3'b111) //  and
        begin
            alu_control=3'b010;
            RegWrite=1'b1;
        end
        else if(funct3==3'b110)   //  or
        begin
            alu_control=3'b011;
            RegWrite=1'b1;
        end
    end

end
(7'b0010011): begin
    if(funct3==3'b000)  // addi
    begin
            RegWrite=1'b1;
            immediate_type=2'b01;
            alu_src=1'b1;
    end
end
(7'b0000011): begin
    if(funct3==3'b010)   // lw
    begin
            RegWrite=1'b1;
            immediate_type=2'b01;
            alu_src=1'b1;
            writeBack_type=2'b01;
            MemRead=1'b1;
    end
end
(7'b0100011): begin
    if(funct3==3'b010) //  sw
    begin
            immediate_type=2'b10;
            alu_src=1'b1;
            MemWrite=1'b1;
    end
end
(7'b1100011): begin
    if (funct3==3'b000) begin   // beq
            alu_control=3'b001;
            immediate_type=2'b11;
            pc_type=2'b01;
        
    end
end
(7'b1101111): begin   // jal
    
            RegWrite=1'b1;
            pc_type=2'b01;
            writeBack_type=2'b10;
end
default : begin
            alu_control=3'b000;
            RegWrite=1'b0;
            immediate_type=2'b00;
            pc_type=2'b00;
            alu_src=1'b0;
            writeBack_type=2'b00;
            MemRead=1'b0;
            MemWrite=1'b0;
end
endcase
end
endmodule