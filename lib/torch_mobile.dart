import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:torch_mobile/model.dart';

class TorchMobile {
  static const MethodChannel _channel = const MethodChannel('torch_mobile');

  static Future<Model> getModel(String path) async {
    String absPath = await _getAbsolutePath(path);
    int index = await _channel
        .invokeMethod("loadModel", {"absPath": absPath, "assetPath": path});
    return Model(index);
  }

  static Future<String> _getAbsolutePath(String path) async {
    Directory dir = await getApplicationDocumentsDirectory();
    String dirPath = join(dir.path, path);
    ByteData data = await rootBundle.load(path);
    //Copy asset to documents directory
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    //create directory
    List split = path.split("/");
    for (int i = 0; i < split.length; i++) {
      if (i != split.length - 1) {
        await Directory(join(dir.path, split[i])).create();
      }
    }
    await File(dirPath).writeAsBytes(bytes);

    return dirPath;
  }
}
