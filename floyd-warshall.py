#!/usr/bin/env python3

import pysmiles
import fileinput
import networkx
import sys
import numpy as np

def floyd_warshall(D):
    assert len(D.shape) == 2
    assert D.shape[0] == D.shape[1]
    N = D.shape[0]
    for k in range(N):
        O = np.add.outer(D[:, k], D[k, :])
        D = np.minimum(D, O)
    return D

if __name__ == "__main__":
    for line in fileinput.input():
        mol = pysmiles.read_smiles(line, explicit_hydrogen=False)
        A = networkx.to_numpy_array(mol)
        np.set_printoptions(threshold=sys.maxsize)
        A[A == 0] = np.inf
        np.fill_diagonal(A, 0)
        print(A)
        D = floyd_warshall(A.copy())
        print(D)
