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
    return Scaffold(
      body: Container(
        decoration: AppTheme.getBackgroundDecoration(),
        child: SafeArea(
          child: Column(
            children: [
              // Image with program name overlay
              Expanded(
                flex: 1,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    children: [
                      // Background image with opacity
                      Hero(
                        tag: 'program_image_$name',
                        child: Opacity(
                          opacity: 0.7,
                          child: Image.asset(
                            image,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        left: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              width: 50,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.3),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.arrow_back,
                                size: 24,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Program name overlay at bottom center
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.8),
                              ],
                            ),
                          ),
                          child: Column(
                            children: [
                              Hero(
                                tag: 'program_name_$name',
                                child: Material(
                                  color: Colors.transparent,
                                  child: Text(
                                    name,
                                    style: AppTheme
                                        .lightTheme.textTheme.displayMedium
                                        ?.copyWith(
                                      color: AppTheme.white,
                                      fontWeight: FontWeight.bold,
                                      shadows: [
                                        const Shadow(
                                          offset: Offset(0, 2),
                                          blurRadius: 4,
                                          color: Colors.black54,
                                        ),
                                      ],
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryBlue.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  level,
                                  style: AppTheme
                                      .lightTheme.textTheme.bodyMedium
                                      ?.copyWith(
                                    color: AppTheme.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
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
                        style: AppTheme.lightTheme.textTheme.headlineSmall
                            ?.copyWith(
                          color: AppTheme.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      // Separator
                      const SeparatorStart(),

                      Text(
                        description,
                        style:
                            AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                          color: AppTheme.white.withOpacity(0.9),
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
