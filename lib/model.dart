import 'package:flutter/services.dart';

class Model {
  static const MethodChannel _channel = const MethodChannel('torch_mobile');

  static Future<String> getPrediction() async {
    final String prediction = await _channel.invokeMethod('predict');
    return prediction;
  }

}
