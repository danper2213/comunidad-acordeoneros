import 'package:flutter/material.dart';
import 'theme/theme_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:comunidad_acordeoneros/core/di/injection_container.dart';
import 'package:comunidad_acordeoneros/core/di/programs_injection.dart';
import 'package:comunidad_acordeoneros/features/auth/presentation/providers/auth_provider.dart';
import 'package:comunidad_acordeoneros/features/programs/presentation/providers/programs_provider.dart';
import 'package:comunidad_acordeoneros/features/auth/presentation/widgets/auth_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize dependency injection
  await InjectionContainer.init();
  await ProgramsInjection.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>.value(
          value: InjectionContainer.authProvider,
        ),
        ChangeNotifierProvider<ProgramsProvider>.value(
          value: ProgramsInjection.programsProvider,
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Comunidad Acordeoneros',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        home: const AuthWrapper(),
      ),
    );
  }
}
