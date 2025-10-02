import 'package:comunidad_acordeoneros/core/errors/failures.dart';
import 'package:comunidad_acordeoneros/core/utils/either.dart';
import 'package:comunidad_acordeoneros/features/programs/domain/entities/program_entity.dart';
import 'package:comunidad_acordeoneros/features/programs/domain/entities/lesson_entity.dart';
import 'package:comunidad_acordeoneros/features/programs/domain/entities/comment_entity.dart';

abstract class ProgramsRepository {
  Future<Either<Failure, List<ProgramEntity>>> getPrograms();
  Future<Either<Failure, ProgramEntity>> getProgramById(String id);
  Future<Either<Failure, List<LessonEntity>>> getLessonsByLevelId(
      String levelId);
  Future<Either<Failure, void>> markLessonAsCompleted(String lessonId);
  Future<Either<Failure, List<CommentEntity>>> getCommentsByLessonId(
      String lessonId);
  Future<Either<Failure, CommentEntity>> addComment({
    required String lessonId,
    required String userId,
    required String userName,
    String? userPhotoUrl,
    required String content,
  });
  Future<Either<Failure, void>> deleteComment(String commentId);
  Future<Either<Failure, CommentEntity>> likeComment(
      String commentId, String userId);
}
