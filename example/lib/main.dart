import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:torch_mobile/torch_mobile.dart';
import 'package:torch_mobile/model.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  Future<Model> loadModel(String path) async {
    return await TorchMobile.getModel(path);
  }

  @override
  Widget build(BuildContext context) {
    loadModel("assets/model.pt").then((Model model){
      model.getPrediction([1,2,3,4], [1,2,2]);
    } );
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(child: Text("Test")),
      ),
    );
  }
}
