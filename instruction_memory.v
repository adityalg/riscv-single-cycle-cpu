`timescale 1ns / 1ps

module instruction_memory (
    input  [7:0]  pc,
    output reg [31:0] instruction
);

    
    reg [31:0] instructionRegister [0:63];

    
    initial begin
        instructionRegister[0] = 32'h00000013; 
        instructionRegister[1] = 32'h00100093; 
        instructionRegister[2] = 32'h00200113; 
        instructionRegister[3] = 32'h002081B3; 
        instructionRegister[4] = 32'h00000013; 

        
     
    end

   
    always @(*) begin
        instruction = instructionRegister[pc[7:2]];
    end

endmodule
