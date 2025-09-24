import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sombola/services/model_repository.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';

class Classifier {
  late File imageFile;
  final ModelRepository? modelRepository;

  Interpreter? _interpreter;
  List<String> _labels = const [];

  Classifier({this.modelRepository});

  Future<List?> getDisease(ImageSource imageSource) async {
    final image = await ImagePicker().pickImage(source: imageSource);
    if (image == null) return null;
    imageFile = File(image.path);

    if (modelRepository == null) {
      return null;
    }

    final local = await modelRepository!.ensureLocalModel();

    await _loadModelAndLabels(local.model.path, local.labels.path);

    // Load and preprocess image
    final rawImage = FileImage(imageFile);
    final bytes = await rawImage.file.readAsBytes();
    final imgLib = ImageProcessorBuilder()
        .add(ResizeOp(224, 224, ResizeMethod.BILINEAR))
        .add(NormalizeOp(0.0, 255.0))
        .build()
        .process(TensorImage.fromFile(imageFile));

    final inputTensor = _interpreter!.getInputTensor(0);
    final inputShape = inputTensor.shape;
    final inputType = inputTensor.type;

    TensorImage inputImage = TensorImage(inputType);
    inputImage.loadImage(imgLib.image!);

    final outputTensor = _interpreter!.getOutputTensor(0);
    final outputShape = outputTensor.shape; // e.g., [1, numClasses]
    final outputType = outputTensor.type;

    TensorBuffer outputBuffer = TensorBuffer.createFixedSize(outputShape, outputType);

    // Run inference
    _interpreter!.run(inputImage.buffer, outputBuffer.buffer);

    // Map probabilities to labels
    final probabilities = outputBuffer.getDoubleList();
    final results = <Map<String, dynamic>>[];

    for (int i = 0; i < probabilities.length; i++) {
      results.add({
        'label': _labels[i],
        'confidence': probabilities[i],
      });
    }

    // Sort by confidence desc and take top 3 to match previous behavior
    results.sort((a, b) => (b['confidence'] as double).compareTo(a['confidence'] as double));
    final top = results.take(3).toList();

    await _dispose();
    return top;
  }

  Future<void> _loadModelAndLabels(String modelPath, String labelsPath) async {
    // Create interpreter with xnnpack if available
    _interpreter = await Interpreter.fromFile(File(modelPath), options: InterpreterOptions()..threads = 2);
    _labels = await _loadLabels(labelsPath);
  }

  Future<List<String>> _loadLabels(String labelsPath) async {
    final file = File(labelsPath);
    final lines = await file.readAsLines();
    return lines.map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
  }

  Future<void> _dispose() async {
    _interpreter?.close();
    _interpreter = null;
  }
}
