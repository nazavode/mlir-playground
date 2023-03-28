#!/usr/bin/env python3

import pysmiles
import fileinput
import networkx
import sys
import numpy as np


def printrow(row, stream=sys.stdout):
    print(f"  {row.flatten().tolist()[0]},")


if __name__ == "__main__":
    for line in fileinput.input():
        mol = pysmiles.read_smiles(line, explicit_hydrogen=True)
        adj = networkx.to_numpy_matrix(mol, dtype=np.int8)
        print(mol, file=sys.stderr)
        print(
            f"memref.global constant @adj : memref<{adj.shape[0]}x{adj.shape[1]}xi8> = dense<["
        )
        np.apply_along_axis(printrow, axis=1, arr=adj)
        print("]>")
