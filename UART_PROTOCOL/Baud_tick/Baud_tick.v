//DESIGN CODE
module  baud_tick(
	input clk,
	input rst,
        output reg baud_tick);
parameter N=16;
parameter M=5208;

reg [(N-1):0]count = 0;

always@(posedge clk)begin
if(rst)begin
	count     <= 0;
	baud_tick <= 0;	
end
else begin
	if(count == (M-1))begin
	    count <= 0;
	    baud_tick <= 1;
	end
	else begin
	    count <= count+1;
	    baud_tick <= 0;
	end
	
end
end
endmodule
	
 	
