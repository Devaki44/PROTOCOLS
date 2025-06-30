module APB_topmodule(
	input clk,
	input rst,
	input transfer,
	input read_write,
	input [7:0]apb_read_add,
        input [7:0]apb_write_add,
	input [7:0]apb_write_data,

	output wire [7:0]pr_data,
	output wire ready);


wire psel;
wire penable;
wire pwrite;
wire [7:0]pw_add;
wire [7:0]pw_data;
wire [7:0]apb_read_data;
wire [7:0]data_out;
wire pready;

APB_master uut1(.clk(clk),
		.rst(rst),
		.transfer(transfer),
		.read_write(read_write),
		.apb_read_add(apb_read_add),
		.apb_write_add(apb_write_add),
		.apb_write_data(apb_write_data),
		.pr_data(data_out),
		.pready(pready),
		.psel(psel),
		.penable(penable),
		.pwrite(pwrite),
		.pw_add(pw_add),
		.pw_data(pw_data),
		.apb_read_data(apb_read_data));

APB_slave uut2(.clk(clk),
	       .rst(rst),
	       .sel(psel),
	       .enable(penable),
	       .w_en(pwrite),
	       .add(pw_add),
	       .data_in(pw_data),
	       .ready(pready),
       	       .data_out(data_out));

assign pr_data = apb_read_data;
assign ready   = pready;

endmodule
