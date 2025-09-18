import 'package:flutter/material.dart';
import 'package:sombola/constants/constants.dart';

class TitleSection extends SliverFixedExtentList {
  TitleSection(String title, double height, {Key? key})
      : super(
          key: key,
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, index) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              Padding(
                padding: EdgeInsets.fromLTRB((0.32*height), 0, 0, 0),
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: (0.6*height),
                    fontFamily: 'SFBold',
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: (0.32*height), top: (0.12*height)),
                child: Container(
                  height: (0.08*height),
                  width: (2.0*height),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).colorScheme.primary,
                        Theme.of(context).colorScheme.secondary,
                      ],
                    ),
                    borderRadius: BorderRadius.circular((0.04*height)),
                  ),
                ),
              ),
                ],
              );
            },
            childCount: 1,
          ),
          itemExtent: height,
        );
}
