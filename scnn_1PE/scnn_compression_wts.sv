module scnn_compression_wts
  (arr,
   //n,
   non_zero,
   comp_arr,
   comp_ind);
  
  input  [8:0][15:0]arr;
  //input n;
  output [3:0]non_zero;
  output [8:0][15:0]comp_arr;
  output [8:0][3:0]comp_ind;

  reg [8:0][15:0] arr_compr;
  integer i;
  reg [3:0]nz;
  reg [8:0][3:0]arr_ind;
  integer counter1;
  
  
  
  
  always @(*) begin
	 counter1 = 0;
	 nz = 4'b0000;
    for(i = 0 ; i<9 ; i=i+1)
  	begin
      //$display("wt:%b",arr[i]);
    	if(arr[i]!=16'b0000000000000000)
    	begin
          	arr_ind[counter1] = nz;
      		nz = 4'b0000;
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