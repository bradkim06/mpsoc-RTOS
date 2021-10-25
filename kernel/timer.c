#include <kernel.h>
#include <timer.h>
#include <scheduler.h>
#include <task.h>
//#include <irqs.h>
//#include <regs-systimer.h>

unsigned int system_tick = 0;


void Timer_init(void)
{
	// TCFG0
	*(volatile unsigned int*)(0x139D0000) = 0x0C00;

	// TCFG1
	//*(volatile unsigned int*)(0x139D0004) = 0xF << 16;

	// TCNTB4
	*(volatile unsigned int*)(0x139D003C) = 10000;

	// TCON
	*(volatile unsigned int*)(0x139D0008) = 5 << 20;

	// TINT_CSTAT	
	*(volatile unsigned int*)(0x139D0044) = (1<<4);

}

void Timer_irq(void)
{
	system_tick++;
	*(volatile unsigned int*)(0x139D0044) |= (1<<9);

	if(system_tick % 1000 == 0)
		printf("systimer_irq %d\n",system_tick);
	
	if(!current_task->time_quantum--){
		current_task->time_quantum = SCHED_TIME_QUANTUM;
		Task_dequeue(current_task);
		Task_enqueue(current_task);
		Do_scheduling();
	}
	
}
