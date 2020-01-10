#-------------------------------------------------------------------------------
  #
  #  Filename       : makefile
  #  Author         : Huang Lei Lei
  #  Created        : 2019-06-19
  #  Description    : makefile to run ncsim
  #
#-------------------------------------------------------------------------------

#--- PARAMETER -------------------------

NUM_PARAL ?= 1


#--- INFO ------------------------------

default:
	@ echo "MAKE TARGETS:                                                                                                                        "
	@ echo "                                                                                                                                     "
	@ echo "  clean                                                                                                                              "
	@ echo "    clean                                                                                clean temperary files                       "
	@ echo "    cleanall                                                                             clean all generated files                   "
	@ echo "                                                                                                                                     "
	@ echo "  single targets                                                                                                                     "
	@ echo "    com                                                                                  elaborate design with ncverilog             "
	@ echo "    com_view                                                                             grep warn & error message during elaboration"
	@ echo "    sim               [DMP_SHM=<state>] [DMP_SHM_TIME=<time>] [DMP_SHM_LEVEL=<level>]    simulate design with ncverilog              "
	@ echo "    sim_view                                                                             view waveform genereted during simulation   "
	@ echo "    cov               [COV_TOP=<module_name>]                                            run simulation with coverage                "
	@ echo "    cov_view                                                                             view coverage report                        "
	@ echo "                                                                                                                                     "
	@ echo "  regression targets                                                                                                                 "
	@ echo "    sim_regr          [TST_DIR=<test_directory>] [TST_TAR=<test_target>]                 run regression for simulation               "
	@ echo "                      [DSP_SETTING=<state>]                                                                                          "
	@ echo "                      [STP_ON_ERR=<state>]                                                                                           "
	@ echo "                      [DMP_SHM=<state>] [DMP_SHM_TIME=<time>] [DMP_SHM_LEVEL=<level>]                                                "
	@ echo "                      [BAK_SIM=<state>]                                                                                              "
	@ echo "                      [NUM_PARAL=<number>]                                                                                           "
	@ echo "    sim_regr_view                                                                        view regression results of simulation       "
	@ echo "    cov_regr          [COV_TOP=<module_name>]                                            run regression for coverage                 "
	@ echo "                      [TST_DIR=<test_directory>] [TST_TAR=<test_target>]                                                             "
	@ echo "                      [DSP_SETTING=<state>]                                                                                          "
	@ echo "                      [NUM_PARAL=<number>]                                                                                           "
	@ echo "    cov_regr_view                                                                        view regression results of coverage         "
	@ echo "                                                                                                                                     "
	@ echo "  parameters                                                                                                                         "
	@ echo "    TST_DIR                                                                              directory of test cases                     "
	@ echo "    TST_TAR                                                                              name/pattern of the targeted test cases     "
	@ echo "    DSP_SETTING       on / off                                                           display simulation settings                 "
	@ echo "    STP_ON_ERR        global / local / off                                               stop all/cur case when encounter any error  "
	@ echo "    DMP_SHM           on / off                                                           dump waveform                               "
	@ echo "    DMP_SHM_TIME      %d                                                                 start time to dump waveform                 "
	@ echo "    DMP_SHM_LEVEL     as (all) / a (just tb)                                             dump level of waveform                      "
	@ echo "    COV_TOP                                                                              name of the module to be collected          "
	@ echo "    BAK_SIM           on / off                                                           backup simulation results                   "
	@ echo "    NUM_PARAL         %d                                                                 number of parallel running job              "




#--- SINGLE TASKS ----------------------

setup:
	@- export prjDir=$(PRJ_DIR)    # bash shell
	@- setenv prjDir $(PRJ_DIR)    # c shell

clean:
	rm -rf INCA_libs
	rm -rf *.bak*
	rm -rf *.key*
	rm -rf *.log*
	rm -rf *.rpt*
	rm -rf *.sim*
	rm -rf *.tmp*
	rm -rf *.txt*
	rm -rf *sim.*
	rm -rf *zoix*
	rm -rf __*__

cleanall:
	rm -rf INCA_libs
	rm -rf *.bak*
	rm -rf *.key*
	rm -rf *.log*
	rm -rf *.rpt*
	rm -rf *.sim*
	rm -rf *.tmp*
	rm -rf *.txt*
	rm -rf *sim.*
	rm -rf *zoix*
	rm -rf __*__
	rm -rf simul_data
	rm -rf simul_data_regr_tst
	rm -rf simul_data_regr_fti

com:
	- ncverilog +elaborate                                    \
	            +access+r                                     \
	            +nospecify                                    \
	            +nctop+$(TST_TOP)                             \
	            +define+TST_TOP=$(TST_TOP)                    \
	            +define+TST_TOP_STR=\"$(TST_TOP)\"            \
	            +define+DUT_TOP=$(DUT_TOP)                    \
	            +define+DUT_TOP_STR=\"$(DUT_TOP)\"            \
	            +define+STP_ON_ERR=\"$(STP_ON_ERR)\"          \
	            +define+DMP_SHM=\"$(DMP_SHM)\"                \
	            +define+DMP_SHM_TIME=$(DMP_SHM_TIME)          \
	            +define+DMP_SHM_LEVEL=\"$(DMP_SHM_LEVEL)\"    \
	            -f $(SRC_LST)                                 \
	            -l simul_data/nc_com_and_sim.log

com_view: clean com
	@ echo '-----------------------------------'
	@ echo '- WARNINGS                        -'
	@ echo '-----------------------------------'
	@- cat simul_data/nc_com_and_sim.log       \
	  | grep    '*W'                           \
	  | grep -v 'MACNDF'                       \
		| grep -v 'MACRDF'                       \
		| grep -v 'MRSTAR'                       \
	  | grep -v 'RECOME'
	@ echo '-----------------------------------'
	@ echo '- ERRORS                          -'
	@ echo '-----------------------------------'
	@- cat simul_data/nc_com_and_sim.log       \
	  | grep    '*E'

sim:
	@ mkdir -p simul_data
	ncverilog +access+r                                     \
	          +nospecify                                    \
	          +nctop+$(TST_TOP)                             \
	          +define+TST_TOP=$(TST_TOP)                    \
	          +define+TST_TOP_STR=\"$(TST_TOP)\"            \
	          +define+DUT_TOP=$(DUT_TOP)                    \
	          +define+DUT_TOP_STR=\"$(DUT_TOP)\"            \
	          +define+STP_ON_ERR=\"$(STP_ON_ERR)\"          \
	          +define+DMP_SHM=\"$(DMP_SHM)\"                \
	          +define+DMP_SHM_TIME=$(DMP_SHM_TIME)          \
	          +define+DMP_SHM_LEVEL=\"$(DMP_SHM_LEVEL)\"    \
	          -f $(SRC_LST)                                 \
	          -l simul_data/nc_com_and_sim.log

sim_view:
	simvision -64bit    \
	          -waves    \
	          simul_data/waveform.shm/waveform.trn &

cov:
	ncverilog +access+r                                     \
	          +nospecify                                    \
	          +nctop+$(TST_TOP)                             \
	          +define+TST_TOP=$(TST_TOP)                    \
	          +define+TST_TOP_STR=\"$(TST_TOP)\"            \
	          +define+DUT_TOP=$(DUT_TOP)                    \
	          +define+DUT_TOP_STR=\"$(DUT_TOP)\"            \
	          +define+STP_ON_ERR=\"global\"                 \
	          +define+DMP_SHM=\"off\"                       \
	          +define+DMP_SHM_TIME=$(DMP_SHM_TIME)          \
	          +define+DMP_SHM_LEVEL=\"$(DMP_SHM_LEVEL)\"    \
	          -f $(SRC_LST)                                 \
	          +nccovdut+$(COV_TOP)                          \
	          +nccoverage+all                               \
	          +nccovworkdir+simul_data                      \
	          -covoverwrite                                 \
	          -l simul_data/nc_com_and_sim.log

cov_view:
	iccr -GUI    \
	     -test "simul_data/scope/test" &




#--- REGRESSION TASKS ------------------

sim_regr: cleanall
	@ clear
	@ chmod a+x ../script/regr_tst.sh
	@ ../script/regr_tst.sh $(TST_DIR)              \
	                            $(TST_TAR)          \
	                            $(TST_TOP)          \
	                            $(DSP_SETTING)      \
	                            $(STP_ON_ERR)       \
	                            $(DMP_SHM)          \
	                            $(DMP_SHM_TIME)     \
	                            $(DMP_SHM_LEVEL)    \
	                            "off"               \
	                            $(COV_TOP)          \
	                            $(BAK_SIM)          \
	                            $(NUM_PARAL)        \
	                            | tee sim_regr.log

sim_regr_view:
	@ cat error.log

cov_regr:
	@ clear
	@ chmod a+x ../script/regr_tst.sh
	@ ../script/regr_tst.sh $(TST_DIR)              \
	                            $(TST_TAR)          \
	                            $(TST_TOP)          \
	                            $(DSP_SETTING)      \
	                            "global"            \
	                            "off"               \
	                            $(DMP_SHM_TIME)     \
	                            $(DMP_SHM_LEVEL)    \
	                            "on"                \
	                            $(COV_TOP)          \
	                            "on"                \
	                            $(NUM_PARAL)        \
	                            | tee cov_regr.log

cov_regr_view:
	@ echo 'merge simul_data_regr_tst*/*/*/* -output merged_cov' > iccr.tmp
	@ echo 'load_test simul_data_regr_tst*/*/*/merged_cov' >> iccr.tmp
	@ rm -rf simul_data_regr_tst*/*/*/merged_cov
	iccr -GUI    \
	     iccr.tmp &
