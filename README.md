# Single-Cycle RISC-V CPU (RV32I Subset) – Verilog

This repository contains a **single-cycle RISC-V CPU** implemented in **pure Verilog**, supporting a subset of the RV32I ISA.  
The project is intended as a learning-oriented yet structurally clean CPU design, with a roadmap toward **verification and pipelining**.

---

## Current Status

✔ Single-cycle datapath  
✔ Modular RTL design  
✔ Fully functional ALU and register file  
✔ Correct immediate generation and PC control  
✔ Clean control-signal-driven muxing  

The CPU has been tested at the module level and is ready for system-level simulation using a testbench.

---

## Supported Instructions (RV32I Subset)

### R-type
- `ADD`
- `SUB`
- `AND`
- `OR`

### I-type
- `ADDI`
- `LW`

### S-type
- `SW`

### B-type
- `BEQ`

### J-type
- `JAL`

---

## Datapath Overview

- **Single-cycle implementation**
- Separate modules for:
  - Program Counter (PC)
  - Instruction Memory
  - Register File (x0 hardwired to zero)
  - ALU
  - Immediate Generator
  - Control Unit
  - Data Memory
- Three main multiplexers:
  - ALU source selection (register / immediate)
  - Write-back selection (ALU / memory / PC+4)
  - PC update selection (PC+4 / branch target / jump target)

A detailed datapath diagram will be added in a future update.

---

## Project Structure

