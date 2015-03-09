/* sbrk.c -- allocate memory dynamically.
 * 
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
#include "glue.h"

/* just in case, most boards have at least some memory */
#define RAMSIZE             (caddr_t)0x02000000
#define STACK_RESERVED_BYTES 65536

char *__heap_ptr = (char *)&_end;

/*
 * sbrk -- changes heap size size. Get nbytes more
 *         RAM. We just increment a pointer in what's
 *         left of memory on the board.
 */
char *
_sbrk (nbytes)
     int nbytes;
{
  char *base;
  char *sp;

  base = __heap_ptr;
  __heap_ptr += nbytes;

  return base;
}
