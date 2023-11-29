import 'package:flutter/material.dart';

class Dead_Pixel extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.red[600],
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
      ),
    );
  }
}
