import 'package:flutter/material.dart';
import 'package:comunidad_acordeoneros/theme/theme_app.dart';
import 'package:comunidad_acordeoneros/features/programs/domain/entities/program_entity.dart';
import 'package:comunidad_acordeoneros/features/programs/domain/entities/level_entity.dart';
import 'package:comunidad_acordeoneros/core/services/storage_service.dart';
import 'package:comunidad_acordeoneros/features/programs/data/services/programs_service.dart';
import 'package:uuid/uuid.dart';

class CreateEditProgramPage extends StatefulWidget {
  final ProgramEntity? program; // Si es null, estamos creando; si no, editando

  const CreateEditProgramPage({super.key, this.program});

  @override
  State<CreateEditProgramPage> createState() => _CreateEditProgramPageState();
}

class _CreateEditProgramPageState extends State<CreateEditProgramPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _instructorController = TextEditingController();

  bool _isLoading = false;
  bool _isActive = true;
  String? _selectedImageUrl;
  List<LevelEntity> _levels = [];

  @override
  void initState() {
    super.initState();
    if (widget.program != null) {
      _initializeForEdit();
    }
  }

  void _initializeForEdit() {
    final program = widget.program!;
    _nameController.text = program.name;
    _descriptionController.text = program.description;
    _instructorController.text = program.instructor;
    _isActive = program.isActive;
    _selectedImageUrl = program.imageUrl;
    _levels = List.from(program.levels);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _instructorController.dispose();
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
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildImageSection(),
                        const SizedBox(height: 24),
                        _buildBasicInfoSection(),
                        const SizedBox(height: 24),
                        _buildLevelsSection(),
                        const SizedBox(height: 32),
                        _buildActionButtons(),
                        const SizedBox(height: 100), // Space for FAB
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addLevel,
        backgroundColor: AppTheme.primaryBlue,
        child: const Icon(Icons.add, color: Colors.white),
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
                  widget.program == null ? 'Crear Programa' : 'Editar Programa',
                  style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.program == null
                      ? 'Crea un nuevo programa educativo'
                      : 'Modifica la información del programa',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: _isActive,
            onChanged: (value) => setState(() => _isActive = value),
            activeColor: Colors.green,
            inactiveThumbColor: Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _buildImageSection() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.white.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.image, color: AppTheme.primaryBlue),
                const SizedBox(width: 8),
                Text(
                  'Imagen del Programa',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: InkWell(
              onTap: _selectImage,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: AppTheme.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.white.withOpacity(0.2),
                    style: BorderStyle.solid,
                  ),
                ),
                child: _selectedImageUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: _selectedImageUrl!.startsWith('assets/')
                            ? Image.asset(
                                _selectedImageUrl!,
                                fit: BoxFit.cover,
                              )
                            : Image.network(
                                _selectedImageUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    _buildImagePlaceholder(),
                              ),
                      )
                    : _buildImagePlaceholder(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.add_photo_alternate_outlined,
          size: 48,
          color: AppTheme.white.withOpacity(0.5),
        ),
        const SizedBox(height: 8),
        Text(
          'Toca para seleccionar imagen',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.white.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildBasicInfoSection() {
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
                const Icon(Icons.info_outline, color: AppTheme.primaryBlue),
                const SizedBox(width: 8),
                Text(
                  'Información Básica',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _nameController,
              label: 'Nombre del Programa',
              hint: 'Ej: Curso de Acordeón Básico',
              icon: Icons.school,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'El nombre es requerido';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _instructorController,
              label: 'Instructor',
              hint: 'Nombre del instructor',
              icon: Icons.person,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'El instructor es requerido';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _descriptionController,
              label: 'Descripción',
              hint: 'Describe el contenido del programa...',
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

  Widget _buildLevelsSection() {
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
                  'Niveles (${_levels.length})',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_levels.isEmpty)
              _buildEmptyLevelsState()
            else
              ..._levels.asMap().entries.map((entry) {
                final index = entry.key;
                final level = entry.value;
                return _buildLevelCard(index, level);
              }),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyLevelsState() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.white.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Icon(
            Icons.layers_outlined,
            size: 48,
            color: AppTheme.white.withOpacity(0.5),
          ),
          const SizedBox(height: 12),
          Text(
            'No hay niveles creados',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.white.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Agrega niveles para organizar las clases',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.white.withOpacity(0.6),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLevelCard(int index, LevelEntity level) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppTheme.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.white.withOpacity(0.1)),
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppTheme.primaryBlue.withOpacity(0.3),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              '${index + 1}',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                color: AppTheme.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        title: Text(
          level.name,
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            color: AppTheme.white,
          ),
        ),
        subtitle: Text(
          '${level.lessons.length} clases',
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.white.withOpacity(0.7),
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () => _editLevel(index),
              icon: const Icon(Icons.edit, color: AppTheme.primaryBlue),
            ),
            IconButton(
              onPressed: () => _removeLevel(index),
              icon: const Icon(Icons.delete, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
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
            onPressed: _isLoading ? null : _saveProgram,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryBlue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child:
                Text(widget.program == null ? 'Crear Programa' : 'Actualizar'),
          ),
        ),
      ],
    );
  }

  Future<void> _selectImage() async {
    final imageUrl = await StorageService.uploadImage(
      folder: 'programs',
      fileName: StorageService.generateUniqueFileName('program_image.jpg'),
    );

    if (imageUrl != null) {
      setState(() {
        _selectedImageUrl = imageUrl;
      });
    }
  }

  void _addLevel() {
    
    _showAddLevelDialog();
  }

  void _editLevel(int index) {
    // Navegar a página de editar nivel
    _showEditLevelDialog(index);
  }

  void _removeLevel(int index) {
    setState(() {
      _levels.removeAt(index);
    });
  }

  void _showAddLevelDialog() {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.darkBlue,
        title: const Text(
          'Agregar Nivel',
          style: TextStyle(color: AppTheme.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Nombre del nivel',
                labelStyle: TextStyle(color: AppTheme.white.withOpacity(0.8)),
              ),
              style: const TextStyle(color: AppTheme.white),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: 'Descripción',
                labelStyle: TextStyle(color: AppTheme.white.withOpacity(0.8)),
              ),
              style: const TextStyle(color: AppTheme.white),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:
                const Text('Cancelar', style: TextStyle(color: AppTheme.white)),
          ),
          TextButton(
            onPressed: () {
              if (nameController.text.trim().isNotEmpty) {
                final newLevel = LevelEntity(
                  id: const Uuid().v4(),
                  name: nameController.text.trim(),
                  description: descriptionController.text.trim(),
                  order: _levels.length + 1,
                  lessons: [],
                  isUnlocked: _levels
                      .isEmpty, // El primer nivel siempre está desbloqueado
                );

                setState(() {
                  _levels.add(newLevel);
                });

                Navigator.pop(context);
              }
            },
            child: const Text('Agregar',
                style: TextStyle(color: AppTheme.primaryBlue)),
          ),
        ],
      ),
    );
  }

  void _showEditLevelDialog(int index) {
    final level = _levels[index];
    final nameController = TextEditingController(text: level.name);
    final descriptionController =
        TextEditingController(text: level.description);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.darkBlue,
        title: const Text(
          'Editar Nivel',
          style: TextStyle(color: AppTheme.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Nombre del nivel',
                labelStyle: TextStyle(color: AppTheme.white.withOpacity(0.8)),
              ),
              style: const TextStyle(color: AppTheme.white),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: 'Descripción',
                labelStyle: TextStyle(color: AppTheme.white.withOpacity(0.8)),
              ),
              style: const TextStyle(color: AppTheme.white),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:
                const Text('Cancelar', style: TextStyle(color: AppTheme.white)),
          ),
          TextButton(
            onPressed: () {
              if (nameController.text.trim().isNotEmpty) {
                final updatedLevel = LevelEntity(
                  id: level.id,
                  name: nameController.text.trim(),
                  description: descriptionController.text.trim(),
                  order: level.order,
                  lessons: level.lessons,
                  isUnlocked: level.isUnlocked,
                  progress: level.progress,
                );

                setState(() {
                  _levels[index] = updatedLevel;
                });

                Navigator.pop(context);
              }
            },
            child: const Text('Actualizar',
                style: TextStyle(color: AppTheme.primaryBlue)),
          ),
        ],
      ),
    );
  }

  Future<void> _saveProgram() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final imageUrl = _selectedImageUrl ?? 'assets/images/fer-festival.jpg';

      if (widget.program == null) {
        // Crear nuevo programa
        final programId = await ProgramsService.createProgram(
          name: _nameController.text.trim(),
          description: _descriptionController.text.trim(),
          instructor: _instructorController.text.trim(),
          imageUrl: imageUrl,
          levels: _levels,
        );

        if (programId != null) {
          if(!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Programa creado exitosamente'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, true);
        } else {
          _showErrorSnackBar('Error al crear el programa');
        }
      } else {
        // Actualizar programa existente
        final success = await ProgramsService.updateProgram(
          id: widget.program!.id,
          name: _nameController.text.trim(),
          description: _descriptionController.text.trim(),
          instructor: _instructorController.text.trim(),
          imageUrl: imageUrl,
          isActive: _isActive,
          levels: _levels,
        );
        

        if (success) {
          if(!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Programa actualizado exitosamente'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, true);
        } else {
          _showErrorSnackBar('Error al actualizar el programa');
        }
      }
    } catch (e) {
      _showErrorSnackBar('Error inesperado: $e');
    } finally {
      setState(() => _isLoading = false);
    }
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
