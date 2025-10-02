import 'package:comunidad_acordeoneros/features/programs/domain/entities/lesson_entity.dart';

class LessonModel extends LessonEntity {
  const LessonModel({
    required super.id,
    required super.title,
    required super.description,
    required super.videoUrl,
    super.thumbnailUrl,
    required super.duration,
    required super.order,
    super.isCompleted,
    super.views,
  });

  factory LessonModel.fromJson(Map<String, dynamic> json) {
    return LessonModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      videoUrl: json['videoUrl'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      duration: json['duration'] as int,
      order: json['order'] as int,
      isCompleted: json['isCompleted'] as bool? ?? false,
      views: json['views'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'videoUrl': videoUrl,
      'thumbnailUrl': thumbnailUrl,
      'duration': duration,
      'order': order,
      'isCompleted': isCompleted,
      'views': views,
    };
  }

  LessonModel copyWith({
    String? id,
    String? title,
    String? description,
    String? videoUrl,
    String? thumbnailUrl,
    int? duration,
    int? order,
    bool? isCompleted,
    int? views,
  }) {
    return LessonModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      videoUrl: videoUrl ?? this.videoUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      duration: duration ?? this.duration,
      order: order ?? this.order,
      isCompleted: isCompleted ?? this.isCompleted,
      views: views ?? this.views,
    );
  }
}
