module scnn_controller_4PE
  (clk,
   input_acts,
   input_dim,
   weights,
   weight_dim,
   outputs
  );
  
  input clk;
  input [63:0][15:0]input_acts;
  input [7:0]input_dim;
  input [8:0][15:0]weights;
  input [3:0]weight_dim;
  output[63:0][31:0]outputs;
  
  wire [63:0][31:0]conv_outputs;
  
  wire [7:0]num_nz_ips; //num of non_zero ips
  wire [3:0][15:0][15:0]compressed_ips; //array of compressed ips
  wire [3:0][15:0][7:0]comp_inds_ips; //array of compressed inds of ips
  wire [3:0][7:0]nzips_per_slice;
  wire [3:0][7:0]nzips_arr;
  wire [3:0][7:0]offset_array;
  
  wire [3:0]num_nz_wts; //num of non_zero wts
  wire [8:0][15:0]compressed_wts; //array of compressed wts
  wire [8:0][3:0]comp_inds_wts; //array of compressed inds of wts
  
  wire [63:0][31:0]acc_buffer0;
  wire [63:0][31:0]acc_buffer1;
  wire [63:0][31:0]acc_buffer2;
  wire [63:0][31:0]acc_buffer3;
  

  scnn_compression_ips comp0 (input_acts,num_nz_ips,compressed_ips,comp_inds_ips,nzips_per_slice,nzips_arr,offset_array);
  scnn_compression_wts comp1 (weights,num_nz_wts,compressed_wts,comp_inds_wts);
  
  scnn_PE PE0 (clk,weight_dim,input_dim,compressed_ips[0],compressed_wts,comp_inds_ips[0],comp_inds_wts,nzips_per_slice[0],num_nz_wts,offset_array[0],acc_buffer0);
  scnn_PE PE1 (clk,weight_dim,input_dim,compressed_ips[1],compressed_wts,comp_inds_ips[1],comp_inds_wts,nzips_per_slice[1],num_nz_wts,offset_array[1],acc_buffer1);
  scnn_PE PE2 (clk,weight_dim,input_dim,compressed_ips[2],compressed_wts,comp_inds_ips[2],comp_inds_wts,nzips_per_slice[2],num_nz_wts,offset_array[2],acc_buffer2);
  scnn_PE PE3 (clk,weight_dim,input_dim,compressed_ips[3],compressed_wts,comp_inds_ips[3],comp_inds_wts,nzips_per_slice[3],num_nz_wts,offset_array[3],acc_buffer3);                       

  scnn_accumulate a0 (acc_buffer0,acc_buffer1,acc_buffer2,acc_buffer3,conv_outputs);
  
  endmodule