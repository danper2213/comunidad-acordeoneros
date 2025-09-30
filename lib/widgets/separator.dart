import 'package:flutter/material.dart';
import '../theme/theme_app.dart';

class SeparatorStart extends StatelessWidget {
  final double? height;
  final Color? lineColor;
  final Color? starColor;
  final double? starSize;
  final double? lineThickness;

  const SeparatorStart({
    super.key,
    this.height = 60,
    this.lineColor,
    this.starColor,
    this.starSize = 24,
    this.lineThickness = 2,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveLineColor = lineColor ?? AppTheme.white.withOpacity(0.6);

    return SizedBox(
      height: height,
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: lineThickness,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    effectiveLineColor,
                  ],
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            child: Image.asset(
              'assets/images/corona.png',
              width: 50,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Container(
              height: lineThickness,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    effectiveLineColor,
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
