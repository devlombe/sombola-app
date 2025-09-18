import 'package:flutter/material.dart';
import 'package:sombola/constants/constants.dart';

class InstructionsSection extends SliverFixedExtentList {
  InstructionsSection(Size size, {Key? key})
      : super(
          key: key,
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, index) {
              return Padding(
                padding: EdgeInsets.fromLTRB(
                    (0.061 * size.height * 0.26),
                    (0.071 * size.height * 0.26),
                    (0.076 * size.height * 0.26),
                    (0.061 * size.height * 0.26)),
                child: Container(
                  height: size.height * 0.26,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius:
                        BorderRadius.circular((0.061 * size.height * 0.26)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB((0.025 * size.height * 0.26),
                        0, 0, (0.025 * size.height * 0.26)),
                    child: ListView(
                      children: [
                        ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              child: const Text(
                                '1',
                                style: TextStyle(color: kWhite),
                              ),
                            ),
                            title: Text(
                              'Tap the camera to take or select a leaf photo',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            )),
                        ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            child: const Text(
                              '2',
                              style: TextStyle(color: kWhite),
                            ),
                          ),
                          title: Text(
                              'Wait a moment to see the detected disease and tips',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                              )),
                        ),
                        const ListTile(
                          title: Text(''),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            childCount: 1,
          ),
          itemExtent: size.height * 0.26,
        );
}
