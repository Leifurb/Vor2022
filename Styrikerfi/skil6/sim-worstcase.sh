#!/bin/sh
. ./def-worstcase.sh
#echo "Performance of your 6.1a worst case reference string:"
#python3 paging-policy.py -a ${WORST20ALL} -C 5 -p FIFO -c
#python3 paging-policy.py -a ${WORST20ALL} -C 5 -p LRU -c
#python3 paging-policy.py -a ${WORST20ALL} -C 5 -p CLOCK -c
#python3 paging-policy.py -a ${WORST20ALL} -C 5 -p OPT -c

echo "Performance of your 6.1b worst case reference string:"
#python3 paging-policy.py -a ${WORST5FIFO} -C 4 -p FIFO -c
#python3 paging-policy.py -a ${WORST5LRU} -C 4 -p LRU -c
python3 paging-policy.py -a ${WORST5MRU} -C 4 -p CLOCK -c

