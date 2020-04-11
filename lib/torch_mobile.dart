import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:torch_mobile/model.dart';

class TorchMobile {
  static const MethodChannel _channel = const MethodChannel('torch_mobile');

  static Future<Model> getModel(String path) async{
    await _channel.invokeMethod("loadModel", await _getAbsolutePath(path));
    return Model();
  }

  static Future<String> _getAbsolutePath(String path) async{
    Directory dir = await getApplicationDocumentsDirectory();
    print(dir.listSync());
    return "";
  }
}
