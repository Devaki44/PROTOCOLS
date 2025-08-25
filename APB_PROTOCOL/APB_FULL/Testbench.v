module APB_topmodule_tb;
        reg clk;
	reg rst;
	reg transfer;
	reg read_write;
	reg [7:0]apb_read_add;
        reg [7:0]apb_write_add;
	reg [7:0]apb_write_data;
	
	wire [7:0]pr_data;
	wire ready;

APB_topmodule uut(clk,rst,transfer,read_write,apb_read_add,apb_write_add,apb_write_data,pr_data,ready);
	
initial begin
	clk=0;
	forever #5 clk=~clk;
end
initial begin
    #5;
    rst = 1;
    transfer = 1; 
    read_write = 0;
    apb_read_add = 0;
    apb_write_add = 0;
    apb_write_data = 0;

    #5;
    rst = 0;
   
    // Write to address 8'h10
    #5; 
    read_write = 1; 
    apb_write_add = 8'h10; 
    apb_read_add = 8'h10; 
    apb_write_data = 8'hA5;

    // Write to address 8'h10
    #50;
    read_write = 0;
    apb_write_add = 8'h10; 
    #30;
    transfer = 0;
    #50;

    $finish;
end 
initial begin
	$dumpfile("dump.vcd");
	$dumpvars(0,APB_topmodule_tb);
end
endmodule
