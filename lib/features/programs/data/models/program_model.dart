import 'package:comunidad_acordeoneros/features/programs/domain/entities/program_entity.dart';
import 'package:comunidad_acordeoneros/features/programs/data/models/level_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
      createdAt: _parseDateTime(json['createdAt']),
      updatedAt:
          json['updatedAt'] != null ? _parseDateTime(json['updatedAt']) : null,
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

  /// Convierte de Entity a Model
  static ProgramModel fromEntity(ProgramEntity entity) {
    return ProgramModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      imageUrl: entity.imageUrl,
      levels:
          entity.levels.map((level) => LevelModel.fromEntity(level)).toList(),
      isActive: entity.isActive,
      instructor: entity.instructor,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  /// Convierte de Model a Entity
  ProgramEntity toEntity() {
    return ProgramEntity(
      id: id,
      name: name,
      description: description,
      imageUrl: imageUrl,
      levels: levels.map((level) => (level as LevelModel).toEntity()).toList(),
      isActive: isActive,
      instructor: instructor,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Helper method para parsear DateTime desde Firestore
  static DateTime _parseDateTime(dynamic dateValue) {
    if (dateValue == null) {
      return DateTime.now();
    }

    if (dateValue is Timestamp) {
      return dateValue.toDate();
    }

    if (dateValue is String) {
      return DateTime.parse(dateValue);
    }

    if (dateValue is DateTime) {
      return dateValue;
    }

    // Fallback
    return DateTime.now();
  }
}
