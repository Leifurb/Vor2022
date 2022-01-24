#include "parseint.h"
#include <string.h>

/*
 * Returns the value of c or -1 on error
 */

int parseDecimalChar(char c)
{
    (void)c;

    int i = (int)c - '0';
    if (i < 0  || i >= 9){
        return -1;
    }
    else{
        return i;
    }
}

int parseInt(char *string)
{
    (void)string;
    int lenght = strlen(string) - 1;
    int res = 0;
    int power = 1;
    
    if (string[0] == '0'){
        while (lenght >= 0){
                int temp = parseDecimalChar(string[lenght]);
                if (temp < 8 && temp != -1){
                    res += temp *power;
                    power *= 8;
                }
                else{
                        return -1;
                }
                lenght--;
        }
        return res;
    }
    else{
        while (lenght >= 0){
                int temp = parseDecimalChar(string[lenght]);
                if (temp != -1){
                    res += temp *power;
                    power *= 10;
                }
                else{
                        return -1;
                }
                lenght--;
        }
        return res;
    }
}