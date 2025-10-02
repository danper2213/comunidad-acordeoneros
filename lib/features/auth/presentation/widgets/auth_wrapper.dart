import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:comunidad_acordeoneros/features/auth/presentation/providers/auth_provider.dart';
import 'package:comunidad_acordeoneros/pages/login.dart';
import 'package:comunidad_acordeoneros/pages/home.dart';

/// Widget que verifica el estado de autenticación y navega a la pantalla apropiada
class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  void initState() {
    super.initState();
    // Verificar el usuario actual al iniciar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AuthProvider>(context, listen: false).checkCurrentUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        // Mostrar loading mientras se verifica el estado
        if (authProvider.status == AuthStatus.initial ||
            authProvider.status == AuthStatus.loading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Si está autenticado, mostrar Home
        if (authProvider.isAuthenticated && authProvider.user != null) {
          return const HomePage();
        }

        // Si no está autenticado, mostrar Login
        return const LoginPage();
      },
    );
  }
}
