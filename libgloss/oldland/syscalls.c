/*
 * Copyright (c) 2015 Jamie Iles
 *
 * The authors hereby grant permission to use, copy, modify, distribute,
 * and license this software and its documentation for any purpose, provided
 * that existing copyright notices are retained in all copies and that this
 * notice is included verbatim in any distributions. No written agreement,
 * license, or royalty fee is required for any of the authorized uses.
 * Modifications to this software may be copyrighted by their authors
 * and need not follow the licensing terms described here, provided that
 * the new terms are clearly indicated on the first page of each file where
 * they apply.
 */
#include <errno.h>

#define UART_STATUS_TX_EMPTY	(1 << 0)
#define UART_STATUS_RX_READY	(1 << 1)
#define UART_DATA_OFFS		0x0
#define UART_STATUS_OFFS	0x4
#define UART_BASE		0x80000000

static inline unsigned long readl(unsigned long addr)
{
	volatile unsigned long *p = (volatile unsigned long *)addr;

	return *p;
}

static inline void writel(unsigned long v, unsigned long addr)
{
	volatile unsigned long *p = (volatile unsigned long *)addr;

	*p = v;
}

static void oldland_serial_putc(char c)
{
	if (c == '\n')
		oldland_serial_putc('\r');
	while (!(readl(UART_BASE + UART_STATUS_OFFS) &
		 UART_STATUS_TX_EMPTY))
		continue;
	writel((unsigned char)c, UART_BASE + UART_DATA_OFFS);
}

static int oldland_serial_tstc(void)
{
	return (readl(UART_BASE + UART_STATUS_OFFS) &
		UART_STATUS_RX_READY);
}

static int oldland_serial_getc(void)
{
	while (!(readl(UART_BASE + UART_STATUS_OFFS) &
		 UART_STATUS_RX_READY))
		continue;
	return readl(UART_BASE + UART_DATA_OFFS) & 0xff;
}

int _write(int fd, char *buf, int len)
{
	int i = 0;

	while (i < len)
		oldland_serial_putc(buf[i++]);

	return len;
}

int _read(int fd, char *buf, int len)
{
	if (len == 0)
		return 0;

	buf[0] = oldland_serial_getc();

	return 1;
}

void _exit(int status)
{
	asm volatile("bkp" ::: "memory");

	for (;;)
		continue;
}

int _close(int fd)
{
	errno = ENOSYS;
	return -1;
}

_off_t
_lseek(int file, _off_t ptr, int dir)
{
	errno = ENOSYS;
	return -1;
}
