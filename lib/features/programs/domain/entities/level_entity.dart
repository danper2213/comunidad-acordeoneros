import 'package:comunidad_acordeoneros/features/programs/domain/entities/lesson_entity.dart';

class LevelEntity {
  final String id;
  final String name;
  final String description;
  final int order;
  final List<LessonEntity> lessons;
  final bool isUnlocked;
  final double progress; // 0.0 a 1.0

  const LevelEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.order,
    required this.lessons,
    this.isUnlocked = false,
    this.progress = 0.0,
  });

  int get totalLessons => lessons.length;

  int get completedLessons =>
      lessons.where((lesson) => lesson.isCompleted).length;

  bool get isCompleted => completedLessons == totalLessons && totalLessons > 0;
}
