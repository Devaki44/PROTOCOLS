module UART_rx_tb;
	reg clk;
	reg rst;
	reg rx;
	wire baud_tick;
	wire p_err;
	wire [7:0]data_out;

baud_tick uut1(.clk(clk),.rst(rst),.baud_tick(baud_tick));
UART_rx   uut2(.clk(clk),.rst(rst),.rx(rx),.baud_tick(baud_tick),.p_err(p_err),.data_out(data_out));

initial begin
	clk =0 ;
	forever #10 clk= ~clk;
end
initial begin
    rst = 1;
    rx  = 1;
    #100;

    rst = 0;
    repeat (2) @(posedge baud_tick);
    rx  = 0;
    @(posedge baud_tick);

    uart_send_byte(8'b1010_1011, 1'b1);
    #12000;
end
 

task uart_send_byte;
    input [7:0] data;
    input parity_bit;

    integer i;
    begin
      // Send 8 data bits (LSB first)
      for(i = 0; i < 8; i = i + 1) begin
        rx = data[i];
        @(posedge baud_tick);
      end

      // Parity bit
      rx = parity_bit;
      @(posedge baud_tick);

      // Stop bit
      rx = 1;
      @(posedge baud_tick);
    end
endtask

initial  begin
	$dumpfile("dump.vcd");
	$dumpvars;
end
endmodule
