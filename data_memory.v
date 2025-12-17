`timescale 1ns / 1ps
module data_memory (
    input  clk,
    input  MemRead,
    input   MemWrite,
    input   [31:0] address,
    input  [31:0] writeData,
    output reg [31:0] readData
);

                    
    reg [31:0] memory [0:63];// data memory 256 bytes

    
    always @(posedge clk) begin
        if (MemWrite) begin
            memory[address[31:2]] <= writeData;
        end
    end

   
    always @(*) begin
        if (MemRead)
            readData = memory[address[31:2]];
        else
            readData = 32'b0;
    end

endmodule
