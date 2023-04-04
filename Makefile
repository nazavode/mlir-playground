OPT       = mlir-opt
TRANSLATE = mlir-translate

OPTFLAGS =
OPTFLAGS += --eliminate-empty-tensors
OPTFLAGS += --empty-tensor-to-alloc-tensor
OPTFLAGS += --one-shot-bufferize="bufferize-function-boundaries allow-return-allocs"

# Current lowering of all_to_all_shortest needs to save tensors
# coming from previous iterations: let's hoist allocs out of
# loop nests:
OPTFLAGS += --buffer-loop-hoisting

# Pretty standard lowering strategy down to llvm:
# taken straight from the 'test-lower-to-llvm' pass,
# the sequence below should be identical to:
# OPTFLAGS += --test-lower-to-llvm

# Blanket-convert any remaining high-level vector ops to loops if any remain.
OPTFLAGS += --convert-vector-to-scf
# Blanket-convert any remaining linalg ops to loops if any remain.
OPTFLAGS += --convert-linalg-to-loops
# Blanket-convert any remaining affine ops if any remain.
OPTFLAGS += --lower-affine
# Convert SCF to CF (always needed).
OPTFLAGS += --convert-scf-to-cf
# Sprinkle some cleanups.
OPTFLAGS += --canonicalize
OPTFLAGS += --cse
# Blanket-convert any remaining linalg ops to LLVM if any remain.
OPTFLAGS += --convert-linalg-to-llvm
# Convert vector to LLVM (always needed).
OPTFLAGS += --convert-vector-to-llvm=reassociate-fp-reductions
# Convert Math to LLVM (always needed).
OPTFLAGS += --convert-math-to-llvm
# Expand complicated MemRef operations before lowering them.
OPTFLAGS += --expand-strided-metadata
# The expansion may create affine expressions. Get rid of them.
OPTFLAGS += --lower-affine
# Convert MemRef to LLVM (always needed).
OPTFLAGS += --convert-memref-to-llvm
# Convert Func to LLVM (always needed).
OPTFLAGS += --convert-func-to-llvm
# Convert Index to LLVM (always needed).
OPTFLAGS += --convert-index-to-llvm
# Convert remaining unrealized_casts (always needed).
OPTFLAGS += --reconcile-unrealized-casts

.PRECIOUS: %.llvm.mlir

%.llvm.mlir: %.mlir
	$(OPT) $(OPTFLAGS) -o $@ $<

%.ll: %.llvm.mlir
	$(TRANSLATE) --mlir-to-llvmir -o $@ $<
