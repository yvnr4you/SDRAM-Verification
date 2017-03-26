#MakeFile
#Authors: Venkata Naveen Reddy Yalla
#       : Manasa Gurrala
#       : Karthik Rudraraju

all:clean setup compile simtest

setup:
	vlib work
	vmap work work

compile:
	vlog +define+S50=1 +cover=f  -fsmimplicittrans +incdir+./src ./opencores/verif/model/IS42VM16400K.v
	vlog +cover=f  -fsmimplicittrans +incdir+./src ./opencores/verif/model/mt48lc2m32b2.v
	vlog +cover=f  -fsmimplicittrans +incdir+./src ./opencores/verif/model/mt48lc4m16.v
	vlog +cover=f  -fsmimplicittrans +incdir+./src ./opencores/verif/model/mt48lc4m32b2.v
	vlog +cover=f  -fsmimplicittrans +incdir+./src ./opencores/verif/model/mt48lc8m8a2.v
	vlog +cover=f  -fsmimplicittrans +incdir+./src ./opencores/verif/model/mt48lc8m16a2.v
	vlog +cover=f  -fsmimplicittrans +incdir+./src ./opencores/verif/tb/tb_core.sv
	vlog +cover=f  -fsmimplicittrans +incdir+./src ./opencores/verif/tb/tb_top.sv
	vlog +cover=f  -fsmimplicittrans +incdir+./src ./opencores/rtl/wb2sdrc/wb2sdrc.v
	vlog +cover=f  -fsmimplicittrans +incdir+./src ./opencores/rtl/lib/async_fifo.v
	vlog +cover=f  -fsmimplicittrans +incdir+./src ./opencores/rtl/lib/sync_fifo.v
	vlog +cover=f  -fsmimplicittrans +incdir+./src ./opencores/rtl/top/sdrc_top.v
	vlog +cover=f  -fsmimplicittrans +incdir+./src ./opencores/rtl/core/sdrc_bank_ctl.v
	vlog +cover=f  -fsmimplicittrans +incdir+./src ./opencores/rtl/core/sdrc_bank_fsm.v
	vlog +cover=f  -fsmimplicittrans +incdir+./src ./opencores/rtl/core/sdrc_bs_convert.v
	vlog +cover=f  -fsmimplicittrans +incdir+./src ./opencores/rtl/core/sdrc_core.v
	vlog +cover=f  -fsmimplicittrans +incdir+./src ./opencores/rtl/core/sdrc_define.v
	vlog +cover=f  -fsmimplicittrans +incdir+./src ./opencores/rtl/core/sdrc_req_gen.v
	vlog +cover=f  -fsmimplicittrans +incdir+./src ./opencores/rtl/core/sdrc_xfr_ctl.v
	vlog +cover=f  -fsmimplicittrans +incdir+./src ./classes/stimulus.svh
	vlog +cover=f  -fsmimplicittrans +incdir+./src ./classes/scoreboard.svh
	vlog +cover=f  -fsmimplicittrans +incdir+./src ./classes/coverage.svh
	vlog +cover=f  -fsmimplicittrans +incdir+./src ./package.sv
	vlog +cover=f  -fsmimplicittrans +incdir+./src ./bfms/sdrctrl_bfm.sv
	vlog +cover=f  -fsmimplicittrans +incdir+./src ./bfms/cov_intf.sv
	vlog +cover=f  -fsmimplicittrans +incdir+./src ./classes/testbench.svh
	vlog +cover=f  -fsmimplicittrans +incdir+./src ./my_top.sv

simtest:
	vopt +acc my_top -o my_top_opt
#For Simulation with coverage use this else use the next line
#	vsim tb_top_opt
#To simulate with coverage uncomment the following line
	vsim -fsmdebug -coverage my_top_opt

clean:
	rm -rf work transcript *~ vsim.wlf *.log dgs.dbg dmslogdir

