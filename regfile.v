`timescale 1ns/1ps
module regfile(
input clk,
input RegWrite,
input [4:0] rs1,
input [4:0] rs2,
input [4:0] rd,
input [31:0]writeBackData,
output reg [31:0]src1,
output reg [31:0] src2
);
reg [31:0]registers [0:31];


always @(posedge clk)
begin
if(RegWrite) 
begin
if (rd != 5'b00000)
registers[rd]<=writeBackData;
end
end 
always @(*)
begin
if(rs1==5'b0)
begin
src1=32'b0;
end

else 
begin
src1 =registers[rs1];
end
if(rs2==5'b0)
begin 
src2=32'b0;
end
else
begin
src2=registers[rs2];
end
end 
endmodule