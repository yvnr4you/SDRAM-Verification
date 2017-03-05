
class scoreboard;

virtual sdrctrlinterface_bfm        bfm;

function new(virtual sdrctrlinterface_bfm        bfm);
    this.bfm = bfm;
    endfunction : new
    
task execute();
    logic   [31:0]      exp_result;
    logic   [7:0]       bl;
    logic   [31:0]      Address;

    logic [7:0] bl_assoc [int];
    logic [31:0] data_assoc[int];
 static    int i=0;


forever begin
    if (bfm.read_init==1'b1) begin
//	$monitor("bfm.read_init:%b entered  read,time",bfm.read_init,$time);
	repeat(bfm.bl)begin
		wait(bfm.wb_ack_o == 1'b1)		//Wait for the acknowledge from sdram and find the expected result
		exp_result = data_assoc[bfm.wb_addr_i];
                @(posedge bfm.sdram_clk);	//Check the results at sdram clock rate
		if (exp_result === bfm.wb_dat_o)
		   $display("Read succesfull Addr:%x,Obtained data:%x, time:",bfm.wb_addr_i, exp_result, $time);
		else
		   $display("Read not succesfull Addr:%x,expected data:%x,obtained data:%x, Time: ",bfm.wb_addr_i, exp_result, $time);
		@(posedge bfm.sdram_clk); //Wait until the acknowledge turns off
	end
    end
    else begin
	wait(bfm.wb_ack_o == 1)
	while(bfm.write_done == 1'b0)begin 
		@(posedge bfm.sys_clk)begin data_assoc[bfm.wb_addr_i] = bfm.wb_dat_i;
		if(bfm.write_done == 1'b1 && bfm.sdram_clk == 1'b1)
		break;end
	$display("array %p",data_assoc,$time);	
	end 
    end
end

endtask


endclass : scoreboard
