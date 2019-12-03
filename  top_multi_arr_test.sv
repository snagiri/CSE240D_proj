module multi_arr_test();
  //reg clk;
  reg [3:0][15:0] wts;
  reg [3:0][15:0] ips;
  wire [15:0][31:0] ops;
 
  
  top_multi_arr DUT
  ( //.clk(clk),
   .wts(wts),
   .ips(ips),
   .ops(ops));
  
  initial begin
    //clk = 1;
    
    #20
    wts[0] = 16'b0000000000110100;
    wts[1] = 16'b0000000000100100;
    wts[2] = 16'b0000000000110101;
    wts[3] = 16'b0000000000110110;
    
    ips[0] = 16'b0000000000000001;
    ips[1] = 16'b0000000000000100;
    ips[2] = 16'b0000000000000011;
    ips[3] = 16'b0000000000000101;
    
    #20
    for(int nu = 0;nu<16;nu=nu+1)
      $display("%b",ops[nu]);
    
    $finish;
    
  end
  
  //always begin
    //#5  clk = ~clk; 
  //end
  
endmodule