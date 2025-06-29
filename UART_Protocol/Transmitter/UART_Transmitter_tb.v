module UART_tx_tb;
	reg clk;
	reg rst;
	reg start;
	reg [7:0]data_in;
	reg p_sel;
	wire baud_tick;
	wire tx;

baud_tick uut1(.clk(clk),.rst(rst),.baud_tick(baud_tick));
UART_tx   uut2(clk,rst,start,data_in,p_sel,baud_tick,tx);

	initial begin 
		clk = 0;
		forever #10 clk =~clk ;
	end
	initial begin
      		rst = 1;
      		start = 1;
      		data_in = 8'b0;
      		p_sel = 0;

      		#100;
      		rst = 0;
		start = 0;
    		data_in = 8'b11001100;
    		p_sel = 1;     
    		start = 1;
 		
   		#12_000_000;
	 	$finish;
	end
	initial begin
		$dumpfile("dump.vcd");
		$dumpvars;
	end
endmodule	
