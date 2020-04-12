# pytorch_mobile

A flutter plugin for pytorch model inference.
Since this is still being developed, the plugin is only supported for Android.
An iOS version is going to come soon

## Usage

### Installation

To use this plugin, add `pytorch_mobile` as a [dependency in your pubspec.yaml file](https://flutter.dev/docs/development/packages-and-plugins/using-packages).

Create a `assets` folder with your pytorch model and labels if needed. Modify `pubspec.yaml` accoringly.

```yaml
assets:
 - assets/models/model.pt
 - assets/labels.csv
```

Run `flutter pub get`

### Import the library

```dart
import 'package:pytorch_mobile/pytorch_mobile.dart';
```

### Load model

Either custom model:
```dart
Model customModel = await PyTorchMobile.loadModel(model: 'assets/models/custom_model.pt');
```
Or image model:
```dart
Model imageModel = await PyTorchMobile.loadModel(model: 'assets/models/resnet18.pt');
```

### Get custom prediction

```dart
List prediction = await customModel.getPrediction([1, 2, 3, 4], [1, 2, 2], DType.float32);
```

### Get prediction for an image

```dart
String prediction = await _imageModel.getImagePrediction(image, 224, 224, "assets/labels/labels.csv");
```

## Contact
fynnmaarten.business@gmail.com