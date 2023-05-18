import 'package:flutter/material.dart';

void showToast(BuildContext context, String message, [bool showTick = true]) {
  final scaffoldMessenger = ScaffoldMessenger.of(context);

  scaffoldMessenger.showSnackBar(
    SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(message),
          showTick
              ? const CircleAvatar(
                  radius: 14.0,
                  backgroundColor: Colors.green,
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                  ),
                )
              : const SizedBox(),
        ],
      ),
      duration: const Duration(seconds: 2),
    ),
  );
}
