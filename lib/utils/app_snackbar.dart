import 'package:flutter/material.dart';

void showToast(BuildContext context, String message) {
  final scaffoldMessenger = ScaffoldMessenger.of(context);

  scaffoldMessenger.showSnackBar(
    SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(message),
          const CircleAvatar(
            radius: 14.0,
            backgroundColor: Colors.green,
            child: Icon(
              Icons.check,
              color: Colors.white,
            ),
          ),
        ],
      ),
      duration: const Duration(seconds: 2),
    ),
  );
}
