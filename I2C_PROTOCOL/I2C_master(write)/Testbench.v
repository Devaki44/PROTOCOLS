module testbench;
  reg clk;
  reg rst;
  reg start;
  reg w_en;
  reg [7:0]data,s_addr,r_addr;
  wire sda;
  
  master dut(clk,rst,start,w_en,data,s_addr,r_addr,sda);
  
  initial begin
    clk = 0;
    forever #5 clk = ~clk ;
  end
  initial begin
    rst = 1;
    #40;
    rst = 0;
    start = 1;
    w_en = 0;
    s_addr = 8'hcd;
    r_addr = 8'h81;
    data = 8'hb7;
  end
  initial begin
    #5000;
    $finish;
  end
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
  end
endmodule
