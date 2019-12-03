// Code your testbench here
// or browse Examples
module output_cord_test();
  
reg [8:0][3:0]comp_wt_ind;
reg [15:0][3:0]comp_ip_ind;
reg [2:0]num_wt;
reg [3:0]num_ip;
reg [4:0]wt_size;
reg [4:0]ip_size;
  wire [23:0][3:0]op_cords;
  
  output_cord DUT
  (.comp_wt_ind(comp_wt_ind),
   .comp_ip_ind(comp_ip_ind),
   .num_wt(num_wt),
   .num_ip(num_ip),
   .wt_size(wt_size),
   .ip_size(ip_size),
   .op_cords(op_cords)
  );
    
  
initial begin
  comp_wt_ind[0] = 4'b0010;
  comp_wt_ind[1] = 4'b0001;
  comp_wt_ind[2] = 4'b0001;
  comp_wt_ind[3] = 4'b0000;
  comp_wt_ind[4] = 4'b0000;
  
  comp_ip_ind[0] = 4'b0010;
  comp_ip_ind[1] = 4'b0100; 
  comp_ip_ind[2] = 4'b0001;
  comp_ip_ind[3] = 4'b0100;
  
  num_wt = 3'b101;
  num_ip = 4'b0100;
  wt_size = 5'b00011;
  ip_size = 5'b00100;
  
  #20
  $display("%b,%b,%b,%b,%b",op_cords[0],op_cords[1],op_cords[2],op_cords[3],op_cords[18]);
  #20
  $finish;
  
end
  
endmodule