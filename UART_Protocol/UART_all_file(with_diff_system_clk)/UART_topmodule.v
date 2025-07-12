module top_module(
        input clk1,
        input clk2,
        input rst,
        input start,
        input [7:0]data_in,
        input p_sel,

        output tx,
        output [7:0]data_out,
        output p_err);

baud_tx uut_b0( .clk(clk1),
                 .rst(rst),
                 .baud_tx(baud_tx));

baud_rx uut_b1( .clk(clk2),
                 .rst(rst),
                 .baud_rx(baud_rx));


UART_tx   uut_t( .clk(clk1),
                 .rst(rst),
                 .start(start),
                 .data_in(data_in),
                 .p_sel(p_sel),
                 .baud_tx(baud_tx),
                 .tx(tx));

UART_rx   uut_r( .clk(clk2),
                 .rst(rst),
                 .baud_rx(baud_rx),
                 .rx(rx),
                 .p_err(p_err),
                 .data_out(data_out));
assign rx=tx;

endmodule
