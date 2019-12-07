module scnn_PE
  (	clk,
	wt_dim,
	ip_dim,
   compressed_inputs,
   compressed_weights,
   comp_indices_ips,
   comp_indices_wts,
   num_nz_ips,
   num_nz_wts,
   conv_outputs);
  
  input clk;
  input [3:0]wt_dim;
  input [3:0]ip_dim;
  input [15:0][15:0]compressed_inputs;
  input [8:0][15:0]compressed_weights;
  input [15:0][4:0]comp_indices_ips;
  input [8:0][3:0]comp_indices_wts;
  input [3:0]num_nz_ips;
  input [3:0]num_nz_wts;
  output [15:0][31:0]conv_outputs;
  
  
  reg [3:0]counter1=4'b0000;
  reg [3:0]counter2=4'b0000;

  reg [3:0][15:0]ips_to_mult;
  reg [3:0][15:0]wts_to_mult;
  wire [15:0][31:0]ops_from_mult;
  
  reg [15:0][31:0]acc_buffer;
  
  reg [3:0][4:0]ips_inds_comp;
  reg [3:0][3:0]wts_inds_comp;
  reg [4:0]ips_offset = 4'b00000;
  reg [3:0]wts_offset = 4'b0000;
  //wt_size
  //ip_size
  wire [3:0][3:0]original_wt_ind;
  wire [3:0][4:0]original_ip_ind;
  wire [15:0][4:0]ops_cords;
  wire [4:0]last_ip_ind;
  wire [3:0]last_wt_ind;
  
  reg stop=0;
  
  
  scnn_multi_arr multarr0 (wts_to_mult,ips_to_mult,ops_from_mult);
  scnn_output_cordn op_cord0 (wts_inds_comp,ips_inds_comp,wts_offset,ips_offset,wt_dim,ip_dim,last_ip_ind,last_wt_ind,original_wt_ind,original_ip_ind,ops_cords);
  
  
  always@(posedge clk)
  begin
    if(!stop)
      begin
    	ips_to_mult[0] <= compressed_inputs[counter1];
    	ips_to_mult[1] <= compressed_inputs[counter1+1];
    	ips_to_mult[2] <= compressed_inputs[counter1+2];
    	ips_to_mult[3] <= compressed_inputs[counter1+3];
      
    	wts_to_mult[0] <= compressed_weights[counter2];
    	wts_to_mult[1] <= compressed_weights[counter2+1];
    	wts_to_mult[2] <= compressed_weights[counter2+2];
    	wts_to_mult[3] <= compressed_weights[counter2+3];
		
		ips_inds_comp[0] <= comp_indices_ips[counter1];
    	ips_inds_comp[1] <= comp_indices_ips[counter1+1];
    	ips_inds_comp[2] <= comp_indices_ips[counter1+2];
    	ips_inds_comp[3] <= comp_indices_ips[counter1+3];
      
    	wts_inds_comp[0] <= comp_indices_wts[counter2];
    	wts_inds_comp[1] <= comp_indices_wts[counter2+1];
    	wts_inds_comp[2] <= comp_indices_wts[counter2+2];
    	wts_inds_comp[3] <= comp_indices_wts[counter2+3];

		
		if(counter1!=4'b0000)
		begin
		
		wts_offset <= last_wt_ind + 1;
		ips_offset <= last_ip_ind + 1;
			for(int k =0 ; k<4; k=k+1)
			begin
			for(int n =0;n<4;n=n+1)
			begin
				$display("original_wt_ind[k],original_ip_ind[n]:%b,%b",original_wt_ind[k],original_ip_ind[n]);
				if(original_wt_ind[k]>4'b0101 && original_ip_ind[n]<5'b00100)
			
						acc_buffer[ops_cords[(4*k)+n]] <= acc_buffer[ops_cords[(4*k)+n]] + 0;
						
				else if(original_wt_ind[k]<4'b0011 &&  original_ip_ind[n]>5'b01011)
				
						acc_buffer[ops_cords[(4*k)+n]] <= acc_buffer[ops_cords[(4*k)+n]] + 0;
				
				else begin
				acc_buffer[ops_cords[(4*k)+n]] <= acc_buffer[ops_cords[(4*k)+n]] + ops_from_mult[(4*k)+n];
				$display("ops_cords[(4*k)+n],acc_buffer[ops_cords[(4*k)+n]:%b,%b",ops_cords[(4*k)+n],acc_buffer[ops_cords[(4*k)+n]]);
				end
			end //inner for
			end //outer for
		
		end
		
		else
			begin //
			for(int m =0 ; m<16; m=m+1)
			begin
			
				acc_buffer[m] <= 32'b00000000000000000000000000000000;
				
			end
			
			end //end of else
        
        $display("%b,%b",ops_from_mult[0],ops_from_mult[1]);
      end
		
    else if(stop == 0 && counter1!=4'b0000)
	 begin
			for(int k =0 ; k<4; k=k+1)
			begin
			for(int n =0;n<4;n=n+1)
			begin
				$display("original_wt_ind[k],original_ip_ind[n]:%b,%b",original_wt_ind[k],original_ip_ind[n]);
				if(original_wt_ind[k]>4'b0101 && original_ip_ind[n]<5'b00100)
			
						acc_buffer[ops_cords[(4*k)+n]] <= acc_buffer[ops_cords[(4*k)+n]] + 0;
						
				else if(original_wt_ind[k]<4'b0011 &&  original_ip_ind[n]>5'b01011)
				
						acc_buffer[ops_cords[(4*k)+n]] <= acc_buffer[ops_cords[(4*k)+n]] + 0;
				
				else begin
				acc_buffer[ops_cords[(4*k)+n]] <= acc_buffer[ops_cords[(4*k)+n]] + ops_from_mult[(4*k)+n];
				$display("ops_cords[(4*k)+n],acc_buffer[ops_cords[(4*k)+n]:%b,%b",ops_cords[(4*k)+n],acc_buffer[ops_cords[(4*k)+n]]);
				end
			end //inner for
			end //outer for
	 end
  end
  
  always@(posedge clk)
    begin
      
      if(counter1 > num_nz_ips && counter2 > num_nz_wts)
        stop <= 1;
      else
        begin
          counter1 <= counter1+4;
      	  counter2 <= counter2+4;
        end      
    end
   

assign conv_outputs = acc_buffer;	
  
endmodule
   