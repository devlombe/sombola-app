import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class ModelRepository {
	final Uri modelUrl;
	final Uri labelsUrl;
	final String modelFileName;
	final String labelsFileName;

	ModelRepository({
		required this.modelUrl,
		required this.labelsUrl,
		this.modelFileName = 'model.tflite',
		this.labelsFileName = 'labels.txt',
	});

	Future<File> _downloadTo(File file, Uri url) async {
		final response = await http.get(url);
		if (response.statusCode != 200) {
			throw Exception('Failed to download: ${url.toString()}');
		}
		await file.writeAsBytes(response.bodyBytes, flush: true);
		return file;
	}

	Future<({File model, File labels})> ensureLocalModel() async {
		final Directory dir = await getApplicationSupportDirectory();
		final File modelFile = File('${dir.path}/$modelFileName');
		final File labelsFile = File('${dir.path}/$labelsFileName');

		if (!await modelFile.exists()) {
			await modelFile.create(recursive: true);
			await _downloadTo(modelFile, modelUrl);
		}
		if (!await labelsFile.exists()) {
			await labelsFile.create(recursive: true);
			await _downloadTo(labelsFile, labelsUrl);
		}
		return (model: modelFile, labels: labelsFile);
	}
}
