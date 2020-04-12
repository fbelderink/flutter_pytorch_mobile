import 'dart:io';

import 'package:flutter/services.dart';
import 'package:pytorch_mobile/enums/dtype.dart';

class Model {
  static const MethodChannel _channel = const MethodChannel('pytorch_mobile');

  final int _index;

  Model(this._index);

  //predicts abstract number input
  Future<List> getPrediction(List<double> input, List<int> shape, DType dtype) async {
    final List prediction = await _channel.invokeListMethod('predict', {"index": _index, "data": input, "shape": shape, "dtype": dtype.toString().split(".").last});
    return prediction;
  }

  //predicts image and returns the supposed label belonging to it
  Future<String> getImagePrediction(File image, int width, int height, String labelPath) async{
    List<String> labels = await _getLabels(labelPath);
    List byteArray = image.readAsBytesSync();
    final List prediction = await _channel.invokeListMethod("predictImage", {"index": _index, "image": byteArray, "width": width, "height": height});
    double maxScore = double.negativeInfinity;
    int maxScoreIndex = -1;
    for(int i = 0; i < prediction.length; i++){
      if(prediction[i] > maxScore){
        maxScore = prediction[i];
        maxScoreIndex = i;
      }
    }
    return labels[maxScoreIndex];
  }

  //predicts image but returns the raw net output
  Future<List> getImagePredictionList(File image, int width, int height) async{
    final List prediction = await _channel.invokeListMethod("predictImage", {"index": _index, "image": image, "width": width, "height": height});
    return prediction;
  }

  //get labels in csv format
  Future<List<String>> _getLabels(String labelPath) async{
    String labelsData = await rootBundle.loadString(labelPath);
    return labelsData.split(",");
  }

}
