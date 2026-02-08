`timescale 1ns / 1ps

module instruction_memory (
    input  [7:0]  pc,
    output reg [31:0] instruction
);

    
    reg [31:0] instructionRegister [0:63];

    
    initial begin
      

// ---------- R & I TYPE TEST ----------
instructionRegister[0]  = 32'h00500093; // addi x1,x0,5
instructionRegister[1]  = 32'h00A00113; // addi x2,x0,10
instructionRegister[2]  = 32'h002081B3; // add x3,x1,x2  (15)
instructionRegister[3]  = 32'h40110233; // sub x4,x2,x1  (5)
instructionRegister[4]  = 32'h0020A2B3; // slt x5,x1,x2  (1)
instructionRegister[5]  = 32'h0020B333; // sltu x6,x1,x2 (1)
instructionRegister[6]  = 32'h0020C3B3; // xor x7,x1,x2
instructionRegister[7]  = 32'h0020E433; // or x8,x1,x2
instructionRegister[8]  = 32'h0020F4B3; // and x9,x1,x2
instructionRegister[9]  = 32'h00209533; // sll x10,x1,x2
instructionRegister[10] = 32'h0020D5B3; // srl x11,x1,x2
instructionRegister[11] = 32'h4020D633; // sra x12,x1,x2

// ---------- STORE TEST ----------
instructionRegister[12] = 32'h00302023; // sw x3,0(x0)
instructionRegister[13] = 32'h00102223; // sb x1,4(x0)
instructionRegister[14] = 32'h00202423; // sh x2,8(x0)

// ---------- LOAD TEST ----------
instructionRegister[15] = 32'h00002283; // lw x5,0(x0)
instructionRegister[16] = 32'h00402303; // lb x6,4(x0)
instructionRegister[17] = 32'h00404383; // lbu x7,4(x0)
instructionRegister[18] = 32'h00802403; // lh x8,8(x0)
instructionRegister[19] = 32'h00804483; // lhu x9,8(x0)

// ---------- BRANCH TEST ----------
instructionRegister[20] = 32'h00500113; // addi x2,x0,5
instructionRegister[21] = 32'h00208663; // beq x1,x2,+8 (taken)
instructionRegister[22] = 32'h06300193; // addi x3,x0,99 (skip)
instructionRegister[23] = 32'h00109063; // bne x1,x1,+0 (not taken)

// BLT
instructionRegister[24] = 32'h0020C463; // blt x1,x2,+8
instructionRegister[25] = 32'h06400213; // addi x4,x0,100 (skip)

// BGE
instructionRegister[26] = 32'h0020D463; // bge x1,x2,+8 (not taken)
instructionRegister[27] = 32'h02A00293; // addi x5,x0,42

// ---------- U TYPE ----------
instructionRegister[28] = 32'h000012B7; // lui x5,0x1
instructionRegister[29] = 32'h00001317; // auipc x6,0x1

// ---------- JAL TEST ----------
instructionRegister[30] = 32'h0040006F; // jal x0,+4
instructionRegister[31] = 32'h07B00393; // addi x7,x0,123 (skip)

// ---------- JALR TEST ----------
instructionRegister[32] = 32'h00000093; // addi x1,x0,0
instructionRegister[33] = 32'h000080E7; // jalr x1,x1,0

// ---------- END LOOP ----------
instructionRegister[34] = 32'h0000006F; // infinite loop

end


   
    always @(*) begin
        instruction = instructionRegister[pc[7:2]];
    end

endmodule
