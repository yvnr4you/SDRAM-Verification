/******************************************************/
// Title 		: stimulus_values.svh
// Project Name : SDRAM Controller with wishbone Validation
// Author		: Karthik Rudraraju
//				  Manasa Gurrala
//				  Naveen Yalla
// Description	: This class is the generation of the values required for the stimulus_tester
//				  class. The address and burst length are randomly generated using the random function.
//				  This is UVM based. 
/******************************************************/
class stimulus_values extends stimulus_tester;
`uvm_component_utils(stimulus_values)


	function logic [31:0] get_addr();
    logic   [31:0]  Address;  
    Address =$urandom_range(0,2**32-1);
    return Address;
    endfunction : get_addr
	
	function logic [7:0] get_bl();
    logic  [7:0]   bl;  
    bl = $urandom_range(0,2**8-1);
    return bl;
    endfunction : get_bl
	
   function new (string name, uvm_component parent);
      super.new(name, parent);
   endfunction : new	
   
endclass : stimulus_values   