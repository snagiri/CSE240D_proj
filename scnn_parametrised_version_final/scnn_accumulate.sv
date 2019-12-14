module scnn_accumulate(
	buffer0,
	buffer1,
	buffer2,
	buffer3,
	added_ops);
	
	
  input [63:0][31:0]buffer0;
  input [63:0][31:0]buffer1;
  input [63:0][31:0]buffer2;
  input [63:0][31:0]buffer3;
  output [63:0][31:0]added_ops;
	
	
	reg [63:0][31:0]reg_added_ops;
	
	always@(*)
	begin
		for(int w=0;w<64;w=w+1)
			reg_added_ops[w] = buffer0[w]+buffer1[w]+buffer2[w]+buffer3[w];
		
	end
	
assign 	added_ops = reg_added_ops;
	
	
endmodule