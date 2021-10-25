#ifndef __TASK_H__
#define __TASK_H__


#define TASK_STATE_READY	(1 << 0)
//#define TASK_STATE_RUNNING	(1 << 1)
#define TASK_STATE_WAITING	(1 << 2)
#define TASK_STATE_ZOMBI	(1 << 3)


struct STask {
	struct STask *next;
	struct STask *prev;

	unsigned int id;
	unsigned int prio;
	unsigned int state;

	unsigned char *stack_addr;
	unsigned char *stack_pointer;
	unsigned int stack_size;

	unsigned int time_quantum;
	int (*Start_function)(void *);
	void *args;
};


extern struct STask *current_task;
extern struct STask idle_task;
extern struct STask init_task;
extern unsigned char idle_stack[CONFIG_TASK_STACK_SIZE];
extern unsigned char init_stack[CONFIG_TASK_STACK_SIZE];


extern int Init_idle_task(void);
extern int Task_init(struct STask *task, int(*Start_function)(void *), void *args, unsigned prio,
	unsigned char *stack_addr, unsigned int stack_size);
extern void Task_init_context(struct STask *task);
extern int Task_exit(void);
extern struct STask *Task_getID(void);
extern int Task_yield(void);
extern int Task_get_priority(struct STask *task);
extern int Task_set_priority(struct STask *task, unsigned int prio);

#endif

