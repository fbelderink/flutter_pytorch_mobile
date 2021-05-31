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

### Detectron2 model [only detection]
```dart
List<List>? prediction = await _d2model
        .detectron2(image, 320, 320, "assets/labels/d2go.csv", minScore: 0.4);

// prediction[0] => [left, top, right, bottom, score, label]
```

#### Detectron2 model is generated with [d2go](https://github.com/facebookresearch/d2go), using [script](create_d2go.py)

## Contact
fynnmaarten.business@gmail.com