#ifndef __KERNEL_H__
#define __KERNEL_H__

#define CONFIG_TASK_STACK_SIZE      8192
#define CONFIG_EXCEPT_STACK_SIZE    8192
#define CONFIG_MAX_PRIORITY         256

//#define __REG(reg)  (*(volatile unsigned int *)(reg))

#include <hal.h>

#ifndef __ASSEMBLY__
void printf(const char *fmt, ...);
inline void puts(const char *str);
inline void putchar(char ch);
int sprintf(char *buf, const char *fmt, ...);
void delay(unsigned int cnt);
#endif /* __ASSEMBLY__ end. */

#endif /* __KERNEL_H__ end. */


