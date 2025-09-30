import 'package:comunidad_acordeoneros/theme/theme_app.dart';
import 'package:comunidad_acordeoneros/widgets/separator.dart';
import 'package:flutter/material.dart';

class DetailProgramPage extends StatelessWidget {
  final String name;
  final String level;
  final String image;
  final String description;

  const DetailProgramPage({
    super.key,
    required this.name,
    required this.level,
    required this.image,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return SizedBox(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: height * 0.4,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: [
                Hero(
                  tag: 'program_image_$name',
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(image),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                // Back button
                Positioned(
                  top: 50,
                  left: 20,
                  child: Hero(
                    tag: 'back_button',
                    child: Material(
                      color: Colors.transparent,
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.3),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.arrow_back,
                            color: AppTheme.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Decorative shapes overlay

                // Instructor illustration with hero animation
                Positioned(
                  bottom: 30,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Hero(
                      tag: 'instructor_$name',
                      child: SizedBox(
                        width: 250,
                        child: Text(
                          'PROGRAMA VIP',
                          style: AppTheme.lightTheme.textTheme.displayMedium
                              ?.copyWith(
                            color: AppTheme.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Text(
                    'Descripción del programa',
                    style:
                        AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                      color: AppTheme.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  // Separator
                  const SeparatorStart(),

                  Text(
                    description,
                    style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                      color: AppTheme.white.withOpacity(0.9),
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Description Section
        ],
      ),
    );
  }
}
