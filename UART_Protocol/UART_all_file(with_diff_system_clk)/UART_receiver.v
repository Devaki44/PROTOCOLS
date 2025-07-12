module UART_rx(
        input clk,
        input rst,
        input baud_rx,
        input rx,
        output reg p_err,
        output reg [7:0] data_out
);

parameter IDLE    = 2'b00,
          RECEIVE = 2'b01,
          PARITY  = 2'b10,
          STOP    = 2'b11;

reg [1:0]state,next_state;
reg [2:0]count = 0;
reg parity = 0;


always@(posedge clk)begin
if(rst)begin
        state <= IDLE;
        data_out <= 8'b0;
        p_err    <= 0;
        count    <= 0;
        parity   <= 0;

end
else
        state <= next_state;
end

always@(*)begin
  case(state)
        IDLE   :begin
                  if(baud_rx && rx==0)
                        next_state = RECEIVE;
                  else
                        next_state = IDLE;
                end
        RECEIVE:begin
                  if(baud_rx)begin
                    if(count == 7)
                            next_state = PARITY;
                    else
                          next_state = RECEIVE;
                  end
                end
        PARITY :begin
                  if(baud_rx)begin
                    next_state = STOP;
                  end
                  else
                    next_state = PARITY;
                end

        STOP   :begin
                  if(baud_rx)
                          next_state = IDLE;
                  else
                          next_state = STOP;
                end

  endcase
end
always@(posedge clk)begin
if(rst)begin
        count <= 0;
        data_out <= 0;
end
else begin
        if(baud_rx)begin
         case(state)
           IDLE   :begin
                     count <= 0;
                     data_out <= 0;
                   end
           RECEIVE:begin
                     data_out[count] <= rx;
                     count <= count+1;
                   end
           PARITY :begin
                     if(^data_out == rx)
                             p_err <= 0;
                     else
                             p_err <= 1;
                   end
           STOP   :begin
                     data_out <= data_out;
                   end
         endcase
        end
end
end
endmodule
