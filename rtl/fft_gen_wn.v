//------------------------------------------------------------------------------
    //
    //  Filename       : fft_gen_wn.v
    //  Author         : liuxun
    //  Created        : 2019-12-03
    //  Description    : Fetch Wn for FFT
    //
//------------------------------------------------------------------------------

module fft_gen_wn(
    stage_i,

    fft_wn_re_o,
    fft_wn_im_o
);

//*** PARAMETER ****************************************************************


//*** INPUT/OUTPUT *************************************************************
input  [`STG_WID -1 : 0] stage_i;

output reg [`FFT_LEN/2*`WN_WID -1 : 0] fft_wn_re_o;
output reg [`FFT_LEN/2*`WN_WID -1 : 0] fft_wn_im_o;

//*** WIRE/REG *****************************************************************
// reg [`WN_WID -1 : 0] wn_re_r [0:`FFT_LEN/2];
// reg [`WN_WID -1 : 0] wn_im_r [0:`FFT_LEN/2];


//*** MAIN BODY ****************************************************************
always @(stage_i) begin
    fft_wn_re_o = 'd0;
    fft_wn_im_o = 'd0;
    case(stage_i)
        'd0: begin
            fft_wn_re_o = {`FFT_LEN/2{`WN_WID'd256}};
            fft_wn_im_o = {`FFT_LEN/2{`WN_WID'd0}};
        end
        'd1: begin
            fft_wn_re_o[`WN_WID -1   :         0] = 'd256;
            fft_wn_re_o[2*`WN_WID -1 :   `WN_WID] = 'd0;
            fft_wn_re_o[3*`WN_WID -1 : 2*`WN_WID] = 'd256;
            fft_wn_re_o[4*`WN_WID -1 : 3*`WN_WID] = 'd0;
            fft_wn_im_o[`WN_WID -1   :         0] = 'd0;
            fft_wn_im_o[2*`WN_WID -1 :   `WN_WID] = -'d256; //'h200;
            fft_wn_im_o[3*`WN_WID -1 : 2*`WN_WID] = 'd0;
            fft_wn_im_o[4*`WN_WID -1 : 3*`WN_WID] = -'d256;
        end
        'd2: begin
            fft_wn_re_o[`WN_WID -1   :         0] = 'd256;
            fft_wn_re_o[2*`WN_WID -1 :   `WN_WID] = 'd181;
            fft_wn_re_o[3*`WN_WID -1 : 2*`WN_WID] = 'd256;
            fft_wn_re_o[4*`WN_WID -1 : 3*`WN_WID] = -'d181;
            fft_wn_im_o[`WN_WID -1   :         0] = 'd0;
            fft_wn_im_o[2*`WN_WID -1 :   `WN_WID] = -'d181;
            fft_wn_im_o[3*`WN_WID -1 : 2*`WN_WID] = -'d256;
            fft_wn_im_o[4*`WN_WID -1 : 3*`WN_WID] = -'d181;
        end
        // 'd3:
        // 'd4:
        // 'd5:
        default: begin
            fft_wn_re_o = 'd0;
            fft_wn_im_o = 'd0;
        end
    endcase
end


endmodule
