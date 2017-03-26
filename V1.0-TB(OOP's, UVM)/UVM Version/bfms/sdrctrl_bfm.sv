
`timescale 1ns/1ps
`define SDR_16BIT = 1;
//`include "env.svh"

interface sdrctrlinterface_bfm;
import  sdrctrl_package::*;


parameter       P_SYS   = 10;     //    200MHz
parameter       P_SDR   = 20;     //    100MHz

parameter       aw      = 26;  // address wdith
parameter       dw      = 32;  // data width
parameter       tw      = 8;   // tag id width
//parameter       bl      = 5;   // burst_lenght_width 


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
   wire [31:0]           Dq                 ; // SDRAM Read/Write Data Bus
   wire [3:0]            sdr_dqm            ; // SDRAM DATA Mask
`elsif SDR_16BIT 
   wire  [15:0]           Dq                 ; // SDRAM Read/Write Data Bus
   wire [1:0]            sdr_dqm            ; // SDRAM DATA Mask
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

int dfifo[$];
int afifo[$];
int bfifo[$];
logic [7:0] bl;
logic write_done;
logic read_init;
logic FLAG;

wire #(2.0) sdram_clk_d   = bfm.sdram_clk; //signal is being sent to memory IP's.


initial begin
	sys_clk = 0;
	
	forever	begin
	#(P_SYS/2); sys_clk = ~sys_clk;
	end
end
initial begin
	sdram_clk = 0;
	forever begin
	#(P_SDR/2);	sdram_clk = ~sdram_clk;
	end
end	



task initialization ();
   read_init      = 0;
   write_done     = 0;
   FLAG 	 = 0;
   wb_addr_i      = 0;
   wb_dat_i       = 0;
   wb_sel_i       = 4'h0;
   wb_we_i        = 0;
   wb_stb_i       = 0;
   wb_cyc_i       = 0;

  RESETN    = 1'h1;
  repeat (2) @(negedge sys_clk);
  // Applying reset
  RESETN    = 1'h0;
  repeat (3) @(negedge sys_clk);
  // Releasing reset
  RESETN    = 1'h1;
  repeat (2) @(negedge sys_clk);
 // wait(sdr_init_done == 1);       //Need to use this before generating stimulus
 	
endtask

endinterface
