/////////////////////////////////////////////////////////////////
////        This is the Scoreboard class on test bench side. ////
////                                                         ////
////                                                         ////
////     Created By: Manasa Gurrala                          ////
////                 Venkata Naveen Reddy Yalla              ////
////                 Karthik Rudraraju                       ////
////                                                         ////
/////////////////////////////////////////////////////////////////

class scoreboard;

virtual sdrctrlinterface_bfm        bfm;

function new(virtual sdrctrlinterface_bfm        bfm);
    this.bfm = bfm;
    endfunction : new
    
task execute();
    logic   [31:0]      exp_result;
    logic   [7:0]       bl;
    logic   [31:0]      Address;

    logic   [31:0]      data_assoc[int];    //associative array for storing data.
 
    static    int i=0;

forever begin
	if(bfm.FLAG == 1) begin
		bfm.FLAG = 0;
	end
	else if (bfm.read_init==1'b1) begin
        repeat(bfm.bl)begin
            if(data_assoc.exists(bfm.wb_addr_i)) begin
                wait(bfm.wb_ack_o == 1'b1);		    //Wait for the acknowledge from sdram and find the expected result
                exp_result = data_assoc[bfm.wb_addr_i];
                @(posedge bfm.sdram_clk);	        //Check the results at sdram clock rate
                if (exp_result === bfm.wb_dat_o)
                    $display("Read succesfull Addr:%x,Obtained data:%x, time:",bfm.wb_addr_i, exp_result, $time);
                else begin                
                    $display("Read not succesfull Addr:%x,expected data:%x,obtained data:%x, Time: ",bfm.wb_addr_i, exp_result, $time);
                    @(posedge bfm.sdram_clk);       //Wait until the acknowledge turns off
                end
            end
            else begin 
                $display("Error::Should Perform a write before reading from this address. This address has unkonown value:%d",bfm.wb_addr_i);
                    bfm.FLAG = 1;
                    @(posedge bfm.sys_clk);
                    @(posedge bfm.sys_clk);	
                    break;	
            end
        end
    end
    
    else begin
        wait(bfm.wb_ack_o == 1)
        while(bfm.write_done == 1'b0)
            begin 
                @(posedge bfm.sys_clk)
                begin data_assoc[bfm.wb_addr_i] = bfm.wb_dat_i;
                if(bfm.write_done == 1'b1 && bfm.sdram_clk == 1'b1)
                    break;
                end
            end 
    end
end

endtask


endclass : scoreboard
