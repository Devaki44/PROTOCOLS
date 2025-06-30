module APB_slave_tb;
  reg clk;
  reg rst;
  reg sel;
  reg enable;
  reg w_en;
  reg [7:0]add;
  reg [7:0]data_in;
  wire ready;
  wire [7:0]data_out;
  
  APB_slave uut(clk,rst,sel,enable,w_en,add,data_in,ready,data_out);
  
  initial begin
    clk = 0;
    forever #5 clk = ~clk ;
  end
  initial begin
    rst=1;
    sel=0;
    enable=0;
    #100;
    rst=0;
    sel=1;
    enable=0;
    w_en=1;
    add=8'hcd;
    data_in=8'hee;
    #1000;
    enable=1;
    #1000;
    w_en=0;
    #100_000;
    $finish;
  end
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
  end
endmodule
    
