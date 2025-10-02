import 'package:comunidad_acordeoneros/theme/theme_app.dart';
import 'package:comunidad_acordeoneros/widgets/card_todo.dart';
import 'package:comunidad_acordeoneros/widgets/program_card.dart';
import 'package:comunidad_acordeoneros/widgets/separator.dart';
import 'package:comunidad_acordeoneros/pages/level_lessons_page.dart';
import 'package:comunidad_acordeoneros/pages/login.dart';
import 'package:comunidad_acordeoneros/features/programs/presentation/providers/programs_provider.dart';
import 'package:comunidad_acordeoneros/features/auth/presentation/providers/auth_provider.dart';

import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // Cargar programas al inicializar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProgramsProvider>(context, listen: false).loadPrograms();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildCurrentPage(),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        color: AppTheme.primaryBlue,
        buttonBackgroundColor: AppTheme.primaryBlue,
        height: 65,
        animationDuration: const Duration(milliseconds: 300),
        index: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          Icon(Icons.home, color: Colors.white, size: 30),
          Icon(Icons.play_circle_outline, color: Colors.white, size: 30),
          Icon(Icons.video_library, color: Colors.white, size: 30),
          Icon(Icons.person, color: Colors.white, size: 30),
        ],
      ),
    );
  }

  Widget _buildCurrentPage() {
    switch (_selectedIndex) {
      case 0:
        return _HomeContent();
      case 1:
        return _ProgramsContent();
      case 2:
        return _VideosContent();
      case 3:
        return _ProfileContent();
      default:
        return _HomeContent();
    }
  }
}

class _HomeContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final programsProvider = Provider.of<ProgramsProvider>(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Image.asset('assets/images/logo.png', width: 100, height: 100),
          leading: IconButton(
            onPressed: () {
              // Mostrar drawer con opciones de perfil
              _showProfileDrawer(context, authProvider);
            },
            icon: const Icon(Icons.menu),
          ),
        ),
        body: Container(
          decoration: AppTheme.getBackgroundDecoration(),
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Hola,', style: AppTheme.lightTheme.textTheme.bodyLarge),
                  Text(
                    authProvider.user?.displayName ?? 'Usuario',
                    style: AppTheme.lightTheme.textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 16),

                  // Lista de programas
                  if (programsProvider.isLoading)
                    const Center(
                      child: CircularProgressIndicator(
                        color: AppTheme.primaryBlue,
                      ),
                    )
                  else if (programsProvider.programs.isNotEmpty)
                    ...programsProvider.programs.map(
                      (program) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _ProgramCardDynamic(program: program),
                      ),
                    )
                  else
                    const ProgramCard(
                      name: 'Programa VIP',
                      level: 'Nivel 1',
                      image: 'assets/images/fer-festival.jpg',
                    ),

                  const SizedBox(height: 16),
                  const SeparatorStart(),
                  const CardTodo(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showProfileDrawer(BuildContext context, AuthProvider authProvider) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.darkBlue,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: AppTheme.primaryBlue,
              backgroundImage: authProvider.user?.photoURL != null
                  ? NetworkImage(authProvider.user!.photoURL!)
                  : null,
              child: authProvider.user?.photoURL == null
                  ? Text(
                      (authProvider.user?.displayName?.isNotEmpty == true
                              ? authProvider.user!.displayName!
                              : authProvider.user?.email ?? 'U')[0]
                          .toUpperCase(),
                      style: const TextStyle(
                        color: AppTheme.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : null,
            ),
            const SizedBox(height: 16),
            Text(
              authProvider.user?.displayName ?? 'Usuario',
              style: AppTheme.lightTheme.textTheme.headlineSmall,
            ),
            Text(
              authProvider.user?.email ?? '',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.white.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  Navigator.pop(context);
                  final success = await authProvider.signOut();
                  if (success) {
                    // Navegar explícitamente a la página de login
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()),
                    );
                  }
                },
                icon: const Icon(Icons.logout),
                label: const Text('Cerrar sesión'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: AppTheme.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgramCardDynamic extends StatelessWidget {
  final dynamic program;

  const _ProgramCardDynamic({required this.program});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navegar a la página de detalles del programa
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => _ProgramDetailPage(program: program),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Hero(
                tag: 'program_image_${program.name}',
                child: Opacity(
                  opacity: 0.5,
                  child: Image.asset(
                    'assets/images/fer-festival.jpg',
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 20,
              right: 0,
              child: Container(
                padding: EdgeInsets.zero,
                margin: EdgeInsets.zero,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Image.asset(
                    'assets/images/corona.png',
                    width: 60,
                    height: 30,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 16,
              top: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Hero(
                    tag: 'program_name_${program.name}',
                    child: Material(
                      color: Colors.transparent,
                      child: Text(
                        program.name,
                        style: AppTheme.lightTheme.textTheme.headlineLarge,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: program.isActive
                          ? Colors.green.withOpacity(0.4)
                          : Colors.grey.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      program.isActive ? 'Habilitado' : 'Bloqueado',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgramDetailPage extends StatelessWidget {
  final dynamic program;

  const _ProgramDetailPage({required this.program});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: AppTheme.getBackgroundDecoration(),
        child: SafeArea(
          child: Column(
            children: [
              // Header con imagen
              Expanded(
                flex: 1,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    children: [
                      Hero(
                        tag: 'program_image_${program.name}',
                        child: Opacity(
                          opacity: 0.7,
                          child: Image.asset(
                            'assets/images/fer-festival.jpg',
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        left: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              width: 50,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.3),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.arrow_back,
                                size: 24,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.8),
                              ],
                            ),
                          ),
                          child: Column(
                            children: [
                              Hero(
                                tag: 'program_name_${program.name}',
                                child: Material(
                                  color: Colors.transparent,
                                  child: Text(
                                    program.name,
                                    style: AppTheme
                                        .lightTheme.textTheme.displayMedium
                                        ?.copyWith(
                                      color: AppTheme.white,
                                      fontWeight: FontWeight.bold,
                                      shadows: [
                                        const Shadow(
                                          offset: Offset(0, 2),
                                          blurRadius: 4,
                                          color: Colors.black54,
                                        ),
                                      ],
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Progreso: ${(program.overallProgress * 100).toInt()}%',
                                style: AppTheme.lightTheme.textTheme.bodyMedium
                                    ?.copyWith(
                                  color: AppTheme.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Lista de niveles
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Niveles del programa',
                        style: AppTheme.lightTheme.textTheme.headlineSmall
                            ?.copyWith(
                          color: AppTheme.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: ListView.builder(
                          itemCount: program.levels.length,
                          itemBuilder: (context, index) {
                            final level = program.levels[index];
                            return _buildLevelCard(context, level, index + 1);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLevelCard(BuildContext context, dynamic level, int number) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: level.isUnlocked
            ? AppTheme.white.withOpacity(0.1)
            : AppTheme.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: level.isUnlocked
              ? AppTheme.primaryBlue.withOpacity(0.5)
              : AppTheme.white.withOpacity(0.2),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: level.isUnlocked
              ? () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LevelLessonsPage(
                        level: level,
                        programName: program.name,
                      ),
                    ),
                  );
                }
              : null,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: level.isUnlocked
                        ? AppTheme.primaryBlue.withOpacity(0.3)
                        : Colors.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: level.isUnlocked
                        ? Text(
                            '$number',
                            style: AppTheme.lightTheme.textTheme.titleLarge
                                ?.copyWith(
                              color: AppTheme.white,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : const Icon(
                            Icons.lock,
                            color: Colors.grey,
                            size: 24,
                          ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        level.name,
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          color: AppTheme.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${level.completedLessons} de ${level.totalLessons} clases completadas',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.white.withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: level.progress,
                          backgroundColor: AppTheme.white.withOpacity(0.2),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            AppTheme.primaryBlue,
                          ),
                          minHeight: 6,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  level.isUnlocked ? Icons.arrow_forward_ios : Icons.lock,
                  color: level.isUnlocked ? AppTheme.primaryBlue : Colors.grey,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProgramsContent extends StatelessWidget {
  const _ProgramsContent();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppTheme.getBackgroundDecoration(),
      child: const Center(
        child: Text(
          'Programas',
          style: TextStyle(color: AppTheme.white, fontSize: 24),
        ),
      ),
    );
  }
}

class _VideosContent extends StatelessWidget {
  const _VideosContent();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppTheme.getBackgroundDecoration(),
      child: const Center(
        child: Text(
          'Videos',
          style: TextStyle(color: AppTheme.white, fontSize: 24),
        ),
      ),
    );
  }
}

class _ProfileContent extends StatelessWidget {
  const _ProfileContent();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppTheme.getBackgroundDecoration(),
      child: const Center(
        child: Text(
          'Perfil',
          style: TextStyle(color: AppTheme.white, fontSize: 24),
        ),
      ),
    );
  }
}
