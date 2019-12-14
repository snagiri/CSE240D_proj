module scnn_compression_ips #(parameter PARAM_ISIZE = 64)
  (arr,
   //n,
   non_zero,
   comp_arr,
   comp_ind,
	inputs_per_slice,
	nzinputs_arr,
	offset_arr);
  
  input  [(PARAM_ISIZE-1):0][15:0]arr;
  //input n;
  output [7:0]non_zero;
  output [3:0][(PARAM_ISIZE>>2)-1:0][15:0]comp_arr;
  output [3:0][(PARAM_ISIZE>>2)-1:0][7:0]comp_ind;
  output [3:0][7:0]inputs_per_slice;
  output [3:0][7:0]nzinputs_arr;
  output [3:0][7:0]offset_arr;
  

  reg [3:0][(PARAM_ISIZE>>2)-1:0][15:0] arr_compr;
  integer i;
  reg [7:0]nz;
  reg [3:0][(PARAM_ISIZE>>2)-1:0][7:0]arr_ind;
  reg [3:0][7:0]reg_ips_pslice;
  reg [3:0][7:0]running_sum;
  reg [3:0][7:0]reg_offset_arr;
  reg [7:0]temp_var;
  integer counter1,counter2,counter3,counter4;
  integer val1,val2,val3,val4;
  
  
  
  
  always @(*) begin
	 counter1 = 0;
	 counter2 = 0;
	 counter3 = 0;
	 counter4 = 0;
	 nz = 8'b00000000;
	 
	 val1 = (PARAM_ISIZE>>2)-1;
	 val2 = (PARAM_ISIZE>>1)-1;
	 val3 = (PARAM_ISIZE>>2)+(PARAM_ISIZE>>1)-1;
	 val4 = (PARAM_ISIZE-1);
	 
	 
	 
    for(i = 0 ; i<PARAM_ISIZE ; i=i+1)
  	begin
    	if(i==val1 || i== val2|| i==val3||i==val4) //It's nothing but the condition if(i%16==0)
		begin
			if(i==val1) begin
			reg_ips_pslice[counter2] = counter4;
			reg_offset_arr[counter2] = 0;
			
			end
			
			else
			reg_ips_pslice[counter2] = counter4-running_sum[counter2-1];
			
			
			
			running_sum[counter2] = counter4;
			counter2 = counter2 + 1;		
		end
		
		if(arr[i]!=16'b0000000000000000)
    	begin
          	arr_ind[counter1][counter3] = nz;
      		nz = 8'b00000000;
      		arr_compr[counter1][counter3] = arr[i];
            //$display("compr_ip:%b",arr_compr[counter1]);
				//$display("index arr_ind[counter1][counter3] : %b",arr_ind[counter1][counter3]);
      		counter3 = counter3+1;
				counter4 = counter4+1;
				temp_var = i;
    	end
    	else
      		nz = nz+1;
				
	
		if(i==val1 || i== val2|| i==val3) begin
				reg_offset_arr[counter2] = temp_var+1;
				counter1 = counter1+1;
				counter3 = 0;
		end
      
  	end//for loop
  end //always
  
  
  assign comp_arr = arr_compr;

 
  assign non_zero = counter1;
  
  assign comp_ind = arr_ind;
  
  assign inputs_per_slice = reg_ips_pslice;
  assign nzinputs_arr = running_sum;
  assign offset_arr = reg_offset_arr;

endmodule
