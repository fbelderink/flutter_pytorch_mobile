# pytorch_mobile

A flutter plugin for pytorch model inference, supported both for Android and iOS.

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
Model customModel = await PyTorchMobile
        .loadModel('assets/models/custom_model.pt');
```
Or image model:
```dart
Model imageModel = await PyTorchMobile
        .loadModel('assets/models/resnet18.pt');
```

### Get custom prediction

```dart
List prediction = await customModel
        .getPrediction([1, 2, 3, 4], [1, 2, 2], DType.float32);
```

### Get prediction for an image

```dart
String prediction = await _imageModel
        .getImagePrediction(image, 224, 224, "assets/labels/labels.csv");
```

### Image prediction for an image with custom mean and std
```dart
final mean = [0.5, 0.5, 0.5];
final std = [0.5, 0.5, 0.5];
String prediction = await _imageModel
        .getImagePrediction(image, 224, 224, "assets/labels/labels.csv", mean: mean, std: std);
```

## Contact
fynnmaarten.business@gmail.com