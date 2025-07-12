module UART_tb;
        reg clk1;
        reg clk2;
        reg rst;
        reg start;
        reg [7:0]data_in;
        reg p_sel;
        wire tx;
        wire [7:0]data_out;
        wire p_err;

top_module uut(clk1,clk2,rst,start,data_in,p_sel,tx,data_out,p_err);

initial begin
        clk1=0;
        forever #10 clk1 = ~clk1 ;
end
initial begin
        clk2= 0;
        forever #12.5 clk2 = ~clk2 ;
end
initial begin
  rst = 1;
  start = 0;
  data_in = 8'b0000_0000;
  p_sel = 1;

  #100;
  rst = 0;
  #100;
  data_in = 8'b1111_1111;
  #20;
  start = 1;

  #100_000_000;
  $finish;

end
initial begin
        $dumpfile("dump.vcd");
        $dumpvars;
end
endmodule
