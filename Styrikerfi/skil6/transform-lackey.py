#!/usr/bin/env python3

# Put your script here (instead of the print statements)
# Your script shall read the valgrind output on stdin,
# and produce a list of newline-separated lines of virtual page numbers
import sys
NUMBERS = []

for line in sys.stdin:
    if line[0] != '=':
        address = "0x" + line.strip("ILSM ").split(",")[0]

        intnumb = str((int("0x" + line[3:11], 16) & 0xfffff000) >> 12) + "\n"       
        NUMBERS.append(intnumb)

for i in NUMBERS:
    print(i)



