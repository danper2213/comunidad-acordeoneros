import 'package:comunidad_acordeoneros/theme/theme_app.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:comunidad_acordeoneros/features/programs/presentation/providers/programs_provider.dart';
import 'package:comunidad_acordeoneros/features/programs/domain/entities/level_entity.dart';
import 'package:comunidad_acordeoneros/features/programs/domain/entities/lesson_entity.dart';
import 'package:comunidad_acordeoneros/pages/lesson_detail_page.dart';

class LevelLessonsPage extends StatelessWidget {
  final LevelEntity level;
  final String programName;

  const LevelLessonsPage({
    super.key,
    required this.level,
    required this.programName,
  });

  @override
  Widget build(BuildContext context) {
    final programsProvider = Provider.of<ProgramsProvider>(context);

    return Scaffold(
      body: Container(
        decoration: AppTheme.getBackgroundDecoration(),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              _buildHeader(context),

              // Progreso del nivel
              Padding(
                padding: const EdgeInsets.all(16),
                child: _buildProgressCard(),
              ),

              // Lista de clases
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: level.lessons.length,
                  itemBuilder: (context, index) {
                    final lesson = level.lessons[index];
                    return _buildLessonCard(
                      context,
                      lesson,
                      index + 1,
                      programsProvider,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.darkBlue,
            AppTheme.primaryBlue,
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    color: AppTheme.white,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      programName,
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.white.withOpacity(0.8),
                      ),
                    ),
                    Text(
                      level.name,
                      style:
                          AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                        color: AppTheme.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            level.description,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.white.withOpacity(0.9),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard() {
    final percentage = (level.progress * 100).toInt();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.white.withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Progreso del nivel',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      color: AppTheme.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${level.completedLessons} de ${level.totalLessons} clases completadas',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.white.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
              Text(
                '$percentage%',
                style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
                  color: AppTheme.primaryBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: level.progress,
              backgroundColor: AppTheme.white.withOpacity(0.2),
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppTheme.primaryBlue,
              ),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLessonCard(
    BuildContext context,
    LessonEntity lesson,
    int number,
    ProgramsProvider provider,
  ) {
    final duration = Duration(seconds: lesson.duration);
    final minutes = duration.inMinutes;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppTheme.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: lesson.isCompleted
              ? Colors.green.withOpacity(0.5)
              : AppTheme.white.withOpacity(0.3),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            provider.selectLesson(lesson);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LessonDetailPage(
                  lesson: lesson,
                  levelName: level.name,
                  programName: programName,
                  allLessons: level.lessons, // Pasar todas las clases
                ),
              ),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Número de clase
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: lesson.isCompleted
                        ? Colors.green.withOpacity(0.3)
                        : AppTheme.primaryBlue.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: lesson.isCompleted
                        ? const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 28,
                          )
                        : Text(
                            '$number',
                            style: AppTheme.lightTheme.textTheme.titleLarge
                                ?.copyWith(
                              color: AppTheme.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: 16),

                // Info de la clase
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lesson.title,
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          color: AppTheme.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 16,
                            color: AppTheme.white.withOpacity(0.7),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '$minutes min',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.white.withOpacity(0.7),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Icon(
                            Icons.visibility,
                            size: 16,
                            color: AppTheme.white.withOpacity(0.7),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${lesson.views} vistas',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.white.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Icono de play
                Icon(
                  lesson.isCompleted ? Icons.replay : Icons.play_circle_filled,
                  color: AppTheme.primaryBlue,
                  size: 32,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
