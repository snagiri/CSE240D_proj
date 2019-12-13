module scnn_controller_test();
  reg clk;
  reg [63:0][15:0] input_acts;
  reg [7:0]input_dim;
  reg [8:0][15:0]weights;
  reg [3:0]weight_dim;
  wire[63:0][31:0]outputs;  
 
  
  scnn_controller_4PE DUT
  (.clk(clk),
   .input_acts(input_acts),
   .input_dim(input_dim),
   .weights(weights),
   .weight_dim(weight_dim),
   .outputs(outputs));
  
  initial begin
    clk = 0;
    
 		for(int i =0;i<64;i=i+1)
		begin
		input_acts[i] = 16'b0000000000000000;
		end
		
		#1
		
		input_acts[2] =  16'b0000000000000010;
		input_acts[4] =  16'b0000000000000101;
		input_acts[11] = 16'b0000000000001011;
		input_acts[13] = 16'b0000000000000111;
		input_acts[14] = 16'b0000000000000100;
		input_acts[17] = 16'b0000000000000001;
		input_acts[19] = 16'b0000000000000011;
		input_acts[25] = 16'b0000000000000101;
		input_acts[27] = 16'b0000000000000010;
		input_acts[30] = 16'b0000000000000110;
		input_acts[34] = 16'b0000000000000100;
		input_acts[35] = 16'b0000000000000100;
		input_acts[38] = 16'b0000000000000011;
		input_acts[41] = 16'b0000000000000010;
		input_acts[46] = 16'b0000000000000001;
		input_acts[49] = 16'b0000000000000100;
		input_acts[51] = 16'b0000000000000010;
		input_acts[53] = 16'b0000000000000010;
		input_acts[57] = 16'b0000000000000001;
		input_acts[59] = 16'b0000000000000110;
		input_acts[60] = 16'b0000000000000011;
    
    weights[0] = 16'b0000000000000010;
    weights[1] = 16'b0000000000000101;
    weights[2] = 16'b0000000000000001;
    weights[3] = 16'b0000000000000000;
    weights[4] = 16'b0000000000000010;
    weights[5] = 16'b0000000000000000;
    weights[6] = 16'b0000000000000000;
    weights[7] = 16'b0000000000000011;
    weights[8] = 16'b0000000000000000;
    
    input_dim = 8'b00001000;
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