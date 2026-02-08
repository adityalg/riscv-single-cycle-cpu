# RV32I Single-Cycle CPU

A fully functional RV32I single-cycle processor written in Verilog.

## Features
- Complete R-type instruction set
- Complete I-type instruction set
- Load/store support (LB, LH, LW, LBU, LHU, SB, SH, SW)
- Branch instructions (BEQ, BNE, BLT, BGE, BLTU, BGEU)
- Jump instructions (JAL, JALR)
- U-type instructions (LUI, AUIPC)

## Architecture
- Single-cycle implementation
- Separate instruction and data memory
- 32-bit datapath

## Testing
- Verified using behavioral simulation
- Full instruction coverage testbench included
