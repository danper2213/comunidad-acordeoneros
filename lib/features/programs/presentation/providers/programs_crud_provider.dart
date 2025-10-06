import 'package:flutter/material.dart';
import 'package:comunidad_acordeoneros/features/programs/domain/entities/program_entity.dart';
import 'package:comunidad_acordeoneros/features/programs/domain/entities/level_entity.dart';
import 'package:comunidad_acordeoneros/features/programs/domain/entities/lesson_entity.dart';
import 'package:comunidad_acordeoneros/features/programs/data/services/programs_service.dart';

class ProgramsCrudProvider extends ChangeNotifier {
  List<ProgramEntity> _programs = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<ProgramEntity> get programs => _programs;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Estado de operaciones CRUD
  bool _isCreating = false;
  bool _isUpdating = false;
  bool _isDeleting = false;

  bool get isCreating => _isCreating;
  bool get isUpdating => _isUpdating;
  bool get isDeleting => _isDeleting;

  /// Inicializa el provider cargando los programas
  Future<void> initialize() async {
    await loadPrograms();
  }

  /// Carga todos los programas
  Future<void> loadPrograms() async {
    _setLoading(true);
    _clearError();

    try {
      _programs = await ProgramsService.getAllPrograms();

      // Si no hay programas en Firebase, cargar datos de ejemplo
      if (_programs.isEmpty) {
        _loadSamplePrograms();
      }
    } catch (e) {
      // Si hay error con Firestore, mostrar datos de ejemplo
      _setError('Error al cargar los programas: $e');
      _loadSamplePrograms();
    } finally {
      _setLoading(false);
    }
  }

  /// Carga programas de ejemplo cuando Firestore no está disponible
  void _loadSamplePrograms() {
    _programs = [
      ProgramEntity(
        id: 'sample_1',
        name: 'Curso Básico de Acordeón',
        description:
            'Aprende los fundamentos del acordeón desde cero. Este curso te llevará desde conocer las partes del instrumento hasta tocar tus primeras melodías.',
        imageUrl: 'assets/images/fer-festival.jpg',
        instructor: 'María González',
        isActive: true,
        levels: [
          LevelEntity(
            id: 'level_1',
            name: 'Introducción al Acordeón',
            description:
                'Conoce las partes del acordeón, postura correcta y primeros ejercicios.',
            order: 1,
            lessons: [
              LessonEntity(
                id: 'lesson_1',
                title: 'Conociendo tu Acordeón',
                description:
                    'Aprende sobre las diferentes partes del acordeón y cómo funciona el instrumento.',
                videoUrl: 'assets/videos/test.mp4',
                thumbnailUrl: 'assets/images/fer-festival.jpg',
                duration: 600,
                order: 1,
              ),
              LessonEntity(
                id: 'lesson_2',
                title: 'Postura Correcta',
                description:
                    'Aprende la postura correcta para tocar el acordeón sin lesionarte.',
                videoUrl: 'assets/videos/test.mp4',
                thumbnailUrl: 'assets/images/fer-festival.jpg',
                duration: 480,
                order: 2,
              ),
            ],
            isUnlocked: true,
            progress: 0.3,
          ),
          LevelEntity(
            id: 'level_2',
            name: 'Escalas y Acordes Básicos',
            description:
                'Aprende las escalas fundamentales y acordes básicos en el acordeón.',
            order: 2,
            lessons: [
              LessonEntity(
                id: 'lesson_3',
                title: 'Escala de Do Mayor',
                description:
                    'Aprende la escala de Do Mayor en el acordeón, paso a paso.',
                videoUrl: 'assets/videos/test.mp4',
                thumbnailUrl: 'assets/images/fer-festival.jpg',
                duration: 720,
                order: 1,
              ),
            ],
            isUnlocked: false,
            progress: 0.0,
          ),
        ],
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        updatedAt: DateTime.now(),
      ),
      ProgramEntity(
        id: 'sample_2',
        name: 'Técnicas Avanzadas de Acordeón',
        description:
            'Domina técnicas avanzadas como el acordeón diatónico, ornamentos, y estilos musicales tradicionales. Para estudiantes con conocimientos previos.',
        imageUrl: 'assets/images/fer-festival.jpg',
        instructor: 'Carlos Mendoza',
        isActive: true,
        levels: [
          LevelEntity(
            id: 'level_3',
            name: 'Acordeón Diatónico',
            description:
                'Domina el acordeón diatónico y sus características únicas.',
            order: 1,
            lessons: [
              LessonEntity(
                id: 'lesson_4',
                title: 'Introducción al Diatónico',
                description:
                    'Conoce las características únicas del acordeón diatónico.',
                videoUrl: 'assets/videos/test.mp4',
                thumbnailUrl: 'assets/images/fer-festival.jpg',
                duration: 900,
                order: 1,
              ),
            ],
            isUnlocked: true,
            progress: 0.0,
          ),
        ],
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        updatedAt: DateTime.now(),
      ),
    ];
    notifyListeners();
  }

  /// Crea un nuevo programa
  Future<String?> createProgram({
    required String name,
    required String description,
    required String instructor,
    String? imageUrl,
    List<LevelEntity> levels = const [],
  }) async {
    _setCreating(true);
    _clearError();

    try {
      final programId = await ProgramsService.createProgram(
        name: name,
        description: description,
        instructor: instructor,
        imageUrl: imageUrl,
        levels: levels,
      );

      if (programId != null) {
        // Recargar la lista de programas
        await loadPrograms();
        return programId;
      } else {
        _setError('Error al crear el programa');
        return null;
      }
    } catch (e) {
      _setError('Error al crear el programa: $e');
      return null;
    } finally {
      _setCreating(false);
    }
  }

  /// Actualiza un programa existente
  Future<bool> updateProgram({
    required String id,
    String? name,
    String? description,
    String? instructor,
    String? imageUrl,
    bool? isActive,
    List<LevelEntity>? levels,
  }) async {
    _setUpdating(true);
    _clearError();

    try {
      final success = await ProgramsService.updateProgram(
        id: id,
        name: name,
        description: description,
        instructor: instructor,
        imageUrl: imageUrl,
        isActive: isActive,
        levels: levels,
      );

      if (success) {
        // Recargar la lista de programas
        await loadPrograms();
        return true;
      } else {
        _setError('Error al actualizar el programa');
        return false;
      }
    } catch (e) {
      _setError('Error al actualizar el programa: $e');
      return false;
    } finally {
      _setUpdating(false);
    }
  }

  /// Elimina un programa
  Future<bool> deleteProgram(String id) async {
    _setDeleting(true);
    _clearError();

    try {
      final success = await ProgramsService.deleteProgram(id);

      if (success) {
        // Remover el programa de la lista local
        _programs.removeWhere((program) => program.id == id);
        notifyListeners();
        return true;
      } else {
        _setError('Error al eliminar el programa');
        return false;
      }
    } catch (e) {
      _setError('Error al eliminar el programa: $e');
      return false;
    } finally {
      _setDeleting(false);
    }
  }

  /// Obtiene un programa por ID
  ProgramEntity? getProgramById(String id) {
    try {
      return _programs.firstWhere((program) => program.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Crea un nuevo nivel para un programa
  Future<String?> createLevel({
    required String programId,
    required String name,
    required String description,
    required int order,
    List<LessonEntity> lessons = const [],
  }) async {
    _clearError();

    try {
      final levelId = await ProgramsService.createLevel(
        programId: programId,
        name: name,
        description: description,
        order: order,
        lessons: lessons,
      );

      if (levelId != null) {
        // Recargar los programas para obtener la actualización
        await loadPrograms();
        return levelId;
      } else {
        _setError('Error al crear el nivel');
        return null;
      }
    } catch (e) {
      _setError('Error al crear el nivel: $e');
      return null;
    }
  }

  /// Crea una nueva lección para un nivel
  Future<String?> createLesson({
    required String programId,
    required String levelId,
    required String title,
    required String description,
    required String videoUrl,
    String? thumbnailUrl,
    required int duration,
    required int order,
  }) async {
    _clearError();

    try {
      final lessonId = await ProgramsService.createLesson(
        programId: programId,
        levelId: levelId,
        title: title,
        description: description,
        videoUrl: videoUrl,
        thumbnailUrl: thumbnailUrl,
        duration: duration,
        order: order,
      );

      if (lessonId != null) {
        // Recargar los programas para obtener la actualización
        await loadPrograms();
        return lessonId;
      } else {
        _setError('Error al crear la lección');
        return null;
      }
    } catch (e) {
      _setError('Error al crear la lección: $e');
      return null;
    }
  }

  /// Obtiene programas filtrados
  List<ProgramEntity> getFilteredPrograms({
    String? searchQuery,
    bool? isActive,
    String? instructor,
  }) {
    var filteredPrograms = _programs;

    if (searchQuery != null && searchQuery.isNotEmpty) {
      filteredPrograms = filteredPrograms
          .where((program) =>
              program.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
              program.description
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase()) ||
              program.instructor
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase()))
          .toList();
    }

    if (isActive != null) {
      filteredPrograms = filteredPrograms
          .where((program) => program.isActive == isActive)
          .toList();
    }

    if (instructor != null && instructor.isNotEmpty) {
      filteredPrograms = filteredPrograms
          .where((program) => program.instructor
              .toLowerCase()
              .contains(instructor.toLowerCase()))
          .toList();
    }

    return filteredPrograms;
  }

  /// Obtiene estadísticas de los programas
  Map<String, int> getProgramStats() {
    final totalPrograms = _programs.length;
    final activePrograms = _programs.where((p) => p.isActive).length;
    final totalLevels =
        _programs.fold<int>(0, (sum, p) => sum + p.levels.length);
    final totalLessons = _programs.fold<int>(
        0,
        (sum, p) =>
            sum +
            p.levels.fold<int>(
                0, (levelSum, level) => levelSum + level.lessons.length));

    return {
      'totalPrograms': totalPrograms,
      'activePrograms': activePrograms,
      'inactivePrograms': totalPrograms - activePrograms,
      'totalLevels': totalLevels,
      'totalLessons': totalLessons,
    };
  }

  /// Limpia el error actual
  void clearError() {
    _clearError();
  }

  /// Refresca los datos
  Future<void> refresh() async {
    await loadPrograms();
  }

  // Métodos privados para manejar el estado
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setCreating(bool creating) {
    _isCreating = creating;
    notifyListeners();
  }

  void _setUpdating(bool updating) {
    _isUpdating = updating;
    notifyListeners();
  }

  void _setDeleting(bool deleting) {
    _isDeleting = deleting;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }
}
