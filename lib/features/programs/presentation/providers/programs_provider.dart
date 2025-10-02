import 'package:flutter/material.dart';
import 'package:comunidad_acordeoneros/features/programs/domain/entities/program_entity.dart';
import 'package:comunidad_acordeoneros/features/programs/domain/entities/level_entity.dart';
import 'package:comunidad_acordeoneros/features/programs/domain/entities/lesson_entity.dart';
import 'package:comunidad_acordeoneros/features/programs/domain/entities/comment_entity.dart';
import 'package:comunidad_acordeoneros/features/programs/domain/repositories/programs_repository.dart';

enum ProgramsStatus { initial, loading, loaded, error }

class ProgramsProvider extends ChangeNotifier {
  final ProgramsRepository repository;

  ProgramsProvider({required this.repository});

  ProgramsStatus _status = ProgramsStatus.initial;
  List<ProgramEntity> _programs = [];
  ProgramEntity? _selectedProgram;
  LevelEntity? _selectedLevel;
  LessonEntity? _selectedLesson;
  List<CommentEntity> _comments = [];
  String? _errorMessage;

  // Getters
  ProgramsStatus get status => _status;
  List<ProgramEntity> get programs => _programs;
  ProgramEntity? get selectedProgram => _selectedProgram;
  LevelEntity? get selectedLevel => _selectedLevel;
  LessonEntity? get selectedLesson => _selectedLesson;
  List<CommentEntity> get comments => _comments;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == ProgramsStatus.loading;

  // Cargar todos los programas
  Future<void> loadPrograms() async {
    _status = ProgramsStatus.loading;
    notifyListeners();

    final result = await repository.getPrograms();

    result.fold(
      (failure) {
        _status = ProgramsStatus.error;
        _errorMessage = failure.message;
      },
      (programs) {
        _programs = programs;
        _status = ProgramsStatus.loaded;
        _errorMessage = null;
      },
    );

    notifyListeners();
  }

  // Seleccionar un programa
  Future<void> selectProgram(String programId) async {
    final result = await repository.getProgramById(programId);

    result.fold(
      (failure) {
        _errorMessage = failure.message;
        notifyListeners();
      },
      (program) {
        _selectedProgram = program;
        // Auto-seleccionar el nivel actual
        _selectedLevel = program.currentLevel;
        notifyListeners();
      },
    );
  }

  // Seleccionar un nivel
  void selectLevel(LevelEntity level) {
    _selectedLevel = level;
    notifyListeners();
  }

  // Seleccionar una clase
  void selectLesson(LessonEntity lesson) {
    _selectedLesson = lesson;
    notifyListeners();
  }

  // Marcar clase como completada
  Future<void> markLessonAsCompleted(String lessonId) async {
    final result = await repository.markLessonAsCompleted(lessonId);

    result.fold(
      (failure) {
        _errorMessage = failure.message;
        notifyListeners();
      },
      (_) {
        // Recargar el programa para actualizar el progreso
        if (_selectedProgram != null) {
          selectProgram(_selectedProgram!.id);
        }
      },
    );
  }

  // Cargar comentarios de una clase
  Future<void> loadComments(String lessonId) async {
    final result = await repository.getCommentsByLessonId(lessonId);

    result.fold(
      (failure) {
        _errorMessage = failure.message;
        _comments = [];
      },
      (comments) {
        _comments = comments;
        _errorMessage = null;
      },
    );

    notifyListeners();
  }

  // Agregar comentario
  Future<bool> addComment({
    required String lessonId,
    required String userId,
    required String userName,
    String? userPhotoUrl,
    required String content,
  }) async {
    final result = await repository.addComment(
      lessonId: lessonId,
      userId: userId,
      userName: userName,
      userPhotoUrl: userPhotoUrl,
      content: content,
    );

    return result.fold(
      (failure) {
        _errorMessage = failure.message;
        notifyListeners();
        return false;
      },
      (comment) {
        // Recargar comentarios
        loadComments(lessonId);
        return true;
      },
    );
  }

  // Eliminar comentario
  Future<bool> deleteComment(String commentId, String lessonId) async {
    final result = await repository.deleteComment(commentId);

    return result.fold(
      (failure) {
        _errorMessage = failure.message;
        notifyListeners();
        return false;
      },
      (_) {
        // Recargar comentarios
        loadComments(lessonId);
        return true;
      },
    );
  }

  // Dar like a comentario
  Future<void> likeComment(String commentId, String userId) async {
    final result = await repository.likeComment(commentId, userId);

    result.fold(
      (failure) {
        _errorMessage = failure.message;
        notifyListeners();
      },
      (updatedComment) {
        // Actualizar el comentario en la lista local
        final index = _comments.indexWhere((c) => c.id == commentId);
        if (index != -1) {
          _comments[index] = updatedComment;
          notifyListeners();
        }
      },
    );
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
