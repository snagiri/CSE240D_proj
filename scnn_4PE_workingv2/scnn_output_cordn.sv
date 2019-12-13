module scnn_output_cordn
(comp_wt_ind,
comp_ip_ind,
offset_wt,
offset_ip,
wt_size,
ip_size,
last_ind_ips,
last_ind_wts,
orig_wt_ind,
orig_ip_ind,
op_cords);

input reg [3:0][3:0]comp_wt_ind;
input reg [3:0][7:0]comp_ip_ind;
input reg [3:0]offset_wt;
input reg [7:0]offset_ip;
input [3:0]wt_size;
input [7:0]ip_size;
output [7:0]last_ind_ips;
output [3:0]last_ind_wts;
output [3:0][3:0]orig_wt_ind;
output [3:0][7:0]orig_ip_ind;
output [15:0][7:0]op_cords;





reg [15:0][7:0]op_reg;

integer f,i;
integer counter_op;



assign orig_wt_ind[0] = offset_wt+comp_wt_ind[0];
assign orig_wt_ind[1] = orig_wt_ind[0] + comp_wt_ind[1]+1;
assign orig_wt_ind[2] = orig_wt_ind[1] + comp_wt_ind[2]+1;
assign orig_wt_ind[3] = orig_wt_ind[2] + comp_wt_ind[3]+1;

assign orig_ip_ind[0] = offset_ip+comp_ip_ind[0];
assign orig_ip_ind[1] = orig_ip_ind[0] + comp_ip_ind[1]+1;
assign orig_ip_ind[2] = orig_ip_ind[1] + comp_ip_ind[2]+1;
assign orig_ip_ind[3] = orig_ip_ind[2] + comp_ip_ind[3]+1;


 
always@(*)

begin

	counter_op = 0;
	for(f = 0;f<4;f=f+1)
		begin
			for(i=0;i<4;i=i+1)
				begin
					//$display("%d,%d",f,i);
					$display("comp_wt_ind[0],comp_wt_ind[1]:%b,%b",comp_wt_ind[0],comp_wt_ind[1]);
					$display("orig_wt_ind[f],orig_ip_ind[i]:%b,%b",orig_wt_ind[f],orig_ip_ind[i]);
					if((orig_wt_ind[f]>4'b0101 && orig_ip_ind[i]<8'b00001000)||(orig_wt_ind[f]<4'b0011 &&  orig_ip_ind[i]>8'b00111011))
			
						op_reg[counter_op]  = -1;
						
					else begin
					case(orig_wt_ind[f])
						4'b0000:
							op_reg[counter_op]  = orig_ip_ind[i]+ (ip_size+1);
						4'b0001:
							op_reg[counter_op]  = orig_ip_ind[i]+ ip_size;
						4'b0010:
							op_reg[counter_op]  = orig_ip_ind[i]+ (ip_size-1);
						4'b0011:
							op_reg[counter_op]  = orig_ip_ind[i]+ 1;
						4'b0100:
							op_reg[counter_op]  = orig_ip_ind[i];
						4'b0101:
							op_reg[counter_op]  = orig_ip_ind[i] - 1 ;
						4'b0110:
							op_reg[counter_op]  = orig_ip_ind[i] - (ip_size-1);
						4'b0111:
							op_reg[counter_op]  = orig_ip_ind[i] - ip_size ;
						4'b1000:
							op_reg[counter_op]  = orig_ip_ind[i] - (ip_size+1);
						default:
							op_reg[counter_op] = 0;

					endcase
					end
			$display("op_reg is %b",op_reg[counter_op]);
			counter_op = counter_op+1;

		end //inner for loop
	end //outer for loop

end //always

assign op_cords = op_reg;

assign last_ind_ips = orig_ip_ind[3];
assign last_ind_wts = orig_wt_ind[3];

endmodule