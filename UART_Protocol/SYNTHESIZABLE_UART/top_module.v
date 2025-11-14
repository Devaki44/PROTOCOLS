module top_module(
        input clk1,
        input rst,
        input start,
        input [7:0]data_in,
        input p_sel,

        output tx);
        
//wire tx;
 wire baud_tx;
baud_tx uut_b0( .clk(clk1),
                 .rst(rst),
                 .baud_tx(baud_tx));

UART_tx   uut_t( .clk(clk1),
                 .rst(rst),
                 .start(start),
                 .data_in(data_in),
                 .p_sel(p_sel),
                 .baud_tx(baud_tx),
                 .tx(tx));



endmodule
