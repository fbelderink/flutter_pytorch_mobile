import 'package:flutter/services.dart';

class Model {
  static const MethodChannel _channel = const MethodChannel('torch_mobile');

  final int _index;

  Model(this._index);

  Future<String> getPrediction(List input, List shape) async {
    final String prediction = await _channel.invokeMethod('predict', {"index": this._index, "input": input, "shape": shape});
    return prediction;
  }

}
