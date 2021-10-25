
#include <kernel.h>
#include <task.h>
#include <scheduler.h>
#include <config.h>
#include <test.h>
#include <timer.h>
#include <interrupt.h>
unsigned int idle_count;



int kernel_main(void) {
	unsigned int i;
	printf("\nStart YHC RTOS kernel...............\n");
	

	Init_scheduler();
	Init_idle_task();
	Timer_init();
	Interrupt_init();

	Task_init(&init_task, Init_task_main, 0, CONFIG_MAX_PRIORITY - 1,init_stack, sizeof(init_stack));

    while (1) {
        printf("idle_count = %d\n", idle_count);
        idle_count++;
		for(i=0;i<0xFFFFFF;i++);
    }

    return 0;
}




