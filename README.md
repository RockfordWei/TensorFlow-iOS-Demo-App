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
  strip_unused_nodes(type=float, shape="1,512,512,3")
  fold_constants(ignore_errors=true)
  fold_batch_norms
  fold_old_batch_norms'
	
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

Alright @cwhipkey it worked! The full solution I used is as follows:

Build the print_selective_registration_header with the right macro for iOS
//$ bazel build --copt="-DUSE_GEMM_FOR_CONV" tensorflow/python/tools/print_selective_registration_header
Generate a header in the right path, i.e.
$ bazel-bin/tensorflow/python/tools/print_selective_registration_header --graphs=$(PROJECT_DIR).pb > tensorflow/core/framework/ops_to_register.h
In my case, the resulting libtensorflow-core.a is 45% smaller, the universal .ipa is 6.1MB lighter, and the unzipped payload is 19.5MB lighter. (Of course, your mileage may vary depending on the graph you are using selective registration on.) Thanks everyone!
