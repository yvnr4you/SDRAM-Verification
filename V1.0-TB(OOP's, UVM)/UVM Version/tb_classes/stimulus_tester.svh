/******************************************************/
// Title 		: stimulus_values.svh
// Project Name : SDRAM Controller with wishbone Validation
// Author		: Karthik Rudraraju
//				  Manasa Gurrala
//				  Naveen Yalla
// Description	: This class is the stimulus to the validation design. The values are
//				  extracted from the class stimulus_values class and based on the protocol the 
//				  test cases are provided to run it on the DUT.
/******************************************************/

virtual class stimulus_tester extends uvm_component;
`uvm_component_utils(stimulus_tester)
	parameter integer NO_OF_TESTS =50;
	int addr_array[$];
	randc int number;
	randc bit case_var;

	virtual sdrctrlinterface_bfm   bfm;
	
	function new (string name, uvm_component parent);
		super.new(name,parent);
	endfunction: new	
	
	function void build_phase(uvm_phase phase);
		if(!uvm_config_db #(virtual sdrctrlinterface_bfm) :: get(null,"*","bfm",bfm) )
			$fatal("Failed to get BFM");
	endfunction : build_phase

	pure virtual function logic [31:0] get_addr();
    pure virtual function logic [7:0] get_bl();
    
	
	task run_phase  (uvm_phase phase);
	    
	logic [31:0]addr;
    logic [7:0] burst_length;
	 
	 phase.raise_objection(this);
	 bfm.initialization();
     wait(bfm.sdr_init_done == 1'b1);
    
    
	
	repeat (NO_OF_TESTS) begin
	addr = get_addr();
    burst_length = get_bl();
    bfm.bl = burst_length; 
	//$display("entered repeat:\n\n");
	case_var = $urandom_range(0,1);
	//$display("Generated value: %d\n\n",case_var);
	
	case(case_var)
	1'b0: begin
		    burst_write(addr,burst_length);
		    $display("Write Operation Performed with burst length:%d",burst_length);
		    addr = get_addr();
	            burst_length = get_bl();
	      end
	1'b1: begin
		    $display("Read operation initiated with burst length:%d",burst_length);
		    number = $urandom_range(0,addr_array.size());
		    addr = addr_array[number];
		    burst_read({addr,2'b00},burst_length);
		    burst_length = get_bl();
	      end

	endcase
	
end
	phase.drop_objection(this);
endtask : run_phase

task burst_write;
input   logic   [31:0]  Address;
input   logic   [7:0]   bl;
begin
   
   @ (negedge bfm.sys_clk);
   for(int i=0; i < bl; i++) begin 
      bfm.write_done      = '0;
      bfm.wb_stb_i        = 1;
      bfm.wb_cyc_i        = 1;
      bfm.wb_we_i         = 1;
      bfm.wb_sel_i        = 4'b1111;
      bfm.wb_addr_i       = Address[31:2]+i;
      bfm.wb_dat_i        = $random & 32'hFFFFFFFF;
      addr_array.push_back(bfm.wb_addr_i);
      $display("address arry is: %p,index:%d",addr_array,i);
      do begin
          @ (posedge bfm.sys_clk);
      end while(bfm.wb_ack_o == 1'b0);
          @ (negedge bfm.sys_clk);
   end
   bfm.write_done      = '1;
   bfm.wb_stb_i        = 0;
   bfm.wb_cyc_i        = 0;
   bfm.wb_we_i         = 'hx;
   bfm.wb_sel_i        = 'hx;
   bfm.wb_addr_i       = 'hx;
   bfm.wb_dat_i        = 'hx;
end
endtask : burst_write

task burst_read;
//declare below signals as inputs for randomization
input logic   [31:0]  Address;    
input logic   [7:0]   bl;
                                            
begin
  /*                    //we need to write the code for random read
  Address = get_addr();
  bl = get_bl();
  */
  // Address = bfm.afifo[0];      //.pop_front(); 
  // bl      = bfm.bfifo[0];      //.pop_front(); 
   @ (negedge bfm.sys_clk);
	bfm.read_init = 1'b1;
      for(int j=0; j < bl; j++) begin
         bfm.wb_stb_i        = 1;
         bfm.wb_cyc_i        = 1;
         bfm.wb_we_i         = 0;
         bfm.wb_addr_i       = Address[31:2]+j;
         do begin
             @ (posedge bfm.sys_clk);
         end while(bfm.wb_ack_o == 1'b0 && bfm.FLAG == 1'b0);
        $display("Read succesfull: Address: %h, Data: %h",bfm.wb_addr_i,bfm.wb_dat_o);
         @ (negedge bfm.sdram_clk);
      end
   bfm.read_init       = 0;
   bfm.wb_stb_i        = 0;
   bfm.wb_cyc_i        = 0;
   bfm.wb_we_i         = 'hx;
   bfm.wb_addr_i       = 'hx;
end
endtask : burst_read

endclass : stimulus_tester
