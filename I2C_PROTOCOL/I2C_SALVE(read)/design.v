module slave (
  input        clk,
  input        rst,
  inout        sda
);

  reg [8:0]   s_add,s_add2;
  reg [7:0]   r_add;
  reg [7:0]   data;
  reg mem;

  reg [3:0]   a_count,a_count2;
  reg [3:0]   r_count;
  reg [3:0]   d_count,d_count2;

  reg         sda_o;
  reg         sda_oe;
  assign sda = (sda_oe == 1) ? sda_o : 1'bz;

  reg [3:0]   state, next_state;

  localparam [3:0]
    IDLE   = 4'h0,
    S_ADD  = 4'h1,
    ACK1   = 4'h2,
    R_ADD  = 4'h3,
    ACK2   = 4'h4,
  	DATA   = 4'h5,
    ACK3   = 4'h6,
    S_ADD2 = 4'h7,
    ACK4   = 4'h8,
    DATA_S = 4'h9,
    NACK   = 4'ha,
    STOP   = 4'hb;

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
      ACK2  : next_state = (!sda) ? S_ADD2 : DATA;
      S_ADD2: next_state = (a_count2 == 7) ? ACK4 : S_ADD2 ;
      ACK4  : next_state = DATA_S;
      DATA_S: next_state = ((d_count2==7))  ? NACK : DATA_S;
      NACK  : next_state = STOP;
      DATA  : next_state = (d_count==7)  ? ACK3  : DATA;
      ACK3  : next_state = STOP;
      STOP  : next_state = IDLE;
      default: next_state = IDLE;
    endcase
  end

  always @(posedge clk) begin
    if (rst) begin
      s_add    <= 0;
      r_add    <= 0;
      data     <= 0;
      a_count  <= 0;
      a_count2 <= 0;
      r_count  <= 0;
      d_count  <= 0;
      d_count2 <= 0;
      sda_o    <= 1;
      sda_oe   <= 0;
      mem 	   <= 1;
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
        S_ADD2: begin
          sda_oe <= 0 ;
          if (a_count2 == 8) begin
            a_count2 <= 0;
          end else begin
            a_count2 <= a_count2 + 1;
            s_add2   <= {s_add2[7:0], sda};
          end
        end
        ACK4: begin
          sda_o  <= 1;
          sda_oe <= 1;
        end
        DATA_S: begin
          sda_oe <= 1;
          if (d_count2 == 8) begin
            d_count2 <= 0;
          end else begin
            mem      <= 1;
            sda_o    <= mem;
            d_count2 <= d_count2 + 1;
          end
        end
        NACK: begin
          sda_o  <= 0;
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
