# Tensorflow iOS Application without CocoaPod:


## Best Practice to import TensorFlow Framework into iOS

- Prepare a new fresh iOS Xcode project, with:
	TFLib.h with extern functions
	TFLib.mm with extern “C” declare also with C++ implements

- git clone TensorFlow, install virtual environment and MUST `source activate` the virtual environment.
- goto TensorFlow/tensorflow/contrib/makefile
- `bazel clean --expunge`
- modify Makefile line 52 to `ANDROID_TYPES := -D__ANDROID_TYPES_FULL__`, which the original SLIM would cause session failure.
``` bash
#bazel build tensorflow/tools/graph_transforms:transform_graph
bazel-bin/tensorflow/tools/graph_transforms/transform_graph \
--in_graph=$(PROJECT_DIR)/frozen_inference_graph.pb \
--out_graph=$(PROJECT_DIR)/mobile_inception_graph.pb \
--inputs='image_tensor' \
--outputs='num_detections,detection_boxes,detection_scores,detection_classes' \
--transforms='
  add_default_attributes
  strip_unused_nodes(type=float, shape="1,512,512,3")
  remove_nodes(op=Identity, op=CheckNumerics)
  fold_constants(ignore_errors=true)
  fold_batch_norms
  fold_old_batch_norms
  quantize_weights
  quantize_nodes
  flatten_atrous_conv
  merge_duplicate_nodes
  remove_device
  strip_unused_nodes
  sort_by_execution_order'
	
$ build_all_ios.sh -a x86_64 -g $(PROJECT_DIR)/xxx.pb # for simulator, or armv7 / armv7s for real phone
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
-force_load $(PROJECT_DIR)/tensorflow_experimental.framework/tensorflow_experimental
```


## Important Fix
https://github.com/tensorflow/tensorflow/issues/9073

$ bazel-bin/tensorflow/python/tools/print_selective_registration_header --graphs=$(PROJECT_DIR).pb > tensorflow/core/framework/ops_to_register.h
