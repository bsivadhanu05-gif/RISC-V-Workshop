# Day 3 – Single-Cycle RISC-V CPU

## Goal
Extend the single-cycle CPU with additional RV32I instructions, execute assembly programs, verify results automatically, and inspect simulation waveforms.

## Activities

### 3.1 Instruction Extensions
Implement and verify these instructions:
- ANDI, ORI, XORI
- SLTI
- SLLI, SRLI, SRLI/SRAI as supported by the design
- LUI
- JAL

Update the ALU, immediate generator, and control unit as required. JAL must write `PC + 4` to `rd` and redirect the PC to the jump target.

### 3.2 Assembly Programs
Create and assemble three programs:
1. Sum of integers from 1 to N.
2. Generate and store the first 10 Fibonacci numbers.
3. Find the maximum value in an array of 8 words.

Include comments for each instruction and its machine encoding. Produce:
- `program1.hex`
- `program2.hex`
- `program3.hex`

### 3.3 Self-Checking Testbench
Use `cpu_tb.v` to:
1. Apply reset.
2. Load a program into instruction memory.
3. Run the CPU for the required cycles.
4. Compare the final register/memory values with expected results.
5. Print `PASS` or `FAIL` automatically.

### 3.4 Waveform Analysis
For Program 1, capture and annotate:
- Program Counter (PC)
- Instruction
- ALU result
- Write-back data

Explain the behavior of three instructions, including one branch.

## Files
- `single_cycle/alu.v`
- `single_cycle/control_unit.v`
- `single_cycle/immediate_generator.v`
- `single_cycle/register_file.v`
- `single_cycle/cpu.v`
- `single_cycle/cpu_tb.v`
- `programs/program1_sum.asm`
- `programs/program2_fibonacci.asm`
- `programs/program3_max.asm`

## Simulation (Icarus Verilog)
From the project root:
```bash
iverilog -g2012 -o day3_sim single_cycle/*.v
vvp day3_sim
```

For ModelSim, add the Day 3 source files to a project, compile them, set `cpu_tb` as the simulation top, and run the simulation.

## Expected Deliverables
- Updated single-cycle CPU source files
- Three assembly programs and their HEX files
- Self-checking testbench output showing PASS/FAIL
- Annotated waveform screenshot and explanation

## Notes
This is a teaching subset, not a complete RV32I implementation. Check the instruction encodings, branch offsets, memory indexing, and expected results against your final design before submission.
