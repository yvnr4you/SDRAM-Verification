/////////////////////////////////////////////////////////////////
////        This is the testbench class on test bench side.  ////
////                                                         ////
////                                                         ////
////     Created By: Manasa Gurrala                          ////
////                 Venkata Naveen Reddy Yalla              ////
////                 Karthik Rudraraju                       ////
////                                                         ////
/////////////////////////////////////////////////////////////////



import sdrctrl_package::*;
//`include "coverage.svh"
class testbench;

virtual sdrctrlinterface_bfm        bfm;
virtual cov_intf                    cov_bfm;

stimulus     stimulus_h;
scoreboard   scoreboard_h;
coverage     coverage_h;

function new(virtual cov_intf    cov_bfm, virtual sdrctrlinterface_bfm        bfm);
    this.bfm = bfm;
    this.cov_bfm = cov_bfm;
    endfunction : new

task execute();
    
    stimulus_h      = new(bfm);
    scoreboard_h    = new(bfm);
    coverage_h      = new(cov_bfm, bfm);
    
    fork
        stimulus_h.execute();
        scoreboard_h.execute();
        coverage_h.execute();
    join_none
    
endtask: execute

endclass: testbench
