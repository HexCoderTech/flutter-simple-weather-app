import 'package:flutter/material.dart';

class WeatherInfoWidget extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final String label;
  const WeatherInfoWidget(
      {super.key,
      required this.icon,
      required this.iconColor,
      required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: iconColor,
        ),
        Column(
          children: [
            Text(label),
          ],
        ),
      ],
    );
  }
}
