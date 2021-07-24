import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NotFound extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Page not found"),
          ],
        ),
      ),
    );
  }
}
