import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sombola/constants/constants.dart';
import 'package:sombola/services/disease_provider.dart';
import 'package:sombola/src/home_page/models/disease_model.dart';
import 'package:sombola/src/suggestions_page/components/plant_image.dart';
import 'package:sombola/src/suggestions_page/components/text_property.dart';
import 'package:provider/provider.dart';

class Suggestions extends StatelessWidget {
  const Suggestions({Key? key}) : super(key: key);

  static const routeName = '/suggestions';

  @override
  Widget build(BuildContext context) {
    // Get disease from provider
    final _diseaseService = Provider.of<DiseaseService>(context);

    Disease _disease = _diseaseService.disease;
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Suggestions'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/bgr.jpg'), fit: BoxFit.cover),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.0),
                Colors.black.withOpacity(0.3),
              ],
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all((0.02 * size.height)),
            child: Column(
              children: [
                Flexible(
                  child: Center(
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      child: PlantImage(
                        size: size,
                        imageFile: File(_disease.imagePath),
                      ),
                    ),
                  ),
                ),
                Divider(
                  thickness: (0.0066 * size.height),
                  height: (0.013 * size.height),
                ),
                Expanded(
                  child: Card(
                    child: ListView(
                      padding: EdgeInsets.only(bottom: (0.02 * size.height)),
                      children: [
                        TextProperty(
                          title: 'Disease name',
                          value: _disease.name,
                          height: size.height,
                        ),
                        TextProperty(
                          title: 'Possible causes',
                          value: _disease.possibleCauses,
                          height: size.height,
                        ),
                        TextProperty(
                          title: 'Possible solution',
                          value: _disease.possibleSolution,
                          height: size.height,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
