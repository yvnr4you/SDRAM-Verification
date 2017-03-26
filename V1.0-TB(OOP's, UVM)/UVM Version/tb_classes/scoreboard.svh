/******************************************************/
// Title 		: stimulus_values.svh
// Project Name : SDRAM Controller with wishbone Validation
// Author		: Karthik Rudraraju
//				  Manasa Gurrala
//				  Naveen Yalla
// Description	: It contains the checker which checkes the obtained output with the expected
//				  output. It uses queues for its fuctionality. 
/******************************************************/
class scoreboard extends uvm_component;;
`uvm_component_utils(scoreboard)

virtual sdrctrlinterface_bfm        bfm;

function new (string name, uvm_component parent);
      super.new(name, parent);
   endfunction : new
    
function void build_phase(uvm_phase phase);
		if(!uvm_config_db #(virtual sdrctrlinterface_bfm) :: get(null,"*","bfm",bfm) )
			$fatal("Failed to get BFM");
	endfunction : build_phase

task run_phase(uvm_phase phase);
    logic   [31:0]      exp_result;
    logic   [7:0]       bl;
    logic   [31:0]      Address;

    logic [7:0] bl_assoc [int];
    logic [31:0] data_assoc[int];
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

endtask : run_phase


endclass : scoreboard
