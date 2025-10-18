module slave (
  input        clk,
  input        rst,
  inout        sda
);

  reg [8:0]   s_add;
  reg [7:0]   r_add;
  reg [7:0]   data;

  reg [3:0]   a_count, r_count, d_count;

  reg         sda_o;
  reg         sda_oe;
  assign sda = (sda_oe == 1) ? sda_o : 1'bz;

  reg [2:0]   state, next_state;

  localparam [2:0]
    IDLE  = 3'h0,
    S_ADD = 3'h1,
    ACK1  = 3'h2,
    R_ADD = 3'h3,
    ACK2  = 3'h4,
    DATA  = 3'h5,
    ACK3  = 3'h6,
    STOP  = 3'h7;

  always @(posedge clk) begin
    if (rst) state <= IDLE;
    else     state <= next_state;
  end

  always @(*) begin
    case (state)
      IDLE  : next_state = (sda == 1'b0) ? S_ADD : IDLE;
      S_ADD : next_state = (a_count==7)  ? ACK1  : S_ADD;
      ACK1  : next_state = R_ADD;
      R_ADD : next_state = (r_count==7)  ? ACK2  : R_ADD;
      ACK2  : next_state = DATA;
      DATA  : next_state = (d_count==7)  ? ACK3  : DATA;
      ACK3  : next_state = STOP;
      STOP  : next_state = IDLE;
      default: next_state = IDLE;
    endcase
  end

  always @(posedge clk) begin
    if (rst) begin
      s_add   <= 0;
      r_add   <= 0;
      data    <= 0;
      a_count <= 0;
      r_count <= 0;
      d_count <= 0;
      sda_o   <= 1;
      sda_oe  <= 0;
    end else begin
      case (state)
        IDLE: begin
          a_count <= 0;
          r_count <= 0;
          d_count <= 0;
          sda_o   <= 1;
          sda_oe  <= 0;
        end
        S_ADD: begin
          sda_oe <= 0 ;
          if (a_count == 8) begin
            a_count <= 0;
          end else begin
            a_count <= a_count + 1;
            s_add   <= {s_add[7:0], sda};
          end
        end
        ACK1: begin
          sda_oe <= 1;
          sda_o  <= 1;
        end
        R_ADD: begin
          sda_oe <= 0;
          if (r_count == 8) begin
            r_count <= 0;
          end else begin
            r_count <= r_count + 1;
            r_add   <= {r_add[6:0], sda};
          end
        end
        ACK2: begin
          sda_o  <= 1;
          sda_oe <= 1;
        end
        DATA: begin
          sda_oe <= 0;
          if (d_count == 8) begin
            d_count <= 0;
          end else begin
            d_count <= d_count + 1;
            data    <= {data[6:0], sda};
          end
        end
        ACK3: begin
          sda_o  <= 1;
          sda_oe <= 1;
        end
        STOP: begin
          sda_o  <= 1;
          sda_oe <= 0;
        end
      endcase
    end
  end

endmodule
