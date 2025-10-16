module master(
  input clk,
  input rst,
  input start,
  input w_en,
  input [7:0]data,s_addr,r_addr,
  output reg  sda);
  
  reg [2:0] state, next_state ;
  reg [3:0] a_cnt,d_cnt,r_cnt;
  reg start,busy;
  reg [7:0]data_reg;
  reg [7:0]s_addr_reg,r_addr_reg;
  reg sclk;
  wire scl;
  reg [1:0]count;
  
  assign data_reg =  data;
  assign s_addr_reg = s_addr;
  assign r_addr_reg = r_addr;
  
  parameter IDLE	= 4'b0000,
  			START   = 4'b0001,
  			S_ADD   = 4'b0010,
  			ACK1    = 4'b0011,
  			R_ADD   = 4'b0100,
            ACK2    = 4'b0101,
			DATA	= 4'b0110,
            ACK3	= 4'b0111,
  			STOP	= 4'b1000;
  
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
  		state <= IDLE ;
    	sda	  <= 1;
      	a_cnt <= 0;
      	d_cnt <= 0;
        r_cnt <= 0;
      	busy  <= 0;
    end
    else 
      	state <= next_state ;
  end
    
  //next_state logic
  always@(*)begin   
    case(state)
      
      IDLE	: next_state = (start && !busy) ? START : IDLE ;
      START : next_state = S_ADD;
      S_ADD : next_state = (a_cnt == 7) ? ACK1 : S_ADD ;
      ACK1  : next_state = R_ADD ;
      R_ADD : next_state = (r_cnt == 7) ? ACK2 : R_ADD ;
      ACK2  : next_state = DATA ;
      DATA  : next_state = (d_cnt == 7) ? ACK3 : DATA ;
      ACK3	: next_state = STOP ;
      STOP  : next_state = IDLE ;
      
    endcase    
  end
      
  //output logic
  always@(posedge scl)begin
    if(rst)begin
      sda	<= 1;
      a_cnt <= 0;
      d_cnt <= 0;
      r_cnt <= 0;
      busy  <= 0;
    end
    else begin
      
      case(state)
        IDLE : begin
          		sda   <= 1;
          		a_cnt <= 0;
          		d_cnt <= 0;
                r_cnt <= 0;
          		busy  <= 0;
        	   end
        START : begin
          			sda <= 0;
        		end
        S_ADD : begin
          		 busy <= 1;
         			if(a_cnt == 8)begin
            			a_cnt <= 0; 
                    end
          			else begin
            		  a_cnt  <= a_cnt +1 ;
                      sda    <= s_addr_reg[7 - a_cnt] ;
          		    end
        		end
        ACK1  : begin
          			sda <= 1;
        		end
        R_ADD : begin
          			if(r_cnt == 8)begin
            			r_cnt <= 0; 
                    end
          			else begin
            		  r_cnt  <= r_cnt + 1 ;
                      sda    <= r_addr_reg[7 - r_cnt] ;
          		    end
        		end
        ACK2  : begin
          			sda <= 1;
        		end
        DATA  : begin
          		if(!w_en)begin
          			if(d_cnt == 8)begin
            			d_cnt <= 0;
                    end
          			else begin
            		  d_cnt  <= d_cnt +1 ;
                      sda    <= data_reg[7 - d_cnt] ;
          		    end
                end
        		end
        ACK3  : begin
          			sda <= 1;
        		end
        STOP  : begin
          			sda <= 1;
                    busy <= 0;
        		end
      endcase
    end
  end
          		
endmodule
          			
        
          		
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
  			
  	
  
