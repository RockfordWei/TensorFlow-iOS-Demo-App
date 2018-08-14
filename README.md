# Tensorflow iOS Application without CocoaPod:


## Best Practice to import TensorFlow Framework into iOS

- Prepare a new fresh iOS Xcode project, with:
	TFLib.h with extern functions
	TFLib.mm with extern “C” declare also with C++ implements

- git lone TensorFlow
- goto TensorFlow/tensorflow/contrib/makefile
- modify line 52 to `ANDROID_TYPES := -D__ANDROID_TYPES_FULL__`, which the original SLIM would cause session failure.
- 
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
-force_load $(PROJECT_DIR)/tensorflow_experimental.framework/tensorflow_experimental
```
