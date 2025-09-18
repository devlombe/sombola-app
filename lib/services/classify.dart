import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';
import 'package:sombola/services/model_repository.dart';

class Classifier {
  late File imageFile;
  final ModelRepository? modelRepository;

  Classifier({this.modelRepository});

  Future<List?> getDisease(ImageSource imageSource) async {
    final image = await ImagePicker().pickImage(source: imageSource);
    if (image == null) return null;
    imageFile = File(image.path);

    if (modelRepository == null) {
      return null;
    }

    final local = await modelRepository!.ensureLocalModel();
    await Tflite.loadModel(
      model: local.model.path,
      labels: local.labels.path,
      numThreads: 2,
    );
    final result = await Tflite.runModelOnImage(
      path: imageFile.path,
      imageMean: 0.0,
      imageStd: 255.0,
      numResults: 3,
      threshold: 0.2,
      asynch: true,
    );
    await Tflite.close();
    return result;
  }
}
