import 'package:comunidad_acordeoneros/core/services/firestore_service.dart';
import 'package:comunidad_acordeoneros/core/services/storage_service.dart';
import 'package:comunidad_acordeoneros/features/programs/domain/entities/program_entity.dart';
import 'package:comunidad_acordeoneros/features/programs/domain/entities/level_entity.dart';
import 'package:comunidad_acordeoneros/features/programs/domain/entities/lesson_entity.dart';
import 'package:comunidad_acordeoneros/features/programs/data/models/program_model.dart';
import 'package:comunidad_acordeoneros/features/programs/data/models/level_model.dart';
import 'package:comunidad_acordeoneros/features/programs/data/models/lesson_model.dart';

class ProgramsService {
  static const String _programsCollection = 'programs';
  static const String _levelsCollection = 'levels';
  static const String _lessonsCollection = 'lessons';

  /// Crea un nuevo programa
  static Future<String?> createProgram({
    required String name,
    required String description,
    required String instructor,
    String? imageUrl,
    List<LevelEntity> levels = const [],
  }) async {
    try {
      // Si no se proporciona imagen, usar una por defecto
      String finalImageUrl = imageUrl ?? 'assets/images/fer-festival.jpg';

      final programData = {
        'name': name,
        'description': description,
        'instructor': instructor,
        'imageUrl': finalImageUrl,
        'isActive': true,
        'levels': levels
            .map((level) => LevelModel.fromEntity(level).toJson())
            .toList(),
      };

      return await FirestoreService.createDocument(
        collection: _programsCollection,
        data: programData,
      );
    } catch (e) {
      print('Error creating program: $e');
      return null;
    }
  }

  /// Obtiene todos los programas
  static Future<List<ProgramEntity>> getAllPrograms() async {
    try {
      final snapshot = await FirestoreService.getCollection(
        collection: _programsCollection,
        orderBy: 'createdAt',
        descending: true,
      );

      if (snapshot == null) return [];

      return snapshot.docs
          .map((doc) =>
              ProgramModel.fromJson(doc.data() as Map<String, dynamic>))
          .map((model) => model.toEntity())
          .toList();
    } catch (e) {
      print('Error getting programs: $e');
      return [];
    }
  }

  /// Obtiene un programa por ID
  static Future<ProgramEntity?> getProgramById(String id) async {
    try {
      final doc = await FirestoreService.getDocument(
        collection: _programsCollection,
        id: id,
      );

      if (doc == null || !doc.exists) return null;

      return ProgramModel.fromJson(doc.data() as Map<String, dynamic>)
          .toEntity();
    } catch (e) {
      print('Error getting program: $e');
      return null;
    }
  }

  /// Actualiza un programa
  static Future<bool> updateProgram({
    required String id,
    String? name,
    String? description,
    String? instructor,
    String? imageUrl,
    bool? isActive,
    List<LevelEntity>? levels,
  }) async {
    try {
      final updateData = <String, dynamic>{};

      if (name != null) updateData['name'] = name;
      if (description != null) updateData['description'] = description;
      if (instructor != null) updateData['instructor'] = instructor;
      if (imageUrl != null) updateData['imageUrl'] = imageUrl;
      if (isActive != null) updateData['isActive'] = isActive;
      if (levels != null) {
        updateData['levels'] = levels
            .map((level) => LevelModel.fromEntity(level).toJson())
            .toList();
      }

      return await FirestoreService.updateDocument(
        collection: _programsCollection,
        id: id,
        data: updateData,
      );
    } catch (e) {
      print('Error updating program: $e');
      return false;
    }
  }

  /// Elimina un programa
  static Future<bool> deleteProgram(String id) async {
    try {
      // Primero obtener el programa para eliminar la imagen si es necesario
      final program = await getProgramById(id);

      // Eliminar la imagen del storage si no es la por defecto
      if (program != null &&
          !program.imageUrl.startsWith('assets/') &&
          program.imageUrl.isNotEmpty) {
        await StorageService.deleteFile(program.imageUrl);
      }

      // Eliminar todos los niveles y lecciones asociados
      await _deleteProgramLevels(id);

      // Eliminar el programa
      return await FirestoreService.deleteDocument(
        collection: _programsCollection,
        id: id,
      );
    } catch (e) {
      print('Error deleting program: $e');
      return false;
    }
  }

  /// Crea un nuevo nivel para un programa
  static Future<String?> createLevel({
    required String programId,
    required String name,
    required String description,
    required int order,
    List<LessonEntity> lessons = const [],
  }) async {
    try {
      final levelData = {
        'programId': programId,
        'name': name,
        'description': description,
        'order': order,
        'isUnlocked': order == 1, // El primer nivel siempre está desbloqueado
        'progress': 0.0,
        'lessons': lessons
            .map((lesson) => LessonModel.fromEntity(lesson).toJson())
            .toList(),
      };

      final levelId = await FirestoreService.createDocument(
        collection: _levelsCollection,
        data: levelData,
      );

      if (levelId != null) {
        // Actualizar el programa para incluir el nuevo nivel
        final program = await getProgramById(programId);
        if (program != null) {
          final newLevel = LevelEntity(
            id: levelId,
            name: name,
            description: description,
            order: order,
            lessons: lessons,
            isUnlocked: order == 1,
            progress: 0.0,
          );

          final updatedLevels = List<LevelEntity>.from(program.levels)
            ..add(newLevel);
          await updateProgram(id: programId, levels: updatedLevels);
        }
      }

      return levelId;
    } catch (e) {
      print('Error creating level: $e');
      return null;
    }
  }

  /// Crea una nueva lección para un nivel
  static Future<String?> createLesson({
    required String programId,
    required String levelId,
    required String title,
    required String description,
    required String videoUrl,
    String? thumbnailUrl,
    required int duration,
    required int order,
  }) async {
    try {
      final lessonData = {
        'programId': programId,
        'levelId': levelId,
        'title': title,
        'description': description,
        'videoUrl': videoUrl,
        'thumbnailUrl': thumbnailUrl,
        'duration': duration,
        'order': order,
        'isCompleted': false,
        'views': 0,
      };

      final lessonId = await FirestoreService.createDocument(
        collection: _lessonsCollection,
        data: lessonData,
      );

      if (lessonId != null) {
        // Actualizar el nivel para incluir la nueva lección
        final program = await getProgramById(programId);
        if (program != null) {
          final levelIndex = program.levels.indexWhere((l) => l.id == levelId);
          if (levelIndex != -1) {
            final level = program.levels[levelIndex];
            final newLesson = LessonEntity(
              id: lessonId,
              title: title,
              description: description,
              videoUrl: videoUrl,
              thumbnailUrl: thumbnailUrl,
              duration: duration,
              order: order,
            );

            final updatedLessons = List<LessonEntity>.from(level.lessons)
              ..add(newLesson);
            final updatedLevel = LevelEntity(
              id: level.id,
              name: level.name,
              description: level.description,
              order: level.order,
              lessons: updatedLessons,
              isUnlocked: level.isUnlocked,
              progress: level.progress,
            );

            final updatedLevels = List<LevelEntity>.from(program.levels);
            updatedLevels[levelIndex] = updatedLevel;

            await updateProgram(id: programId, levels: updatedLevels);
          }
        }
      }

      return lessonId;
    } catch (e) {
      print('Error creating lesson: $e');
      return null;
    }
  }

  /// Elimina todos los niveles de un programa
  static Future<void> _deleteProgramLevels(String programId) async {
    try {
      final levelsSnapshot = await FirestoreService.getDocumentsWithFilters(
        collection: _levelsCollection,
        filters: [FirestoreFilter(field: 'programId', value: programId)],
      );

      if (levelsSnapshot != null) {
        for (final doc in levelsSnapshot.docs) {
          await _deleteLevelLessons(doc.id);
          await FirestoreService.deleteDocument(
            collection: _levelsCollection,
            id: doc.id,
          );
        }
      }
    } catch (e) {
      print('Error deleting program levels: $e');
    }
  }

  /// Elimina todas las lecciones de un nivel
  static Future<void> _deleteLevelLessons(String levelId) async {
    try {
      final lessonsSnapshot = await FirestoreService.getDocumentsWithFilters(
        collection: _lessonsCollection,
        filters: [FirestoreFilter(field: 'levelId', value: levelId)],
      );

      if (lessonsSnapshot != null) {
        for (final doc in lessonsSnapshot.docs) {
          final lessonData = doc.data() as Map<String, dynamic>;
          final videoUrl = lessonData['videoUrl'] as String?;
          final thumbnailUrl = lessonData['thumbnailUrl'] as String?;

          // Eliminar video y thumbnail del storage
          if (videoUrl != null && videoUrl.isNotEmpty) {
            await StorageService.deleteFile(videoUrl);
          }
          if (thumbnailUrl != null && thumbnailUrl.isNotEmpty) {
            await StorageService.deleteFile(thumbnailUrl);
          }

          await FirestoreService.deleteDocument(
            collection: _lessonsCollection,
            id: doc.id,
          );
        }
      }
    } catch (e) {
      print('Error deleting level lessons: $e');
    }
  }

  /// Obtiene programas en tiempo real
  static Stream<List<ProgramEntity>> getProgramsStream() {
    return FirestoreService.listenToCollection(
      collection: _programsCollection,
      orderBy: 'createdAt',
      descending: true,
    ).map((snapshot) {
      return snapshot.docs
          .map((doc) =>
              ProgramModel.fromJson(doc.data() as Map<String, dynamic>))
          .map((model) => model.toEntity())
          .toList();
    });
  }
}
