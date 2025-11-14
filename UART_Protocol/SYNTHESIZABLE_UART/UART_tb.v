module UART_tb;
        reg clk1;
        reg rst;
        reg start;
        reg [7:0]data_in;
        reg p_sel;
        wire tx;
        
//   top_module uut(clk1,rst,start,data_in,p_sel,tx);


initial begin
        clk1=0;
        forever #10 clk1 = ~clk1 ;
end
initial begin
  rst = 1;
  start = 0;
  data_in = 8'b1010_1010;
  p_sel = 1;

  #100;
  rst = 0;
  start = 1;
  #100;
  data_in = 8'b0101_0101;
  #20;
  start = 1;

  #100_000_000;
  $finish;

end
initial begin
        $dumpfile("dump.vcd");
        $dumpvars(1);
end
endmodule
