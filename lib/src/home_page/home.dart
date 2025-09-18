import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sombola/constants/constants.dart';
import 'package:sombola/services/classify.dart';
import 'package:sombola/services/disease_provider.dart';
import 'package:sombola/services/hive_database.dart';
import 'package:sombola/services/model_repository.dart';
import 'package:sombola/src/home_page/components/greeting.dart';
import 'package:sombola/src/home_page/components/history.dart';
import 'package:sombola/src/home_page/components/instructions.dart';
import 'package:sombola/src/home_page/components/titlesection.dart';
import 'package:sombola/src/home_page/models/disease_model.dart';
import 'package:sombola/src/suggestions_page/suggestions.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  static const routeName = '/';

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get disease from provider
    final _diseaseService = Provider.of<DiseaseService>(context);

    // Hive service
    HiveService _hiveService = HiveService();

    // Data
    Size size = MediaQuery.of(context).size;
    final ModelRepository? repo =
        (kRemoteModelUrl != null && kRemoteLabelsUrl != null)
            ? ModelRepository(
                modelUrl: Uri.parse(kRemoteModelUrl!),
                labelsUrl: Uri.parse(kRemoteLabelsUrl!),
              )
            : null;
    final Classifier classifier = Classifier(modelRepository: repo);
    late Disease _disease;

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SpeedDial(
        icon: Icons.camera_alt,
        spacing: 10,
        children: [
          SpeedDialChild(
            child: const FaIcon(
              FontAwesomeIcons.file,
              color: kWhite,
            ),
            label: "Choose image",
            backgroundColor: kMain,
            onTap: () async {
              late double _confidence;
              final value = await classifier.getDisease(ImageSource.gallery);
              if (value == null) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Model not available. Configure remote model URLs.')),
                );
                return;
              }
              _disease = Disease(
                  name: value[0]["label"],
                  imagePath: classifier.imageFile.path);
              _confidence = value[0]['confidence'];
              // Check confidence
              if (_confidence > 0.8) {
                // Set disease for Disease Service
                _diseaseService.setDiseaseValue(_disease);

                // Save disease
                _hiveService.addDisease(_disease);

                Navigator.restorablePushNamed(
                  context,
                  Suggestions.routeName,
                );
              } else {
                // Display unsure message

              }
            },
          ),
          SpeedDialChild(
            child: const FaIcon(
              FontAwesomeIcons.camera,
              color: kWhite,
            ),
            label: "Take photo",
            backgroundColor: kMain,
            onTap: () async {
              late double _confidence;

              final value = await classifier.getDisease(ImageSource.camera);
              if (value == null) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Model not available. Configure remote model URLs.')),
                );
                return;
              }
              _disease = Disease(
                  name: value[0]["label"],
                  imagePath: classifier.imageFile.path);
              _confidence = value[0]['confidence'];

              // Check confidence
              if (_confidence > 0.8) {
                // Set disease for Disease Service
                _diseaseService.setDiseaseValue(_disease);

                // Save disease
                _hiveService.addDisease(_disease);

                Navigator.restorablePushNamed(
                  context,
                  Suggestions.routeName,
                );
              } else {
                // Display unsure message

              }
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: const DecorationImage(
              image: AssetImage('assets/images/bg.jpg'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(Colors.black26, BlendMode.darken)),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.surface.withOpacity(0.0),
              Theme.of(context).colorScheme.surface.withOpacity(0.6),
            ],
          ),
        ),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              expandedHeight: size.height * 0.18,
              backgroundColor: Colors.transparent,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: const EdgeInsetsDirectional.only(start: 16, bottom: 12),
                title: Text('Sombola',
                    style: TextStyle(
                      fontFamily: 'SFBold',
                      color: Theme.of(context).colorScheme.onSurface,
                    )),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Theme.of(context).colorScheme.primary.withOpacity(0.35),
                        Theme.of(context).colorScheme.secondary.withOpacity(0.25),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            GreetingSection(size.height * 0.2),
            TitleSection('Instructions', size.height * 0.066),
            InstructionsSection(size),
            TitleSection('Your History', size.height * 0.066),
            HistorySection(size, context, _diseaseService)
          ],
        ),
      ),
    );
  }
}
