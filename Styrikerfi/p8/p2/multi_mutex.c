//adalsteinnm20 leifurb20

#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <alloca.h>

#include "multi_mutex.h"

int multi_mutex_unlock(pthread_mutex_t **mutexv, int mutexc)
{
    int res_unlocking;
    for(int i=0; i<mutexc; i++){
        res_unlocking = pthread_mutex_unlock(&*mutexv[i]);
        if(res_unlocking == -1){return -1;}
    }
    return 0;
}

int multi_mutex_trylock(pthread_mutex_t **mutexv, int mutexc)
{
    int res_locking;
    for (int i=0; i < mutexc; i++){
        res_locking = pthread_mutex_trylock(&*mutexv[i]);
        if(res_locking != 0){
            for(int j=0; j < i; j++){
                pthread_mutex_unlock(&*mutexv[j]);
            }
            return -1;
        }
    }
    return 0;
}

