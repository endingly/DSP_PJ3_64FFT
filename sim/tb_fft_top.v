//------------------------------------------------------------------------------
    //
    //  Filename       : tb_fft_top.v
    //  Author         : liuxun
    //  Created        : 2019-12-03
    //  Description    : 
    //                   
//------------------------------------------------------------------------------

`include "../include/fft_defines.vh"

//--- GLOBAL ---------------------------
`define TST_TOP 
`define DUT_TOP 

//--- LOCAL ----------------------------
`define DUT_FULL_CLK 10  //100M
`define DUT_HALF_CLK (`DUT_FULL_CLK / 2)

//--- OTHER DEFINES --------------------
`define     AUTO_CHECK      "on"
`define     CHKI_FFT        "./tv/fft_data_in.dat"
`define     CHKI_FFT_REORD  "./tv/fft_data_reord.dat"
`define     CHKI_FFT_ORD    "./tv/fft_ord.dat"
`define     CHKI_WN         "./tv/fft_wn_64.dat"
`define     CHKO_FFT        "./tv/fft_data_out.dat"

`define     DMP_FFT_FILE    "./fft_rtl_tmp.dat"

`define     DMP_SHM_FILE        "./simul_data/waveform.shm"
`define     DMP_FSDB_FILE       "./simul_data/waveform.fsdb"
`define     DMP_VCD_FILE        "./simul_data/waveform.vcd"
`define     DMP_EVCD_FIL        "./simul_data/waveform.evcd"


module `TST_TOP;

//*** PARAMETER ****************************************************************


//*** INPUT/OUTPUT *************************************************************
reg clk;
reg rst_n;
reg val_i;
reg signed [`DATA_WID -1 : 0]    fft_data_re_i, fft_data_im_i;

wire val_o;
wire signed [`DATA_WID -1 : 0]    fft_data_re_o, fft_data_im_o;



//*** WIRE/REG *****************************************************************
wire [`FFT_LEN*`DATA_WID -1 : 0]  fft_data_re_w = dut.fft_core64_u.fft_data_re_r;
wire [`FFT_LEN*`DATA_WID -1 : 0]  fft_data_im_w = dut.fft_core64_u.fft_data_im_r;

reg signed [`DATA_WID -1 : 0] fft_re_mem [0:`FFT_LEN-1];
reg signed [`DATA_WID -1 : 0] fft_im_mem [0:`FFT_LEN-1];

//*** DUT **********************************************************************
`DUT_TOP dut(
    .clk(clk),
    .rst_n(rst_n),

    .fft_data_re_i(fft_data_re_i),
    .fft_data_im_i(fft_data_im_i),
    .val_i(val_i),

    .fft_data_re_o(fft_data_re_o),
    .fft_data_im_o(fft_data_im_o),
    .val_o(val_o)
);

//*** MAIN BODY ****************************************************************
generate 
genvar i;
    for (i = 0; i < `FFT_LEN; i = i+1) begin
        always @(fft_data_re_w or fft_data_im_w) begin
            fft_re_mem[i] = fft_data_re_w[(i+1)*`DATA_WID -1 : i*`DATA_WID];
            fft_im_mem[i] = fft_data_im_w[(i+1)*`DATA_WID -1 : i*`DATA_WID];
        end
    end
endgenerate

//clk
initial begin
    clk = 0;
    forever #(`DUT_HALF_CLK) clk = ~clk;
end

//rst
initial begin
    rst_n = 0;
    #(2*`DUT_FULL_CLK) rst_n = 1;
end

initial begin
    val_i <= 0;
    fft_data_re_i <= 0;
    fft_data_im_i <= 0;
    #(4*`DUT_FULL_CLK)
    read_fft_i;
    @(posedge clk) val_i <= 0;
    dump_fft_o;
end

initial begin
    #(`DUT_FULL_CLK*200) $finish;
end

//*** SUBTASK *******************************************************************
task read_fft_i;
integer fp_read;
integer f;
reg [`DATA_WID -1 : 0] fft_data_re_tmp;
reg [`DATA_WID -1 : 0] fft_data_im_tmp;

begin
    fp_read = $fopen(`CHKI_FFT_REORD,"r");
    repeat(`FFT_LEN) begin
        @(posedge clk) 
        f = $fscanf(fp_read, "%d + %di\n", fft_data_re_tmp, fft_data_im_tmp);
        val_i           <= 1;
        fft_data_re_i   <= fft_data_re_tmp;
        fft_data_im_i   <= fft_data_im_tmp;
    end
end
endtask

task dump_fft_o;
integer fp_dump;
integer f;

begin
    fp_dump = $fopen(`DMP_FFT_FILE,"w");
    while (1) begin
        @(posedge clk);
        $fdisplay( fp_dump, "%d+%di, %d+%di, %d+%di, %d+%di, %d+%di, %d+%di, %d+%di, %d+%di",
                        fft_re_mem[0], fft_im_mem[0], fft_re_mem[1], fft_im_mem[1], 
                        fft_re_mem[2], fft_im_mem[2], fft_re_mem[3], fft_im_mem[3], 
                        fft_re_mem[4], fft_im_mem[4], fft_re_mem[5], fft_im_mem[5], 
                        fft_re_mem[6], fft_im_mem[6], fft_re_mem[7], fft_im_mem[7] );
    end
end

endtask

//*** AUTO CHECK ****************************************************************


//*** WAVEFORM ******************************************************************
// dump fsdb
`ifdef DMP_FSDB
    initial begin
        #`DMP_FSDB_TIME ;
        $fsdbDumpfile( `DMP_FSDB_FILE );
        $fsdbDumpvars( `TST_TOP );
        #(10*`DUT_FULL_CLK );
        $display( "\t\t dump (fsdb) to this test is on !" );
    end
`endif

// dump shm
initial begin
    if( `DMP_SHM=="on" ) begin
        #`DMP_SHM_TIME ;
        $shm_open( `DMP_SHM_FILE );
        $shm_probe( `TST_TOP ,`DMP_SHM_LEVEL );
        #(10*`DUT_FULL_CLK );
        $display( "\t\t dump (shm,%s) to this test is on !" ,`DMP_SHM_LEVEL );
    end
end

// dump vcd
`ifdef DMP_VCD
    initial begin
        #`DMP_VCD_TIME ;
        $dumpfile( `DMP_VCD_FILE );
        $dumpvars( 0, `TST_TOP );
        #(10*`DUT_FULL_CLK );
        $display( "\t\t dump (vcd) to this test is on !" );
    end
`endif

// dump evcd
`ifdef DMP_EVCD
    initial begin
        #`DMP_EVCD_TIME ;
        $dumpports( dut ,`DMP_EVCD_FILE );
        #(10*`DUT_FULL_CLK );
        $display( "\t\t dump (evcd) to this test is on !" );
    end
`endif

endmodule