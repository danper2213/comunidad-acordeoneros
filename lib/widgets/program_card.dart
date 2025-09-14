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
              top: 20,
              right: 0,
              child: Container(
                padding: EdgeInsets.zero,
                margin: EdgeInsets.zero,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  'assets/images/corona.png',
                  width: 100,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              left: 16,
              top: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: AppTheme.lightTheme.textTheme.headlineLarge),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text('Habilitado',
                        style: AppTheme.lightTheme.textTheme.bodySmall),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
