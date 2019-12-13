module scnn_compression_wts
  (arr,
   //n,
   non_zero,
   comp_arr,
   comp_ind);
  
  input  [24:0][15:0]arr;
  //input n;
  output [7:0]non_zero;
  output [24:0][15:0]comp_arr;
  output [24:0][7:0]comp_ind;

  reg [24:0][15:0] arr_compr;
  integer i;
  reg [7:0]nz;
  reg [24:0][7:0]arr_ind;
  integer counter1;
  
  
  
  
  always @(*) begin
	 counter1 = 0;
	 nz = 8'd0;
    for(i = 0 ; i<25 ; i=i+1) //25 should be parametrized
  	begin
      //$display("wt:%b",arr[i]);
    	if(arr[i]!=16'b0000000000000000)
    	begin
          	arr_ind[counter1] = nz;
      		nz = 8'd0;
      		arr_compr[counter1] = arr[i];
          	$display("compr_wt:%b",arr_compr[counter1]);
      		counter1 = counter1+1;
          
    	end
    	else
      		nz = nz+1;
      
  	end//for loop
  end //always
  
  
  assign comp_arr = arr_compr;

 
  assign non_zero = counter1;
  
  assign comp_ind = arr_ind;
  


endmodule