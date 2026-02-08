`timescale 1ns / 1ps
module alu(
input [3:0]alu_control,
input [31:0]src1,
input [31:0]src2,
output reg [31:0]alu_ans,
output reg zero
    );
    parameter add=4'b0000, sub=4'b0001, andop=4'b0010, orop=4'b0011, xorop=4'b0100, sll= 4'b0101, srl =4'b0110, sra =4'b0111, slt= 4'b1000, sltu= 4'b1001;
    always @(*)
    begin
    zero=0;
    alu_ans=0;
    case(alu_control)
    xorop: begin alu_ans= (src1)^(src2);
    zero = (alu_ans == 0);
    end
    sll : begin
        alu_ans= src1<< src2[4:0];
        zero=(alu_ans==0);
    end
    slt : begin
        if ($signed (src1 )<$signed(src2))
        begin
        alu_ans=32'd1;
        zero=0;
        end
        else begin
            alu_ans =32'd0;
            zero=1;
        end
        end
    sra : begin
        alu_ans = $signed(src1)>>> src2[4:0];
        zero =(alu_ans==0);
    end     
    sltu : begin
        if ((src1 )<(src2))
        begin
        alu_ans=32'd1;
        zero=0;
        end
        else begin
            alu_ans =32'd0;
            zero=1;
        end
    end
    add:begin  alu_ans = src1+src2;
    zero = (alu_ans == 0);
    end
    

srl: begin
    alu_ans= src1 >> src2[4:0];
    zero =(alu_ans==0);

end
    sub: begin 
    alu_ans = src1-src2;
    zero = (alu_ans == 0);

    end
    andop:begin alu_ans= src1&src2;
    zero = (alu_ans == 0);
    end

    orop: begin alu_ans=src1 | src2;
    zero = (alu_ans == 0);
    end
    default : alu_ans=0;
    endcase
    end
        
endmodule
