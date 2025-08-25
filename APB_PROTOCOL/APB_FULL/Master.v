module APB_master(
	input clk,
	input rst,
	input transfer,
	input read_write,
	input [7:0]apb_read_add,
	input [7:0]apb_write_add,
	input [7:0]apb_write_data,
	input [7:0]pr_data,
	input pready,

	output psel,
	output reg penable,
	output pwrite,
	output [7:0]pw_add,
	output [7:0]pw_data,
	output [7:0]apb_read_data);

parameter IDLE   = 2'b00 ,
	  SETUP  = 2'b01 ,
	  ACCESS = 2'b10 ;

reg [1:0]state,next_state;


always@(posedge clk)begin   //reset logic
  if(rst)
	state <= IDLE ;
  else
	state <= next_state ;
end


    always @(*) begin
        case(state)
            IDLE:begin
		              penable =1'b0;
                  if (transfer)
                    next_state = SETUP;
                  else
                    next_state = IDLE;
	         end

	    SETUP: begin
		            penable = 1'b0;    
                next_state = ACCESS;
          	end

	ACCESS: begin
		            penable = 1'b1;
                if (pready && transfer)
                    	next_state = SETUP;
                else if (pready && !transfer)
		                	next_state = IDLE;
                else if (!pready)
                    	next_state = ACCESS;
	    	        else
			                next_state = IDLE;
	        end
            default:next_state = IDLE;
        endcase
    end

assign psel           = (state != IDLE) ;
assign pwrite         = ((state == SETUP) || (state == ACCESS)) ? read_write : 1'b0 ;
assign pw_add         = ((state == SETUP) || (state == ACCESS)) ? apb_read_add : 1'b0 ;
assign pw_data         = (((state == SETUP) || (state == ACCESS)) && read_write) ? apb_write_data : 1'b0 ;
assign apb_read_data  = (((state == SETUP) || (state == ACCESS)) && !read_write ) ? pr_data : 1'b0 ;

endmodule
