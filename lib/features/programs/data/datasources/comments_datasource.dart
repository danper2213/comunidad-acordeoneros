import 'package:comunidad_acordeoneros/features/programs/data/models/comment_model.dart';

/// Data source para comentarios
/// En producción, esto vendría de Firebase/API
abstract class CommentsDataSource {
  Future<List<CommentModel>> getCommentsByLessonId(String lessonId);
  Future<CommentModel> addComment({
    required String lessonId,
    required String userId,
    required String userName,
    String? userPhotoUrl,
    required String content,
  });
  Future<void> deleteComment(String commentId);
  Future<CommentModel> likeComment(String commentId, String userId);
}

class CommentsDataSourceImpl implements CommentsDataSource {
  // Simulación de base de datos en memoria
  final List<CommentModel> _comments = [];

  @override
  Future<List<CommentModel>> getCommentsByLessonId(String lessonId) async {
    // Simular delay de red
    await Future.delayed(const Duration(milliseconds: 500));

    return _comments.where((comment) => comment.lessonId == lessonId).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  @override
  Future<CommentModel> addComment({
    required String lessonId,
    required String userId,
    required String userName,
    String? userPhotoUrl,
    required String content,
  }) async {
    // Simular delay de red
    await Future.delayed(const Duration(milliseconds: 300));

    final comment = CommentModel(
      id: 'comment-${DateTime.now().millisecondsSinceEpoch}',
      lessonId: lessonId,
      userId: userId,
      userName: userName,
      userPhotoUrl: userPhotoUrl,
      content: content,
      createdAt: DateTime.now(),
      likes: 0,
      isLikedByCurrentUser: false,
    );

    _comments.add(comment);
    return comment;
  }

  @override
  Future<void> deleteComment(String commentId) async {
    // Simular delay de red
    await Future.delayed(const Duration(milliseconds: 300));

    _comments.removeWhere((comment) => comment.id == commentId);
  }

  @override
  Future<CommentModel> likeComment(String commentId, String userId) async {
    // Simular delay de red
    await Future.delayed(const Duration(milliseconds: 200));

    final index = _comments.indexWhere((c) => c.id == commentId);
    if (index == -1) {
      throw Exception('Comentario no encontrado');
    }

    final comment = _comments[index];
    final isLiked = comment.isLikedByCurrentUser;

    final updatedComment = comment.copyWith(
      likes: isLiked ? comment.likes - 1 : comment.likes + 1,
      isLikedByCurrentUser: !isLiked,
    );

    _comments[index] = updatedComment;
    return updatedComment;
  }
}
