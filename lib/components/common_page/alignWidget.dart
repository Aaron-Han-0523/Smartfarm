// ** ALIGN WIDGET PAGE **

import 'package:flutter/material.dart';

class AlignWidget extends StatelessWidget {
  final String titles;
  final Color colors;
  final double fontSizes;
  const AlignWidget(
      {Key? key,
      required this.titles,
      required this.colors,
      required this.fontSizes})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Text(
        titles,
        style: TextStyle(color: colors, fontSize: fontSizes),
      ),
    );
  }
}
