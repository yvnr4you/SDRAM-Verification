/******************************************************/
// Title 		: stimulus_values.svh
// Project Name : SDRAM Controller with wishbone Validation
// Author		: Karthik Rudraraju
//				  Manasa Gurrala
//				  Naveen Yalla
// Description	: This creates the environment for the test. It invokes all the classes required
// 				  It has the stimulus class sending the commands and test cases to be tested to 
//				  the DUT. Coverage and scoreboard are monitors working in DUV to meet its own fuctionality.  
/******************************************************/
class env extends uvm_env;
   `uvm_component_utils(env);

   stimulus_tester   tester_h;
   coverage      coverage_h;
   scoreboard    scoreboard_h;

   function void build_phase(uvm_phase phase);
      tester_h     = stimulus_tester::type_id::create("tester_h",this);
      coverage_h   = coverage::type_id::create ("coverage_h",this);
      scoreboard_h = scoreboard::type_id::create("scoreboard_h",this);
   endfunction : build_phase

   function new (string name, uvm_component parent);
      super.new(name,parent);
   endfunction : new

endclass
   
   
   