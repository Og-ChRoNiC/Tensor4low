// RUN: tf-mlir-translate -mlir-tf-to-hlo-text %s -tf-input-shapes=: -emit-return-tuple | FileCheck %s
// RUN: tf-mlir-translate -mlir-tf-to-hlo-text %s -tf-input-shapes=: -emit-use-tuple-args -emit-return-tuple | FileCheck -check-prefix=TUPLE-ARGS %s

module attributes {tf.versions = {producer = 179 : i32}} {
  func @main(%arg0: tensor<f32>, %arg1: tensor<f32>) -> tensor<f32> {
    %0 = "tf.AddV2"(%arg0, %arg1) : (tensor<f32>, tensor<f32>) -> tensor<f32>
    return %0 : tensor<f32>
  }
}

// CHECK-LABEL: HloModule main
// CHECK:       ENTRY %main.{{[0-9]+}} ([[ARG0:.*]]: f32[], [[ARG1:.*]]: f32[]) -> (f32[]) {
// CHECK-NEXT:    %[[ARG0]] = f32[] parameter(0)
// CHECK-NEXT:    %[[ARG1]] = f32[] parameter(1)
// CHECK-NEXT:    [[ADD:%.*]] = f32[] add(f32[] %[[ARG0]], f32[] %[[ARG1]])
// CHECK-NEXT:    ROOT %tuple.{{[0-9]+}} = (f32[]) tuple(f32[] [[ADD]])
// CHECK-NEXT:  }

// CHECK:       // InputMapping {0, 1}
// CHECK-NEXT:  // XlaInputShape f32[]
// CHECK-NEXT:  // XlaInputShape f32[]
// CHECK-NEXT:  // XlaOutputShape (f32[])
// CHECK-NEXT:  // XlaOutputDescription type=float shape=()


// TUPLE-ARGS-LABEL: HloModule main
// TUPLE-ARGS:       ENTRY %main.{{[0-9]+}} ([[ARG_TUPLE:.*]]: (f32[], f32[])) -> (f32[]) {
// TUPLE-ARGS:         %[[ARG_TUPLE]] = (f32[], f32[]) parameter(0)
// TUPLE-ARGS:         [[ARG0:%.*]] = f32[] get-tuple-element((f32[], f32[]) %[[ARG_TUPLE]]), index=0
// TUPLE-ARGS:         [[ARG1:%.*]] = f32[] get-tuple-element((f32[], f32[]) %[[ARG_TUPLE]]), index=1
// TUPLE-ARGS:         [[ADD:%.*]] = f32[] add(f32[] [[ARG0]], f32[] [[ARG1]])
// TUPLE-ARGS:         ROOT %tuple.{{[0-9]+}} = (f32[]) tuple(f32[] [[ADD]])
// TUPLE-ARGS:       }

// TUPLE-ARGS:       // InputMapping {0, 1}
// TUPLE-ARGS-NEXT:  // XlaInputShape (f32[], f32[])
// TUPLE-ARGS-NEXT:  // XlaOutputShape (f32[])
// TUPLE-ARGS-NEXT:  // XlaOutputDescription type=float shape=()
