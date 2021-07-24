import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:test_bloc_app/utils/colors.dart';

class ObjectName extends StatelessWidget {
  final String title;

  const ObjectName(this.title);

  String _textFormatter() {
    var string1 = title.split(' ');
    return string1[0];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0, bottom: 5),
      child: Text(
        title,
        maxLines: 2,
        softWrap: true,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.start,
        style: TextStyle(
          fontSize: 16.0,
          color: AppColors.appBarText,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
