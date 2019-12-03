module multi(a, b, op);
  //input clk;
  input [15:0] a;
  input [15:0] b;
  output[31:0] op;

  reg [31:0] op_reg;
  always @(*)
        begin 
            op_reg = a * b;  
          $display("op_reg:%b",op_reg);
        end  
  assign op = op_reg;
  
endmodule

module top_multi_arr
  (wts,
   ips,
   ops);
  //input clk;
  input [3:0][15:0]wts;
  input [3:0][15:0]ips;
  output [15:0][31:0] ops;
  
  genvar i,j;
  generate
    for(i=0; i<4; i=i+1)
      begin
        for(j = 0; j<4;j=j+1)
          begin
            multi m(wts[i],ips[j],ops[(4*i)+j]);
          end
      end
  endgenerate
  
endmodule