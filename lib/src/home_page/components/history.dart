import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sombola/constants/constants.dart';
import 'package:sombola/services/disease_provider.dart';
import 'package:sombola/services/hive_database.dart';
import 'package:sombola/src/home_page/models/disease_model.dart';
import 'package:sombola/src/suggestions_page/suggestions.dart';

class HistorySection extends SliverFixedExtentList {
  HistorySection(Size size, BuildContext context, DiseaseService diseaseService,
      {Key? key})
      : super(
          key: key,
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, index) {
              return ValueListenableBuilder<Box<Disease>>(
                valueListenable: Boxes.getDiseases().listenable(),
                builder: (context, box, _) {
                  final diseases = box.values.toList().cast<Disease>();

                  if (diseases.isNotEmpty) {
                    return Padding(
                      padding: EdgeInsets.fromLTRB((0.053 * size.height * 0.3),
                          (0.053 * size.height * 0.3), 0, 0),
                      child: SizedBox(
                          width: size.width,
                          child: ListView.builder(
                            itemCount: diseases.length,
                            padding: EdgeInsets.symmetric(
                                vertical: (0.035 * size.height * 0.3)),
                            itemExtent: size.width * 0.9,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return _returnHistoryContainer(diseases[index],
                                  context, diseaseService, size);
                            },
                          )),
                    );
                  } else {
                    return _returnNothingToShow(context, size);
                  }
                },
              );
            },
            childCount: 1,
          ),
          itemExtent: size.height * 0.3,
        );
}

Widget _returnHistoryContainer(Disease disease, BuildContext context,
    DiseaseService diseaseService, Size size) {
  return Padding(
    padding: EdgeInsets.fromLTRB(
        (0.053 * size.height * 0.3), 0, (0.053 * size.height * 0.3), 0),
    child: GestureDetector(
      onTap: () {
        // Set disease for Disease Service
        diseaseService.setDiseaseValue(disease);

        Navigator.restorablePushNamed(
          context,
          Suggestions.routeName,
        );
      },
      child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular((0.053 * size.height * 0.3)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: (0.03 * size.height * 0.3),
                  offset: const Offset(0, 10),
                ),
              ]),
          child: Stack(
            fit: StackFit.expand,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular((0.053 * size.height * 0.3)),
                child: Image.file(
                  File(disease.imagePath),
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular((0.053 * size.height * 0.3)),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.65),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: (0.08 * size.height * 0.3),
                right: (0.08 * size.height * 0.3),
                bottom: (0.1 * size.height * 0.3),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      disease.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: kWhite,
                        fontFamily: 'SFBold',
                        fontSize: (0.08 * size.height * 0.3),
                      ),
                    ),
                    Text(
                      '${disease.dateTime.day}/${disease.dateTime.month}/${disease.dateTime.year}',
                      style: TextStyle(
                        color: kWhite.withOpacity(0.9),
                        fontSize: (0.06 * size.height * 0.3),
                      ),
                    ),
                  ],
                ),
              )
            ],
          )),
    ),
  );
}

Widget _returnNothingToShow(BuildContext context, Size size) {
  return Padding(
    padding: EdgeInsets.fromLTRB((0.053 * size.height * 0.3),
        (0.053 * size.height * 0.3), (0.053 * size.height * 0.3), 0),
    child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular((0.053 * size.height * 0.3)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ]),
        child: Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, (0.066 * size.height * 0.3)),
          child: Center(
              child: Text(
            'No history yet. Scan a leaf to get started.',
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          )),
        )),
  );
}
