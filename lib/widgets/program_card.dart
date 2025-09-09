import 'package:comunidad_acordeoneros/theme/theme_app.dart';
import 'package:flutter/material.dart';

class ProgramCard extends StatelessWidget {
  final String name;
  final String level;
  final String image;
  const ProgramCard(
      {super.key,
      required this.name,
      required this.level,
      required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Opacity(
                opacity: 0.5,
                child: Image.asset(
                  image,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child:
                  Text(name, style: AppTheme.lightTheme.textTheme.titleLarge),
            ),
          ],
        ));
  }
}
