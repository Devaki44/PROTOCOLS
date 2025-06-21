//TESTBENCH

module APB_tb;
	reg clk;
	reg rst;
	reg transfer;
	reg read_write;
	reg [7:0]apb_read_add;
	reg [7:0]apb_write_add;
	reg [7:0]apb_write_data;
	reg [7:0]pr_data;
	reg pready;

	wire psel;
	wire penable;
	wire pwrite;
	wire [7:0]padd;
	wire [7:0]pwdata;
	wire [7:0]apb_read_data;

APB_master uut(clk,rst,transfer,read_write,apb_read_add,apb_write_add,apb_write_data,pr_data,pready,psel,penable,pwrite,padd,pwdata,apb_read_data);

initial begin
	clk = 1'b0 ;
	forever #5 clk = ~clk ;
end
initial begin
	#5;   //IDLE
	rst        =1;
	transfer   =0;
	read_write =0;
	apb_read_add      = 0;
	apb_write_add      =0;
	apb_write_data     =0;
	pr_data    =0;
	pready     =0;

	#10;                 //SETUP
	rst        =0;
	transfer   =1;
	read_write =1;
	apb_read_add       =0;
	apb_write_add      =8'hab;
	apb_write_data     =8'hcd;
	pr_data    =0;
	pready     =0;

	#10;		    //ACCESS
	rst        =0;
	transfer   =1;
	read_write =1;
	apb_read_add       =0;
	apb_write_add      =8'hab;
	apb_write_data     =8'hcd;
	pr_data    =0;
	pready     =1;

	#10;
	rst        =0;
	transfer   =1;
	read_write =0;
	apb_read_add       =8'hcd;
	apb_write_add      =0;
	apb_write_data     =0;
	pr_data    =8'hff;
	pready     =1;

	#10;
	rst        =0;
	transfer   =1;
	read_write =0;
	apb_read_add       =8'hcd;
	apb_write_add      =0;
	apb_write_data     =0;
	pr_data    =8'hff;
	pready     =1;


	#200;
	$finish;
end
initial begin
	$dumpfile("dump.vcd");
	$dumpvars;
end
endmodule
