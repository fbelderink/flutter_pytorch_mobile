import 'dart:io';
import 'dart:ui' as ui;
import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import 'package:pytorch_mobile/pytorch_mobile.dart';
import 'package:pytorch_mobile/model.dart';
import 'package:pytorch_mobile/enums/dtype.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Model? _imageModel, _customModel, _d2Model;

  String? _imagePrediction;
  List? _prediction;
  File? _image;
  ImagePicker _picker = ImagePicker();

  ui.Image? _d2Image;
  List? _d2Results;

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  //load your model
  Future loadModel() async {
    String pathImageModel = "assets/models/resnet.pt";
    String pathCustomModel = "assets/models/custom_model.pt";
    String pathD2Model = "assets/models/d2go.pt";
    try {
      _imageModel = await PyTorchMobile.loadModel(pathImageModel);
      _customModel = await PyTorchMobile.loadModel(pathCustomModel);
      _d2Model = await PyTorchMobile.loadModel(pathD2Model);
    } on PlatformException {
      print("only supported for android and ios so far");
    }
  }

  //run an image model
  Future runImageModel() async {
    //pick a random image
    final PickedFile? image = await _picker.getImage(
        source: (Platform.isIOS ? ImageSource.gallery : ImageSource.camera),
        maxHeight: 224,
        maxWidth: 224);
    //get prediction
    //labels are 1000 random english words for show purposes
    _imagePrediction = await _imageModel!.getImagePrediction(
        File(image!.path), 224, 224, "assets/labels/labels.csv");

    setState(() {
      _image = File(image.path);
    });
  }

  //run a custom model with number inputs
  Future runCustomModel() async {
    _prediction = await _customModel!
        .getPrediction([1, 2, 3, 4], [1, 2, 2], DType.float32);

    setState(() {});
  }

  //run detectron2 model
  Future runDetectron2() async {
    //pick a random image
    final PickedFile? image = await _picker.getImage(
        source: (ImageSource.gallery), maxHeight: 320, maxWidth: 320);

    //get prediction
    final results = await _d2Model!.getDetectron2(
        File(image!.path), 320, 320, "assets/labels/d2go.csv",
        mean: [0, 0, 0], std: [1.0, 1.0, 1.0]);

    ui.Image img = await loadUiImage(image.path);

    setState(() {
      _d2Image = img;
      _d2Results = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Pytorch Mobile Example'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _image == null ? Text('No image selected.') : Image.file(_image!),
            Center(
              child: Visibility(
                visible: _imagePrediction != null,
                child: Text("$_imagePrediction"),
              ),
            ),
            Center(
              child: TextButton(
                onPressed: runImageModel,
                child: Icon(
                  Icons.add_a_photo,
                  color: Colors.grey,
                ),
              ),
            ),
            TextButton(
              onPressed: runCustomModel,
              style: TextButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: Text(
                "Run custom model",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            Center(
              child: Visibility(
                  visible: _d2Image != null,
                  child: Container(
                    width: 320,
                    height: 320,
                    child: CustomPaint(
                      painter: Detectron2Result(_d2Image, _d2Results),
                    ),
                  )),
            ),
            TextButton(
              onPressed: runDetectron2,
              style: TextButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: Text(
                "Run detectron2",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            Center(
              child: Visibility(
                visible: _prediction != null,
                child: Text(_prediction != null ? "${_prediction![0]}" : ""),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// Detectron2 drawing
class Detectron2Result extends CustomPainter {
  Detectron2Result(this.image, this.results);
  ui.Image? image;
  List? results;

  @override
  void paint(Canvas canvas, Size size) {
    if (image == null || results == null) {
      return;
    }

    // Draw original image
    canvas.drawImage(image!, Offset(0.0, 0.0), Paint());

    // Draw results
    for (List res in results!) {
      // Border rectangle
      Rect rect = Rect.fromLTRB(res[0], res[1], res[2], res[3]);
      var paint = Paint()
        ..color = Color(0xffffff33)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;

      canvas.drawRect(rect, paint);

      // Label
      final textStyle = TextStyle(
          color: Colors.white, fontSize: 16, backgroundColor: Colors.purple);
      final textSpan = TextSpan(
        text: res[5],
        style: textStyle,
      );
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout(
        minWidth: 0,
        maxWidth: size.width,
      );
      final offset = Offset(res[0], res[1] - 12);
      textPainter.paint(canvas, offset);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

Future<ui.Image> loadUiImage(String assetPath) async {
  final file = File(assetPath);
  final data = await file.readAsBytes();
  final list = Uint8List.view(data.buffer);
  final completer = Completer<ui.Image>();
  ui.decodeImageFromList(list, completer.complete);
  return completer.future;
}
