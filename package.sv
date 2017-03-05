package sdrctrl_package;

parameter       P_SYS   = 10;     //    200MHz
parameter       P_SDR   = 20;     //    100MHz

parameter       aw      = 26;  // address wdith
parameter       dw      = 32;  // data width
parameter       tw      = 8;   // tag id width
parameter       bl      = 5;   // burst_lenght_width 


//`include "coverage.svh"
`include "stimulus.svh"
`include "scoreboard.svh"
`include "testbench.svh"
endpackage : sdrctrl_package
