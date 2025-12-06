# Parameterized SystemVerilog ALU + Constrained-Random Verification

A compact SystemVerilog ALU showcasing clean RTL design and a simple yet effective
verification environment. The module supports add, subtract, AND, OR, XOR, and
includes zero, carry, and overflow flags. The testbench uses constrained-random
stimulus, a scoreboard-style expected model, and a basic assertion.

This project is intended as a lightweight but professional example of RTL design
and verification fundamentals relevant to ASIC, DV, and FPGA workflows.

---

## ✨ Features

- **Parameterized data width** (default 8 bits)  
- **Add, subtract, AND, OR, XOR** operations  
- **Zero, carry, overflow** flags  
- **Clean `unique case` decode** for combinational logic  
- **Constrained-random verification testbench**  
- **Scoreboarding** via expected-value model  
- **Assertion checking** on the zero flag  

---

## 📁 Files

- `alu.sv` — RTL implementation  
- `tb_alu.sv` — constrained-random self-checking testbench  

---

## ▶️ Running the Simulation

Example using Icarus Verilog:

```bash
iverilog -g2012 alu.sv tb_alu.sv -o alu_tb
./alu_tb
