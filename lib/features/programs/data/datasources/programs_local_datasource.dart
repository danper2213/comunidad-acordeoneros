import 'package:comunidad_acordeoneros/features/programs/data/models/program_model.dart';
import 'package:comunidad_acordeoneros/features/programs/data/models/level_model.dart';
import 'package:comunidad_acordeoneros/features/programs/data/models/lesson_model.dart';

/// Data source local con datos de ejemplo
/// En producción, esto vendría de Firebase/API
abstract class ProgramsLocalDataSource {
  List<ProgramModel> getPrograms();
  ProgramModel? getProgramById(String id);
  List<LessonModel> getLessonsByLevelId(String levelId);
  void markLessonAsCompleted(String lessonId);
}

class ProgramsLocalDataSourceImpl implements ProgramsLocalDataSource {
  // Lista mutable de programas para actualizar el estado
  List<ProgramModel> _programs = [];

  ProgramsLocalDataSourceImpl() {
    _initializePrograms();
  }

  void _initializePrograms() {
    _programs = [
      ProgramModel(
        id: 'prog-001',
        name: 'Programa VIP',
        description:
            'Este es un programa exclusivo diseñado para acordeoneros que buscan perfeccionar su técnica y llevar su música al siguiente nivel. Incluye clases personalizadas, masterclasses con artistas reconocidos, y acceso a contenido premium que no encontrarás en ningún otro lugar.',
        imageUrl: 'assets/images/fer-festival.jpg',
        instructor: 'Ferney Arrieta',
        isActive: true,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        levels: [
          LevelModel(
            id: 'level-001',
            name: 'Nivel 1 - Fundamentos',
            description:
                'Aprende los fundamentos básicos del acordeón vallenato. Desde cómo sostener el instrumento hasta las primeras melodías.',
            order: 1,
            isUnlocked: true,
            progress: 0.0,
            lessons: [
              LessonModel(
                id: 'lesson-001',
                title: 'Introducción al Acordeón Vallenato',
                description:
                    'En esta primera clase aprenderás la historia del acordeón vallenato, sus partes y cómo sostenerlo correctamente.',
                videoUrl: 'assets/videos/test.mp4',
                thumbnailUrl: 'assets/images/fer-festival.jpg',
                duration: 600, // 10 minutos
                order: 1,
                isCompleted: false,
                views: 0,
              ),
              LessonModel(
                id: 'lesson-002',
                title: 'Postura y Técnica Básica',
                description:
                    'Aprende la postura correcta y las técnicas básicas para tocar el acordeón de forma cómoda y eficiente.',
                videoUrl: 'assets/videos/test.mp4',
                thumbnailUrl: 'assets/images/fer-festival.jpg',
                duration: 900, // 15 minutos
                order: 2,
                isCompleted: false,
                views: 0,
              ),
              LessonModel(
                id: 'lesson-003',
                title: 'Primeros Acordes',
                description:
                    'Practica tus primeros acordes básicos y aprende a coordinar ambas manos.',
                videoUrl: 'assets/videos/test.mp4',
                thumbnailUrl: 'assets/images/fer-festival.jpg',
                duration: 1200, // 20 minutos
                order: 3,
                isCompleted: false,
                views: 0,
              ),
            ],
          ),
          LevelModel(
            id: 'level-002',
            name: 'Nivel 2 - Técnicas Intermedias',
            description:
                'Desarrolla tus habilidades con técnicas intermedias y aprende a tocar canciones completas.',
            order: 2,
            isUnlocked: false,
            progress: 0.0,
            lessons: [
              LessonModel(
                id: 'lesson-004',
                title: 'Escalas y Digitación',
                description:
                    'Domina las escalas básicas y mejora tu digitación para tocar con mayor fluidez.',
                videoUrl: 'assets/videos/test.mp4',
                thumbnailUrl: 'assets/images/fer-festival.jpg',
                duration: 1500, // 25 minutos
                order: 1,
                isCompleted: false,
                views: 0,
              ),
              LessonModel(
                id: 'lesson-005',
                title: 'Ritmos Tradicionales',
                description:
                    'Aprende los ritmos tradicionales del vallenato: paseo, merengue, puya y son.',
                videoUrl: 'assets/videos/test.mp4',
                thumbnailUrl: 'assets/images/fer-festival.jpg',
                duration: 1800, // 30 minutos
                order: 2,
                isCompleted: false,
                views: 0,
              ),
            ],
          ),
          LevelModel(
            id: 'level-003',
            name: 'Nivel 3 - Técnicas Avanzadas',
            description:
                'Perfecciona tu técnica con lecciones avanzadas y aprende a improvisar.',
            order: 3,
            isUnlocked: false,
            progress: 0.0,
            lessons: [
              LessonModel(
                id: 'lesson-006',
                title: 'Improvisación y Creatividad',
                description:
                    'Desarrolla tu creatividad musical y aprende a improvisar sobre diferentes ritmos.',
                videoUrl: 'assets/videos/test.mp4',
                thumbnailUrl: 'assets/images/fer-festival.jpg',
                duration: 2100, // 35 minutos
                order: 1,
                isCompleted: false,
                views: 0,
              ),
              LessonModel(
                id: 'lesson-007',
                title: 'Técnicas de Ornamentación',
                description:
                    'Aprende las técnicas de ornamentación que le darán ese toque profesional a tu interpretación.',
                videoUrl: 'assets/videos/test.mp4',
                thumbnailUrl: 'assets/images/fer-festival.jpg',
                duration: 1800, // 30 minutos
                order: 2,
                isCompleted: false,
                views: 0,
              ),
            ],
          ),
        ],
      ),
    ];
  }

  @override
  List<ProgramModel> getPrograms() {
    return _programs;
  }

  @override
  ProgramModel? getProgramById(String id) {
    try {
      return _programs.firstWhere((program) => program.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  List<LessonModel> getLessonsByLevelId(String levelId) {
    for (final program in _programs) {
      for (final level in program.levels) {
        if (level.id == levelId) {
          return level.lessons.cast<LessonModel>();
        }
      }
    }

    return [];
  }

  @override
  void markLessonAsCompleted(String lessonId) {
    // Buscar y actualizar la lección en los programas
    for (var i = 0; i < _programs.length; i++) {
      final program = _programs[i];
      bool updated = false;

      final updatedLevels = program.levels.map((level) {
        final updatedLessons = level.lessons.map((lesson) {
          if (lesson.id == lessonId && !lesson.isCompleted) {
            updated = true;
            return (lesson as LessonModel).copyWith(isCompleted: true);
          }
          return lesson;
        }).toList();

        if (updated) {
          // Calcular nuevo progreso del nivel
          final completedCount =
              updatedLessons.where((l) => l.isCompleted).length;
          final progress = updatedLessons.isEmpty
              ? 0.0
              : completedCount / updatedLessons.length;

          return (level as LevelModel).copyWith(
            lessons: updatedLessons.cast<LessonModel>(),
            progress: progress,
          );
        }
        return level;
      }).toList();

      if (updated) {
        _programs[i] =
            program.copyWith(levels: updatedLevels.cast<LevelModel>());

        // Actualizar desbloqueo de niveles si es necesario
        _updateLevelUnlocking(i);
        break;
      }
    }
  }

  void _updateLevelUnlocking(int programIndex) {
    final program = _programs[programIndex];
    final updatedLevels = <LevelModel>[];

    for (var i = 0; i < program.levels.length; i++) {
      final level = program.levels[i] as LevelModel;

      if (i == 0) {
        // Primer nivel siempre desbloqueado
        updatedLevels.add(level.copyWith(isUnlocked: true));
      } else {
        // Desbloquear si el nivel anterior está completado
        final previousLevel = updatedLevels[i - 1];
        final shouldUnlock = previousLevel.isCompleted;
        updatedLevels
            .add(level.copyWith(isUnlocked: shouldUnlock || level.isUnlocked));
      }
    }

    _programs[programIndex] =
        program.copyWith(levels: updatedLevels.cast<LevelModel>());
  }
}
