#include <kernel.h>
#include <s5pv310.h>
#include <irqs.h>
#include <interrupt.h>
unsigned char exception_stack[CONFIG_EXCEPT_STACK_SIZE];


void irq_handler(unsigned int my_cpsr)
{
	//printf("0x%x\n",my_cpsr);
	unsigned int icciar0 = *(volatile unsigned int *)(0x1048000C);
	if((icciar0 & 0x3FF)== 73)//IMTER4
		Timer_irq();

	*(volatile unsigned int *)(0x10480010) = (icciar0 & 0x3FF);

}

void enable_interrupts(void)
{
	unsigned long temp;
	__asm__ __volatile__("mrs %0, cpsr\n" "bic %0, %0, #0xc0\n" "msr cpsr_c, %0":"=r"(temp)
				::"memory");
}

void Interrupt_init(void)
{
	*(volatile unsigned int*)(0x10490d08) = 0;
	*(volatile unsigned int*)(0x10490088) = 0<<9;		//ICDISR
	*(volatile unsigned int*)(0x10490448) = 0xF<<8;		//ICDIPR
	*(volatile unsigned int*)(0x10490848) = 0x01010101; //ICDIPTR
	*(volatile unsigned int*)(0x10490108) = 1<<9;		//ICDISER
	*(volatile unsigned int*)(0x10480004) = 0xFF;		//ICCPMR
	*(volatile unsigned int*)(0x10480000) = 0x03;		//iCCICR
	*(volatile unsigned int*)(0x10490000) = 0x1;

	enable_interrupts();
}
