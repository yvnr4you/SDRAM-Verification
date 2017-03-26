/////////////////////////////////////////////////////////////////

////      This is the readme file for the project            ////

////                                                         ////

////                                                         ////

////    Created  By: Manasa Gurrala                          ////

////                 Venkata Naveen Reddy Yalla              ////

////                 Karthik Rudraraju                       ////

////                                                         ////

/////////////////////////////////////////////////////////////////


The folder organization is as follows:

ECE593_Final_Project.zip
	|
	|---- README.txt
	|
	|---- Project Report.pdf
	|	- It contains our project description, Strategy, Results.
	|
	|---- Verification plan.pdf
	|	- It contains our project verification plan and schedule.
	|
	|---- SDRAM_Controller
	|	|
	|	|
	|	|---- OOPs Version
	|	|	|
	|	|	|---- bfms
	|	|	|	|
	|	|	|	|---- cov_intf.sv
	|	|	|	|
	|	|	|	|---- sdrctrl_bfm.sv
	|	|	|
	|	|	|---- classes
	|	|	|	|
	|	|	|	|---- coverage.svh
	|	|	|	|
	|	|	|	|---- scoreboard.svh
	|	|	|	|
	|	|	|	|---- stimulus.svh
	|	|	|	|
	|	|	|	|---- testbench.svh
	|	|	|
	|	|	|---- opencores files
	|	|	|
	|	|	|---- Makefile
	|	|	|
	|	|	|---- my_top.sv
	|	|	|
	|	|	|---- package.sv
	|	|	|
	|	|	|---- reports
	|	|	
	|	|
	|	|
	|	|---- UVM Version
	|	|	|
	|	|	|---- run.do
	|	|	|
	|	|	|---- my_top.sv
	|	|	|
	|	|	|---- package.sv
	|	|	|
	|	|	|---- tb.f
	|	|	|
	|	|	|---- dut.f
	|	|	|
	|	|	|---- bfms
	|	|	|	|
	|	|	|	|---- cov_intf.sv
	|	|	|	|
	|	|	|	|---- sdrctrl_bfm.sv
	|	|	|
	|	|	|---- TB_classes files
	|	|	|
	|	|	|---- sdr_ctrl_dut
	|	|	|
	|	|	|---- reports
	|	|	|
	|	|	|
	|	|	|
	|	|	
	|	|	
	|	
	


Compilation/Simulation instructions on Linux machine:

For OOPs Version
1) open terminal and move to the respective directory.
2) type "make" command
3) add required signals to the wave.
4) run all
5) check transcript and waveform.


For UVM Version
1) open terminal and move to the respective directory.
2) type "vsim" command
3) after the GUI appears type "do run.do" in the transcript window.
4) check transcript and waveform.