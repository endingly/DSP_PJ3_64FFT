//------------------------------------------------------------------------------
    //
    //  Filename       : fft_ord.v
    //  Author         : liuxun
    //  Created        : 2019-12-03
    //  Description    : or
    //                   and do reorder as well.
//------------------------------------------------------------------------------

`include "../include/fft_defines.vh"

module fft_ord(
    stage_i,

    fft_data_re_i,
    fft_data_im_i,

    fft_data_re_o,
    fft_data_im_o
);


//*** PARAMETER ****************************************************************


//*** INPUT/OUTPUT *************************************************************
input   [`STG_WID -1 : 0] stage_i;
input   [`FFT_LEN * `DATA_WID -1 : 0] fft_data_re_i;
input   [`FFT_LEN * `DATA_WID -1 : 0] fft_data_im_i;

output  [`FFT_LEN * `DATA_WID -1 : 0] fft_data_re_o;
output  [`FFT_LEN * `DATA_WID -1 : 0] fft_data_im_o;

//*** WIRE/REG *****************************************************************
reg [`FFT_LEN*`LOG2_FFT_LEN -1 : 0] idx_list;
reg [`DATA_WID -1 : 0] fft_data_re_r [0 : `FFT_LEN -1];
reg [`DATA_WID -1 : 0] fft_data_im_r [0 : `FFT_LEN -1];


//*** MAIN BODY ****************************************************************
always @(stage_i) begin
    case (stage_i)
        'd0 : begin
            idx_list[ 1*`LOG2_FFT_LEN -1 : 0*`LOG2_FFT_LEN] = 'd0;
            idx_list[ 2*`LOG2_FFT_LEN -1 : 1*`LOG2_FFT_LEN] = 'd4;
            idx_list[ 3*`LOG2_FFT_LEN -1 : 2*`LOG2_FFT_LEN] = 'd2;
            idx_list[ 4*`LOG2_FFT_LEN -1 : 3*`LOG2_FFT_LEN] = 'd6;
            idx_list[ 5*`LOG2_FFT_LEN -1 : 4*`LOG2_FFT_LEN] = 'd1;
            idx_list[ 6*`LOG2_FFT_LEN -1 : 5*`LOG2_FFT_LEN] = 'd5;
            idx_list[ 7*`LOG2_FFT_LEN -1 : 6*`LOG2_FFT_LEN] = 'd3;
            idx_list[ 8*`LOG2_FFT_LEN -1 : 7*`LOG2_FFT_LEN] = 'd7;
        end
        'd1 : begin
            idx_list[ 1*`LOG2_FFT_LEN -1 : 0*`LOG2_FFT_LEN] = 'd0;
            idx_list[ 2*`LOG2_FFT_LEN -1 : 1*`LOG2_FFT_LEN] = 'd2;
            idx_list[ 3*`LOG2_FFT_LEN -1 : 2*`LOG2_FFT_LEN] = 'd1;
            idx_list[ 4*`LOG2_FFT_LEN -1 : 3*`LOG2_FFT_LEN] = 'd3;
            idx_list[ 5*`LOG2_FFT_LEN -1 : 4*`LOG2_FFT_LEN] = 'd4;
            idx_list[ 6*`LOG2_FFT_LEN -1 : 5*`LOG2_FFT_LEN] = 'd6;
            idx_list[ 7*`LOG2_FFT_LEN -1 : 6*`LOG2_FFT_LEN] = 'd5;
            idx_list[ 8*`LOG2_FFT_LEN -1 : 7*`LOG2_FFT_LEN] = 'd7;
        end
        'd2 : begin
            idx_list[ 1*`LOG2_FFT_LEN -1 : 0*`LOG2_FFT_LEN] = 'd0;
            idx_list[ 2*`LOG2_FFT_LEN -1 : 1*`LOG2_FFT_LEN] = 'd4;
            idx_list[ 3*`LOG2_FFT_LEN -1 : 2*`LOG2_FFT_LEN] = 'd1;
            idx_list[ 4*`LOG2_FFT_LEN -1 : 3*`LOG2_FFT_LEN] = 'd5;
            idx_list[ 5*`LOG2_FFT_LEN -1 : 4*`LOG2_FFT_LEN] = 'd2;
            idx_list[ 6*`LOG2_FFT_LEN -1 : 5*`LOG2_FFT_LEN] = 'd6;
            idx_list[ 7*`LOG2_FFT_LEN -1 : 6*`LOG2_FFT_LEN] = 'd3;
            idx_list[ 8*`LOG2_FFT_LEN -1 : 7*`LOG2_FFT_LEN] = 'd7;
        end
        // 'd3 : 
        // 'd4 :
        // 'd5 : 
        default: begin
            idx_list[ 1*`LOG2_FFT_LEN -1 : 0*`LOG2_FFT_LEN] = 'd0;
            idx_list[ 2*`LOG2_FFT_LEN -1 : 1*`LOG2_FFT_LEN] = 'd0;
            idx_list[ 3*`LOG2_FFT_LEN -1 : 2*`LOG2_FFT_LEN] = 'd0;
            idx_list[ 4*`LOG2_FFT_LEN -1 : 3*`LOG2_FFT_LEN] = 'd0;
            idx_list[ 5*`LOG2_FFT_LEN -1 : 4*`LOG2_FFT_LEN] = 'd0;
            idx_list[ 6*`LOG2_FFT_LEN -1 : 5*`LOG2_FFT_LEN] = 'd0;
            idx_list[ 7*`LOG2_FFT_LEN -1 : 6*`LOG2_FFT_LEN] = 'd0;
            idx_list[ 8*`LOG2_FFT_LEN -1 : 7*`LOG2_FFT_LEN] = 'd0;
        end
    endcase
end


generate
genvar i;
    for (i = 0; i < `FFT_LEN; i = i+1) begin:ordering
        always @(idx_list or fft_data_re_i or fft_data_im_i) begin
            fft_data_re_r[idx_list[(i+1)*`LOG2_FFT_LEN -1 : i*`LOG2_FFT_LEN]] = fft_data_re_i[(i+1)*`DATA_WID -1 : i*`DATA_WID];
            fft_data_im_r[idx_list[(i+1)*`LOG2_FFT_LEN -1 : i*`LOG2_FFT_LEN]] = fft_data_im_i[(i+1)*`DATA_WID -1 : i*`DATA_WID];
        end
    end
endgenerate

/*
// `FFT_LEN == 'd64
assign fft_data_re_o = {fft_data_re_r[63], fft_data_re_r[62], fft_data_re_r[61], fft_data_re_r[60],
                        fft_data_re_r[59], fft_data_re_r[58], fft_data_re_r[57], fft_data_re_r[56],
                        fft_data_re_r[55], fft_data_re_r[54], fft_data_re_r[53], fft_data_re_r[52],
                        fft_data_re_r[51], fft_data_re_r[50], fft_data_re_r[49], fft_data_re_r[48],
                        fft_data_re_r[47], fft_data_re_r[46], fft_data_re_r[45], fft_data_re_r[44],
                        fft_data_re_r[43], fft_data_re_r[42], fft_data_re_r[41], fft_data_re_r[40],
                        fft_data_re_r[39], fft_data_re_r[38], fft_data_re_r[37], fft_data_re_r[36],
                        fft_data_re_r[35], fft_data_re_r[34], fft_data_re_r[33], fft_data_re_r[32],
                        fft_data_re_r[31], fft_data_re_r[30], fft_data_re_r[29], fft_data_re_r[28],
                        fft_data_re_r[27], fft_data_re_r[26], fft_data_re_r[25], fft_data_re_r[24],
                        fft_data_re_r[23], fft_data_re_r[22], fft_data_re_r[21], fft_data_re_r[20],
                        fft_data_re_r[19], fft_data_re_r[18], fft_data_re_r[17], fft_data_re_r[16],
                        fft_data_re_r[15], fft_data_re_r[14], fft_data_re_r[13], fft_data_re_r[12],
                        fft_data_re_r[11], fft_data_re_r[10], fft_data_re_r[ 9], fft_data_re_r[ 8],
                        fft_data_re_r[ 7], fft_data_re_r[ 6], fft_data_re_r[ 5], fft_data_re_r[ 4],
                        fft_data_re_r[ 3], fft_data_re_r[ 2], fft_data_re_r[ 1], fft_data_re_r[ 0] };

assign fft_data_im_o = {fft_data_im_r[63], fft_data_im_r[62], fft_data_im_r[61], fft_data_im_r[60],
                        fft_data_im_r[59], fft_data_im_r[58], fft_data_im_r[57], fft_data_im_r[56],
                        fft_data_im_r[55], fft_data_im_r[54], fft_data_im_r[53], fft_data_im_r[52],
                        fft_data_im_r[51], fft_data_im_r[50], fft_data_im_r[49], fft_data_im_r[48],
                        fft_data_im_r[47], fft_data_im_r[46], fft_data_im_r[45], fft_data_im_r[44],
                        fft_data_im_r[43], fft_data_im_r[42], fft_data_im_r[41], fft_data_im_r[40],
                        fft_data_im_r[39], fft_data_im_r[38], fft_data_im_r[37], fft_data_im_r[36],
                        fft_data_im_r[35], fft_data_im_r[34], fft_data_im_r[33], fft_data_im_r[32],
                        fft_data_im_r[31], fft_data_im_r[30], fft_data_im_r[29], fft_data_im_r[28],
                        fft_data_im_r[27], fft_data_im_r[26], fft_data_im_r[25], fft_data_im_r[24],
                        fft_data_im_r[23], fft_data_im_r[22], fft_data_im_r[21], fft_data_im_r[20],
                        fft_data_im_r[19], fft_data_im_r[18], fft_data_im_r[17], fft_data_im_r[16],
                        fft_data_im_r[15], fft_data_im_r[14], fft_data_im_r[13], fft_data_im_r[12],
                        fft_data_im_r[11], fft_data_im_r[10], fft_data_im_r[ 9], fft_data_im_r[ 8],
                        fft_data_im_r[ 7], fft_data_im_r[ 6], fft_data_im_r[ 5], fft_data_im_r[ 4],
                        fft_data_im_r[ 3], fft_data_im_r[ 2], fft_data_im_r[ 1], fft_data_im_r[ 0] };
*/

assign fft_data_re_o = {fft_data_re_r[ 7], fft_data_re_r[ 6], fft_data_re_r[ 5], fft_data_re_r[ 4],
                        fft_data_re_r[ 3], fft_data_re_r[ 2], fft_data_re_r[ 1], fft_data_re_r[ 0] };


assign fft_data_im_o = {fft_data_im_r[ 7], fft_data_im_r[ 6], fft_data_im_r[ 5], fft_data_im_r[ 4],
                        fft_data_im_r[ 3], fft_data_im_r[ 2], fft_data_im_r[ 1], fft_data_im_r[ 0] };
endmodule

