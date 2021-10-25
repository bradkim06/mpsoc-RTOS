//==============================================================================
// System Hardware Initialization Routines
//
// Date : 2009/11/28
//==============================================================================
#define __ASSEMBLY__

#include <hal.h>

    .text
	.global		DDR2_SDRAM_ASM_Init
	.global		Clock_Controller_ASM_Init
	.global		UART0_ASM_Init
//	.global		mem_ctrl_asm_init
	
.align 4
//	
////------------------------------------------------------------------------------
//// DDR2 SDRAM Initialization Function
////------------------------------------------------------------------------------
//DDR2_SDRAM_ASM_Init:
//
//	ldr	r0, =APB_DMC_BASE			//APB_DMC_BASE 0xE6000000
//	
//        ldr     r1, =0x6E101000                         //Phycontrol0 DLL parameter setting
//        str     r1, [r0, #DMC_PHYCONTROL0]
//
//        ldr     r1, =0x000000F4                         //Phycontrol1 DLL parameter setting
////        ldr     r1, =0x000000F6                        //Phycontrol1 DLL parameter setting
//
//        str     r1, [r0, #DMC_PHYCONTROL1]
//
//        ldr     r1, =0x00000000                         //Phycontrol2 DLL parameter setting
//        str     r1, [r0, #DMC_PHYCONTROL2]
//
//        ldr     r1, =0x6E101002                         //Dll on
//        str     r1, [r0, #DMC_PHYCONTROL0]
//
//        ldr     r1, =0x6E101003                         //dll start
//        str     r1, [r0, #DMC_PHYCONTROL0]
//
//wait_for_dll_locking:
//	ldr		r2, [r0, #DMC_PHYSTATUS0]
//	bic		r2, #0xfffffffb		
//	mov		r2, r2, lsr #2
//	cmp		r2, #0x1
//	bne		wait_for_dll_locking
//
//	ldr		r2, [r0, #DMC_PHYSTATUS0]
//	bic		r2, #0xffffc03f		
//	mov		r2, r2, lsr #6
//	mov		r2,r2,lsl #24
//	ldr		r1, =0x00101003
//	orr		r1,r1,r2
//
//	ldr		r4, =0xF4010000
//	str		r1, [r4, #4]
//
//		
////        ldr     r1, =0x54101003                         //Force Value locking
//        str     r1, [r0, #DMC_PHYCONTROL0]
//
//	ldr		r1, =0x00101001
//	orr		r1,r1,r2
////        ldr     r1, =0x54101001                         //Dll off
//        str     r1, [r0, #DMC_PHYCONTROL0]
//
//        ldr     r1, =0x00FF2010                         //auto refresh off
//        str     r1, [r0, #DMC_CONCONTROL]
//
//        ldr     r1, =0x00212400                         // BL=4 , 2 chip , DDR2
//        str     r1, [r0, #DMC_MEMCONTROL]
//
////#if 1	// add charles 512MB enable
//        ldr     r1, =0x20E01323							// 512MB config , 8banks , linear, Row=14bit,COL=10bit
//        str     r1, [r0, #DMC_MEMCONFIG0]
//
//        ldr     r1, =0x40E00323
//        str     r1, [r0, #DMC_MEMCONFIG1]
////#else	// 256MB enable
////        ldr     r1, =0x20F80313							// 128MB config , 8banks , linear, Row=13bit,COL=10bit
////        str     r1, [r0, #DMC_MEMCONFIG0]
//
////        ldr     r1, =0x40F80313
////        str     r1, [r0, #DMC_MEMCONFIG1]
//
////#endif
//        ldr     r1, =0x20000000
//        str     r1, [r0, #DMC_PRECHCONFIG]
//
//
////#ifdef	CONFIG_HCLKD0_222
////	ldr 	r1, =0x000006c3 						//7.8us*222MHz=0x6c3, 7.8us*166MHz=1294(0x50E)
////       str     r1, [r0, #DMC_TIMINGAREF]
//////	/* T-rfc   127.5nS/5ns  64 */
////       ldr     r1, =0x202332C8                         		//TimingRow      @222MHz
////       str     r1, [r0, #DMC_TIMINGROW]
////
////       ldr     r1, =0x24450304							//CL=5
////       str     r1, [r0, #DMC_TIMINGDATA]
////
// //#else
////
//	ldr	 r1, =0x0000050E						 //7.8us*200MHz=0x618, 7.8us*166MHz=1294(0x50E)
//	str	 r1, [r0, #DMC_TIMINGAREF]
//
//	ldr	 r1, =0x16233288						 //TimingRow 	 @166MHz
//	str	 r1, [r0, #DMC_TIMINGROW]
//
//	ldr	 r1, =0x24250304						 //CL=5
//	str	 r1, [r0, #DMC_TIMINGDATA]
// //#endif
//
//        ldr     r1, =0x07c80232                         //Timing Power
//        str     r1, [r0, #DMC_TIMINGPOWER]
//
//        ldr     r1, =0x07000000                         //chip0 Deselect
//        str     r1, [r0, #DMC_DIRECTCMD]
//
//        ldr     r1, =0x01000000                         //chip0 PALL
//        str     r1, [r0, #DMC_DIRECTCMD]
//
//        ldr     r1, =0x00020000                         //chip0 EMRS2
//        str     r1, [r0, #DMC_DIRECTCMD]
//
//        ldr     r1, =0x00030000                         //chip0 EMRS3
//        str     r1, [r0, #DMC_DIRECTCMD]
//
//	ldr     r1, =0x00010400                         //chip0 EMRS1 (MEM DLL on = DQS# disable)
//        str     r1, [r0, #DMC_DIRECTCMD]
//
//        ldr     r1, =0x00000552                         //chip0 MRS (MEM DLL reset) CL=5, Burst Length=4
//        str     r1, [r0, #DMC_DIRECTCMD]
//
//        ldr     r1, =0x01000000                         //chip0 PALL
//        str     r1, [r0, #DMC_DIRECTCMD]
//
//        ldr     r1, =0x05000000                         //chip0 REFA
//        str     r1, [r0, #DMC_DIRECTCMD]
//
//        ldr     r1, =0x05000000                         //chip0 REFA
//        str     r1, [r0, #DMC_DIRECTCMD]
//
//        ldr     r1, =0x00000452                         //chip0 MRS (MEM DLL unreset) , BL=4 , CL=5
//        str     r1, [r0, #DMC_DIRECTCMD]
//
//        ldr     r1, =0x00010780                         //chip0 EMRS1 (OCD default)
//        str     r1, [r0, #DMC_DIRECTCMD]
//
//
//// 	    ldr     r1, =0x00010400                         //chip0 EMRS1 (OCD exit)
//	    ldr     r1, =0x00010402                         //chip0 EMRS1 (OCD exit)  Reduced Strength
////      ldr     r1, =0x00010000                         //chip0 EMRS1 (OCD exit)  ODT Disabled
////      ldr     r1, =0x00010440                         //chip0 EMRS1 (OCD exit)
//        str     r1, [r0, #DMC_DIRECTCMD]
//
//        ldr     r1, =0x00FF20B0                         //ConControl PHY driving , auto refresh on , out of order scheduling
//        str     r1, [r0, #DMC_CONCONTROL]
//
//        ldr     r1, =0x00100002                         //PwrdnConfig
//        str     r1, [r0, #DMC_PWRDNCONFIG]
//
//        ldr     r1, =0xFF212400                         //MemControl
//        str     r1, [r0, #DMC_MEMCONTROL]
//
//        mov pc, lr
//
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// void uart_putc(int data)//
////------------------------------------------------------------------------------
	.global uart_putc
uart_putc:
	ldr	r3, =(ELFIN_UART_BASE+ELFIN_UART1_OFFSET)
1:	ldr	r1, [r3, #UTRSTAT_OFFSET]
	bic	r1, r1, #0xfffffffd
	mov r1, r1, lsr #1
	cmp r1, #1
	bne 1b
	str	r0, [r3, #UTXH_OFFSET]
	mov pc, lr
//------------------------------------------------------------------------------

//int get_pc(void)
	.global get_pc
get_pc:
	mov r0, pc
	mov pc, lr


//cache_init:
//	mov	pc, lr
//	
//	.globl lowlevel_init
//lowlevel_init:
//	ldr sp, =0x02040000
//	push {lr}
//
//	ldr	r0, =(INF_REG_BASE + INF_REG1_OFFSET)
//	ldr r1, [r0]	
//
//	ldr r2, =S5P_CHECK_SLEEP
//	cmp r1, r2
//	beq wakeup_reset
//
//
//
//
//
//wakeup_reset:
//	bl read_om
//    ldr r0, =INF_REG_BASE
//    ldr r1, [r0, #INF_REG3_OFFSET]
//    cmp r1, #BOOT_EMMC_4_4
//    bleq    emmc_4_4_endbootOp_eMMC
//    ldr     r0, =(INF_REG_BASE + INF_REG1_OFFSET)
//    ldr     r1, [r0]
//
//    /* If NOT Sleep wakeup reset */
//    ldr r2, =S5P_CHECK_SLEEP
//    cmp r1, r2
//    bne exit_wakeup
//
//    /* MSHC CLKENA Disable */
//    ldr r0, =0x12550010
//    ldr r1, =0x0
//    str     r1, [r0]
//
//    ldr r0, =0x1255002C
//    ldr r1, =(1<<31|1<<21|1<<13);
//    str     r1, [r0]
//    ldr r0, =CHIP_ID_BASE
//    ldr r1, [r0]
//    lsr r1, r1, #8
//    and r1, r1, #3
//    cmp r1, #2
//    bne wake_v310
//	/*
//		init system clock */
//
//    bl  mem_ctrl_asm_init
//    bl  system_clock_init
//
//
//    /* If eMMC booting */
//    /* mmc ch4 devider value change */
//    ldr r0, =INF_REG_BASE
//    ldr r1, [r0, #INF_REG3_OFFSET]
//    cmp r1, #BOOT_EMMC_4_4
//    bleq    mmc_ch4_devider_change
//
//    bl  tzpc_init
//    b   exit_wakeup
//
//
//
//read_om:
//	ldr r0, =S5PV310_POSER_BASE
//    ldr r1, [r0,#OMR_OFFSET]
//    bic r2, r1, #0xffffffc1
//
//    /* NAND BOOT */
//@   cmp r2, #0x0        @ 512B 4-cycle
//@   moveq   r3, #BOOT_NAND
//
//@   cmp r2, #0x2        @ 2KB 5-cycle
//@   moveq   r3, #BOOT_NAND
//
//@   cmp r2, #0x4        @ 4KB 5-cycle   8-bit ECC
//@   moveq   r3, #BOOT_NAND
//
//    cmp     r2, #0xA
//    moveq   r3, #BOOT_ONENAND
//
//    cmp r2, #0x10   @ 2KB 5-cycle   16-bit ECC
//    moveq   r3, #BOOT_NAND
//
//    /* SD/MMC BOOT */
//    cmp     r2, #0x4
//    moveq   r3, #BOOT_MMCSD
//
//    /* eMMC BOOT */
//    cmp r2, #0x6
//    moveq   r3, #BOOT_EMMC
//
//    /* eMMC 4.4 BOOT */
//    cmp r2, #0x8
//    moveq   r3, #BOOT_EMMC_4_4
//    cmp r2, #0x28
//    moveq   r3, #BOOT_EMMC_4_4
//
//
//    ldr r0, =INF_REG_BASE
//    str r3, [r0, #INF_REG3_OFFSET]
//    
//    mov pc, lr
//
