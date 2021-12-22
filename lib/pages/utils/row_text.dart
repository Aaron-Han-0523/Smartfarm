import 'package:flutter/material.dart';

class RowText extends StatelessWidget {
  final String title;

  RowText({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '*',
          style: TextStyle(
            color: Colors.red,
            fontSize: 10,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey[400],
          ),
        ),
      ],
    );
  }
}
