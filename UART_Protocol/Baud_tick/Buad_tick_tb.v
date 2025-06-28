module baud_tick_tb;
	reg clk;
	reg rst;
	wire baud_tick;

baud_tick uut(clk,rst,baud_tick);

initial begin
	clk = 0;
	forever #10 clk = ~clk;
end
initial begin
	rst = 1;#30;
	rst = 0;#50_000_000;
	$finish;
end
initial begin
	$dumpfile("dump.vcd");
	$dumpvars;
end
endmodule

