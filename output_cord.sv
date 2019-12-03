// Code your design here
// Code your design here
module output_cord
(comp_wt_ind,
comp_ip_ind,
num_wt,
num_ip,
wt_size,
ip_size,
op_cords);

input [8:0][3:0]comp_wt_ind;
input [15:0][3:0]comp_ip_ind;
input [2:0]num_wt;
input [3:0]num_ip;
input [4:0]wt_size;
input [4:0]ip_size;
  output [23:0][3:0]op_cords;

reg [8:0][3:0]orig_wt_ind;
reg [15:0][3:0]orig_ip_ind;

  reg [23:0][3:0]op_reg;
reg [3:0] counter_f;
reg [3:0] counter_i;

integer f,i;
integer wt_max,ip_max;
integer wt_size_int,ip_size_int;
integer counter_op;
integer wt_ind, wt_ind_div;



assign wt_max = num_wt;
assign ip_max = num_ip;
assign wt_size_int = wt_size;
assign ip_size_int = ip_size;
 
always@(*)

begin

counter_f = 4'b0000;
counter_i = 4'b0000;
counter_op = 0;

for(f = 0;f<num_wt;f=f+1)
begin


if(f == 0)
orig_wt_ind[f] = comp_wt_ind[f];

else
orig_wt_ind[f] = orig_wt_ind[f-1] + comp_wt_ind[f]+1;

  $display("%b, %d",orig_wt_ind[f],f);
end
  
for(i=0;i<num_ip;i=i+1)
begin

if(i == 0)
orig_ip_ind[i] = comp_ip_ind[i];

else
  orig_ip_ind[i] = orig_ip_ind[i-1] + comp_ip_ind[i]+1;	
 
  $display("%b, %d",orig_ip_ind[i],i);
end
  
for(f = 0;f<num_wt;f=f+1)
begin
	for(i=0;i<num_ip;i=i+1)
	begin
      //$display("%d,%d",f,i);
		wt_ind = orig_wt_ind[f];
      //$display("%b,%b",orig_wt_ind[f],orig_ip_ind[i]);
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
      $display("op_reg is %b",op_reg[counter_op]);
	counter_op = counter_op+1;

end //inner for loop
end //outer for loop

end //always

assign op_cords = op_reg;

endmodule  