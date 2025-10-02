import 'package:comunidad_acordeoneros/core/errors/failures.dart';
import 'package:comunidad_acordeoneros/core/utils/either.dart';
import 'package:comunidad_acordeoneros/features/programs/domain/entities/program_entity.dart';
import 'package:comunidad_acordeoneros/features/programs/domain/entities/lesson_entity.dart';
import 'package:comunidad_acordeoneros/features/programs/domain/entities/comment_entity.dart';
import 'package:comunidad_acordeoneros/features/programs/domain/repositories/programs_repository.dart';
import 'package:comunidad_acordeoneros/features/programs/data/datasources/programs_local_datasource.dart';
import 'package:comunidad_acordeoneros/features/programs/data/datasources/comments_datasource.dart';

class ProgramsRepositoryImpl implements ProgramsRepository {
  final ProgramsLocalDataSource localDataSource;
  final CommentsDataSource commentsDataSource;

  ProgramsRepositoryImpl({
    required this.localDataSource,
    required this.commentsDataSource,
  });

  @override
  Future<Either<Failure, List<ProgramEntity>>> getPrograms() async {
    try {
      final programs = localDataSource.getPrograms();
      return Right(programs);
    } catch (e) {
      return Left(ServerFailure('Error al obtener programas: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, ProgramEntity>> getProgramById(String id) async {
    try {
      final program = localDataSource.getProgramById(id);
      if (program == null) {
        return const Left(ServerFailure('Programa no encontrado'));
      }
      return Right(program);
    } catch (e) {
      return Left(ServerFailure('Error al obtener programa: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<LessonEntity>>> getLessonsByLevelId(
      String levelId) async {
    try {
      final lessons = localDataSource.getLessonsByLevelId(levelId);
      return Right(lessons);
    } catch (e) {
      return Left(ServerFailure('Error al obtener clases: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> markLessonAsCompleted(String lessonId) async {
    try {
      localDataSource.markLessonAsCompleted(lessonId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(
          'Error al marcar clase como completada: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<CommentEntity>>> getCommentsByLessonId(
      String lessonId) async {
    try {
      final comments = await commentsDataSource.getCommentsByLessonId(lessonId);
      return Right(comments);
    } catch (e) {
      return Left(
          ServerFailure('Error al obtener comentarios: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, CommentEntity>> addComment({
    required String lessonId,
    required String userId,
    required String userName,
    String? userPhotoUrl,
    required String content,
  }) async {
    try {
      final comment = await commentsDataSource.addComment(
        lessonId: lessonId,
        userId: userId,
        userName: userName,
        userPhotoUrl: userPhotoUrl,
        content: content,
      );
      return Right(comment);
    } catch (e) {
      return Left(
          ServerFailure('Error al agregar comentario: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteComment(String commentId) async {
    try {
      await commentsDataSource.deleteComment(commentId);
      return const Right(null);
    } catch (e) {
      return Left(
          ServerFailure('Error al eliminar comentario: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, CommentEntity>> likeComment(
      String commentId, String userId) async {
    try {
      final comment = await commentsDataSource.likeComment(commentId, userId);
      return Right(comment);
    } catch (e) {
      return Left(ServerFailure('Error al dar like: ${e.toString()}'));
    }
  }
}
