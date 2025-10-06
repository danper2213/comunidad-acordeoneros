import 'package:comunidad_acordeoneros/features/programs/presentation/providers/programs_crud_provider.dart';

class ProgramsCrudInjection {
  static ProgramsCrudProvider? _programsCrudProvider;

  static ProgramsCrudProvider get programsCrudProvider {
    _programsCrudProvider ??= ProgramsCrudProvider();
    return _programsCrudProvider!;
  }

  static Future<void> init() async {
    // Inicializar el provider si es necesario
    _programsCrudProvider ??= ProgramsCrudProvider();
    await _programsCrudProvider!.initialize();
  }

  static void dispose() {
    _programsCrudProvider?.dispose();
    _programsCrudProvider = null;
  }
}
