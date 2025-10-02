class LessonEntity {
  final String id;
  final String title;
  final String description;
  final String videoUrl;
  final String? thumbnailUrl;
  final int duration; // en segundos
  final int order;
  final bool isCompleted;
  final int views;

  const LessonEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.videoUrl,
    this.thumbnailUrl,
    required this.duration,
    required this.order,
    this.isCompleted = false,
    this.views = 0,
  });
}
