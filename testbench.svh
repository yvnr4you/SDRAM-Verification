import sdrctrl_package::*;

class testbench;
virtual sdrctrlinterface_bfm        bfm;

stimulus    stimulus_h;
scoreboard  scoreboard_h;
//coverage    coverage_h;

function new(virtual sdrctrlinterface_bfm        bfm);
    this.bfm = bfm;
    endfunction : new

task execute();
    
    stimulus_h      = new(bfm);
    scoreboard_h    = new(bfm);
    //coverage_h      = new(bfm);
    
    fork
        stimulus_h.execute();
        scoreboard_h.execute();
    join_none
    
endtask: execute

endclass: testbench
