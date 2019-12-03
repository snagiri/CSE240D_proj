module multi(clk, a, b, op);
  input clk;
  input [15:0] a;
  input [15:0] b;
  output[31:0] op;

  reg [31:0] op_reg;
    always @(posedge clk)
        begin 
            op_reg <= a * b;      
        end  
  assign op = op_reg;
endmodule