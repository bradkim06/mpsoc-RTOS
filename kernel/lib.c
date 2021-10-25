/* vi: set ts=4 sw=4 sts=4 expandtab: */

#include <kernel.h>
#include <vsprintf.h>

#define SIGN	            1		/* unsigned/signed long */
#define LARGE	            2		/* converts lower alphabet to higher one */
#define BUFFER_SIZE         1024


/*
 * DECLARES INTERNEL FUNCTIONS
 */
static int ffmt(char *buf, const char *fmt, va_list args);


/*
 * FUNTIONS EXPORTED
 */
int vsprintf(char *buf, const char *fmt, va_list args) {
	return ffmt(buf, fmt, args);
}


int sprintf(char *buf, const char *fmt, ...) {
	va_list args;
	int i;

	va_start(args, fmt);
	i=vsprintf(buf,fmt,args);
	va_end(args);

	return i;
}

/*
 * INTERNEL FUNCTIONS
 */
static int ffmt(char *buf, const char *fmt, va_list args) {
	char *str, temp, numtemp[33], *numptr, prefix;
	unsigned int number, base, flag, width;

	str = buf;
	numtemp[32]=0;

	for (; *fmt ; fmt++) {
		/* normal character */
		if (*fmt != '%') {
			*str = *fmt;
			++str;
			continue;
		}

		/* flag process */
		fmt++;
		flag=0;
		prefix = ' ';
		width=0;

		if(*fmt == '0')
			prefix='0';

		while(*fmt >= '0' && *fmt <= '9') {
			width=(width * 10) + (*(fmt++) - '0');
		}

		switch(*fmt) {
			case 'c':
				*str++ = va_arg(args, char);
				continue;
			case 's':
				numptr = va_arg(args, char *);
				while(*numptr != 0)
					*str++ = *numptr++;
				continue;
			case '%':
				*str++ = '%';
				continue;
			case 'b':
				base = 2;
				break;
			case 'd':	case 'i':
				flag |= SIGN;
			case 'u':
				base = 10;
				break;
			case 'o':
				base = 8;
				break;
			case 'X':
				flag |= LARGE;
			case 'x':
				base = 16;
				break;
			default:
				continue;
		}

		/* number */
		numptr = &numtemp[31];
		number = va_arg(args, unsigned int);

		if( (flag&SIGN) && (number&0x80000000) ) {
			number = ~number + 1;	/* 2's complement */
			*str++ = '-';	/* '-';;;; */
		}

		do {
			temp = number%base;
			if(temp > 9) {
				temp += ((flag & LARGE ? 'A' : 'a') - 10);
			} else {
				temp += '0';
			}
			*numptr-- = temp;
			if(width > 0) width--;
		} while(number/=base);

		if(width > 0) {
			while(width-- != 0)
				*numptr-- = prefix;
		}
		while((temp = *(++numptr))) {
			*str++ = temp;
		}
	}
	*str = 0;

	return (int)(str-buf+1);
}


extern void uart_putc(int);

inline void putchar(char ch) {
    uart_putc(ch);
    
    if (ch == '\n') 
        uart_putc('\r');
}


inline void puts(const char *str) {
    while (*str != 0) {
        putchar(*str);
        str++;
    }
}


void printf(const char *fmt, ...) {
	char str[BUFFER_SIZE];
	va_list args;

	va_start(args, fmt);
	vsprintf(str, fmt, args);
	puts(str);
}


void delay(unsigned int cnt) {
    while (cnt--);
}


void raise(void) {
    printf("error: raise()\n");
}



