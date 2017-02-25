#MakeFile
#Author: Venkata Naveen Reddy Yalla
#Author: Manasa Reddy Gurrala
#Author: Karthik Varma

all:clean setup compile bigtest

setup:
	vlib work
	vmap work work

compile:
	vlog +cover=f  -fsmimplicittrans +incdir+./src ./trunk/verif/model/IS42VM16400K.v
	vlog +cover=f  -fsmimplicittrans +incdir+./src ./trunk/verif/model/mt48lc2m32b2.v
	vlog +cover=f  -fsmimplicittrans +incdir+./src ./trunk/verif/model/mt48lc4m16.v
	vlog +cover=f  -fsmimplicittrans +incdir+./src ./trunk/verif/model/mt48lc4m32b2.v
	vlog +cover=f  -fsmimplicittrans +incdir+./src ./trunk/verif/model/mt48lc8m8a2.v
	vlog +cover=f  -fsmimplicittrans +incdir+./src ./trunk/verif/model/mt48lc8m16a2.v
	vlog +cover=f  -fsmimplicittrans +incdir+./src ./trunk/verif/tb/tb_core.sv
	vlog +cover=f  -fsmimplicittrans +incdir+./src ./trunk/verif/tb/tb_top.sv
	vlog +cover=f  -fsmimplicittrans +incdir+./src ./trunk/rtl/wb2sdrc/wb2sdrc.v
	vlog +cover=f  -fsmimplicittrans +incdir+./src ./trunk/rtl/lib/async_fifo.v
	vlog +cover=f  -fsmimplicittrans +incdir+./src ./trunk/rtl/lib/sync_fifo.v
	vlog +cover=f  -fsmimplicittrans +incdir+./src ./trunk/rtl/top/sdrc_top.v
	vlog +cover=f  -fsmimplicittrans +incdir+./src ./trunk/rtl/core/sdrc_bank_ctl.v
	vlog +cover=f  -fsmimplicittrans +incdir+./src ./trunk/rtl/core/sdrc_bank_fsm.v
	vlog +cover=f  -fsmimplicittrans +incdir+./src ./trunk/rtl/core/sdrc_bs_convert.v
	vlog +cover=f  -fsmimplicittrans +incdir+./src ./trunk/rtl/core/sdrc_core.v
	vlog +cover=f  -fsmimplicittrans +incdir+./src ./trunk/rtl/core/sdrc_define.v
	vlog +cover=f  -fsmimplicittrans +incdir+./src ./trunk/rtl/core/sdrc_req_gen.v
	vlog +cover=f  -fsmimplicittrans +incdir+./src ./trunk/rtl/core/sdrc_xfr_ctl.v
bigtest:
	vopt -debugdb +acc tb_top -o tb_top_opt
#For Simulation with coverage use this else use the next line
#	vsim tb_top_opt
#To simulate with coverage uncomment the following line
	vsim -fsmdebug -debugDB -coverage tb_top

clean:
	rm -rf work transcript *~ vsim.wlf *.log dgs.dbg dmslogdir

