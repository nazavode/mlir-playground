OPT = mlir-opt

OPTFLAGS = 
OPTFLAGS += --one-shot-bufferize
OPTFLAGS += --convert-linalg-to-affine-loops
OPTFLAGS += --convert-func-to-llvm
OPTFLAGS += --convert-memref-to-llvm
OPTFLAGS += --convert-index-to-llvm
OPTFLAGS += --convert-arith-to-llvm
OPTFLAGS += --convert-scf-to-cf
OPTFLAGS += --convert-cf-to-llvm
OPTFLAGS += --lower-affine
OPTFLAGS += --reconcile-unrealized-casts

%.opt.mlir: %.mlir
	$(OPT) $(OPTFLAGS) -o $@ $<
