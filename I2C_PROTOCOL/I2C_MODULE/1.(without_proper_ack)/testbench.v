module testbench;
  reg clk;
  reg rst;
  reg start;
  reg w_en;
  reg [7:0]data,data2,s_addr,s_addr2,r_addr;
  wire  sda;
  wire temp;
  wire sig;
  
  pullup(sda);
  
  top_module t(clk,rst,start,w_en,data,data2,s_addr,s_addr2,r_addr,sda,temp,sig);
  
  initial begin
    clk = 0;
    forever #5 clk = ~clk ;
  end
  initial begin
    rst = 1;
    #300;
    rst = 0;
    start = 1;
    w_en = 0;
    s_addr = 8'hcd;
    r_addr = 8'h81;
    data = 8'hb7;       
    s_addr2 = 8'he4;

    
    wait(!temp);
    start =  0;
    #20;
    start =1;
    #10;
    wait(sig);
    w_en = 1;
    #10;
    wait(!temp);
    start =  0;
  end
  initial begin
    #7000;
    $finish;
  end
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
  end
endmodule

















https://www.edaplayground.com/x/CPhn
