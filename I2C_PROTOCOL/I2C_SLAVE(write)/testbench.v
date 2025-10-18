
// testbench.sv
module testbench;
  reg       clk;
  reg       rst;
  wire      sda;

  reg       sda_tb_drv;
  reg       sda_tb_en;

  assign sda = sda_tb_en ? sda_tb_drv : 1'bz;

  slave dut (
    .clk  (clk),
    .rst  (rst),
    .sda  (sda)
  );

  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  initial begin
    rst       = 1;
    #20;
    sda_tb_en = 0;
    sda_tb_drv= 1;
    #45;
    rst       = 0;
    #10;
    sda_tb_en = 1;
    sda_tb_drv= 0;
    #10;
    
    //slave address
    repeat (4) begin
      sda_tb_drv = 0;
      #10;
      sda_tb_drv = 1;
      #10;
    end
    sda_tb_drv = 0;
    #10;
    sda_tb_en = 0;
    
    
    #10;
    sda_tb_en = 1;
    //register address
    
    begin
      sda_tb_drv = 1;
      #10;
      sda_tb_drv = 0;
      #10;
      sda_tb_drv = 1;
      #10;
      sda_tb_drv = 1;
      #10;
      sda_tb_drv = 1;
      #10;
      sda_tb_drv = 1;
      #10;
      sda_tb_drv = 1;
      #10;
      sda_tb_drv = 0;
      #10;
    end
    sda_tb_drv = 0;
    sda_tb_en = 0;
    
    //data
    #10;
    sda_tb_en = 1;
    
    begin
      sda_tb_drv = 1;
      #10;
      sda_tb_drv = 0;
      #10;
      sda_tb_drv = 0;
      #10;
      sda_tb_drv = 1;
      #10;
      sda_tb_drv = 1;
      #10;
      sda_tb_drv = 0;
      #10;
      sda_tb_drv = 1;
      #10;
      sda_tb_drv = 0;
      #10;
    end
    sda_tb_drv = 0;
    sda_tb_en = 0;
    
    #10;
    sda_tb_drv = 1;
    sda_tb_en = 1;
    
      
  end

  initial begin
    #500;
    $finish;
  end

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
  end
endmodule





https://www.edaplayground.com/x/auzh
