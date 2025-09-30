import 'package:comunidad_acordeoneros/pages/login_form.dart';
import 'package:comunidad_acordeoneros/pages/register_form.dart';
import 'package:comunidad_acordeoneros/theme/theme_app.dart';
import 'package:comunidad_acordeoneros/widgets/button_custom.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(children: [
      SizedBox(
        width: size.width,
        height: size.height,
        child: Image.asset(
          'assets/images/fer-festival.jpg',
          fit: BoxFit.cover,
        ),
      ),
      Positioned(
        top: size.height * 0.6,
        left: 20.0,
        child: Column(
          children: [
            Text(
              'INICIA TU CAMINO\nCON EL ACORDEON',
              style: AppTheme.lightTheme.textTheme.displayLarge,
            ),
          ],
        ),
      ),
      Positioned(
        top: size.height * 0.3,
        left: size.width * 0.6,
        child: Image.asset(
          'assets/images/logo.png',
          width: 150,
          height: 150,
        ),
      ),
      Positioned(
        bottom: 100,
        left: 20.0,
        right: 20.0,
        child: ButtonCustom(
            text: 'Ingresar',
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const LoginFormPage()));
            }),
      ),
      Positioned(
        bottom: 55,
        left: 20.0,
        right: 20.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'Aún no tienes una cuenta?',
              style: AppTheme.lightTheme.textTheme.bodySmall,
            ),
            const SizedBox(
              width: 10,
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const RegisterFormPage()),
                );
              },
              child: Text(
                'Registrate',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
      Positioned(
        left: 0,
        right: 0,
        bottom: 10.0,
        child: Center(
          child: Text('By Comunidad Acordeoneros',
              style: AppTheme.lightTheme.textTheme.bodySmall),
        ),
      )
    ]);
  }
}
