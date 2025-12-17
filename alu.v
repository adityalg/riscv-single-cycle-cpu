`timescale 1ns / 1ps
module alu(
input [2:0]alu_control,
input [31:0]src1,
input [31:0]src2,
output reg [31:0]alu_ans,
output reg zero
    );
    parameter add=3'b000, sub=3'b001, andop=3'b010, orop=3'b011;
    always @(*)
    begin
    zero=0;
    alu_ans=0;
    case(alu_control)
    add: alu_ans = src1+src2;
    sub: begin 
    alu_ans = src1-src2;
    if(alu_ans==0)
    zero=1;
    else zero =0;
    end
    andop: alu_ans= src1&src2;
    orop: alu_ans=src1 | src2;
    default : alu_ans=0;
    endcase
    end
        
endmodule
