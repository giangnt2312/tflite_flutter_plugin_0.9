import 'dart:ffi';
import 'dart:io';

import 'package:path/path.dart' as Path;

const Set<String> _supported = {'linux', 'mac', 'win'};

String get binaryName {
  String os, ext;
  if (Platform.isLinux) {
    os = 'linux';
    ext = 'so';
  } else if (Platform.isMacOS) {
    os = 'mac';
    ext = 'so';
  } else if (Platform.isWindows) {
    os = 'win';
    ext = 'dll';
  } else {
    throw Exception('Unsupported platform!');
  }

  if (!_supported.contains(os)) {
    throw UnsupportedError('Unsupported platform: $os!');
  }

  return 'libtensorflowlite_c-$os.$ext';
}

/// TensorFlowLite C library.
// ignore: missing_return
DynamicLibrary tflitelib = () {
  if (Platform.isAndroid) {
    try {
      DynamicLibrary lib = DynamicLibrary.open('libtensorflowlite_c.so');
      print("successfully loaded libtensorflowlite_c");
      return lib;
    } catch (e) {
      print("fail, trying workarounds...");
      try {
        String pathLibTensorFlowLite = TfliteData.shared.pathLibTensorFlowLite;
        if (pathLibTensorFlowLite.isEmpty) {
          print("fail, trying workarounds pathLibTensorFlowLite empty...");
          rethrow;
        }
        // DynamicLibrary lib = DynamicLibrary.open("$pathLibTensorFlowLite/libtensorflowlite_c.so");
        DynamicLibrary lib = DynamicLibrary.open(pathLibTensorFlowLite);
        print("successfully loaded libtensorflowlite_c with strange workaround at $pathLibTensorFlowLite");
        return lib;
      } catch (_) {
        print("fail, trying path native workarounds...");
        rethrow;
      }
    }
  } else if (Platform.isIOS) {
    return DynamicLibrary.process();
  } else {    
    return DynamicLibrary.open(
      Directory(Platform.resolvedExecutable).parent.path + '/blobs/${binaryName}'
    );
  }
}();
