module scnn_controller
  (clk,
   input_acts,
   input_dim,
   weights,
   weight_dim,
   outputs
  );
  
  input clk;
  input [15:0][15:0]input_acts;
  input [3:0]input_dim;
  input [8:0][15:0]weights;
  input [3:0]weight_dim;
  output[15:0][31:0]outputs;
  
  wire [15:0][31:0]conv_outputs;
  
  wire [3:0]num_nz_ips; //num of non_zero ips
  wire [15:0][15:0]compressed_ips; //array of compressed ips
  wire [15:0][4:0]comp_inds_ips; //array of compressed inds of ips
  
  wire [3:0]num_nz_wts; //num of non_zero wts
  wire [8:0][15:0]compressed_wts; //array of compressed wts
  wire [8:0][3:0]comp_inds_wts; //array of compressed inds of wts
  
  
  scnn_compression_ips comp0 (input_acts,num_nz_ips,compressed_ips,comp_inds_ips);
  scnn_compression_wts comp1 (weights,num_nz_wts,compressed_wts,comp_inds_wts);
  
  scnn_PE PE0 (clk,weight_dim,input_dim,compressed_ips,compressed_wts,comp_inds_ips,comp_inds_wts,num_nz_ips,num_nz_wts,conv_outputs);
  
  
                         
endmodule