class CommentEntity {
  final String id;
  final String lessonId;
  final String userId;
  final String userName;
  final String? userPhotoUrl;
  final String content;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final int likes;
  final bool isLikedByCurrentUser;

  const CommentEntity({
    required this.id,
    required this.lessonId,
    required this.userId,
    required this.userName,
    this.userPhotoUrl,
    required this.content,
    required this.createdAt,
    this.updatedAt,
    this.likes = 0,
    this.isLikedByCurrentUser = false,
  });
}
