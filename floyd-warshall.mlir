
#floyd_warshall_trait = {
  doc = "W_k(i, j) = W_{k-1}(i, j) .min [W(:, k) .+ W(k, :)] foreach k in N",
  indexing_maps = [
    affine_map<(i, j) -> (i)>,
    affine_map<(i, j) -> (j)>,
    affine_map<(i, j) -> (i, j)>
  ],
  iterator_types = ["parallel", "parallel"]
}

module {

memref.global constant @adj : memref<36x36xi8> = dense<[
  [0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
  [1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0],
  [0,1,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
  [0,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0],
  [0,0,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0],
  [0,0,0,0,1,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
  [0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0],
  [0,0,0,0,0,1,0,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
  [0,0,0,0,0,0,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
  [0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0],
  [0,0,1,0,0,0,0,1,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
  [0,0,0,0,0,0,0,0,0,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0],
  [0,0,0,0,0,0,0,0,0,0,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
  [0,0,0,0,0,0,0,0,0,0,0,0,1,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
  [0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0],
  [0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
  [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0],
  [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
  [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0],
  [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0],
  [0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
  [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
  [0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
  [0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
  [0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
  [0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
  [0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
  [0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
  [0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
  [0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
  [0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
  [0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
  [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
  [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
  [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
  [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
  ]>

func.func @make_weights(%A : tensor<36x36xi8>) -> tensor<36x36xf32> {
  %inf = arith.constant 0x7F800000 : f32
  %0 = arith.constant 0. : f32
  %1 = arith.constant 1. : f32
  %i0 = arith.constant 0 : i8
  
  %empty = tensor.empty() : tensor<36x36xf32>

  %W = linalg.generic {
      indexing_maps = [affine_map<(i, j) -> (i, j)>, affine_map<(i, j) -> (i, j)>],
      iterator_types = ["parallel", "parallel"]}
      ins(%A : tensor<36x36xi8>) outs(%empty : tensor<36x36xf32>) {
    ^bb0(%a : i8, %w : f32): // FIXME: %w not really needed here...
      %isadjacent = arith.cmpi ne, %a, %i0 : i8
      %res = arith.select %isadjacent, %1, %inf : f32
      linalg.yield %res : f32
  } -> tensor<36x36xf32>

  %Wdiag = linalg.generic {
      indexing_maps = [affine_map<(i) -> (i, i)>],
      iterator_types = ["parallel"]}
      outs(%W : tensor<36x36xf32>) {
    ^bb0(%w : f32):
      linalg.yield %0 : f32
  } -> tensor<36x36xf32>

  return %Wdiag : tensor<36x36xf32>
}

func.func @all_to_all_shortest_paths(%W: tensor<36x36xf32>) -> tensor<36x36xf32> {
  %begin = index.constant 0
  %end = index.constant 36
  %step = index.constant 1
  %Wmin = scf.for %k = %begin to %end step %step iter_args(%Wprev = %W) -> (tensor<36x36xf32>) {
    %column = tensor.extract_slice %Wprev[0, %k] [36, 1] [1, 1] 
              : tensor<36x36xf32> to tensor<36xf32>
    %row = tensor.extract_slice %Wprev[%k, 0] [1, 36] [1, 1]
           : tensor<36x36xf32> to tensor<36xf32>
    %Wnext = linalg.generic #floyd_warshall_trait
    ins(%column, %row : tensor<36xf32>, tensor<36xf32>)
    outs(%Wprev : tensor<36x36xf32>)
    {
    ^bb0(%a: f32, %b: f32, %c: f32) :
      %newpath = arith.addf %b, %c : f32
      %min = arith.minf %a, %newpath : f32
      linalg.yield %min : f32
    } -> tensor<36x36xf32>
    scf.yield %Wnext : tensor<36x36xf32>
  }
 func.return %Wmin : tensor<36x36xf32>
}

// FIXME: understand why affine.for with loop-carry tensors breaks affine.yield
// func.func @affine_loopcarry_fill(%M: tensor<1024xf32>) -> tensor<1024xf32> {
//   %Mres = affine.for %i = 0 to 10
//     iter_args(%Mcur = %M) -> tensor<1024xf32> {
//     %ii = arith.index_castui %i : index to i32
//     %fi = arith.uitofp %ii : i32 to f32
//     %Mnext = linalg.fill ins(%fi : f32)
//                          outs(%Mcur : tensor<1024xf32>) -> tensor<1024xf32>
//     affine.yield %Mnext : tensor<1024xf32>
//   }
//   return %Mres : tensor<1024xf32>
// }

func.func @main() {
  %adj_memref = memref.get_global @adj : memref<36x36xi8>
  %A = bufferization.to_tensor %adj_memref : memref<36x36xi8>

  %W = func.call @make_weights(%A) : (tensor<36x36xi8>) -> tensor<36x36xf32>
  %Wmin = func.call @all_to_all_shortest_paths(%W) : (tensor<36x36xf32>) -> tensor<36x36xf32>
  // TODO: vector.transfer_read -> vector.print
  func.return
}

}