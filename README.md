# SystemVerilog ALU (Parameterized RTL + Directed & Random Verification)

A compact but professional ASIC/DV-style project demonstrating:

- Clean RTL design  
- Arithmetic flag handling  
- Directed corner-case tests  
- Constrained-random testing  
- Assertions for correctness  
- Scoreboarding  
- Coverage-style counters  

This is representative of fundamentals used in silicon, DV, and FPGA workflows.

---

## Features

### RTL Design
- Parameterized width (default 8 bits)  
- ADD, SUB, AND, OR, XOR  
- Zero, carry/borrow, signed overflow flags  
- `unique case` decode for clarity  

### Verification
- Directed stress tests (overflow, borrow, boundaries)  
- 100-vector constrained-random regression  
- Scoreboard comparing DUT vs. expected model  
- Assertions for zero and overflow correctness  
- Functional-coverage-style operation counters  
- PASS/FAIL summary  

---

## Running

```bash
iverilog -g2012 alu.sv tb_alu.sv -o alu_tb
./alu_tb
