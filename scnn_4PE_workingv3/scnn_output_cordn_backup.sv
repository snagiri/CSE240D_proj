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

input reg [3:0][7:0]comp_wt_ind;
input reg [3:0][7:0]comp_ip_ind;
input reg [7:0]offset_wt;
input reg [7:0]offset_ip;
input [3:0]wt_size;
input [7:0]ip_size;
output [7:0]last_ind_ips;
output [7:0]last_ind_wts;
output [3:0][7:0]orig_wt_ind;
output [3:0][7:0]orig_ip_ind;
output [15:0][7:0]op_cords;





reg [15:0][7:0]op_reg;
reg [4:0] column;
reg [4:0] row;
reg [4:0] cen_column;
reg [4:0] cen_row;
integer f, i, m;
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
	cen_column = (wt_size - 1) >> 1;
	cen_row = (wt_size - 1) >> 1;
	for(f = 0;f<4;f=f+1)
		begin
			for(i=0;i<4;i=i+1)
				begin
					//$display("%d,%d",f,i);
					$display("comp_wt_ind[0],comp_wt_ind[1]:%b,%b",comp_wt_ind[0],comp_wt_ind[1]);
					$display("orig_wt_ind[f],orig_ip_ind[i]:%b,%b",orig_wt_ind[f],orig_ip_ind[i]);
					column = 4'b0;
					row = 4'b0;
					for(m=0;m < 32;m=m+5) //Parametrize this
					begin
					if(m > orig_wt_ind[f]) 
						break;
					else
						// emulates synthesizable division
						row = row + 1;
					end
					// emulates synthesizable modulo
					row = row - 1;
					column = orig_wt_ind[f] - (m - wt_size);

					op_reg[counter_op] = orig_ip_ind[i] + ((cen_row - row) * ip_size) + (cen_column - column);
					
					if(op_reg[counter_op] < 0 || op_reg[counter_op] >= ip_size*ip_size)
						op_reg[counter_op] = -1;
			
			$display("op_reg is %b",op_reg[counter_op]);
			counter_op = counter_op+1;

		end //inner for loop
	end //outer for loop

end //always

assign op_cords = op_reg;

assign last_ind_ips = orig_ip_ind[3];
assign last_ind_wts = orig_wt_ind[3];

endmodule