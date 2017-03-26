/******************************************************/
// Title 		: test.svh
// Project Name : SDRAM Controller with wishbone Validation
// Author		: Karthik Rudraraju
//				  Manasa Gurrala
//				  Naveen Yalla
// Description	: This is the top class to test required functionalities in the design
//				  This class is invoked using the UVM_TESTNAME in run.do. Based on the 
//				  test required the stimulus tester is overwritten in this class and calls
//				  the UVM environment class. 
/******************************************************/
class test extends uvm_test;
	`uvm_component_utils(test)
	
	env env_h;
	
	function void build_phase(uvm_phase phase);
	  stimulus_tester::type_id::set_type_override(stimulus_values::get_type());
	  env_h     = env::type_id::create("env_h",this);
	 endfunction :build_phase
	 
	function new (string name, uvm_component parent);
      super.new(name,parent);
   endfunction : new
   
	 
  endclass