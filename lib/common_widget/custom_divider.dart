// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  Colors? colors;
  double? thickness;

  CustomDivider({this.colors, this.thickness});

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: Colors.grey,
      thickness: 1.0,
    );
  }
}
