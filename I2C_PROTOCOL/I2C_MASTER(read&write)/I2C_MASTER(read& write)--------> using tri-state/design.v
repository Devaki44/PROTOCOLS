module master(
  input clk,
  input rst,
  input start,
  input w_en,
  input [7:0]data,data2,s_addr,s_addr2,r_addr,
  inout  sda,
  output reg temp,
  output reg sig);
  
  reg [3:0] state, next_state ;
  reg [3:0] a_cnt,a_cnt2,d_cnt,d_cnt2,r_cnt;
  reg start,busy;
  reg [7:0]data_reg,data_reg2;
  reg [8:0]s_addr_reg;
  reg [8:0]s_addr2_reg;
  reg [7:0]r_addr_reg;
  reg sclk;
  wire scl;
  reg [1:0]count;
  
  assign data_reg =  data;
  assign data_reg2 = data2;
  assign s_addr_reg = {s_addr,w_en};
  assign s_addr2_reg = {s_addr2,w_en};
  assign r_addr_reg = r_addr;
  
  reg         sda_o;
  reg         sda_oe;
  assign sda = (sda_oe == 1) ? sda_o : 1'bz;
  
  parameter IDLE	= 4'b0000,
  			START   = 4'b0001,
  			S_ADD   = 4'b0010,
  			ACK1    = 4'b0011,
  			R_ADD   = 4'b0100,
            ACK2    = 4'b0101,
			DATA	= 4'b0110,
            ACK3	= 4'b0111,
  			R_START = 4'b1000,
  			S_ADD2  = 4'b1001,
  			ACK4    = 4'b1010,
  			DATA_S  = 4'b1011,
  			NACK    = 4'b1100,
  			STOP	= 4'b1101;
  
  //clk from master to slave 
  always@(posedge clk)begin
    if(rst)begin
      sclk  <= 0;
      count <= 0;
    end
    else begin
      count = count + 1;
      if(count == 2'b11)
      	sclk <= ~sclk;
    end
  end
  
  assign scl = (start) ? sclk : 1'bz ;  //scl 
 
  
  //reset logic
  always@(posedge scl or posedge rst)begin
    if(rst)begin
  		state  <= IDLE ;
    	sda_oe <= 0;
        sda_o  <= 1;
      	a_cnt  <= 0;
        a_cnt2 <= 0;
      	d_cnt  <= 0;
        d_cnt2 <= 0;
        r_cnt  <= 0;
      	busy   <= 0;
        temp   <= 1;
        sig    <= 0;
    end
    else 
      	state <= next_state ;
  end
    
  //next_state logic
  always@(*)begin   
    case(state)
      
      IDLE	 : next_state = (start && !busy) ? START : IDLE ;
      START  : next_state = S_ADD;
      S_ADD  : next_state = (a_cnt == 8) ? ACK1 : S_ADD ;
      ACK1   : next_state = R_ADD ;
      R_ADD  : next_state = (r_cnt == 7) ? ACK2 : R_ADD ;
      ACK2   : next_state = (!w_en) ? DATA : R_START ; 
      R_START: next_state = S_ADD2;
      S_ADD2 : next_state = (a_cnt2 == 8) ? ACK4 : S_ADD2 ;
      ACK4   : next_state = DATA_S;
      DATA_S : next_state = (d_cnt2 == 7) ? NACK : DATA_S ;
      NACK   : next_state = STOP; 
      DATA   : next_state = (d_cnt == 7) ? ACK3 : DATA ;
      ACK3	 : next_state = STOP ;
      STOP   : next_state = IDLE ;
      
    endcase    
  end
      
  //output logic
  always@(posedge scl)begin
      
      case(state)
        IDLE : begin
          		sda_oe <= 0;
        		sda_o  <= 1;
          		a_cnt <= 0;
          		d_cnt <= 0;
                r_cnt <= 0;
          		busy  <= 0;
                temp  <= 1;
          		sig   <= 0;
        	   end
        START : begin
          			sda_oe <= 1;
        		    sda_o  <= 0;
                end
        S_ADD : begin
          		 busy <= 1;
          		 sda_oe <= 1;
          			if(a_cnt == 9)begin
            			a_cnt <= 0; 
                    end
          			else begin
            		  a_cnt  <= a_cnt +1 ;
                      sda_o  <= s_addr_reg[8 - a_cnt] ;
          		    end
        		end
        ACK1  : begin
          			sda_oe  <= 1;
                    sda_o   <= sda;

        		end
        R_ADD : begin
          			sda_oe  <= 1;
          			if(r_cnt == 8)begin
            			r_cnt <= 0; 
                    end
          			else begin
            		  r_cnt  <= r_cnt + 1 ;
                      sda_o  <= r_addr_reg[7 - r_cnt] ;
          		    end
                sig <= 1;
        		end
        ACK2  : begin
          			sda_oe  <= 1;
                    sda_o   <= sda;
        		end
        DATA  : begin
          			sda_oe  <= 1;
          			if(d_cnt == 8)begin
            			d_cnt <= 0;
                    end
          			else begin
            		  d_cnt  <= d_cnt +1 ;
                      sda_o  <= data_reg[7 - d_cnt] ;
          		    end
        		end
        ACK3  : begin
          			sda_oe  <= 1;
                    sda_o   <= sda;
        		end
        R_START: begin
          			sda_oe <= 1;
          			sda_o  <= 0;
        		 end
        S_ADD2 : begin
          			sda_oe <= 1;
          			if(a_cnt2 == 9)begin
            			a_cnt2 <= 0; 
                    end
          			else begin
            		  a_cnt2  <= a_cnt2 +1 ;
                      sda_o   <= s_addr2_reg[8 - a_cnt2] ;
          		    end
        		end
        ACK3  : begin
          			sda_oe <= 1;
          			sda_o  <= sda;
        		end
        DATA_S: begin
          			sda_oe <= 1;
          			if(d_cnt2 == 8)begin
            			d_cnt2 <= 0;
                    end
          			else begin
            		  d_cnt2  <= d_cnt2 +1 ;
                      sda_o   <= data_reg2[7 - d_cnt2] ;
          		    end
        		end
        NACK  : begin
          			sda_oe  <= 1;
          			sda_o   <= 0;
        		end
        STOP  : begin
          			sda_oe  <= 1;
          			sda_o   <= 1;
                    busy <= 0;
          			temp <= 0;
        		end
      endcase
    end
          		
endmodule
          			
        
          		
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
  			
  	
  
