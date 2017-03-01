
`timescale 1ns/1ps

interface sdrctrlinterface_bfm;
import  sdrctrl_package::*;


//----------------------------------------------------------
//      RESET & CLK SIGNALS
//----------------------------------------------------------
    logic               RESETN;
    logic               sdram_clk;
    logic               sys_clk;  
//**********************************************************


//----------------------------------------------------------
//      Wish Bone Interface
// ---------------------------------------------------------
    logic               wb_stb_i           ;
    logic               wb_ack_o           ;
    logic   [aw-1:0]    wb_addr_i          ;
    logic               wb_we_i            ; // 1 - Write, 0 - Read
    logic   [dw-1:0]    wb_dat_i           ;
    logic   [dw/8-1:0]  wb_sel_i           ; // Byte enable
    logic   [dw-1:0]    wb_dat_o           ;
    logic               wb_cyc_i           ;
    logic   [2:0]       wb_cti_i           ;
//**********************************************************


//----------------------------------------------------------
//      SDRAM I/F 
//----------------------------------------------------------

`ifdef SDR_32BIT
   logic [31:0]           Dq                 ; // SDRAM Read/Write Data Bus
   logic [3:0]            sdr_dqm            ; // SDRAM DATA Mask
`elsif SDR_16BIT 
   logic [15:0]           Dq                 ; // SDRAM Read/Write Data Bus
   logic [1:0]            sdr_dqm            ; // SDRAM DATA Mask
`else 
   wire [7:0]            Dq                 ; // SDRAM Read/Write Data Bus
   wire [0:0]            sdr_dqm            ; // SDRAM DATA Mask
`endif
//**********************************************************


//----------------------------------------------------------
//      SDRAM Bank BITS
//----------------------------------------------------------
    logic   [1:0]       sdr_ba             ; // SDRAM Bank Select
    logic   [12:0]      sdr_addr           ; // SDRAM ADRESS
//**********************************************************


//----------------------------------------------------------
//          SDRAM memory Signals for classes in bfm
//----------------------------------------------------------
    logic               sdr_cke;
    logic               sdr_cs_n;
    logic               sdr_ras_n;
    logic               sdr_cas_n;
    logic               sdr_we_n;
//----------------------------------------------------------


//--------------------------------------------------------
//          Wishbone signals
//--------------------------------------------------------
    logic               sdr_init_done      ; // SDRAM Init Done - from sdrc top
//********************************************************


//--------------------------------------------------------
// data/address/burst length FIFO
//--------------------------------------------------------
    int     dfifo[$]; // data fifo
    int     afifo[$]; // address  fifo
    int     bfifo[$]; // Burst Length fifo
//********************************************************

wire #(2.0) sdram_clk_d   = sdram_clk; //signal is being sent to memory IP's.


initial sys_clk = 0;
initial sdram_clk = 0;

always #(P_SYS/2) sys_clk = !sys_clk;
always #(P_SDR/2) sdram_clk = !sdram_clk;



task initialization ();
   wb_addr_i      = 0;
   wb_dat_i       = 0;
   wb_sel_i       = 4'h0;
   wb_we_i        = 0;
   wb_stb_i       = 0;
   wb_cyc_i       = 0;

  RESETN    = 1'h1;

  repeat (100) @(negedge sys_clk);
  // Applying reset
  RESETN    = 1'h0;
  repeat (10000) @(negedge sys_clk);
  // Releasing reset
  RESETN    = 1'h1;
  repeat (1000) @(negedge sys_clk);
  //wait(u_dut.sdr_init_done == 1);       //Need to use this before generating stimulus
  
endtask

endinterface