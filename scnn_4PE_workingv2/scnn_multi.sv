module scnn_multi(a, b, op);
  //input clk;
  input reg [15:0] a;
  input reg [15:0] b;
  output[31:0] op;

  reg [31:0] op_reg;
  always @(*)
        begin 
            op_reg = a * b;  
          $display("op_reg:%b",op_reg);
        end  
  assign op = op_reg;
  
endmodule