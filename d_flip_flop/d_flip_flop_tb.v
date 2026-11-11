// D Flip-Flop Testbench
`timescale 1ns/1ps

module d_flip_flop_tb;

reg D;
reg CLK;
wire Q;

d_flip_flop uut (
    .D(D),
    .CLK(CLK),
    .Q(Q)
);

// Clock generation: 10 ns period
initial begin
    CLK = 0;
    forever #5 CLK = ~CLK;
end

// Input stimulus
initial begin
    D = 0;
    #10 D = 1;
    #10 D = 0;
    #10 D = 1;
    #10 D = 0;
    #10 $finish;
end

// Display signal values
initial begin
    $monitor("Time=%0t | CLK=%b | D=%b | Q=%b", $time, CLK, D, Q);
end

endmodule
