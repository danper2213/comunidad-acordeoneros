import 'package:comunidad_acordeoneros/pages/detail_program.dart';
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
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailProgramPage(
              name: name,
              level: level,
              image: image,
              description: _getProgramDescription(name),
            ),
          ),
        );
      },
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Hero(
                  tag: 'program_image_$name',
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
                    width: 60,
                    height: 30,
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
                    Hero(
                      tag: 'program_name_$name',
                      child: Material(
                        color: Colors.transparent,
                        child: Text(name,
                            style: AppTheme.lightTheme.textTheme.headlineLarge),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
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
          )),
    );
  }

  String _getProgramDescription(String programName) {
    switch (programName) {
      case 'Programa VIP':
        return 'Este es un programa exclusivo diseñado para acordeoneros que buscan perfeccionar su técnica y llevar su música al siguiente nivel. Incluye clases personalizadas, masterclasses con artistas reconocidos, y acceso a contenido premium que no encontrarás en ningún otro lugar.';
      default:
        return 'Descubre un programa único diseñado especialmente para acordeoneros apasionados. Aprende técnicas avanzadas, mejora tu interpretación y conecta con una comunidad de músicos dedicados al acordeón.';
    }
  }
}
