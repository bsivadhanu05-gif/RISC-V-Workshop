DAY 2 VERILOG ACTIVITIES 2.1–2.4
================================

Folders contain RTL, testbenches and supporting files.

Important design notes:
1) Sequence detector pattern is 1011 with overlap. Moore output is asserted in its detect state after the final input edge; Mealy output is asserted combinationally when the final '1' is present in the current state. The Moore indication is one clock later/one state interval later than the Mealy indication.
2) Vending machine accepts one coin pulse at a time. If both coin inputs are high together, the 10-rupee coin takes priority. Dispense is a one-clock pulse; change is the returned amount in rupees. Cancel returns the accumulated credit.
3) FIFO is synchronous, 16 entries x 8 bits. At full, writes are rejected; at empty, reads are rejected. Simultaneous read/write is accepted when both operations are legal and leaves occupancy unchanged. In this compact implementation, a simultaneous operation at full rejects the write; at empty rejects the read.
4) Traffic FSM: a pedestrian request is latched during vehicle phases and serviced after the green/yellow sequence. Requests during WALK are ignored.
5) ATM uses a 4-bit parallel PIN input (default PIN_CODE=4'b1234), a 16-bit withdrawal amount and an initial balance parameter. The testbench uses PIN 0001 by overriding PIN_CODE in the DUT instance if desired; update the instance to .PIN_CODE(4'b0001) for that testbench.

