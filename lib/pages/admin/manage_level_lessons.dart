import 'package:flutter/material.dart';
import 'package:comunidad_acordeoneros/theme/theme_app.dart';
import 'package:comunidad_acordeoneros/features/programs/domain/entities/program_entity.dart';
import 'package:comunidad_acordeoneros/features/programs/domain/entities/level_entity.dart';
import 'package:comunidad_acordeoneros/features/programs/domain/entities/lesson_entity.dart';
import 'package:comunidad_acordeoneros/core/services/storage_service.dart';
import 'package:comunidad_acordeoneros/features/programs/data/services/programs_service.dart';
import 'package:uuid/uuid.dart';

class ManageLevelLessonsPage extends StatefulWidget {
  final ProgramEntity program;
  final LevelEntity? level; // Si es null, estamos creando un nivel

  const ManageLevelLessonsPage({
    super.key,
    required this.program,
    this.level,
  });

  @override
  State<ManageLevelLessonsPage> createState() => _ManageLevelLessonsPageState();
}

class _ManageLevelLessonsPageState extends State<ManageLevelLessonsPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final _levelFormKey = GlobalKey<FormState>();
  final _lessonFormKey = GlobalKey<FormState>();

  // Level form controllers
  final _levelNameController = TextEditingController();
  final _levelDescriptionController = TextEditingController();

  // Lesson form controllers
  final _lessonTitleController = TextEditingController();
  final _lessonDescriptionController = TextEditingController();
  final _lessonDurationController = TextEditingController();

  bool _isLoading = false;
  String? _selectedVideoUrl;
  String? _selectedThumbnailUrl;
  List<LessonEntity> _lessons = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    if (widget.level != null) {
      _initializeForEdit();
    }
  }

  void _initializeForEdit() {
    final level = widget.level!;
    _levelNameController.text = level.name;
    _levelDescriptionController.text = level.description;
    _lessons = List.from(level.lessons);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _levelNameController.dispose();
    _levelDescriptionController.dispose();
    _lessonTitleController.dispose();
    _lessonDescriptionController.dispose();
    _lessonDurationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: AppTheme.getBackgroundDecoration(),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              _buildTabBar(),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildLevelTab(),
                    _buildLessonsTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primaryBlue.withOpacity(0.8),
            AppTheme.secondaryBlue.withOpacity(0.6),
          ],
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.level == null ? 'Crear Nivel' : 'Editar Nivel',
                  style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.program.name,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
          if (widget.level != null)
            IconButton(
              onPressed: _deleteLevel,
              icon: const Icon(Icons.delete, color: Colors.red),
            ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: AppTheme.backgroundColor,
      child: TabBar(
        controller: _tabController,
        indicatorColor: AppTheme.primaryBlue,
        labelColor: AppTheme.white,
        unselectedLabelColor: AppTheme.white.withOpacity(0.6),
        tabs: const [
          Tab(
            icon: Icon(Icons.info_outline),
            text: 'Información',
          ),
          Tab(
            icon: Icon(Icons.play_circle_outline),
            text: 'Clases',
          ),
        ],
      ),
    );
  }

  Widget _buildLevelTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _levelFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLevelInfoSection(),
            const SizedBox(height: 24),
            _buildLevelActions(),
            const SizedBox(height: 100), // Space for FAB
          ],
        ),
      ),
    );
  }

  Widget _buildLevelInfoSection() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.white.withOpacity(0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.layers, color: AppTheme.primaryBlue),
                const SizedBox(width: 8),
                Text(
                  'Información del Nivel',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _levelNameController,
              label: 'Nombre del Nivel',
              hint: 'Ej: Nivel Básico',
              icon: Icons.label,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'El nombre es requerido';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _levelDescriptionController,
              label: 'Descripción',
              hint: 'Describe el contenido de este nivel...',
              icon: Icons.description,
              maxLines: 4,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'La descripción es requerida';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLevelActions() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey.withOpacity(0.3),
              foregroundColor: AppTheme.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Cancelar'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: _isLoading ? null : _saveLevel,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryBlue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(widget.level == null ? 'Crear Nivel' : 'Actualizar'),
          ),
        ),
      ],
    );
  }

  Widget _buildLessonsTab() {
    return Column(
      children: [
        Expanded(
          child: _lessons.isEmpty
              ? _buildEmptyLessonsState()
              : _buildLessonsList(),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.backgroundColor,
            border: Border(
              top: BorderSide(color: AppTheme.white.withOpacity(0.1)),
            ),
          ),
          child: SafeArea(
            child: ElevatedButton.icon(
              onPressed: _addLesson,
              icon: const Icon(Icons.add),
              label: const Text('Agregar Clase'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryBlue,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyLessonsState() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: AppTheme.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.white.withOpacity(0.1)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.play_circle_outline,
              size: 64,
              color: AppTheme.white.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No hay clases creadas',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                color: AppTheme.white.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Agrega clases para este nivel',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.white.withOpacity(0.6),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLessonsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _lessons.length,
      itemBuilder: (context, index) {
        final lesson = _lessons[index];
        return _buildLessonCard(index, lesson);
      },
    );
  }

  Widget _buildLessonCard(int index, LessonEntity lesson) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppTheme.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.white.withOpacity(0.2)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _editLesson(index),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryBlue.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: lesson.thumbnailUrl != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: lesson.thumbnailUrl!.startsWith('assets/')
                              ? Image.asset(
                                  lesson.thumbnailUrl!,
                                  fit: BoxFit.cover,
                                )
                              : Image.network(
                                  lesson.thumbnailUrl!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      _buildLessonIcon(),
                                ),
                        )
                      : _buildLessonIcon(),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lesson.title,
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          color: AppTheme.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatDuration(lesson.duration),
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.white.withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        lesson.description,
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.white.withOpacity(0.6),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    IconButton(
                      onPressed: () => _editLesson(index),
                      icon: const Icon(Icons.edit, color: AppTheme.primaryBlue),
                    ),
                    IconButton(
                      onPressed: () => _removeLesson(index),
                      icon: const Icon(Icons.delete, color: Colors.red),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLessonIcon() {
    return const Icon(
      Icons.play_circle_outline,
      color: Colors.white,
      size: 30,
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: validator,
      style: const TextStyle(color: AppTheme.white),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: AppTheme.primaryBlue),
        labelStyle: TextStyle(color: AppTheme.white.withOpacity(0.8)),
        hintStyle: TextStyle(color: AppTheme.white.withOpacity(0.5)),
        filled: true,
        fillColor: AppTheme.white.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppTheme.white.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppTheme.white.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.primaryBlue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
      ),
    );
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  Future<void> _saveLevel() async {
    if (!_levelFormKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      if (widget.level == null) {
        // Crear nuevo nivel
        final levelId = await ProgramsService.createLevel(
          programId: widget.program.id,
          name: _levelNameController.text.trim(),
          description: _levelDescriptionController.text.trim(),
          order: widget.program.levels.length + 1,
          lessons: _lessons,
        );

        if (levelId != null) {
          if(!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Nivel creado exitosamente'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, true);
        } else {
          _showErrorSnackBar('Error al crear el nivel');
        }
      } else {
        // Actualizar nivel existente - implementar cuando sea necesario
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Funcionalidad de edición pendiente'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      _showErrorSnackBar('Error inesperado: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _addLesson() {
    _showAddLessonDialog();
  }

  void _editLesson(int index) {
    _showEditLessonDialog(index);
  }

  void _removeLesson(int index) {
    setState(() {
      _lessons.removeAt(index);
    });
  }

  void _deleteLevel() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.darkBlue,
        title: const Text(
          'Eliminar Nivel',
          style: TextStyle(color: AppTheme.white),
        ),
        content: Text(
          '¿Estás seguro de que quieres eliminar este nivel? Esta acción no se puede deshacer.',
          style: TextStyle(color: AppTheme.white.withOpacity(0.8)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:
                const Text('Cancelar', style: TextStyle(color: AppTheme.white)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context, true); // Regresar indicando eliminación
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showAddLessonDialog() {
    _lessonTitleController.clear();
    _lessonDescriptionController.clear();
    _lessonDurationController.clear();
    _selectedVideoUrl = null;
    _selectedThumbnailUrl = null;

    showDialog(
      context: context,
      builder: (context) => _buildLessonDialog('Agregar Clase', _saveLesson),
    );
  }

  void _showEditLessonDialog(int index) {
    final lesson = _lessons[index];
    _lessonTitleController.text = lesson.title;
    _lessonDescriptionController.text = lesson.description;
    _lessonDurationController.text = lesson.duration.toString();
    _selectedVideoUrl = lesson.videoUrl;
    _selectedThumbnailUrl = lesson.thumbnailUrl;

    showDialog(
      context: context,
      builder: (context) =>
          _buildLessonDialog('Editar Clase', () => _updateLesson(index)),
    );
  }

  Widget _buildLessonDialog(String title, VoidCallback onSave) {
    return AlertDialog(
      backgroundColor: AppTheme.backgroundColor,
      title: Text(title, style: const TextStyle(color: AppTheme.white)),
      content: Form(
        key: _lessonFormKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField(
                controller: _lessonTitleController,
                label: 'Título de la clase',
                hint: 'Ej: Introducción al acordeón',
                icon: Icons.title,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'El título es requerido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _lessonDescriptionController,
                label: 'Descripción',
                hint: 'Describe el contenido de la clase...',
                icon: Icons.description,
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'La descripción es requerida';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _lessonDurationController,
                label: 'Duración (segundos)',
                hint: '300',
                icon: Icons.timer,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'La duración es requerida';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Ingresa un número válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _selectVideo,
                      icon: const Icon(Icons.video_library),
                      label: const Text('Video'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryBlue,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _selectThumbnail,
                      icon: const Icon(Icons.image),
                      label: const Text('Imagen'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.secondaryBlue,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child:
              const Text('Cancelar', style: TextStyle(color: AppTheme.white)),
        ),
        TextButton(
          onPressed: onSave,
          child: const Text('Guardar',
              style: TextStyle(color: AppTheme.primaryBlue)),
        ),
      ],
    );
  }

  Future<void> _selectVideo() async {
    final videoUrl = await StorageService.uploadVideo(
      folder: 'lessons',
      fileName: StorageService.generateUniqueFileName('lesson_video.mp4'),
    );

    if (videoUrl != null) {
      setState(() {
        _selectedVideoUrl = videoUrl;
      });
      if(!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Video subido exitosamente'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> _selectThumbnail() async {
    final thumbnailUrl = await StorageService.uploadImage(
      folder: 'lessons',
      fileName: StorageService.generateUniqueFileName('lesson_thumbnail.jpg'),
    );

    if (thumbnailUrl != null) {
      setState(() {
        _selectedThumbnailUrl = thumbnailUrl;
      });
      if(!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Imagen subida exitosamente'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _saveLesson() {
    if (!_lessonFormKey.currentState!.validate()) return;

    if (_selectedVideoUrl == null) {
      _showErrorSnackBar('Debes seleccionar un video para la clase');
      return;
    }

    final duration = int.tryParse(_lessonDurationController.text);
    if (duration == null) {
      _showErrorSnackBar('La duración debe ser un número válido');
      return;
    }

    final newLesson = LessonEntity(
      id: const Uuid().v4(),
      title: _lessonTitleController.text.trim(),
      description: _lessonDescriptionController.text.trim(),
      videoUrl: _selectedVideoUrl!,
      thumbnailUrl: _selectedThumbnailUrl,
      duration: duration,
      order: _lessons.length + 1,
    );

    setState(() {
      _lessons.add(newLesson);
    });

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Clase agregada exitosamente'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _updateLesson(int index) {
    if (!_lessonFormKey.currentState!.validate()) return;

    if (_selectedVideoUrl == null) {
      _showErrorSnackBar('Debes seleccionar un video para la clase');
      return;
    }

    final duration = int.tryParse(_lessonDurationController.text);
    if (duration == null) {
      _showErrorSnackBar('La duración debe ser un número válido');
      return;
    }

    final updatedLesson = LessonEntity(
      id: _lessons[index].id,
      title: _lessonTitleController.text.trim(),
      description: _lessonDescriptionController.text.trim(),
      videoUrl: _selectedVideoUrl!,
      thumbnailUrl: _selectedThumbnailUrl,
      duration: duration,
      order: _lessons[index].order,
      isCompleted: _lessons[index].isCompleted,
      views: _lessons[index].views,
    );

    setState(() {
      _lessons[index] = updatedLesson;
    });

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Clase actualizada exitosamente'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}
