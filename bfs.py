#!/usr/bin/env python3

import pysmiles
import fileinput
import networkx
import numpy as np


def bfs(A, source=0):
    N = A.shape[0]
    d = np.zeros((N), dtype=np.uint8)
    d[source] = 1
    v = d
    for k in range(1, N+1):
        v = A.dot(v) * np.logical_not(d)
        nxt = v != 0
        if not np.any(nxt):
            break
        d[nxt] = k + 1
    return d - 1


if __name__ == "__main__":
    for line in fileinput.input():
        mol = pysmiles.read_smiles(line, explicit_hydrogen=False)
        A = networkx.to_numpy_array(mol, dtype=np.uint8)
        d = bfs(A, source=1)
        print(d)
