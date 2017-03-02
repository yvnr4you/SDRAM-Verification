
class stimulus;

virtual sdrctrlinterface_bfm        bfm;

function new(virtual sdrctrlinterface_bfm        bfm);
    this.bfm = bfm;
    endfunction : new
    
protected function logic [31:0] get_addr();
    logic   [31:0]  Address;  
    Address = 32'd32;//$random;
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
    $display("address is: %x",addr);
    $display("Bl is: %x",burst_length);
    burst_write(addr,burst_length);
    burst_read(addr,burst_length);
   // burst_read();
    $display("Finished read and write");
#100    $finish;        
endtask
    
task burst_write;
input   logic   [31:0]  Address;
input   logic   [7:0]   bl;
begin
 // bfm.afifo.push_back(Address);
 // bfm.bfifo.push_back(bl);

   @ (negedge bfm.sys_clk);
   for(int i=0; i < bl; i++) begin
      bfm.wb_stb_i        = 1;
      bfm.wb_cyc_i        = 1;
      bfm.wb_we_i         = 1;
      bfm.wb_sel_i        = 4'b1111;
      bfm.wb_addr_i       = Address[31:2]+i;
      bfm.wb_dat_i        = $random & 32'hFFFFFFFF;
     // bfm.dfifo.push_back(bfm.wb_dat_i);
      $display("Write Address: %x, Data: %x",bfm.wb_addr_i,bfm.wb_dat_i);	
     // $display("address fifo: %p",bfm.afifo);
      //$display("bl fifo:%p",bfm.bfifo);
      //$display("data fifo:%p",bfm.dfifo);
      do begin
          @ (posedge bfm.sys_clk);
      end while(bfm.wb_ack_o == 1'b0);
          @ (negedge bfm.sys_clk);
   
       //$display("Status: Burst-No: %d  Write Address: %x  WriteData: %x ",i,bfm.wb_addr_i,bfm.wb_dat_i);
   end
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

      for(int j=0; j < bl; j++) begin
         bfm.wb_stb_i        = 1;
         bfm.wb_cyc_i        = 1;
         bfm.wb_we_i         = 0;
         bfm.wb_addr_i       = Address[31:2]+j;

         do begin
             @ (posedge bfm.sys_clk);
         end while(bfm.wb_ack_o == 1'b0);
        $display("Read succesfull: Address: %h, Data: %h",bfm.wb_addr_i,bfm.wb_dat_o);
         @ (negedge bfm.sdram_clk);
      end
   bfm.wb_stb_i        = 0;
   bfm.wb_cyc_i        = 0;
   bfm.wb_we_i         = 'hx;
   bfm.wb_addr_i       = 'hx;
end
endtask

endclass : stimulus
