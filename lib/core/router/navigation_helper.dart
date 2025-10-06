import 'package:flutter/material.dart';
import 'package:comunidad_acordeoneros/pages/admin/admin_dashboard.dart';
import 'package:comunidad_acordeoneros/pages/admin/create_edit_program.dart';
import 'package:comunidad_acordeoneros/pages/admin/manage_level_lessons.dart';
import 'package:comunidad_acordeoneros/features/programs/domain/entities/program_entity.dart';
import 'package:comunidad_acordeoneros/features/programs/domain/entities/level_entity.dart';

class NavigationHelper {
  /// Navega al dashboard de administración
  static void goToAdminDashboard(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AdminDashboard()),
    );
  }

  /// Navega a crear un nuevo programa
  static void goToCreateProgram(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CreateEditProgramPage(),
      ),
    ).then((result) {
      if (result == true) {
        // Recargar datos si es necesario
      }
    });
  }

  /// Navega a editar un programa existente
  static void goToEditProgram(BuildContext context, String programId) {
    // TODO: Obtener el programa por ID desde el provider
    // Por ahora, pasamos un programa vacío
    final program = ProgramEntity(
      id: programId,
      name: '',
      description: '',
      imageUrl: '',
      levels: [],
      instructor: '',
      createdAt: DateTime.now(),
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateEditProgramPage(program: program),
      ),
    ).then((result) {
      if (result == true) {
        // Recargar datos si es necesario
      }
    });
  }

  /// Navega a gestionar niveles y lecciones
  static void goToManageLevelLessons({
    required BuildContext context,
    required ProgramEntity program,
    LevelEntity? level,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ManageLevelLessonsPage(
          program: program,
          level: level,
        ),
      ),
    ).then((result) {
      if (result == true) {
        // Recargar datos si es necesario
      }
    });
  }

  /// Navega a crear un nuevo nivel
  static void goToCreateLevel({
    required BuildContext context,
    required ProgramEntity program,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ManageLevelLessonsPage(
          program: program,
        ),
      ),
    ).then((result) {
      if (result == true) {
        // Recargar datos si es necesario
      }
    });
  }

  /// Navega a editar un nivel existente
  static void goToEditLevel({
    required BuildContext context,
    required ProgramEntity program,
    required LevelEntity level,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ManageLevelLessonsPage(
          program: program,
          level: level,
        ),
      ),
    ).then((result) {
      if (result == true) {
        // Recargar datos si es necesario
      }
    });
  }

  /// Navega a la lista de programas
  static void goToProgramsList(BuildContext context) {
    // TODO: Implementar página de lista de programas
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Lista de programas - En desarrollo'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  /// Navega a los detalles de un programa
  static void goToProgramDetails(BuildContext context, String programId) {
    // TODO: Implementar navegación a detalles del programa
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Detalles del programa - En desarrollo'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  /// Navega a las lecciones de un nivel
  static void goToLevelLessons({
    required BuildContext context,
    required String programId,
    required String levelId,
    required String programName,
    required String levelName,
  }) {
    // Esta función ya existe en el código original
    // Mantener la implementación existente
  }

  /// Navega a los detalles de una lección
  static void goToLessonDetails(BuildContext context, String lessonId) {
    // TODO: Implementar navegación a detalles de lección
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Detalles de lección - En desarrollo'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  /// Navega a la configuración
  static void goToSettings(BuildContext context) {
    // TODO: Implementar página de configuración
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Configuración - En desarrollo'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  /// Navega al perfil del usuario
  static void goToProfile(BuildContext context) {
    // TODO: Implementar página de perfil
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Perfil de usuario - En desarrollo'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  /// Regresa a la página anterior
  static void goBack(BuildContext context) {
    Navigator.pop(context);
  }

  /// Regresa a la página anterior con resultado
  static void goBackWithResult(BuildContext context, dynamic result) {
    Navigator.pop(context, result);
  }

  /// Navega y reemplaza la ruta actual
  static void goAndReplace(BuildContext context, Widget page) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  /// Navega y elimina todas las rutas anteriores
  static void goAndClearStack(BuildContext context, Widget page) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => page),
      (route) => false,
    );
  }
}
