module APB_slave(
	input clk,
	input rst,
  	input sel,
    	input enable,
	input w_en,
	input [7:0]add,
	input [7:0]data_in,
        output reg ready,
	output reg [7:0]data_out);

  reg [7:0]mem[255:0];
  
always@(posedge clk)begin
    if(rst)begin
		data_out <=  8'h0 ;
        	ready    <=  0 ;
    end
    else if (sel && enable)begin
       		 ready <= 1 ;
		if(w_en)
			mem[add] <= data_in ;
		else
			data_out <= mem[add] ;
	end
end
endmodule
