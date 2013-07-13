#include<stdio.h>

void  *memmove(void *dest, const void *src, size_t count) 
 { 
        assert((src != NULL)&&(dest != NULL));  
        char *tmp, *s;
 
 　　    if (dest <= src) 
        { 
               tmp = (char *) dest; 
               s = (char *) src; 
 　　　　       while (count--) 
                      *tmp++ = *s++; 
        } 
        else { 
               tmp = (char *) dest + count; 
               s = (char *) src + count; 
 　　　　       while (count--) 
                       *--tmp = *--s; 
        } 
 　 　return dest; 
} 
