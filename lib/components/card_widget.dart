import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  const CardWidget({
    super.key,
    required this.title,
    this.cardColor = Colors.blueGrey,
    this.onPress,
    this.icon = Icons.person,
  });

  final VoidCallback? onPress;
  final String title;
  final Color cardColor;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    double sw = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onPress,
      child: Container(
        width: sw * 40 / 100,
        height: 140.0,
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14.0),
          color: cardColor.withOpacity(1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              icon,
              size: 60.0,
              color: Colors.white,
            ),
            const SizedBox(height: 10.0),
            Center(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 14.0,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
