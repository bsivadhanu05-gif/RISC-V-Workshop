# Verilog Activity Tasks 1.1–1.4

Each activity folder contains the RTL and a testbench.

For other folders, compile the listed RTL and testbench files and simulate the matching testbench top module.

## Notes
- ALU operation codes are in `alu.v`: ADD=000, SUB=001, AND=010, OR=011, XOR=100, SLT=101, SLL=110, SRL=111. The right shift in the ALU is logical; arithmetic right shift is separately supported by the barrel shifter.
- Counter priority is synchronous reset, then parallel load, then enabled count.
- Register-file reads are asynchronous and include same-cycle write-through bypass. x0 is hardwired to zero.
- Design shifter implements a combinational shift operation that shifts binary data left or right by a specified number of bit positions using the shift amount and control signals, supporting logical left shift (SLL), logical right shift (SRL), and arithmetic right shift (SRA), where zeros are inserted during logical shifts and the sign bit is preserved during arithmetic right shift, producing the shifted result at the output without requiring a clock signal.

## Waveform screenshots
For each testbench, open the waveform window, add relevant signals (`add wave *`), run to completion, zoom full, and take a screenshot. The screenshot must be captured from your simulator; it is not fabricated or included here.
