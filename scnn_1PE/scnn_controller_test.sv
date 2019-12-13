module scnn_controller_test();
  reg clk;
  reg [15:0][15:0] input_acts;
  reg [3:0]input_dim;
  reg [8:0][15:0]weights;
  reg [3:0]weight_dim;
  wire[15:0][31:0]outputs;  
 
  
  scnn_controller DUT
  (.clk(clk),
   .input_acts(input_acts),
   .input_dim(input_dim),
   .weights(weights),
   .weight_dim(weight_dim),
   .outputs(outputs));
  
  initial begin
    clk = 0;
    
    input_acts[0] = 16'b0000000000000000;
    input_acts[1] = 16'b0000000000000000;
    input_acts[2] = 16'b0000000000000010;
    input_acts[3] = 16'b0000000000000000;
    input_acts[4] = 16'b0000000000000000;
    input_acts[5] = 16'b0000000000000100;
    input_acts[6] = 16'b0000000000000000;
    input_acts[7] = 16'b0000000000000000;
    input_acts[8] = 16'b0000000000000000;
    input_acts[9] = 16'b0000000000000000;
    input_acts[10] = 16'b0000000000000001;
    input_acts[11] = 16'b0000000000000000;
    input_acts[12] = 16'b0000000000000000;
    input_acts[13] = 16'b0000000000000010;
    input_acts[14] = 16'b0000000000001000;
    input_acts[15] = 16'b0000000000000000;
    
    weights[0] = 16'b0000000000001000;
    weights[1] = 16'b0000000000000110;
    weights[2] = 16'b0000000000000001;
    weights[3] = 16'b0000000000000000;
    weights[4] = 16'b0000000000000010;
    weights[5] = 16'b0000000000000000;
    weights[6] = 16'b0000000000000000;
    weights[7] = 16'b0000000000000011;
    weights[8] = 16'b0000000000000000;
    
    input_dim = 4'b0100;
    weight_dim = 4'b0011;
    
    
    #100
 //   for(int nu = 0;nu<16;nu=nu+1)
 //     $display("%b",outputs[nu]);
    
    $finish;
    
  end
  
  always begin
    #5  clk = ~clk; 
  end
  
endmodule