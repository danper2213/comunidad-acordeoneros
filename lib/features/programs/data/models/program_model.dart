import 'package:comunidad_acordeoneros/features/programs/domain/entities/program_entity.dart';
import 'package:comunidad_acordeoneros/features/programs/data/models/level_model.dart';

class ProgramModel extends ProgramEntity {
  const ProgramModel({
    required super.id,
    required super.name,
    required super.description,
    required super.imageUrl,
    required super.levels,
    super.isActive,
    required super.instructor,
    required super.createdAt,
    super.updatedAt,
  });

  factory ProgramModel.fromJson(Map<String, dynamic> json) {
    return ProgramModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      levels: (json['levels'] as List<dynamic>?)
              ?.map(
                  (level) => LevelModel.fromJson(level as Map<String, dynamic>))
              .toList() ??
          [],
      isActive: json['isActive'] as bool? ?? true,
      instructor: json['instructor'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'levels': levels.map((level) => (level as LevelModel).toJson()).toList(),
      'isActive': isActive,
      'instructor': instructor,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  ProgramModel copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    List<LevelModel>? levels,
    bool? isActive,
    String? instructor,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProgramModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      levels: levels ?? this.levels,
      isActive: isActive ?? this.isActive,
      instructor: instructor ?? this.instructor,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
