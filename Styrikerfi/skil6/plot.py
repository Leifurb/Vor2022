#! /usr/bin/env python3
import os

import subprocess
import matplotlib.pyplot as plt
import numpy as np

#cacheSizes = np.arange(0, 120, 20)
cacheSizes = np.arange(1, 5)
policies = ["FIFO", "LRU", "OPT", "RAND"]
hitRates = []

for cacheSize in cacheSizes:
    hitRate = []
    for policy in policies:
        result = subprocess.run(["python3","paging-policy.py", "-c", "-p", policy,
            "-f", "./vpn2.txt", "-C", str(cacheSize)], stdout=subprocess.PIPE)
        result = result.stdout.decode('utf-8')
        hitRate.append(result)
    hitRates.append(hitRate)

for i in range(len(policies)):
    plt.plot(cacheSizes, hitRates[i])

plt.legend(policies)
plt.margins(0)
plt.xticks(cacheSizes, cacheSizes)
plt.xlabel('Cache Size (Blocks)')
plt.ylabel('Hit Rate')
plt.savefig('workload.png', dpi=227)