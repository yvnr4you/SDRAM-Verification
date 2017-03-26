if [file exists "work"] {vdel -all}
vlib work

vlog -f ./dut.f

vlog -f ./tb.f

vopt my_top -o top_optimized  +acc +cover=sbfec+sdrc_top(rtl).
vsim top_optimized -coverage +UVM_TESTNAME=test 
run -all