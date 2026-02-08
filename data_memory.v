`timescale 1ns / 1ps
module data_memory (
    input clk,
    input MemRead,
    input MemWrite,
    input [2:0]funct3,
    input [31:0] address,
    input  [31:0] writeData,
    output reg [31:0] readData
);

                    
    reg [31:0] memory [0:63];// data memory 256 bytes

    
   always @(posedge clk) begin
    if (MemWrite) begin
        case(funct3)

            3'b010: memory[address[31:2]] <= writeData;  // SW

            3'b000: begin // SB
                case(address[1:0])
                    2'b00: memory[address[31:2]][7:0]   <= writeData[7:0];
                    2'b01: memory[address[31:2]][15:8]  <= writeData[7:0];
                    2'b10: memory[address[31:2]][23:16] <= writeData[7:0];
                    2'b11: memory[address[31:2]][31:24] <= writeData[7:0];
                endcase
            end

            3'b001: begin // SH
                if(address[1] == 1'b0)
                    memory[address[31:2]][15:0] <= writeData[15:0];
                else
                    memory[address[31:2]][31:16] <= writeData[15:0];
            end

        endcase
    end
end


   
    always @(*) begin
        if (MemRead)
            readData = memory[address[31:2]];
        else
            readData = 32'b0;
    end

endmodule
