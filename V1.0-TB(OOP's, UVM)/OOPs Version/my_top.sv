/////////////////////////////////////////////////////////////////
////        This is the top module on test bench side.       ////
////                                                         ////
////                                                         ////
////    Created  By: Manasa Gurrala                          ////
////                 Venkata Naveen Reddy Yalla              ////
////                 Karthik Rudraraju                       ////
////                                                         ////
/////////////////////////////////////////////////////////////////

`define SDR_16BIT = 1;
//`define SDR_32BIT = 1;


module my_top();
import  sdrctrl_package::*;

sdrctrlinterface_bfm        bfm();    //BFM variable declaration.
cov_intf                    cov_bfm();//BFM signals for coverage.

testbench       testbench_h;

`ifdef SDR_32BIT
   sdrc_top #(.SDR_DW(32),.SDR_BW(4)) u_dut(
`elsif SDR_16BIT 
   sdrc_top #(.SDR_DW(16),.SDR_BW(2)) u_dut(
`else  // 8 BIT SDRAM
   sdrc_top #(.SDR_DW(8),.SDR_BW(1)) u_dut(
`endif
      // System 

`ifdef SDR_32BIT
          .cfg_sdr_width      (2'b00              ), // 32 BIT SDRAM
`elsif SDR_16BIT
          .cfg_sdr_width      (2'b01              ), // 16 BIT SDRAM
`else 
          .cfg_sdr_width      (2'b10              ), // 8 BIT SDRAM
`endif
          .cfg_colbits        (2'b00              ), // 8 Bit Column Address

/* WISH BONE */
          .wb_rst_i           (!bfm.RESETN        ),
          .wb_clk_i           (bfm.sys_clk        ),

          .wb_stb_i           (bfm.wb_stb_i       ),
          .wb_ack_o           (bfm.wb_ack_o       ),
          .wb_addr_i          (bfm.wb_addr_i      ),
          .wb_we_i            (bfm.wb_we_i        ),
          .wb_dat_i           (bfm.wb_dat_i       ),
          .wb_sel_i           (bfm.wb_sel_i       ),
          .wb_dat_o           (bfm.wb_dat_o       ),
          .wb_cyc_i           (bfm.wb_cyc_i       ),
          .wb_cti_i           (bfm.wb_cti_i       ), 

/* Interface to SDRAMs */
          .sdram_clk          (bfm.sdram_clk      ),
          .sdram_resetn       (bfm.RESETN         ),
          
          .sdr_cs_n           (bfm.sdr_cs_n       ),
          .sdr_cke            (bfm.sdr_cke        ),
          .sdr_ras_n          (bfm.sdr_ras_n      ),
          .sdr_cas_n          (bfm.sdr_cas_n      ),
          .sdr_we_n           (bfm.sdr_we_n       ),
          .sdr_dqm            (bfm.sdr_dqm        ),
          .sdr_ba             (bfm.sdr_ba         ),
          .sdr_addr           (bfm.sdr_addr       ), 
          .sdr_dq             (bfm.Dq             ),

    /* Parameters */
          .sdr_init_done      (bfm.sdr_init_done  ),
          .cfg_req_depth      (2'h3               ), //how many req. buffer should hold
          .cfg_sdr_en         (1'b1               ),
          .cfg_sdr_mode_reg   (13'h033            ),            
          .cfg_sdr_tras_d     (4'h4               ),
          .cfg_sdr_trp_d      (4'h2               ),
          .cfg_sdr_trcd_d     (4'h2               ),
          .cfg_sdr_cas        (3'h3               ),
          .cfg_sdr_trcar_d    (4'h7               ),
          .cfg_sdr_twr_d      (4'h1               ),
          .cfg_sdr_rfsh       (12'h100            ), // reduced from 12'hC35
          .cfg_sdr_rfmax      (3'h6               )

);


`ifdef SDR_32BIT
mt48lc2m32b2 #(.data_bits(32)) u_sdram32 (
          .Dq                 (bfm.Dq             ), 
          .Addr               (bfm.sdr_addr[10:0] ), 
          .Ba                 (bfm.sdr_ba         ), 
          .Clk                (bfm.sdram_clk_d    ), 
          .Cke                (bfm.sdr_cke        ), 
          .Cs_n               (bfm.sdr_cs_n       ), 
          .Ras_n              (bfm.sdr_ras_n      ), 
          .Cas_n              (bfm.sdr_cas_n      ), 
          .We_n               (bfm.sdr_we_n       ), 
          .Dqm                (bfm.sdr_dqm        )
     );

`elsif SDR_16BIT

   IS42VM16400K u_sdram16 (
          .dq                 (bfm.Dq             ), 
          .addr               (bfm.sdr_addr[11:0] ), 
          .ba                 (bfm.sdr_ba         ), 
          .clk                (bfm.sdram_clk_d    ), 
          .cke                (bfm.sdr_cke        ), 
          .csb                (bfm.sdr_cs_n       ), 
          .rasb               (bfm.sdr_ras_n      ), 
          .casb               (bfm.sdr_cas_n      ), 
          .web                (bfm.sdr_we_n       ), 
          .dqm                (bfm.sdr_dqm        )
    );
`else 


mt48lc8m8a2 #(.data_bits(8)) u_sdram8 (
          .Dq                 (bfm.Dq             ), 
          .Addr               (bfm.sdr_addr[11:0] ), 
          .Ba                 (bfm.sdr_ba         ), 
          .Clk                (bfm.sdram_clk_d    ), 
          .Cke                (bfm.sdr_cke        ), 
          .Cs_n               (bfm.sdr_cs_n       ), 
          .Ras_n              (bfm.sdr_ras_n      ), 
          .Cas_n              (bfm.sdr_cas_n      ), 
          .We_n               (bfm.sdr_we_n       ), 
          .Dqm                (bfm.sdr_dqm        )
     );
`endif

//below assign variables are getting covered in coverage class
assign cov_bfm.req_st = my_top.u_dut.u_sdrc_core.u_req_gen.req_st;
assign cov_bfm.xfr_st = my_top.u_dut.u_sdrc_core.u_xfr_ctl.xfr_st;

initial
begin
    testbench_h = new(cov_bfm, bfm);
    bfm.initialization();
    wait(bfm.sdr_init_done == 1'b1);    //wait till initializtion is done.
    testbench_h.execute();
end

endmodule
