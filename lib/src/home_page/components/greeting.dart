import 'package:flutter/material.dart';
import 'package:sombola/constants/constants.dart';

class GreetingSection extends SliverFixedExtentList {
  GreetingSection(double height, {Key? key})
      : super(
          key: key,
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, index) {
              return Padding(
                padding: EdgeInsets.fromLTRB((0.079*height), 0, (0.079*height), (0.079*height)),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Theme.of(context).colorScheme.primary.withOpacity(0.85),
                        Theme.of(context).colorScheme.secondary.withOpacity(0.75),
                      ],
                    ),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular((0.079*height)),
                        bottomRight: Radius.circular((0.079*height))),
                  ),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB((0.092*height), 0, (0.092*height), (0.099*height)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Healthy plants, smarter care',
                          style: TextStyle(
                              fontFamily: 'SFBold',
                              fontSize: (0.16*height),
                              color: kWhite),
                        ),
                        SizedBox(height: (0.03*height)),
                        Text(
                          'Scan a leaf to detect diseases instantly',
                          style: TextStyle(
                            fontSize: (0.08*height),
                            color: kWhite.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            childCount: 1,
          ),
          itemExtent: height,
        );
}
