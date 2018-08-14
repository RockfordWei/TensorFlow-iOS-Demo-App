# Tensorflow iOS Application without CocoaPod:


## Best Practice to import TensorFlow Framework into iOS

- Prepare a new fresh iOS Xcode project, with:
	TFLib.h with extern functions
	TFLib.mm with extern “C” declare also with C++ implements

- git lone TensorFlow then `git checkout r1.10`
- `bazel build --config opt //tensorflow/tools/lib_package:libtensorflow`
- goto TensorFlow/tensorflow/contrib/makefile

- add extra files to `tf_op_files.txt` :

```
tensorflow/cc/framework/cc_op_gen.cc
tensorflow/cc/framework/grad_op_registry.cc
tensorflow/cc/framework/gradient_checker.cc
tensorflow/cc/framework/gradients.cc
tensorflow/cc/framework/ops.cc
tensorflow/cc/framework/scope.cc
tensorflow/cc/framework/while_gradients.cc
tensorflow/cc/ops/array_ops.cc
tensorflow/cc/ops/array_ops_internal.cc
tensorflow/cc/ops/audio_ops.cc
tensorflow/cc/ops/audio_ops_internal.cc
tensorflow/cc/ops/candidate_sampling_ops.cc
tensorflow/cc/ops/candidate_sampling_ops_internal.cc
tensorflow/cc/ops/const_op.cc
tensorflow/cc/ops/control_flow_ops.cc
tensorflow/cc/ops/control_flow_ops_internal.cc
tensorflow/cc/ops/data_flow_ops.cc
tensorflow/cc/ops/data_flow_ops_internal.cc
tensorflow/cc/ops/image_ops.cc
tensorflow/cc/ops/image_ops_internal.cc
tensorflow/cc/ops/io_ops.cc
tensorflow/cc/ops/io_ops_internal.cc
tensorflow/cc/ops/linalg_ops.cc
tensorflow/cc/ops/linalg_ops_internal.cc
tensorflow/cc/ops/logging_ops.cc
tensorflow/cc/ops/logging_ops_internal.cc
tensorflow/cc/ops/lookup_ops.cc
tensorflow/cc/ops/lookup_ops_internal.cc
tensorflow/cc/ops/manip_ops.cc
tensorflow/cc/ops/manip_ops_internal.cc
tensorflow/cc/ops/math_ops.cc
tensorflow/cc/ops/math_ops_internal.cc
tensorflow/cc/ops/nn_ops.cc
tensorflow/cc/ops/nn_ops_internal.cc
tensorflow/cc/ops/no_op.cc
tensorflow/cc/ops/no_op_internal.cc
tensorflow/cc/ops/parsing_ops.cc
tensorflow/cc/ops/parsing_ops_internal.cc
tensorflow/cc/ops/random_ops.cc
tensorflow/cc/ops/random_ops_internal.cc
tensorflow/cc/ops/sparse_ops.cc
tensorflow/cc/ops/sparse_ops_internal.cc
tensorflow/cc/ops/state_ops.cc
tensorflow/cc/ops/state_ops_internal.cc
tensorflow/cc/ops/string_ops.cc
tensorflow/cc/ops/string_ops_internal.cc
tensorflow/cc/ops/training_ops.cc
tensorflow/cc/ops/training_ops_internal.cc
tensorflow/cc/ops/user_ops.cc
tensorflow/cc/ops/user_ops_internal.cc
tensorflow/cc/ops/while_loop.cc
```

``` bash
$ build_all_ios.sh -a x86_64 # for simulator, or armv7 / armv7s for real phone
$ ./create_ios_framework
```

- Unzip the framework to anywhere
- Drag framework (copy if need) to Xcode (Do not embed it)

- Add Search Header:

```
$(PROJECT_DIR)/tensorflow_experimental.framework/Headers
$(PROJECT_DIR)/tensorflow_experimental.framework/Headers/third_party/eigen3
```

- Add Search Lib:
```
$(PROJECT_DIR)/tensorflow_experimental.framework
```

- Manually copy libnsync.a to the framework path

- Add other linker flags:

```
-lprotobuf_experimental
-lnsync
```
