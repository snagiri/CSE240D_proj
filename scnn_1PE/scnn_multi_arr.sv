module scnn_multi_arr
  (wts,
   ips,
   ops);
  //input clk;
  input reg [3:0][15:0]wts;
  input reg [3:0][15:0]ips;
  output [15:0][31:0] ops;
  
  genvar i,j;
  generate
    for(i=0; i<4; i=i+1)
      begin : forloop1
        for(j = 0; j<4;j=j+1)
          begin : forloop2
            scnn_multi m(wts[i],ips[j],ops[(4*i)+j]);
          end
      end
  endgenerate
  

endmodule