`timescale 1ns/1ps
module imm_generator (
    input [2:0] immediate_type,
    input [31:0] instruction,
    output reg [31:0] immediate_value

);

always @(*) begin
    immediate_value= {32{1'b0}};

    case (immediate_type)
    (3'b001): begin      // I type
        immediate_value = {{20{instruction[31]}}, instruction[31:20]};

    end
    (3'b010): begin     // S type
        immediate_value = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};


    end
    (3'b011): begin // b type
        immediate_value[12]= instruction[31];
        immediate_value[10:5] = instruction[30:25];
        immediate_value[4:1]  = instruction[11:8];
        immediate_value[11] = instruction[7];
        immediate_value[0] = 1'b0;
        immediate_value[31:13]={19{instruction[31]}};
        end
    
    (3'b000): begin // j type
        immediate_value[20] = instruction[31];
        immediate_value[10:1]= instruction[30:21];
        immediate_value[11]= instruction[20];
        immediate_value[19:12]= instruction[19:12];
        immediate_value[0] = 1'b0;
        immediate_value[31:21]= {11{instruction[31]}};

    end    
    (3'b100) : begin // u type
            immediate_value ={instruction[31:12], 12'b0};
        end
        default: immediate_value= {32{1'b0}};
    endcase
    
end
    
endmodule