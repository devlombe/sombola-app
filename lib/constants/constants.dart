import 'package:flutter/material.dart';

const kMain = Color(0xff00ad59);
const kAccent = Color(0xff1ca800);
const kSecondary = Color(0xff626463);
const kWhite = Color(0xffffffff);

// Optional: set these to your GitHub raw URLs for model and labels
// Example: https://raw.githubusercontent.com/<user>/<repo>/<commit>/path/to/model.tflite
const String? kRemoteModelUrl = 'https://raw.githubusercontent.com/devlombe/sombola-app/main/assets/model/model_fp16.tflite';
const String? kRemoteLabelsUrl = 'https://raw.githubusercontent.com/devlombe/sombola-app/main/assets/model/labels.txt';
const String? kRemoteDiseaseUrl = 'https://raw.githubusercontent.com/devlombe/sombola-app/main/assets/model/disease_info_by_label.json';
