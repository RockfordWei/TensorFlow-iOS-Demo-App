# Tensorflow iOS Application without CocoaPod:


## Best Practice to import TensorFlow Framework into iOS

- Prepare a new fresh iOS Xcode project, with:
	TFLib.h with extern functions
	TFLib.mm with extern “C” declare also with C++ implements

- Clone TensorFlow
- goto TensorFlow/tensorflow/contrib/makefile

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
