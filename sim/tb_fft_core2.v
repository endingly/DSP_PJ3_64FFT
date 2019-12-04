//------------------------------------------------------------------------------
    //
    //  Filename       : tb_fft_core2.v
    //  Author         : liuxun
    //  Created        : 2019-12-03
    //  Description    : 
    //                   
//------------------------------------------------------------------------------

`include "../include/fft_defines.vh"

//--- GLOBAL ---------------------------
`define TST_TOP tb_fft_core2
`define DUT_TOP fft_core2

//--- LOCAL ----------------------------
`define DUT_FULL_CLK 10  //100M
`define DUT_HALF_CLK (`DUT_FULL_CLK / 2)

//--- CHECK DATA -----------------------


module tb_fft_core2();

//*** PARAMETER ****************************************************************


//*** INPUT/OUTPUT *************************************************************
reg     [`RE_DATA_WID -1 :0] data_re1_i, data_re2_i;
reg     [`IM_DATA_WID -1 :0] data_im1_i, data_im2_i;
reg     [`RE_DATA_WID -1 :0] wn_re;
reg     [`IM_DATA_WID -1 :0] wn_im;

wire    [`RE_DATA_WID -1 :0] data_re1_o, data_re2_o;
wire    [`IM_DATA_WID -1 :0] data_im1_o, data_im2_o;

//*** WIRE/REG *****************************************************************


//*** DUT **********************************************************************
`DUT_TOP dut(
    .fft_data_re1_i(data_re1_i),
    .fft_data_im1_i(data_im1_i),
    .fft_data_re2_i(data_re2_i),
    .fft_data_im2_i(data_im2_i),
    .fft_wn_re_i(wn_re),
    .fft_wn_im_i(wn_im),

    .fft_data_re1_o(data_re1_o),
    .fft_data_im1_o(data_re2_o),
    .fft_data_re2_o(data_im1_o),
    .fft_data_im2_o(data_im2_o)
);

//*** MAIN BODY ****************************************************************
initial begin
    data_re1_i = 'd1;
    data_im1_i = 'd1;
    data_re2_i = 'd1;
    data_im2_i = 'd1;

    wn_re = 1;
    wn_im = 1;
end

initial begin
    #(`DUT_FULL_CLK*10) $finish;
end

endmodule
