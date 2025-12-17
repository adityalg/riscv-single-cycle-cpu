`timescale 1ns / 1ps
module pc(
input clk,
input rst,
input [7:0] next_pc,
output reg [7:0] pc
);

always @(posedge clk or posedge rst)
begin
if(rst)
pc<=8'h00;
else
pc<=next_pc;
end
endmodule