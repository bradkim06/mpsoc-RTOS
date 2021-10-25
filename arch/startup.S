#define __ASSEMBLY__


#include <kernel.h>


.text
.extern __text_start
.extern __bss_start
.extern __bss_end
.extern exception_stack
.extern idle_stack
.extern uart_putc
.extern kernel_main
.extern UART0_ASM_Init

.global except_vec_start
.global except_vec_end
.extern CoSetExceptonVectoerBase


.align 4
except_vec_start:     
    ldr     pc, =reset
    b       .   				@ undefined instruction
    b       .   				@ software interrupt
    b       .   				@ prefetch abort
    b       .   				@ data abort
    b       . 					@ reserved vector
    ldr     pc, =secure_irq 	@ irq
//	ldr		pc, =irq_handler
    b       .   				@ fiq
except_vec_end:




reset:
//	ldr		r0, =97
//	bl		uart_putc
	bl		asm_init_stack
	bl      asm_init_cpu
	bl      asm_init_wdt
	bl		asm_init_clock
	bl      asm_init_memory

//	bl		asm_init_gpio
	bl		asm_init_uart
	bl      asm_init_execption_vector
	bl      asm_init_bss

//	ldr		r0, =99
//	bl		uart_putc
	/* start kernel main */
    mov     lr, pc
    ldr     pc, =kernel_main
//	bl		kernel_main
//	ldr		pc, =0xc3e00000
    b       .

#define S_FRAME_SIZE    72
#define S_PC        60
    .macro  irq_save_user_regs
    sub sp, sp, #S_FRAME_SIZE
    stmia   sp, {r0 - r12}          @ Calling r0-r12
    add r8, sp, #S_PC           @ !!!! R8 NEEDS to be saved !!!! a reserved stack spot would be good.
    stmdb   r8, {sp, lr}^           @ Calling SP, LR
    str lr, [r8, #0]            @ Save calling PC
    mrs r6, spsr
    str r6, [r8, #4]            @ Save CPSR
    str r0, [r8, #8]            @ Save OLD_R0
    mov r0, sp
    .endm

    .macro  irq_restore_user_regs
    ldmia   sp, {r0 - lr}^          @ Calling r0 - lr
    mov r0, r0
    ldr lr, [sp, #S_PC]         @ Get PC
    add sp, sp, #S_FRAME_SIZE
    subs    pc, lr, #4          @ return & move spsr_svc into cpsr
    .endm


.extern irq_handler

secure_irq:
	
	//irq_save_user_regs
	
	mrs     r0, cpsr
    bic     r0, r0, #0x1f
    orr     r0, r0, #0x13
    msr     cpsr, r0
	
	bl		irq_handler

//	mrs     r0, cpsr
//    bic     r0, r0, #0x1f
//    orr     r0, r0, #0x12
//    msr     cpsr, r0	
	
	//irq_restore_user_regs
	
	
	//push	{lr}
	//ldr     r0, =98
	//bl      uart_putc
	//ldr		r0, =0x0d
	//bl		uart_putc
	//ldr		r0, =0x0a
	//bl		uart_putc
	//mov		pc, lr
	//pop		{lr}
	//b		irq_test
	//ldr     pc, =irq_test

asm_init_cpu:
    /* change SVC32 mode	IRQ&FIQ disable */
    mrs     r0, cpsr
    bic     r0, r0, #0x1f
    orr     r0, r0, #0xd3
    msr     cpsr, r0

	
	/* disable mmu */ 
	mrc     p15, 0, r0, c1 ,c0 ,0
	bic     r0, r0, #(1 << 0)
	mcr     p15, 0, r0, c1, c0, 0

//	bl		cache_init
   /* enable	 I-C2che */
	mrc	    p15, 0, r0, c1, c0, 0
	orr     r0, r0, #(1 << 12)
	mcr     p15, 0, r0, c1, c0, 0

    
    /* enable coprocessors */
	ldr     r0, =0xffffffff
	mcr     p15, 0, r0, c1, c0, 2

    /* globally enable NEON & VFP */
	mov     r0, #0x40000000
	fmxR    FPEXC, r0

    
    /* enable branch prediction */
	mrc     p15, 0, r0, c1, c0, 0
	orr     r0, r0, #(1 << 11)
	mcr     p15, 0, r0, c1, c0, 0

	mov     pc, lr




asm_init_wdt:
	/* disable WDT(Watch Dog Timer) */
	ldr	r0, =ELFIN_WATCHDOG_BASE
	mov	r1, #0x0
	str	r1, [r0]

	mov	pc, lr

asm_init_memory:

	/* Async bridge configuration at CPU_core */
	/* 1: half_sync */
	/* 0: full_sync */
	ldr r0, =0x10010350
	mov r1, #1
	str r1, [r0]

	ldr	r0, =MIU_BASE

	ldr	r1, =0x20001507
	str	r1, [r0, #MIU_INTLV_CONFIG]
	ldr	r1, =0x40000000
	str	r1, [r0, #MIU_INTLV_START_ADDR]
	ldr	r1, =0xbfffffff
	str	r1, [r0, #MIU_INTLV_END_ADDR]
	ldr	r1, =0x00000001
	str	r1, [r0, #MIU_MAPPING_UPDATE]


/*****************************************************************/
/*DREX0***********************************************************/
/*****************************************************************/

	ldr	r0, =APB_DMC_0_BASE

	ldr	r1, =0xe0000086
	str	r1, [r0, #DMC_PHYCONTROL1]

	ldr	r1, =0xE3855703
	str	r1, [r0, #DMC_PHYZQCONTROL]

	mov	r2, #0x100000
1:	subs	r2, r2, #1
	bne	1b

	ldr	r1, =0xe000008e
	str	r1, [r0, #DMC_PHYCONTROL1]
	ldr	r1, =0xe0000086
	str	r1, [r0, #DMC_PHYCONTROL1]

	ldr	r1, =0x71101008
	str	r1, [r0, #DMC_PHYCONTROL0]
	ldr	r1, =0x7110100A
	str	r1, [r0, #DMC_PHYCONTROL0]
	ldr	r1, =0xe0000086
	str	r1, [r0, #DMC_PHYCONTROL1]
	ldr	r1, =0x7110100B
	str	r1, [r0, #DMC_PHYCONTROL0]

	ldr	r1, =0x00000000
	str	r1, [r0, #DMC_PHYCONTROL2]

	ldr	r1, =0x0FFF301A
	str	r1, [r0, #DMC_CONCONTROL]
	ldr	r1, =0x00312640
	str	r1, [r0, #DMC_MEMCONTROL]

	ldr	r1, =0x20e01323
	str	r1, [r0, #DMC_MEMCONFIG0]
	ldr	r1, =0x40e01323
	str	r1, [r0, #DMC_MEMCONFIG1]

	ldr	r1, =0xff000000
	str	r1, [r0, #DMC_PRECHCONFIG]

	ldr	r1, =0x000000BB
	str	r1, [r0, #DMC_TIMINGAREF] @TimingAref

	ldr	r1, =0x4046654f
	str	r1, [r0, #DMC_TIMINGROW] @TimingRow
	ldr	r1, =0x46400506
	str	r1, [r0, #DMC_TIMINGDATA] @TimingData
	ldr	r1, =0x52000a3c
	str	r1, [r0, #DMC_TIMINGPOWER] @TimingPower

	ldr	r1, =0x07000000
	str	r1, [r0, #DMC_DIRECTCMD]

	mov	r2, #0x100000
2:	subs	r2, r2, #1
	bne	2b

	ldr	r1, =0x00020000
	str	r1, [r0, #DMC_DIRECTCMD]
	ldr	r1, =0x00030000
	str	r1, [r0, #DMC_DIRECTCMD]
	ldr	r1, =0x00010002
	str	r1, [r0, #DMC_DIRECTCMD]
	ldr	r1, =0x00000328
	str	r1, [r0, #DMC_DIRECTCMD]

	mov	r2, #0x100000
3:	subs	r2, r2, #1
	bne	3b

	ldr	r1, =0x0a000000
	str	r1, [r0, #DMC_DIRECTCMD]

	mov	r2, #0x100000
4:	subs	r2, r2, #1
	bne	4b

	ldr	r1, =0x07100000
	str	r1, [r0, #DMC_DIRECTCMD]

	mov	r2, #0x100000
5:	subs	r2, r2, #1
	bne	5b

	ldr	r1, =0x00120000
	str	r1, [r0, #DMC_DIRECTCMD]
	ldr	r1, =0x00130000
	str	r1, [r0, #DMC_DIRECTCMD]
	ldr	r1, =0x00110002
	str	r1, [r0, #DMC_DIRECTCMD]
	ldr	r1, =0x00100328
	str	r1, [r0, #DMC_DIRECTCMD]

	mov	r2, #0x100000
6:	subs	r2, r2, #1
	bne	6b

	ldr	r1, =0x0a100000
	str	r1, [r0, #DMC_DIRECTCMD]

	mov	r2, #0x100000
7:	subs	r2, r2, #1
	bne	7b

	ldr	r1, =0xe000008e
	str	r1, [r0, #DMC_PHYCONTROL1]
	ldr	r1, =0xe0000086
	str	r1, [r0, #DMC_PHYCONTROL1]

	mov	r2, #0x100000
8:	subs	r2, r2, #1
	bne	8b

/*****************************************************************/
/*DREX1***********************************************************/
/*****************************************************************/

	ldr	r0, =APB_DMC_1_BASE

	ldr	r1, =0xe0000086				
	str	r1, [r0, #DMC_PHYCONTROL1]

	ldr	r1, =0xE3855703				
	str	r1, [r0, #DMC_PHYZQCONTROL]

	mov	r2, #0x100000
1:	subs	r2, r2, #1
	bne	1b

	ldr	r1, =0xe000008e
	str	r1, [r0, #DMC_PHYCONTROL1]
	ldr	r1, =0xe0000086
	str	r1, [r0, #DMC_PHYCONTROL1]

	ldr	r1, =0x71101008
	str	r1, [r0, #DMC_PHYCONTROL0]
	ldr	r1, =0x7110100A
	str	r1, [r0, #DMC_PHYCONTROL0]
	ldr	r1, =0xe0000086
	str	r1, [r0, #DMC_PHYCONTROL1]
	ldr	r1, =0x7110100B
	str	r1, [r0, #DMC_PHYCONTROL0]

	ldr	r1, =0x00000000
	str	r1, [r0, #DMC_PHYCONTROL2]

	ldr	r1, =0x0fff301a
	str	r1, [r0, #DMC_CONCONTROL]
	ldr 	r1, =0x00312640
	str	r1, [r0, #DMC_MEMCONTROL]

	ldr	r1, =0x20e01323				
	str	r1, [r0, #DMC_MEMCONFIG0]
	ldr	r1, =0x40e01323
	str	r1, [r0, #DMC_MEMCONFIG1]

	ldr	r1, =0xff000000			
	str	r1, [r0, #DMC_PRECHCONFIG]

	ldr	r1, =0x000000BC
	str	r1, [r0, #DMC_TIMINGAREF] @TimingAref

	ldr	r1, =0x4046654f
	str	r1, [r0, #DMC_TIMINGROW] @TimingRow
	ldr	r1, =0x46400506
	str	r1, [r0, #DMC_TIMINGDATA] @TimingData
	ldr	r1, =0x52000a3c
	str	r1, [r0, #DMC_TIMINGPOWER] @TimingPower

	ldr	r1, =0x07000000
	str	r1, [r0, #DMC_DIRECTCMD]

	mov	r2, #0x100000
2:	subs	r2, r2, #1
	bne	2b

	ldr	r1, =0x00020000
	str	r1, [r0, #DMC_DIRECTCMD]
	ldr	r1, =0x00030000
	str	r1, [r0, #DMC_DIRECTCMD]
	ldr	r1, =0x00010002
	str	r1, [r0, #DMC_DIRECTCMD]
	ldr	r1, =0x00000328
	str	r1, [r0, #DMC_DIRECTCMD]

	mov	r2, #0x100000
3:	subs	r2, r2, #1
	bne	3b

	ldr	r1, =0x0a000000
	str	r1, [r0, #DMC_DIRECTCMD]

	mov	r2, #0x100000
4:	subs	r2, r2, #1
	bne	4b

	ldr	r1, =0x07100000
	str	r1, [r0, #DMC_DIRECTCMD]

	mov	r2, #0x100000
5:	subs	r2, r2, #1
	bne	5b

	ldr	r1, =0x00120000
	str	r1, [r0, #DMC_DIRECTCMD]
	ldr	r1, =0x00130000
	str	r1, [r0, #DMC_DIRECTCMD]
	ldr	r1, =0x00110002
	str	r1, [r0, #DMC_DIRECTCMD]
	ldr	r1, =0x00100328
	str	r1, [r0, #DMC_DIRECTCMD]

	mov	r2, #0x100000
6:	subs	r2, r2, #1
	bne	6b

	ldr	r1, =0x0a100000
	str	r1, [r0, #DMC_DIRECTCMD]

	mov	r2, #0x100000
7:	subs	r2, r2, #1
	bne	7b

	ldr	r1, =0xe000008e
	str	r1, [r0, #DMC_PHYCONTROL1]
	ldr	r1, =0xe0000086
	str	r1, [r0, #DMC_PHYCONTROL1]

	mov	r2, #0x100000
8:	subs	r2, r2, #1
	bne	8b

/*****************************************************************/
/* turn on DREX0, DREX1 ******************************************/
/*****************************************************************/

	ldr	r0, =APB_DMC_0_BASE
	ldr	r1, =0x0FFF303a
	str	r1, [r0, #DMC_CONCONTROL]

	ldr	r0, =APB_DMC_1_BASE
	ldr	r1, =0x0FFF303a
	str	r1, [r0, #DMC_CONCONTROL]

	mov     pc, lr


//
//
//asm_init_gpio:
//	/* GPIO initialization */
//	ldr		r0, =GPK1CON
//	ldr		r1, =0x00002222
//	str		r1, [r0]
//	
//	ldr		r0, =GPK3CON
//	ldr		r1, =0x11111100
//	str		r1, [r0]
//	
//	ldr		r0, =GPK3DAT
//	mov		r1, #0x00000000
//	str		r1, [r0]
//
//	/* IO retention release */
//	ldr		r0, =(ELFIN_CLOCK_POWER_BASE + OTHERS)
//	ldr		r1, [r0]
//	ldr		r2, =(1<<31)
//	orr		r1, r1, r2
//	str		r1, [r0]
//
//    mov     pc, lr
//
asm_init_clock:

    ldr r0, =CMU_BASE   @0x1003_0000

@ CMU_CPU MUX / DIV
    ldr r1, =0x0
    ldr r2, =CLK_SRC_CPU_OFFSET
    str r1, [r0, r2]

    /* wait ?us */
    mov r1, #0x10000
1:  subs    r1, r1, #1
    bne 1b

    ldr r1, =CLK_DIV_CPU0_VAL
    ldr r2, =CLK_DIV_CPU0_OFFSET
    str r1, [r0, r2]
    ldr r1, =CLK_DIV_CPU1_VAL
    ldr r2, =CLK_DIV_CPU1_OFFSET
    str r1, [r0, r2]

@ CMU_DMC MUX / DIV
    ldr r1, =0x10000
    ldr r2, =CLK_SRC_DMC_OFFSET
    str r1, [r0, r2]

    /* wait ?us */
    mov r1, #0x10000
2:  subs    r1, r1, #1
    bne 2b

	ldr r1, =CLK_DIV_DMC0_VAL
    ldr r2, =CLK_DIV_DMC0_OFFSET
    str r1, [r0, r2]
    ldr r1, =CLK_DIV_DMC1_VAL
    ldr r2, =CLK_DIV_DMC1_OFFSET
    str r1, [r0, r2]

@ CMU_TOP MUX / DIV
    ldr r1, =CLK_SRC_TOP0_VAL
    ldr r2, =CLK_SRC_TOP0_OFFSET
    str r1, [r0, r2]
    ldr r1, =CLK_SRC_TOP1_VAL
    ldr r2, =CLK_SRC_TOP1_OFFSET
    str r1, [r0, r2]

    /* wait ?us */
    mov r1, #0x10000
3:  subs    r1, r1, #1
    bne 3b

    ldr r1, =CLK_DIV_TOP_VAL
    ldr r2, =CLK_DIV_TOP_OFFSET
    str r1, [r0, r2]

@ CMU_LEFTBUS MUX / DIV
    ldr r1, =CLK_SRC_LEFTBUS_VAL
    ldr r2, =CLK_SRC_LEFTBUS_OFFSET
    str r1, [r0, r2]

    /* wait ?us */
    mov r1, #0x10000
4:  subs    r1, r1, #1
    bne 4b

    ldr r1, =CLK_DIV_LEFRBUS_VAL
    ldr r2, =CLK_DIV_LEFTBUS_OFFSET
    str r1, [r0, r2]

@ CMU_RIGHTBUS MUX / DIV
    ldr r1, =CLK_SRC_RIGHTBUS_VAL
    ldr r2, =CLK_SRC_RIGHTBUS_OFFSET
    str r1, [r0, r2]

	/* wait ?us */
    mov r1, #0x10000
5:  subs    r1, r1, #1
    bne 5b

    ldr r1, =CLK_DIV_RIGHTBUS_VAL
    ldr r2, =CLK_DIV_RIGHTBUS_OFFSET
    str r1, [r0, r2]

@ Set PLL locktime
    ldr r1, =APLL_LOCK_VAL
    ldr r2, =APLL_LOCK_OFFSET
    str r1, [r0, r2]
    ldr r1, =MPLL_LOCK_VAL
    ldr r2, =MPLL_LOCK_OFFSET
    str r1, [r0, r2]
    ldr r1, =EPLL_LOCK_VAL
    ldr r2, =EPLL_LOCK_OFFSET
    str r1, [r0, r2]
    ldr r1, =VPLL_LOCK_VAL
    ldr r2, =VPLL_LOCK_OFFSET
    str r1, [r0, r2]

@ Set PLL P,M,S ON
    ldr r1, =APLL_CON1_VAL
    ldr r2, =APLL_CON1_OFFSET
    str r1, [r0, r2]

@ Set APLL
    ldr r1, =APLL_CON0_VAL
    ldr r2, =APLL_CON0_OFFSET
    str r1, [r0, r2]

@ Set MPLL
    ldr r1, =MPLL_CON1_VAL
    ldr r2, =MPLL_CON1_OFFSET
    str r1, [r0, r2]
    ldr r1, =MPLL_CON0_VAL
    ldr r2, =MPLL_CON0_OFFSET
    str r1, [r0, r2]

@ Set EPLL
    ldr r1, =EPLL_CON1_VAL
    ldr r2, =EPLL_CON1_OFFSET
    str r1, [r0, r2]
    ldr r1, =EPLL_CON0_VAL
    ldr r2, =EPLL_CON0_OFFSET
    str r1, [r0, r2]

@ Set VPLL
    ldr r1, =VPLL_CON1_VAL
    ldr r2, =VPLL_CON1_OFFSET
    str r1, [r0, r2]
    ldr r1, =VPLL_CON0_VAL
    ldr r2, =VPLL_CON0_OFFSET
    str r1, [r0, r2]

    /* wait ?us */
    mov r1, #0x30000
6:  subs    r1, r1, #1
    bne 6b

    ldr r1, =CLK_SRC_CPU_VAL_MOUTMPLLFOUT
    ldr r2, =CLK_SRC_CPU_OFFSET
    str r1, [r0, r2]

    /* wait ?us */
    mov r1, #0x10000
7:  subs    r1, r1, #1
    bne 7b

    mov     pc, lr





asm_init_uart:

    /* set GPIO to enable UART */
    @ GPIO setting for UART for UART0/1
    ldr r0, =0x11400000
    ldr r1, =0x22222222
    str     r1, [r0]
    ldr r0, =0x11400020
    ldr r1, =0x222222
    str r1, [r0]

    ldr r0, =CMU_BASE   @0x1003_0000
    ldr r1, =CLK_SRC_PERIL0_VAL     @0x666666
    ldr r2, =CLK_SRC_PERIL0_OFFSET
    str r1, [r0, r2]
    ldr r1, =CLK_DIV_PERIL0_VAL     @0x777777
    ldr r2, =CLK_DIV_PERIL0_OFFSET
    str r1, [r0, r2]

    ldr r0, =ELFIN_UART_CONSOLE_BASE        @0xEC000000
    ldr r1, =0x111
    str r1, [r0, #UFCON_OFFSET]

    mov r1, #0x3
    str r1, [r0, #ULCON_OFFSET]

    ldr r1, =0x3c5
    str r1, [r0, #UCON_OFFSET]

    ldr r1, =UART_UBRDIV_VAL    @0x2B /*  UDIV(43) = ((82,500,000 / 16 / 115200) - 1) */
    str r1, [r0, #UBRDIV_OFFSET]

    ldr r1, =UART_UDIVSLOT_VAL  @0xC /* UFRACVAL(12) = ((((82,500,000 / 16 / 115200) - 1) - 43) * 16) */
    str r1, [r0, #UDIVSLOT_OFFSET]

    ldr r1, =0x4f4f4f4f
    str r1, [r0, #UTXH_OFFSET]      @'O'
    mov     pc, lr





asm_init_execption_vector:
    push    {lr}
	/* exception vector address setting */
	ldr		r0, =except_vec_start
 	bl		CoSetExceptonVectoerBase
    pop     {lr}
@    /* initialize exception vector table */
@    ldr     r0, =0x0                             @ low vector address
@    ldr     r1, =except_vec_start
@    ldr     r2, =except_vec_end
@191:
@    ldr     r3, [r1], #4
@    str     r3, [r0], #4
@    teq     r1, r2
@    bne     191b 
    mov     pc, lr




asm_init_stack:
    /* setup fiq mode stack */
    ldr     r0, =exception_stack
    ldr     r2, =CONFIG_EXCEPT_STACK_SIZE
    add     r0, r0, r2
    sub     r0, r0, #4

    mov     r1, #0xC0 | 0x11
    msr     cpsr, r1
    mov     sp, r0

    /* setup irq mode stack */
    mov     r1, #0xC0 | 0x12
    msr     cpsr, r1
    mov     sp, r0

    /* setup about mode stack */
    mov     r1, #0xC0 | 0x17
    msr     cpsr, r1
    mov     sp, r0

    /* setup undefine instrucation mode stack */
    mov     r1, #0xC0 | 0x1B
    msr     cpsr, r1
    mov     sp, r0

    /* setup system mode stack */
    mov     r1, #0xC0 | 0x1F
    msr     cpsr, r1
    mov     sp, r0

    /* setup idle task stack */
    mov     r1, #0xC0 | 0x13
    msr     cpsr,r1
    ldr     r0, =idle_stack
    ldr     r1, =CONFIG_TASK_STACK_SIZE
    add     r0, r0, r1
    sub     r0, r0, #4
    mov     sp, r0

    mov     pc, lr




asm_init_bss:
    /* clear kernel bss */
    ldr     r0, =__bss_start
    ldr     r1, =__bss_end
    mov     r2, #0x0
2:
    cmp     r0, r1
    strle   r2, [r0], #4
    ble     2b

    mov     pc, lr

