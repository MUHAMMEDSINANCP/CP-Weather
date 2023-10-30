import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  final Color color;
  final double thickness;
  final double startIndent;
  final double endIndent;

  CustomDivider({
    this.color = Colors.grey,    // Default color is grey
    this.thickness = 2,         // Default thickness is 2.0
    this.startIndent = 0,       // Default startIndent is 0.0
    this.endIndent = 80,        // Default endIndent is 80.0
  });

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: color,
      thickness: thickness,
     indent: startIndent,
      endIndent: endIndent,
    );
  }
}
