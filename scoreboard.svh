
class scoreboard;

virtual sdrctrlinterface_bfm        bfm;

function new(virtual sdrctrlinterface_bfm        bfm);
    this.bfm = bfm;
    endfunction : new
    
task execute();
    logic   [31:0]      exp_result;
    logic   [7:0]       bl;
    logic   [31:0]      Address;
    /*forever begin
        bl      = bfm.bfifo.pop_front();
	
        for (int i =0; i<bl; i++) begin
	wait (bfm.wb_ack_o == 1'b1)
        Address     = bfm.afifo.pop_front();  
        exp_result  = bfm.dfifo.pop_front();
        
        if(exp_result !== bfm.wb_dat_o)
                $display("Wrong data");
        else begin
                $display("Data Read correct");
		$display("Address: %x, Data: %x", Address,bfm.wb_dat_o);
        end
        @(negedge bfm.sdram_clk);
        end
    end*/
endtask


endclass : scoreboard
