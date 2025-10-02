import 'package:comunidad_acordeoneros/features/programs/domain/entities/level_entity.dart';

class ProgramEntity {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final List<LevelEntity> levels;
  final bool isActive;
  final String instructor;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const ProgramEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.levels,
    this.isActive = true,
    required this.instructor,
    required this.createdAt,
    this.updatedAt,
  });

  int get totalLevels => levels.length;

  int get completedLevels => levels.where((level) => level.isCompleted).length;

  double get overallProgress {
    if (levels.isEmpty) return 0.0;

    final totalLessons = levels.fold<int>(
      0,
      (sum, level) => sum + level.totalLessons,
    );

    if (totalLessons == 0) return 0.0;

    final completedLessons = levels.fold<int>(
      0,
      (sum, level) => sum + level.completedLessons,
    );

    return completedLessons / totalLessons;
  }

  bool get isCompleted => completedLevels == totalLevels && totalLevels > 0;

  LevelEntity? get currentLevel {
    // Retorna el primer nivel no completado
    try {
      return levels
          .firstWhere((level) => !level.isCompleted && level.isUnlocked);
    } catch (e) {
      // Si todos están completados o ninguno desbloqueado, retorna el primero
      return levels.isNotEmpty ? levels.first : null;
    }
  }
}
