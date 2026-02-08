`timescale 1ns/1ps

module cpu_tb;

    reg clk;
    reg rst;

    // Instantiate CPU
    cpu_top uut (
        .clk(clk),
        .rst(rst)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Reset sequence
    initial begin
        rst = 1;
        #20;
        rst = 0;
    end

    // Simulation timeout safety
    initial begin
        #2000;
        $display("Simulation finished (timeout).");
        $stop;
    end

    // Monitor PC and instruction
    always @(posedge clk) begin
        if (!rst) begin
            $display("Time=%0t | PC=%0d | Instr=%h",
                     $time,
                     uut.pc_inst.pc,
                     uut.instr_mem.instruction);
        end
    end

    // Monitor register writes
    always @(posedge clk) begin
        if (uut.regfile_inst.RegWrite) begin
            $display("   --> Write x%0d = %0d",
                     uut.regfile_inst.rd,
                     uut.regfile_inst.writeBackData);
        end
    end

endmodule
