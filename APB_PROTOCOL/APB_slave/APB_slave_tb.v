module APB_slave_tb;
    reg clk;
	reg rst;
	reg w_en;
    reg [7:0]add;
    reg [7:0]data_in;
	wire [7:0]data_out;
  APB_slave uut(clk,rst,w_en,add,data_in,data_out);
  initial begin
    clk = 0 ;
    forever #5 clk = ~clk ;
  end
  initial begin
    rst=1;
    w_en	=0;
    add 	=3'b010;
    data_in	=8'b11111111;
    
    #10;
    rst 	=0;
    w_en	=1;
    add 	=3'b010;
    data_in	=8'b11111111;
    
    #10;
    rst 	=0;
    w_en	=0;
    data_in =0;
    add 	=3'b010;
    
    #50;
    
    $finish;
  end
//   initial begin
//     $dumpfile("dump.vcd");
//     $dumpvars;
//   end
  initial begin
    $monitor("$time=%0t,clk=%b,rst=%b,w_en=%b,add=%b,data_in=%b,data_out=%b",$time,clk,rst,w_en,add,data_in,data_out);
  end
endmodule
    
    
