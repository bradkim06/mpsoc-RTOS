
#include <kernel.h>
#include <s5pv310.h>
#include <scheduler.h>
#include <task.h>

#include <test.h>

struct STask task0,task1,task2;
unsigned char task0_stack[2048],
			  task1_stack[2048],
			  task2_stack[2048];

int Task0_main(void *args);
int Task1_main(void *args);
int Task2_main(void *args);

int Init_task_main(void *args)
{
	printf("init task start.....\n");

	//Task_init(&task0, Task0_main, 0, 10, task0_stack,sizeof(task0_stack));	
	//Task_init(&task1, Task1_main, 0, 10, task1_stack,sizeof(task1_stack));	
	//Task_init(&task2, Task2_main, 0, 10, task2_stack,sizeof(task2_stack));	

	Task_init(&task0, &Task0_main,(void*)0, 31, task0_stack,sizeof(task0_stack));	
	Task_init(&task1, &Task0_main,(void*)1, 31, task1_stack,sizeof(task1_stack));	
	//Task_init(&task2, &Task0_main,(void*)2, 31, task2_stack,sizeof(task2_stack));	
	
	return 0;

}



void set_reg(unsigned int addr, unsigned int data)
{
	*(volatile unsigned int*)(addr) = data;
	printf("addr:0x%08x, setdata:0x%08x, realdata:0x%08x\n",addr,data,*(volatile unsigned int*)(addr));
}


int Task0_main(void *args)
{
	unsigned int temp;
	int i,ram_addr = 0x40000000;



	while(1)
	{
		printf("Task0_%d\n",(unsigned int)args);
		//temp = (*(volatile unsigned int*)(ELFIN_TIMER_BASE+0x40));
		//printf("timer=%d\n",temp);
		//temp = *(volatile unsigned int*)(0x10490D08);

//		temp = *(volatile unsigned int*)(0x139D0000+0x0044);
//		printf("0x%08x\n",temp);
//		if(temp & (1<<9))
		{
//			printf("clear interrupt \n");
//			*(volatile unsigned int*)(0x139D0000+0x0044) |= (1<<9);
			temp = *(volatile unsigned int*)(0x139D0000+0x0044);
			printf("0x%08x  ",temp);
			printf("0x%08x  ",*(volatile unsigned int*)(0x139D0000+0x3C));
			printf("0x%08x  ",*(volatile unsigned int*)(0x139D0000+0x40));
		}
		printf("\n");
		for(i=0;i<0xFFFFF;i++);
//		{
//			*(unsigned int*)(ram_addr+i) = i;
//			if(*(unsigned int*)(ram_addr+i) != i)
//					break;
//		}
//		if(i != 0xFFFF)
//			printf("ram read error 0\n");
//		Task_yield();
	}
}

int Task1_main(void *args)
{
	int i,ram_addr = 0x50000000;
	while(1)
	{
		printf("Task1\n");
		for(i=0;i<0xFFFFF;i++);
//		{
//			*(unsigned int*)(ram_addr+i) = i;
//			if(*(unsigned int*)(ram_addr+i) != i)
//					break;
//		}
//		if(i != 0xFFFF)
//			printf("ram read error 1\n");
		Task_yield();
	}	
}

int Task2_main(void *args)
{
	int i,ram_addr = 0x60000000;
	while(1)
	{
		printf("Task2\n");
		for(i=0;i<0xFFFFF;i++);
//		{
//			*(unsigned int*)(ram_addr+i) = i;
//			if(*(unsigned int*)(ram_addr+i) != i)
//					break;
//		}
//		if(i != 0xFFFF)
//			printf("ram read error 2\n");
		Task_yield();
	}
}

