import 'package:comunidad_acordeoneros/features/programs/domain/entities/level_entity.dart';
import 'package:comunidad_acordeoneros/features/programs/data/models/lesson_model.dart';

class LevelModel extends LevelEntity {
  const LevelModel({
    required super.id,
    required super.name,
    required super.description,
    required super.order,
    required super.lessons,
    super.isUnlocked,
    super.progress,
  });

  factory LevelModel.fromJson(Map<String, dynamic> json) {
    return LevelModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      order: json['order'] as int,
      lessons: (json['lessons'] as List<dynamic>?)
              ?.map((lesson) =>
                  LessonModel.fromJson(lesson as Map<String, dynamic>))
              .toList() ??
          [],
      isUnlocked: json['isUnlocked'] as bool? ?? false,
      progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'order': order,
      'lessons':
          lessons.map((lesson) => (lesson as LessonModel).toJson()).toList(),
      'isUnlocked': isUnlocked,
      'progress': progress,
    };
  }

  LevelModel copyWith({
    String? id,
    String? name,
    String? description,
    int? order,
    List<LessonModel>? lessons,
    bool? isUnlocked,
    double? progress,
  }) {
    return LevelModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      order: order ?? this.order,
      lessons: lessons ?? this.lessons,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      progress: progress ?? this.progress,
    );
  }

  /// Convierte de Entity a Model
  static LevelModel fromEntity(LevelEntity entity) {
    return LevelModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      order: entity.order,
      lessons: entity.lessons
          .map((lesson) => LessonModel.fromEntity(lesson))
          .toList(),
      isUnlocked: entity.isUnlocked,
      progress: entity.progress,
    );
  }

  /// Convierte de Model a Entity
  LevelEntity toEntity() {
    return LevelEntity(
      id: id,
      name: name,
      description: description,
      order: order,
      lessons:
          lessons.map((lesson) => (lesson as LessonModel).toEntity()).toList(),
      isUnlocked: isUnlocked,
      progress: progress,
    );
  }
}
