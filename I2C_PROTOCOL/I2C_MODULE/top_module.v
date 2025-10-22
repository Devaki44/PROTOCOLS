`include "master.v"
`include "slave.v"

module top_module(
  input clk,
  input rst,
  input start,
  input w_en,
  input [7:0]data,data2,s_addr,s_addr2,r_addr,
  inout  sda,
  output temp,
  output sig);
  
  wire scl;
  
  master m(clk,rst,start,w_en,data,data2,s_addr,s_addr2,r_addr,sda,temp,sig,scl,busy);
  slave  s(.scl(scl),.rst(rst),.w_en(w_en),.sda(sda),.busy(busy));
  
endmodule
  
  
