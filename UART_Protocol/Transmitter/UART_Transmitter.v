module UART_tx(
	input clk,
	input rst,
	input start,
	input [7:0]data_in,
	input p_sel,
	input baud_tick,
	output reg tx);

parameter IDLE  =3'b000,	
	  START =3'b001,
	  DATA  =3'b010,
	  PARITY=3'b011,
	  STOP  =3'b100;

reg [2:0]state,next_state;
reg [2:0]count=0;
reg parity=0;

always@(posedge clk)begin
if(rst)
	state <= IDLE;
else
	state <= next_state;
end

always@(*)begin
	case(state)
		IDLE :begin
			if(start)
			  next_state = START;
			else
		 	  next_state = IDLE;
		      end
		START:begin
			if(baud_tick)			  
			  next_state = DATA;
			else
			  next_state = START;
		      end 
		DATA :begin
			if(baud_tick && count == 7)
    			    next_state = PARITY;
  			else
			    next_state = DATA;
		      end
	 	PARITY :begin
			  if(baud_tick)
      		            next_state = STOP;
		          else
		            next_state = PARITY;
			end
		STOP   :begin
			  if(baud_tick)
			    next_state = IDLE;
                          else begin
			    next_state = STOP;
			  end
			end
		default:next_state = IDLE;
	endcase
end
always@(posedge clk)begin
if(rst)begin
	count    <= 0;
	tx       <= 1;

end
else begin
     if(baud_tick)begin
	case(state)
	  IDLE   :begin
		   tx <= 1;
	          end
	  START  :begin
		   tx <= 0;
		          end
	  DATA   :begin
		   tx <= data_in[count];
		   count <= count+1;
	          end
	  PARITY :begin
		   tx <= parity;
		   parity <= (p_sel) ? ^data_in : ~(^data_in);
	          end
          STOP   :begin
		   tx <= 1;
		  end

        endcase
     end
end
end
endmodule

////////////////////////////////////baud_tick////////////////////////////////////////

module baud_tick(
	input clk,
	input rst,
	output reg baud_tick);

parameter FRE       = 50_000_000;
parameter BAUD_RATE = 9600;
parameter COUNT_MAX = FRE / BAUD_RATE;

reg [13:0]count=0;

always@(posedge clk)begin
	if(rst)begin
		count  	  <= 0 ;
		baud_tick <= 0 ;
	end
	else if(count == COUNT_MAX - 1)begin
		count  	  <= 0;
		baud_tick <= 1;
	end
	else begin
		count 	  <= count+1;
		baud_tick <= 0;
	end
end
endmodule
