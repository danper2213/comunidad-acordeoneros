import 'package:comunidad_acordeoneros/features/programs/domain/entities/comment_entity.dart';

class CommentModel extends CommentEntity {
  const CommentModel({
    required super.id,
    required super.lessonId,
    required super.userId,
    required super.userName,
    super.userPhotoUrl,
    required super.content,
    required super.createdAt,
    super.updatedAt,
    super.likes,
    super.isLikedByCurrentUser,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'] as String,
      lessonId: json['lessonId'] as String,
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      userPhotoUrl: json['userPhotoUrl'] as String?,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      likes: json['likes'] as int? ?? 0,
      isLikedByCurrentUser: json['isLikedByCurrentUser'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'lessonId': lessonId,
      'userId': userId,
      'userName': userName,
      'userPhotoUrl': userPhotoUrl,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'likes': likes,
      'isLikedByCurrentUser': isLikedByCurrentUser,
    };
  }

  CommentModel copyWith({
    String? id,
    String? lessonId,
    String? userId,
    String? userName,
    String? userPhotoUrl,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? likes,
    bool? isLikedByCurrentUser,
  }) {
    return CommentModel(
      id: id ?? this.id,
      lessonId: lessonId ?? this.lessonId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userPhotoUrl: userPhotoUrl ?? this.userPhotoUrl,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      likes: likes ?? this.likes,
      isLikedByCurrentUser: isLikedByCurrentUser ?? this.isLikedByCurrentUser,
    );
  }
}
