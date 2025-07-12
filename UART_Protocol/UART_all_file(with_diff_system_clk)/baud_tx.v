module baud_tx(
        input clk,
        input rst,
        output reg baud_tx);

parameter FRE       = 50_000_000;
parameter BAUD_RATE = 9600;
parameter COUNT_MAX = FRE / BAUD_RATE;

reg [13:0]count=0;

always@(posedge clk)begin
        if(rst)begin
                count     <= 0 ;
                baud_tx   <= 0 ;
        end
        else if(count == COUNT_MAX - 1)begin
                count     <= 0;
                baud_tx   <= 1;
        end
        else begin
                count     <= count+1;
                baud_tx   <= 0;
        end
end
endmodule                                                                                                                                               
