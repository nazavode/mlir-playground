#!/usr/bin/env python3

import pysmiles
import fileinput
import networkx
import sys
import numpy as np

if __name__ == "__main__":
    for line in fileinput.input():
        mol = pysmiles.read_smiles(line, explicit_hydrogen=True)
        adj = networkx.to_numpy_matrix(mol, dtype=np.int8)
        print(mol, file=sys.stderr)
        np.savetxt(sys.stdout, adj, fmt="%i", delimiter=",")
