
class stimulus;

virtual sdrctrlinterface_bfm        bfm;

function new(virtual sdrctrlinterface_bfm        bfm);
    this.bfm = bfm;
    endfunction : new
    
protected function logic [31:0] get_addr();
    logic   [31:0]  Address;  
    Address = 32'd1020;//$random;
    return Address;
    endfunction : get_addr
    
protected function logic [7:0] get_bl();
    /*rand*/ logic  [7:0]   bl;  
    //constraint  cs_bl1  {bl< 8'd5};
    bl = 8'd4;//$random;
    return bl;
    endfunction : get_bl
    
    
task execute();           //Need to extend for other cases
    logic [31:0]addr;
    logic [7:0] burst_length;
    addr = get_addr();
    burst_length = get_bl();
    bfm.bl = burst_length;
    $display("address is: %x",addr);
    $display("Bl is: %x",burst_length);
    burst_write(addr,burst_length);
    $display("Finished write\n");
    burst_read(addr,burst_length);
    $display("Finished read\n");
#1000    $finish;        
endtask
    
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
         end while(bfm.wb_ack_o == 1'b0);
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
