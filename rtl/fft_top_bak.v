//------------------------------------------------------------------------------
    //
    //  Filename       : fft_top.v
    //  Author         : liuxun
    //  Created        : 2019-12-03
    //  Description    : Build FFT using fft_core2 module with a pipeline of 6
    //
//------------------------------------------------------------------------------

`include "../include/fft_defines.vh"
module fft_top(
    clk,
    rst_n,

    fft_data_re_i,
    fft_data_im_i,
    val_i,

    fft_data_re_o,
    fft_data_im_o,
    val_o
);

//*** PARAMETER ****************************************************************


//*** INPUT/OUTPUT *************************************************************
input   clk;
input   rst_n;

input   val_i;
input   [`DATA_WID -1 : 0] fft_data_re_i;
input   [`DATA_WID -1 : 0] fft_data_im_i;

output  reg val_o;
output  reg signed [`DATA_WID -1 : 0] fft_data_re_o;
output  reg signed [`DATA_WID -1 : 0] fft_data_im_o;

//*** WIRE/REG *****************************************************************
// input 
reg     [`FFT_LEN*`DATA_WID -1 : 0] in_data_re_buf;
reg     [`FFT_LEN*`DATA_WID -1 : 0] in_data_im_buf;
reg     [`LOG2_FFT_LEN -1 : 0] fft_i_cnt;
reg     ready;
// output
wire    [`FFT_LEN*`DATA_WID -1 : 0] fft_data_re_w, fft_data_im_w;
wire    fft_done;
reg     [`FFT_LEN*`DATA_WID -1 : 0] out_data_re_buf;
reg     [`FFT_LEN*`DATA_WID -1 : 0] out_data_im_buf;
reg     [`LOG2_FFT_LEN -1 : 0] fft_o_cnt;

//*** MAIN BODY ****************************************************************
// input serial to parallel
always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        ready <= 'd0;
        fft_i_cnt <= 'd0;
        in_data_re_buf <= 'd0;
        in_data_im_buf <= 'd0;
    end
    else begin
        if (val_i) begin
            if (fft_i_cnt == `FFT_LEN -1) begin
                ready <= 'd1;
                fft_i_cnt <= 'd0;
            end
            else begin
                fft_i_cnt <= fft_i_cnt + 1;
            end
            case (fft_i_cnt)
                'd0 : begin
                    in_data_re_buf[`DATA_WID -1 : 0] <= fft_data_re_i;
                    in_data_im_buf[`DATA_WID -1 : 0] <= fft_data_im_i;
                end
                'd1 : begin
                    in_data_re_buf[2*`DATA_WID -1 : `DATA_WID] <= fft_data_re_i;
                    in_data_im_buf[2*`DATA_WID -1 : `DATA_WID] <= fft_data_im_i;
                end
                'd2 : begin
                    in_data_re_buf[3*`DATA_WID -1 : 2*`DATA_WID] <= fft_data_re_i;
                    in_data_im_buf[3*`DATA_WID -1 : 2*`DATA_WID] <= fft_data_im_i;
                end
                'd3 : begin
                    in_data_re_buf[4*`DATA_WID -1 : 3*`DATA_WID] <= fft_data_re_i;
                    in_data_im_buf[4*`DATA_WID -1 : 3*`DATA_WID] <= fft_data_im_i;
                end
                'd4 : begin
                    in_data_re_buf[5*`DATA_WID -1 : 4*`DATA_WID] <= fft_data_re_i;
                    in_data_im_buf[5*`DATA_WID -1 : 4*`DATA_WID] <= fft_data_im_i;
                end
                'd5 : begin
                    in_data_re_buf[6*`DATA_WID -1 : 5*`DATA_WID] <= fft_data_re_i;
                    in_data_im_buf[6*`DATA_WID -1 : 5*`DATA_WID] <= fft_data_im_i;
                end
                'd6 : begin
                    in_data_re_buf[7*`DATA_WID -1 : 6*`DATA_WID] <= fft_data_re_i;
                    in_data_im_buf[7*`DATA_WID -1 : 6*`DATA_WID] <= fft_data_im_i;
                end
                'd7 : begin
                    in_data_re_buf[8*`DATA_WID -1 : 7*`DATA_WID] <= fft_data_re_i;
                    in_data_im_buf[8*`DATA_WID -1 : 7*`DATA_WID] <= fft_data_im_i;
                end
                'd8 : begin
                    in_data_re_buf[9*`DATA_WID -1 : 8*`DATA_WID] <= fft_data_re_i;
                    in_data_im_buf[9*`DATA_WID -1 : 8*`DATA_WID] <= fft_data_im_i;
                end
                'd9 : begin
                    in_data_re_buf[10*`DATA_WID -1 : 9*`DATA_WID] <= fft_data_re_i;
                    in_data_im_buf[10*`DATA_WID -1 : 9*`DATA_WID] <= fft_data_im_i;
                end
                'd10: begin
                    in_data_re_buf[11*`DATA_WID -1 : 10*`DATA_WID] <= fft_data_re_i;
                    in_data_im_buf[11*`DATA_WID -1 : 10*`DATA_WID] <= fft_data_im_i;
                end
                'd11: begin
                    in_data_re_buf[12*`DATA_WID -1 : 11*`DATA_WID] <= fft_data_re_i;
                    in_data_im_buf[12*`DATA_WID -1 : 11*`DATA_WID] <= fft_data_im_i;
                end
                'd12: begin
                    in_data_re_buf[13*`DATA_WID -1 : 12*`DATA_WID] <= fft_data_re_i;
                    in_data_im_buf[13*`DATA_WID -1 : 12*`DATA_WID] <= fft_data_im_i;
                end
                'd13: begin
                    in_data_re_buf[14*`DATA_WID -1 : 13*`DATA_WID] <= fft_data_re_i;
                    in_data_im_buf[14*`DATA_WID -1 : 13*`DATA_WID] <= fft_data_im_i;
                end
                'd14: begin
                    in_data_re_buf[15*`DATA_WID -1 : 14*`DATA_WID] <= fft_data_re_i;
                    in_data_im_buf[15*`DATA_WID -1 : 14*`DATA_WID] <= fft_data_im_i;
                end
                'd15: begin
                    in_data_re_buf[16*`DATA_WID -1 : 15*`DATA_WID] <= fft_data_re_i;
                    in_data_im_buf[16*`DATA_WID -1 : 15*`DATA_WID] <= fft_data_im_i;
                end
                'd16: begin
                    in_data_re_buf[17*`DATA_WID -1 : 16*`DATA_WID] <= fft_data_re_i;
                    in_data_im_buf[17*`DATA_WID -1 : 16*`DATA_WID] <= fft_data_im_i;
                end
                'd17: begin
                    in_data_re_buf[18*`DATA_WID -1 : 17*`DATA_WID] <= fft_data_re_i;
                    in_data_im_buf[18*`DATA_WID -1 : 17*`DATA_WID] <= fft_data_im_i;
                end
                'd18: begin
                    in_data_re_buf[19*`DATA_WID -1 : 18*`DATA_WID] <= fft_data_re_i;
                    in_data_im_buf[19*`DATA_WID -1 : 18*`DATA_WID] <= fft_data_im_i;
                end
                'd19: begin
                    in_data_re_buf[20*`DATA_WID -1 : 19*`DATA_WID] <= fft_data_re_i;
                    in_data_im_buf[20*`DATA_WID -1 : 19*`DATA_WID] <= fft_data_im_i;
                end
                'd20: begin
                    in_data_re_buf[21*`DATA_WID -1 : 20*`DATA_WID] <= fft_data_re_i;
                    in_data_im_buf[21*`DATA_WID -1 : 20*`DATA_WID] <= fft_data_im_i;
                end
                'd21: begin
                    in_data_re_buf[22*`DATA_WID -1 : 21*`DATA_WID] <= fft_data_re_i;
                    in_data_im_buf[22*`DATA_WID -1 : 21*`DATA_WID] <= fft_data_im_i;
                end
                'd22: begin
                    in_data_re_buf[23*`DATA_WID -1 : 22*`DATA_WID] <= fft_data_re_i;
                    in_data_im_buf[23*`DATA_WID -1 : 22*`DATA_WID] <= fft_data_im_i;
                end
                'd23: begin
                    in_data_re_buf[24*`DATA_WID -1 : 23*`DATA_WID] <= fft_data_re_i;
                    in_data_im_buf[24*`DATA_WID -1 : 23*`DATA_WID] <= fft_data_im_i;
                end
                'd24: begin
                    in_data_re_buf[25*`DATA_WID -1 : 24*`DATA_WID] <= fft_data_re_i;
                    in_data_im_buf[25*`DATA_WID -1 : 24*`DATA_WID] <= fft_data_im_i;
                end
                'd25: begin
                    in_data_re_buf[26*`DATA_WID -1 : 25*`DATA_WID] <= fft_data_re_i;
                    in_data_im_buf[26*`DATA_WID -1 : 25*`DATA_WID] <= fft_data_im_i;
                end
                'd26: begin
                    in_data_re_buf[27*`DATA_WID -1 : 26*`DATA_WID] <= fft_data_re_i;
                    in_data_im_buf[27*`DATA_WID -1 : 26*`DATA_WID] <= fft_data_im_i;
                end
                'd27: begin
                    in_data_re_buf[28*`DATA_WID -1 : 27*`DATA_WID] <= fft_data_re_i;
                    in_data_im_buf[28*`DATA_WID -1 : 27*`DATA_WID] <= fft_data_im_i;
                end
                'd28: begin
                    in_data_re_buf[29*`DATA_WID -1 : 28*`DATA_WID] <= fft_data_re_i;
                    in_data_im_buf[29*`DATA_WID -1 : 28*`DATA_WID] <= fft_data_im_i;
                end
                'd29: begin
                    in_data_re_buf[30*`DATA_WID -1 : 29*`DATA_WID] <= fft_data_re_i;
                    in_data_im_buf[30*`DATA_WID -1 : 29*`DATA_WID] <= fft_data_im_i;
                end
                'd30: begin
                    in_data_re_buf[31*`DATA_WID -1 : 30*`DATA_WID] <= fft_data_re_i;
                    in_data_im_buf[31*`DATA_WID -1 : 30*`DATA_WID] <= fft_data_im_i;
                end
                'd31: begin
                    in_data_re_buf[32*`DATA_WID -1 : 31*`DATA_WID] <= fft_data_re_i;
                    in_data_im_buf[32*`DATA_WID -1 : 31*`DATA_WID] <= fft_data_im_i;
                end
                default: begin
                    in_data_re_buf <= 'd0;
                    in_data_im_buf <= 'd0;
                end
            endcase
        end
        else begin
            ready <= 'd0;
            fft_i_cnt <= 'd0; 
        end

    end
end

// load output parallel
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        out_data_re_buf <= 'd0;
        out_data_im_buf <= 'd0;
    end
    else begin
        if(fft_done) begin
            out_data_re_buf <= fft_data_re_w;
            out_data_im_buf <= fft_data_im_w;
        end
        else begin
            out_data_re_buf <= out_data_re_buf;
            out_data_im_buf <= out_data_im_buf;
        end
    end
end

// output parallel to serial
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        fft_o_cnt <= 'd0;
        val_o <= 'd0;
        fft_data_re_o <= 'd0;
        fft_data_im_o <= 'd0;
    end
    else begin
        if (fft_done) begin
            fft_o_cnt <= 'd1;
            val_o <= 'd1;
            fft_data_re_o <= fft_data_re_w[`DATA_WID -1 : 0];
            fft_data_im_o <= fft_data_im_w[`DATA_WID -1 : 0];
        end
        else begin
            if(|fft_o_cnt) begin
                if(fft_o_cnt == `FFT_LEN -1) fft_o_cnt <= 'd0;
                else fft_o_cnt <= fft_o_cnt + 1;
                case (fft_o_cnt)
                    'd1 : begin 
                        fft_data_re_o <= out_data_re_buf[2*`DATA_WID -1 : 1*`DATA_WID];
                        fft_data_im_o <= out_data_im_buf[2*`DATA_WID -1 : 1*`DATA_WID];
                    end
                    'd2 : begin 
                        fft_data_re_o <= out_data_re_buf[3*`DATA_WID -1 : 2*`DATA_WID];
                        fft_data_im_o <= out_data_im_buf[3*`DATA_WID -1 : 2*`DATA_WID];
                    end
                    'd3 : begin 
                        fft_data_re_o <= out_data_re_buf[4*`DATA_WID -1 : 3*`DATA_WID];
                        fft_data_im_o <= out_data_im_buf[4*`DATA_WID -1 : 3*`DATA_WID];
                    end
                    'd4 : begin 
                        fft_data_re_o <= out_data_re_buf[5*`DATA_WID -1 : 4*`DATA_WID];
                        fft_data_im_o <= out_data_im_buf[5*`DATA_WID -1 : 4*`DATA_WID];
                    end
                    'd5 : begin 
                        fft_data_re_o <= out_data_re_buf[6*`DATA_WID -1 : 5*`DATA_WID];
                        fft_data_im_o <= out_data_im_buf[6*`DATA_WID -1 : 5*`DATA_WID];
                    end
                    'd6 : begin 
                        fft_data_re_o <= out_data_re_buf[7*`DATA_WID -1 : 6*`DATA_WID];
                        fft_data_im_o <= out_data_im_buf[7*`DATA_WID -1 : 6*`DATA_WID];
                    end
                    'd7 : begin 
                        fft_data_re_o <= out_data_re_buf[8*`DATA_WID -1 : 7*`DATA_WID];
                        fft_data_im_o <= out_data_im_buf[8*`DATA_WID -1 : 7*`DATA_WID];
                    end
                    'd8 : begin 
                        fft_data_re_o <= out_data_re_buf[9*`DATA_WID -1 : 8*`DATA_WID];
                        fft_data_im_o <= out_data_im_buf[9*`DATA_WID -1 : 8*`DATA_WID];
                    end
                    'd9 : begin 
                        fft_data_re_o <= out_data_re_buf[10*`DATA_WID -1 : 9*`DATA_WID];
                        fft_data_im_o <= out_data_im_buf[10*`DATA_WID -1 : 9*`DATA_WID];
                    end
                    'd10: begin 
                        fft_data_re_o <= out_data_re_buf[11*`DATA_WID -1 : 10*`DATA_WID];
                        fft_data_im_o <= out_data_im_buf[11*`DATA_WID -1 : 10*`DATA_WID];
                    end
                    'd11: begin 
                        fft_data_re_o <= out_data_re_buf[12*`DATA_WID -1 : 11*`DATA_WID];
                        fft_data_im_o <= out_data_im_buf[12*`DATA_WID -1 : 11*`DATA_WID];
                    end
                    'd12: begin 
                        fft_data_re_o <= out_data_re_buf[13*`DATA_WID -1 : 12*`DATA_WID];
                        fft_data_im_o <= out_data_im_buf[13*`DATA_WID -1 : 12*`DATA_WID];
                    end
                    'd13: begin 
                        fft_data_re_o <= out_data_re_buf[14*`DATA_WID -1 : 13*`DATA_WID];
                        fft_data_im_o <= out_data_im_buf[14*`DATA_WID -1 : 13*`DATA_WID];
                    end
                    'd14: begin 
                        fft_data_re_o <= out_data_re_buf[15*`DATA_WID -1 : 14*`DATA_WID];
                        fft_data_im_o <= out_data_im_buf[15*`DATA_WID -1 : 14*`DATA_WID];
                    end
                    'd15: begin 
                        fft_data_re_o <= out_data_re_buf[16*`DATA_WID -1 : 15*`DATA_WID];
                        fft_data_im_o <= out_data_im_buf[16*`DATA_WID -1 : 15*`DATA_WID];
                    end
                    'd16: begin 
                        fft_data_re_o <= out_data_re_buf[17*`DATA_WID -1 : 16*`DATA_WID];
                        fft_data_im_o <= out_data_im_buf[17*`DATA_WID -1 : 16*`DATA_WID];
                    end
                    'd17: begin 
                        fft_data_re_o <= out_data_re_buf[18*`DATA_WID -1 : 17*`DATA_WID];
                        fft_data_im_o <= out_data_im_buf[18*`DATA_WID -1 : 17*`DATA_WID];
                    end
                    'd18: begin 
                        fft_data_re_o <= out_data_re_buf[19*`DATA_WID -1 : 18*`DATA_WID];
                        fft_data_im_o <= out_data_im_buf[19*`DATA_WID -1 : 18*`DATA_WID];
                    end
                    'd19: begin 
                        fft_data_re_o <= out_data_re_buf[20*`DATA_WID -1 : 19*`DATA_WID];
                        fft_data_im_o <= out_data_im_buf[20*`DATA_WID -1 : 19*`DATA_WID];
                    end
                    'd20: begin 
                        fft_data_re_o <= out_data_re_buf[21*`DATA_WID -1 : 20*`DATA_WID];
                        fft_data_im_o <= out_data_im_buf[21*`DATA_WID -1 : 20*`DATA_WID];
                    end
                    'd21: begin 
                        fft_data_re_o <= out_data_re_buf[22*`DATA_WID -1 : 21*`DATA_WID];
                        fft_data_im_o <= out_data_im_buf[22*`DATA_WID -1 : 21*`DATA_WID];
                    end
                    'd22: begin 
                        fft_data_re_o <= out_data_re_buf[23*`DATA_WID -1 : 22*`DATA_WID];
                        fft_data_im_o <= out_data_im_buf[23*`DATA_WID -1 : 22*`DATA_WID];
                    end
                    'd23: begin 
                        fft_data_re_o <= out_data_re_buf[24*`DATA_WID -1 : 23*`DATA_WID];
                        fft_data_im_o <= out_data_im_buf[24*`DATA_WID -1 : 23*`DATA_WID];
                    end
                    'd24: begin 
                        fft_data_re_o <= out_data_re_buf[25*`DATA_WID -1 : 24*`DATA_WID];
                        fft_data_im_o <= out_data_im_buf[25*`DATA_WID -1 : 24*`DATA_WID];
                    end
                    'd25: begin 
                        fft_data_re_o <= out_data_re_buf[26*`DATA_WID -1 : 25*`DATA_WID];
                        fft_data_im_o <= out_data_im_buf[26*`DATA_WID -1 : 25*`DATA_WID];
                    end
                    'd26: begin 
                        fft_data_re_o <= out_data_re_buf[27*`DATA_WID -1 : 26*`DATA_WID];
                        fft_data_im_o <= out_data_im_buf[27*`DATA_WID -1 : 26*`DATA_WID];
                    end
                    'd27: begin 
                        fft_data_re_o <= out_data_re_buf[28*`DATA_WID -1 : 27*`DATA_WID];
                        fft_data_im_o <= out_data_im_buf[28*`DATA_WID -1 : 27*`DATA_WID];
                    end
                    'd28: begin 
                        fft_data_re_o <= out_data_re_buf[29*`DATA_WID -1 : 28*`DATA_WID];
                        fft_data_im_o <= out_data_im_buf[29*`DATA_WID -1 : 28*`DATA_WID];
                    end
                    'd29: begin 
                        fft_data_re_o <= out_data_re_buf[30*`DATA_WID -1 : 29*`DATA_WID];
                        fft_data_im_o <= out_data_im_buf[30*`DATA_WID -1 : 29*`DATA_WID];
                    end
                    'd30: begin 
                        fft_data_re_o <= out_data_re_buf[31*`DATA_WID -1 : 30*`DATA_WID];
                        fft_data_im_o <= out_data_im_buf[31*`DATA_WID -1 : 30*`DATA_WID];
                    end
                    'd31: begin 
                        fft_data_re_o <= out_data_re_buf[32*`DATA_WID -1 : 31*`DATA_WID];
                        fft_data_im_o <= out_data_im_buf[32*`DATA_WID -1 : 31*`DATA_WID];
                    end
                    default: begin
                        fft_data_re_o <= 'd0;
                        fft_data_im_o <= 'd0;
                    end
                endcase
            end
            else begin
                fft_o_cnt <= 'd0;
                val_o <= 'd0;
                fft_data_re_o <= 'd0;
                fft_data_im_o <= 'd0;
            end
        end
    end
end

fft_core64 fft_core64_u(
    .clk(clk),
    .rst_n(rst_n),
    .val_i(ready),
    .fft_data_re_i(in_data_re_buf),
    .fft_data_im_i(in_data_im_buf),
    .done_o(fft_done),
    .fft_data_re_o(fft_data_re_w),
    .fft_data_im_o(fft_data_im_w)
);


endmodule
