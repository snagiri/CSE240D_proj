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
	offset_ipind,
   conv_outputs);
  
  input clk;
  input [3:0]wt_dim;
  input [7:0]ip_dim;
  input [15:0][15:0]compressed_inputs;
  input [8:0][15:0]compressed_weights;
  input [15:0][7:0]comp_indices_ips;
  input [8:0][3:0]comp_indices_wts;
  input [7:0]num_nz_ips;
  input [3:0]num_nz_wts;
  input [7:0]offset_ipind;
  output [63:0][31:0]conv_outputs;
  
  
  reg [7:0]counter1=8'b00000000;
  reg [7:0]counter2=8'b00000000;

  reg [3:0][15:0]ips_to_mult;
  reg [3:0][15:0]wts_to_mult;
  wire [15:0][31:0]ops_from_mult;
  
  //reg [15:0][31:0]acc_buffer;
  
  reg [63:0][7:0][31:0]temp_acc_buff;
  reg [63:0][31:0]acc_buffer;
  
  wire [31:0]dummy = 32'b00000000000000000000000000000000;
  
  reg [3:0][7:0]ips_inds_comp;
  reg [3:0][3:0]wts_inds_comp;
  reg [7:0]ips_offset; //needs to be changed
  reg [3:0]wts_offset = 4'b0000;
  //wt_size
  //ip_size
  wire [3:0][3:0]original_wt_ind;
  wire [3:0][7:0]original_ip_ind;
  wire [15:0][7:0]ops_cords;
  wire [7:0]last_ip_ind;
  wire [3:0]last_wt_ind;
  
  reg stop=0;
  reg final_flag = 0;
  reg end_signal = 0;
  
  
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

		
		if((counter1+counter2)!=8'b00000000)
		begin
		
          for(int k =0 ; k<4; k=k+1) begin
            for(int n =0;n<4;n=n+1) begin
				     		
              if(ops_cords[(4*k)+n]!= -1) 
                begin
                  for(int m = 0;m<8;m=m+1) 
                    begin
                      if(temp_acc_buff[ops_cords[(4*k)+n]][m]==0)
                        begin
                          temp_acc_buff[ops_cords[(4*k)+n]][m] = ops_from_mult[(4*k)+n]; break;
                        end //inner if
                    end //for loop m
                end //outer if
            end // for loop n
          end //for loop k
              
		end
		
		else
			begin //
			for(int m =0 ; m<64; m=m+1)
			begin
			
				acc_buffer[m] <= 32'b00000000000000000000000000000000;
				temp_acc_buff[m] <= {8{dummy}};
				
			end
			
			ips_offset <= offset_ipind; 
			
			end //end of else
        
        $display("%b,%b",ops_from_mult[0],ops_from_mult[1]);
      end
		
		else if(final_flag == 1 && !end_signal)
		begin
			for(int y=0;y<64;y=y+1)
            begin
              acc_buffer[y] <= temp_acc_buff[y][0]+temp_acc_buff[y][1]+temp_acc_buff[y][2]+temp_acc_buff[y][3] 
				                   +temp_acc_buff[y][4]+temp_acc_buff[y][5]+temp_acc_buff[y][6]+temp_acc_buff[y][7];
            end
		end
		
    else if(stop == 1 && !end_signal)
	 begin

		     for(int k =0 ; k<4; k=k+1) begin
            for(int n =0;n<4;n=n+1) begin
				     		
              if(ops_cords[(4*k)+n]!= -1) 
                begin
                  for(int m = 0;m<8;m=m+1) 
                    begin
                      if(temp_acc_buff[ops_cords[(4*k)+n]][m]==0)
                        begin
                          temp_acc_buff[ops_cords[(4*k)+n]][m] = ops_from_mult[(4*k)+n]; break;
                        end //inner if
                    end //for loop m
                end //outer if
            end // for loop n
          end //for loop k
	 end
	 

  end
  
  always@(posedge clk)
    begin
      
      if(final_flag ==1)
			end_signal = 1;
		else if(stop ==1)
			final_flag <= 1;
			
		else if(counter1 > num_nz_ips-4&&counter2 > num_nz_wts-4)
        stop <= 1;
      else if (counter2 == 8'b00000000)
        begin
      	  counter2 <= counter2+4;
        end  
		else if(counter2 > num_nz_wts-4)
			begin
			counter1 <= counter1+4;
			counter2 <= 8'b00000000;
			end
		
    end
	 
  always@(posedge clk)
    begin
		if(counter2 == 8'b00000000 && (counter1+counter2)!=8'b00000000)
		begin
			ips_offset <= last_ip_ind + 1;
			wts_offset <= 4'b0000;
		end
		
		if(counter2 != 8'b00000000)
			wts_offset <= last_wt_ind + 1;
	 
    end

assign conv_outputs = acc_buffer;	
  
endmodule