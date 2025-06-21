//DESIGN CODE
module APB_slave(
	input clk,
	input rst,
	input w_en,
	input [7:0]add,
	input [7:0]data_in,
	output reg [7:0]data_out);

  reg [7:0]mem[255:0];
always@(posedge clk)begin
    if(rst)begin
		data_out <=  8'h0 ;
    end
	else begin
		if(w_en)
			mem[add] <= data_in ;
		else
			data_out <= mem[add] ;
	end
end
endmodule




