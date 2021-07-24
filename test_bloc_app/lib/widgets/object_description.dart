import 'package:flutter/material.dart';
import 'package:test_bloc_app/utils/colors.dart';

class ObjectDescription extends StatelessWidget {
  final String description;

  ObjectDescription(this.description);

  @override
  Widget build(BuildContext context) {
    return Text(
      description,
      maxLines: 2,
      softWrap: true,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: 12.0,
        color: AppColors.appBarText,
        fontWeight: FontWeight.normal,
      ),
    );
  }
}
