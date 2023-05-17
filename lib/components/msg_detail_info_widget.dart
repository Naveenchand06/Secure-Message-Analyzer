import 'package:flutter/material.dart';

class MsgDetailInfoWidget extends StatelessWidget {
  const MsgDetailInfoWidget({
    super.key,
    required this.title,
    required this.value,
  });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black,
            fontSize: 16.0,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w400,
            color: Colors.grey,
            fontSize: 16.0,
          ),
        ),
      ],
    );
  }
}
