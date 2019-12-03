module multi_test();
  reg clk;
  reg [15:0] a;
  reg [15:0] b;
  wire [31:0] op;
 
  
  multi DUT
  ( .clk(clk),
    .a(a),
  	.b(b),
   	.op(op));
  
  initial begin
    clk = 1;
    
    #20
    a = 16'b0010001110010100;
    b = 16'b0100110001010011;
    #20
    $display("%b",op);
    $finish;
    
  end
  
  always begin
    #5  clk = ~clk; 
  end
  
endmodule