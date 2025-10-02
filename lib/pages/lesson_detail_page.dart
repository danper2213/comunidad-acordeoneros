import 'package:comunidad_acordeoneros/theme/theme_app.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:comunidad_acordeoneros/features/programs/presentation/providers/programs_provider.dart';
import 'package:comunidad_acordeoneros/features/auth/presentation/providers/auth_provider.dart';
import 'package:comunidad_acordeoneros/features/programs/domain/entities/lesson_entity.dart';
import 'package:comunidad_acordeoneros/features/programs/domain/entities/comment_entity.dart';
import 'package:comunidad_acordeoneros/features/programs/data/models/lesson_model.dart';

class LessonDetailPage extends StatefulWidget {
  final LessonEntity lesson;
  final String levelName;
  final String programName;
  final List<LessonEntity>? allLessons; // Lista completa de clases del nivel

  const LessonDetailPage({
    super.key,
    required this.lesson,
    required this.levelName,
    required this.programName,
    this.allLessons,
  });

  @override
  State<LessonDetailPage> createState() => _LessonDetailPageState();
}

class _LessonDetailPageState extends State<LessonDetailPage> {
  late VideoPlayerController _controller;
  final TextEditingController _commentController = TextEditingController();
  bool _isVideoInitialized = false;
  late LessonEntity currentLesson;

  @override
  void initState() {
    super.initState();
    currentLesson = widget.lesson;
    _initializeVideo();
    _loadComments();
  }

  // Obtener índice de la clase actual
  int get currentLessonIndex {
    if (widget.allLessons == null) return -1;
    return widget.allLessons!.indexWhere((l) => l.id == currentLesson.id);
  }

  // Verificar si hay clase anterior
  bool get hasPreviousLesson {
    return currentLessonIndex > 0;
  }

  // Verificar si hay clase siguiente
  bool get hasNextLesson {
    if (widget.allLessons == null) return false;
    return currentLessonIndex < widget.allLessons!.length - 1;
  }

  // Obtener clase anterior
  LessonEntity? get previousLesson {
    if (!hasPreviousLesson || widget.allLessons == null) return null;
    return widget.allLessons![currentLessonIndex - 1];
  }

  // Obtener clase siguiente
  LessonEntity? get nextLesson {
    if (!hasNextLesson || widget.allLessons == null) return null;
    return widget.allLessons![currentLessonIndex + 1];
  }

  // Navegar a otra clase
  void navigateToLesson(LessonEntity lesson) {
    setState(() {
      currentLesson = lesson;
      _isVideoInitialized = false;
    });

    // Reiniciar video
    _controller.dispose();
    _initializeVideo();
    _loadComments();

    // Actualizar provider
    Provider.of<ProgramsProvider>(context, listen: false).selectLesson(lesson);
  }

  void _initializeVideo() {
    _controller = VideoPlayerController.asset(currentLesson.videoUrl)
      ..initialize().then((_) {
        setState(() {
          _isVideoInitialized = true;
        });
      });
  }

  void _loadComments() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProgramsProvider>(context, listen: false)
          .loadComments(currentLesson.id);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final programsProvider = Provider.of<ProgramsProvider>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Video Player
            _buildVideoPlayer(),

            // Contenido
            Expanded(
              child: Container(
                decoration: AppTheme.getBackgroundDecoration(),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Información de la clase
                      _buildLessonInfo(),

                      const Divider(color: Colors.white24),

                      // Navegación entre clases
                      if (widget.allLessons != null &&
                          widget.allLessons!.length > 1)
                        _buildNavigationButtons(),

                      if (widget.allLessons != null &&
                          widget.allLessons!.length > 1)
                        const Divider(color: Colors.white24),

                      // Descripción
                      _buildDescription(),

                      const Divider(color: Colors.white24),

                      // Sección de comentarios
                      _buildCommentsSection(programsProvider),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoPlayer() {
    return Container(
      color: Colors.black,
      child: Stack(
        children: [
          AspectRatio(
            aspectRatio:
                _isVideoInitialized ? _controller.value.aspectRatio : 16 / 9,
            child: _isVideoInitialized
                ? VideoPlayer(_controller)
                : const Center(
                    child: CircularProgressIndicator(
                      color: AppTheme.primaryBlue,
                    ),
                  ),
          ),

          // Controles
          if (_isVideoInitialized)
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _controller.value.isPlaying
                        ? _controller.pause()
                        : _controller.play();
                  });
                },
                child: Container(
                  color: Colors.transparent,
                  child: Center(
                    child: _controller.value.isPlaying
                        ? const SizedBox.shrink()
                        : const Icon(
                            Icons.play_circle_filled,
                            size: 64,
                            color: AppTheme.white,
                          ),
                  ),
                ),
              ),
            ),

          // Botón de cerrar
          Positioned(
            top: 8,
            left: 8,
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.arrow_back,
                  color: AppTheme.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Botón Anterior
          Expanded(
            child: ElevatedButton.icon(
              onPressed: hasPreviousLesson
                  ? () => navigateToLesson(previousLesson!)
                  : null,
              icon: const Icon(Icons.arrow_back),
              label: const Text('Anterior'),
              style: ElevatedButton.styleFrom(
                backgroundColor: hasPreviousLesson
                    ? AppTheme.darkBlue
                    : AppTheme.darkBlue.withOpacity(0.3),
                foregroundColor: AppTheme.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                disabledBackgroundColor: AppTheme.darkBlue.withOpacity(0.3),
                disabledForegroundColor: AppTheme.white.withOpacity(0.5),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Botón Siguiente
          Expanded(
            child: ElevatedButton.icon(
              onPressed:
                  hasNextLesson ? () => navigateToLesson(nextLesson!) : null,
              icon: const Icon(Icons.arrow_forward),
              label: const Text('Siguiente'),
              style: ElevatedButton.styleFrom(
                backgroundColor: hasNextLesson
                    ? AppTheme.primaryBlue
                    : AppTheme.primaryBlue.withOpacity(0.3),
                foregroundColor: AppTheme.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                disabledBackgroundColor: AppTheme.primaryBlue.withOpacity(0.3),
                disabledForegroundColor: AppTheme.white.withOpacity(0.5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLessonInfo() {
    final duration = Duration(seconds: currentLesson.duration);
    final minutes = duration.inMinutes;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            currentLesson.title,
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              color: AppTheme.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlue.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  widget.programName,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.white,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.access_time,
                size: 16,
                color: AppTheme.white.withOpacity(0.7),
              ),
              const SizedBox(width: 4),
              Text(
                '$minutes min',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.white.withOpacity(0.7),
                ),
              ),
              const SizedBox(width: 16),
              Icon(
                Icons.visibility,
                size: 16,
                color: AppTheme.white.withOpacity(0.7),
              ),
              const SizedBox(width: 4),
              Text(
                '${currentLesson.views} vistas',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.white.withOpacity(0.7),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Botón marcar como completada
          if (!currentLesson.isCompleted)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  final provider = Provider.of<ProgramsProvider>(
                    context,
                    listen: false,
                  );
                  await provider.markLessonAsCompleted(currentLesson.id);

                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('¡Clase completada! 🎉'),
                        backgroundColor: Colors.green,
                      ),
                    );

                    // Actualizar estado local
                    setState(() {
                      currentLesson = LessonModel(
                        id: currentLesson.id,
                        title: currentLesson.title,
                        description: currentLesson.description,
                        videoUrl: currentLesson.videoUrl,
                        thumbnailUrl: currentLesson.thumbnailUrl,
                        duration: currentLesson.duration,
                        order: currentLesson.order,
                        isCompleted: true,
                        views: currentLesson.views,
                      );
                    });
                  }
                },
                icon: const Icon(Icons.check_circle),
                label: const Text('Marcar como completada'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryBlue,
                  foregroundColor: AppTheme.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDescription() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Descripción',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            currentLesson.description,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.white.withOpacity(0.9),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentsSection(ProgramsProvider programsProvider) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Comentarios (${programsProvider.comments.length})',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),

          // Campo para agregar comentario
          if (user != null) ...[
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppTheme.primaryBlue,
                  backgroundImage: user.photoURL != null
                      ? NetworkImage(user.photoURL!)
                      : null,
                  child: user.photoURL == null
                      ? Text(
                          (user.displayName?.isNotEmpty == true
                                  ? user.displayName!
                                  : user.email)[0]
                              .toUpperCase(),
                          style: const TextStyle(color: AppTheme.white),
                        )
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    style: const TextStyle(color: AppTheme.white),
                    decoration: InputDecoration(
                      hintText: 'Escribe un comentario...',
                      hintStyle: TextStyle(
                        color: AppTheme.white.withOpacity(0.5),
                      ),
                      filled: true,
                      fillColor: AppTheme.white.withOpacity(0.1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      suffixIcon: IconButton(
                        icon:
                            const Icon(Icons.send, color: AppTheme.primaryBlue),
                        onPressed: () => _addComment(programsProvider, user),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],

          // Lista de comentarios
          if (programsProvider.comments.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    Icon(
                      Icons.chat_bubble_outline,
                      size: 48,
                      color: AppTheme.white.withOpacity(0.3),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No hay comentarios aún',
                      style: TextStyle(
                        color: AppTheme.white.withOpacity(0.5),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '¡Sé el primero en comentar!',
                      style: TextStyle(
                        color: AppTheme.white.withOpacity(0.3),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            ...programsProvider.comments.map((comment) {
              return _buildCommentCard(comment, programsProvider, user);
            }),
        ],
      ),
    );
  }

  Widget _buildCommentCard(
    CommentEntity comment,
    ProgramsProvider provider,
    user,
  ) {
    final isOwnComment = user?.uid == comment.userId;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.white.withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: AppTheme.primaryBlue,
                backgroundImage: comment.userPhotoUrl != null
                    ? NetworkImage(comment.userPhotoUrl!)
                    : null,
                child: comment.userPhotoUrl == null
                    ? Text(
                        comment.userName[0].toUpperCase(),
                        style: const TextStyle(
                          color: AppTheme.white,
                          fontSize: 14,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      comment.userName,
                      style: const TextStyle(
                        color: AppTheme.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      _formatDateTime(comment.createdAt),
                      style: TextStyle(
                        color: AppTheme.white.withOpacity(0.5),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              if (isOwnComment)
                IconButton(
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                    size: 20,
                  ),
                  onPressed: () => _deleteComment(provider, comment.id),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            comment.content,
            style: TextStyle(
              color: AppTheme.white.withOpacity(0.9),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              InkWell(
                onTap: () {
                  if (user != null) {
                    provider.likeComment(comment.id, user.uid);
                  }
                },
                child: Row(
                  children: [
                    Icon(
                      comment.isLikedByCurrentUser
                          ? Icons.favorite
                          : Icons.favorite_border,
                      size: 18,
                      color: comment.isLikedByCurrentUser
                          ? Colors.red
                          : AppTheme.white.withOpacity(0.5),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${comment.likes}',
                      style: TextStyle(
                        color: AppTheme.white.withOpacity(0.7),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return 'Hace ${difference.inDays} ${difference.inDays == 1 ? 'día' : 'días'}';
    } else if (difference.inHours > 0) {
      return 'Hace ${difference.inHours} ${difference.inHours == 1 ? 'hora' : 'horas'}';
    } else if (difference.inMinutes > 0) {
      return 'Hace ${difference.inMinutes} ${difference.inMinutes == 1 ? 'minuto' : 'minutos'}';
    } else {
      return 'Ahora';
    }
  }

  Future<void> _addComment(ProgramsProvider provider, user) async {
    if (_commentController.text.trim().isEmpty) return;

    final success = await provider.addComment(
      lessonId: currentLesson.id,
      userId: user.uid,
      userName: user.displayName ?? user.email ?? 'Usuario',
      userPhotoUrl: user.photoURL,
      content: _commentController.text.trim(),
    );

    if (success && mounted) {
      _commentController.clear();
      FocusScope.of(context).unfocus();
    }
  }

  Future<void> _deleteComment(
      ProgramsProvider provider, String commentId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.darkBlue,
        title: const Text(
          'Eliminar comentario',
          style: TextStyle(color: AppTheme.white),
        ),
        content: const Text(
          '¿Estás seguro de que deseas eliminar este comentario?',
          style: TextStyle(color: AppTheme.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(
              'Cancelar',
              style: TextStyle(color: AppTheme.white),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(
              'Eliminar',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await provider.deleteComment(commentId, widget.lesson.id);
    }
  }
}
