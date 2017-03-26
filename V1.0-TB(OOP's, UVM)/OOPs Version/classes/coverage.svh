/////////////////////////////////////////////////////////////////
////        This is the Coverage class on test bench side.   ////
////                                                         ////
////                                                         ////
////     Created By: Manasa Gurrala                          ////
////                 Venkata Naveen Reddy Yalla              ////
////                 Karthik Rudraraju                       ////
////                                                         ////
/////////////////////////////////////////////////////////////////

class coverage;

virtual sdrctrlinterface_bfm        bfm;
virtual cov_intf                    cov_bfm;

typedef enum  logic [1:0] {bank0 = 2'b00 ,bank1 = 2'b01,bank2 = 2'b10,bank3 = 2'b11,unknown = 2'bxx} bank_type;
typedef enum  logic    {write = 1'h1, read= 1'h0, nop = 1'hx} rw_type;

bank_type bank_num;
rw_type read_write_cov;

reg [1:0] bA;

covergroup addr_cov();

    //row address cover point
    row_cov: coverpoint bfm.wb_addr_i[25:10] {
		bins l_row = {['h000 : 'h555]};
		bins m_row = {['h556 : 'hAAA]};
		bins h_row = {['hAAB : 'hFFF]};
	}

    //column address cover point
    col_cov: coverpoint bfm.wb_addr_i[7:0] {
		bins l_col = {['h00 : 'h55]};
		bins m_col = {['h56 : 'hAA]};
		bins h_col = {['hAB : 'hFF]};
	}

    //banks cover point
    bank_cov: coverpoint bfm.wb_addr_i [9:8] {
		bins ba0 = {'h0};
		bins ba1 = {'h1};
		bins ba2 = {'h2};
		bins ba3 = {'h3};
	}

    //total memory space cover point
    tot_addr_cov: cross row_cov, col_cov, bank_cov {
			//all row bank column combinations coverage
/*
        //to check for individual banks vary the bank variable.
		bins bank0 = binsof (row_cov) && binsof (col_cov) && binsof (bank_cov.ba0);
		bins bank1 = binsof (row_cov) && binsof (col_cov) && binsof (bank_cov.ba1);
		bins bank2 = binsof (row_cov) && binsof (col_cov) && binsof (bank_cov.ba2);
		bins bank3 = binsof (row_cov) && binsof (col_cov) && binsof (bank_cov.ba3);
		ignore_bins others = binsof (bank_cov.ba1) || binsof (bank_cov.ba0) || binsof (bank_cov.ba3);*/ 
	}


    //transition from one bank to other bank cover point.
    bank_trans: coverpoint bank_num {
		
		bins bank0_1 = (bank0 => bank1);
		bins bank1_2 = (bank1 => bank2);
		bins bank2_3 = (bank2 => bank3);
		bins bank3_0 = (bank3 => bank0);	
	}

    
    //read write transitions.
    read_write_trans:   coverpoint read_write_cov {
		bins r_to_r = (read => read);           //read after read
		bins r_to_w = (read => nop => write);   //write after read
		bins r_to_x = (read => nop);            //NOP after read
		bins w_to_w = (write => write);         //write after write
		bins w_to_r = (write => nop => read);   //read after write
		bins w_to_x = (write => nop);           //NOP after write
		bins x_to_r = (nop => read);            //Read after NOP
		bins x_to_w = (nop => write);           //Write after NOP
		//bins x_to_x = (nop => nop);             //NOP to NOP
		}

    //Coverpoints on reset signal
    rst_trans:  coverpoint bfm.RESETN {
		bins rst = {'h0};
		bins not_rst = {'h1};
		}

    //ignoring read write transitions when reset enabled.
    rw_full_trans : cross read_write_trans, rst_trans {
		ignore_bins others_only = binsof (read_write_trans) && binsof (rst_trans.rst) ;
		}
        

endgroup


covergroup fsm_cov();           //FSM's cover group

//request generator FSM coverage
req_st_trans: coverpoint cov_bfm.req_st {

        bins st1 = {2'h0};
        bins st2 = {2'h1};
        bins st3 = {2'h2};
      }

//transfer control FSM coverage
xfrfsm_trans: coverpoint cov_bfm.xfr_st {

        bins st1 = {2'h0};
        bins st2 = {2'h1};
        bins st3 = {2'h2};
        bins st4 = {2'h3};
      }
            
    req_xfr_cross: cross   req_st_trans, xfrfsm_trans {}    //Cross coverage between FSM's
endgroup


function new(virtual cov_intf    cov_bfm, virtual sdrctrlinterface_bfm        bfm);
     this.cov_bfm = cov_bfm;
     this.bfm = bfm;
     addr_cov = new();
     fsm_cov  = new();  /*$root.my_top.u_dut.u_sdrc_core.u_req_gen.req_st*/   //$root is not working so using one more interface for temporary
   
    endfunction : new


task execute;
forever begin @(posedge bfm.sys_clk)
	$cast(read_write_cov, bfm.wb_we_i);             //getting read write signal
  //  $display("Values in coverage: %b",bfm.wb_addr_i[9:8]);
    bA = bfm.wb_addr_i [9:8];
	$cast(bank_num, bA);   //getting the bank address

   	addr_cov.sample();
    fsm_cov.sample();
	end

endtask : execute

endclass : coverage




/*
//////////////////////////////////////////////////////////////
//////                  Future work                     //////
//////////////////////////////////////////////////////////////
covergroup read_write;

    r_cov: coverpoint read_cov {
		bins zeros = {'h0};
		bins ones  = {'h1};
		//bins others= {'hx};
	}

    w_cov: coverpoint write_cov {
		bins zeros = {'h0};
		bins ones  = {'h1};
		//bins others= {'hx};
	}

    o_cov: coverpoint NOP_cov {
		bins others = {'hx};
	}
    
    ovf_cov: coverpoint overflow_cov {
		bins zeros = {'h0};
		bins ones  = {'h1};
	}

    rw_cov: cross r_cov, w_cov {
		//cross coverage between read and write
		//all combinations starting from read task to other.
		bins r_to_x = r_cov.zeros => //r/o_cov.others;
		bins r_to_r = r_cov.zeros => r_cov.zeros;
		bins r_to_w = r_cov.zeros => r_cov.ones;

		//all combinations starting from write task to other.
		bins w_to_x = w_cov.ones => //w/o_cov.others;
		bins w_to_r = w_cov.ones => w_cov.zeros;
		bins w_to_w = w_cov.ones => w_cov.ones;

		//all combinations starting from other task to other.
		bins o_to_w = o_cov.others => w_cov.ones;
		bins o_to_r = o_cov.others => r_cov.zeros;
		bins o_to_x = o_cov.others => o_cov.others;


	}


    rw_ovf_cov: cross r_cov, w_cov, ovf_cov {
		bins r_ovf0 = binsof (r_cov.zeros) intersect binsof (ovf_cov.zeros); //read with no page overflow
		bins r_ovf1 = binsof (r_cov.zeros) intersect binsof (ovf_cov.ones); //read with page overflow
		bins w_ovf0 = binsof (w_cov.ones) intersect binsof (ovf_cov.zeros); //write with no page overflow
		bins w_ovf1 = binsof (w_cov.ones) intersect binsof (ovf_cov.ones); //write with page overflow
	}

endgroup

*/
