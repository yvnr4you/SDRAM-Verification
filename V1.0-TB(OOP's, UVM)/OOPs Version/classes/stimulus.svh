/////////////////////////////////////////////////////////////////
////        This is the stimulus class on test bench side.   ////
////                                                         ////
////                                                         ////
////     Created By: Manasa Gurrala                          ////
////                 Venkata Naveen Reddy Yalla              ////
////                 Karthik Rudraraju                       ////
////                                                         ////
/////////////////////////////////////////////////////////////////

class stimulus;

parameter NO_OF_TESTS = 50;

virtual sdrctrlinterface_bfm        bfm;

int wno = 2,rno = 2;
int addr_array[$];

randc int number;
randc bit case_var;


//new constructor function.
function new(virtual sdrctrlinterface_bfm        bfm);
    this.bfm = bfm;
    endfunction : new
    
    
//function to generate random address.
protected function logic [31:0] get_addr();
    logic   [31:0]  Address;  
    Address =$urandom_range(0,2**32-1);
    return Address;
    endfunction : get_addr
    
    
//function to generate random burst length.
protected function logic [7:0] get_bl();
    logic  [7:0]   bl;  
    bl = $urandom_range(0,2**8-1);
    return bl;
    endfunction : get_bl
    
    
task execute();           //Need to extend for other cases
    logic [31:0]    addr;
    logic [7:0]     burst_length;
    
    addr            = get_addr();
    burst_length    = get_bl();
    bfm.bl          = burst_length; 
    
    repeat (NO_OF_TESTS) 
        begin
            case_var = $urandom_range(0,1);
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
            //	default: continue;
            endcase
        end
#1000    $finish;        
endtask
    
    
//write task    
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
          addr_array.push_back(bfm.wb_addr_i);  //storing the address to perform future read operations.
        //  $display("address arry is: %p,index:%d",addr_array,i);
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
endtask


//read task
task burst_read;
input logic   [31:0]  Address;    
input logic   [7:0]   bl;
                                            
begin
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
            //  $display("Read succesfull: Address: %h, Data: %h",bfm.wb_addr_i,bfm.wb_dat_o);
         @ (negedge bfm.sdram_clk);
      end
      
   bfm.read_init       = 0;
   bfm.wb_stb_i        = 0;
   bfm.wb_cyc_i        = 0;
   bfm.wb_we_i         = 'hx;
   bfm.wb_addr_i       = 'hx;
end
endtask

endclass : stimulus
