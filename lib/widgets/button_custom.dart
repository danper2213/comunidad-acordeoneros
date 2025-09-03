import 'package:comunidad_acordeoneros/theme/theme_app.dart';
import 'package:flutter/material.dart';

class ButtonCustom extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const ButtonCustom({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
        width: size.width, // Full width minus padding
        child: Container(
          decoration: BoxDecoration(
            gradient: AppTheme.backgroundGradientButton,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onPressed,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Center(
                  child: Text(
                    text,
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      color: AppTheme.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
