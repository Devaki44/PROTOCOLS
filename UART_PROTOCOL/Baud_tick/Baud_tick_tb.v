//TESTBENCH
`timescale 1ns/1ps
module baud_tick_tb;
  reg  clk;
  reg  rst;
  wire baud_tick;

  parameter M = 5208;
  parameter N = 16;

  baud_tick uut (
    .clk(clk),
    .rst(rst),
    .baud_tick(baud_tick)
  );
  
  initial begin
     clk =0;
     forever #5 clk = ~clk;
  end
  initial begin
    rst = 1;
    #50;
    rst = 0;
    #(M * 5 * 20); 
    $stop;
  end

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
  end
endmodule  
