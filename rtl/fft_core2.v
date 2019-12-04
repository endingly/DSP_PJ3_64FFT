//------------------------------------------------------------------------------
    //
    //  Filename       : fft_core2.v
    //  Author         : liuxun
    //  Created        : 2019-12-03
    //  Description    : FFT core part. Do 64-FFT using 2-based FFT
    //                   May use fsm to inplement
//------------------------------------------------------------------------------

`include "../include/fft_defines.vh"

module fft_core2(
    fft_data_re1_i,
    fft_data_im1_i,
    fft_data_re2_i,
    fft_data_im2_i,
    fft_wn_re_i,
    fft_wn_im_i,

    fft_data_re1_o,
    fft_data_im1_o,
    fft_data_re2_o,
    fft_data_im2_o
);

//*** PARAMETER ****************************************************************


//*** INPUT/OUTPUT *************************************************************
input   [`RE_DATA_WID -1 :0] fft_data_re1_i, fft_data_re2_i;
input   [`IM_DATA_WID -1 :0] fft_data_im1_i, fft_data_im2_i;
input   [`RE_DATA_WID -1 :0] fft_wn_re_i;
input   [`IM_DATA_WID -1 :0] fft_wn_im_i;

output  [`RE_DATA_WID -1 :0] fft_data_re1_o, fft_data_re2_o;
output  [`IM_DATA_WID -1 :0] fft_data_im1_o, fft_data_im2_o;

//*** WIRE/REG *****************************************************************
reg     [2*`RE_DATA_WID -1 :0] fft_cal_re1_tmp, fft_cal_re2_tmp;
reg     [2*`IM_DATA_WID -1 :0] fft_cal_im1_tmp, fft_cal_im2_tmp;

//*** MAIN BODY ****************************************************************
always @(*) begin
    fft_cal_re1_tmp = (fft_data_re1_i*fft_wn_re_i - fft_data_im1_i*fft_wn_im_i) + (fft_data_re2_i*fft_wn_re_i - fft_data_im2_i*fft_wn_im_i);
    fft_cal_im1_tmp = (fft_data_re1_i*fft_wn_im_i + fft_data_im1_i*fft_wn_re_i) + (fft_data_re2_i*fft_wn_im_i + fft_data_im2_i*fft_wn_re_i);
    fft_cal_re2_tmp = (fft_data_re1_i*fft_wn_re_i - fft_data_im1_i*fft_wn_im_i) - (fft_data_re2_i*fft_wn_re_i - fft_data_im2_i*fft_wn_im_i);
    fft_cal_im2_tmp = (fft_data_re1_i*fft_wn_im_i + fft_data_im1_i*fft_wn_re_i) - (fft_data_re2_i*fft_wn_im_i + fft_data_im2_i*fft_wn_re_i);
end

assign fft_data_re1_o = fft_cal_re1_tmp[2*`RE_DATA_WID -1:`RE_DATA_WID];
assign fft_data_re2_o = fft_cal_re2_tmp[2*`RE_DATA_WID -1:`RE_DATA_WID];
assign fft_data_im1_o = fft_cal_im1_tmp[2*`IM_DATA_WID -1:`IM_DATA_WID];
assign fft_data_im2_o = fft_cal_im2_tmp[2*`IM_DATA_WID -1:`IM_DATA_WID];

endmodule
