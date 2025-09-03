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
        top: size.height * 0.25,
        left: size.width * 0.5,
        child: Image.asset(
          'assets/images/logo.png',
          width: 150,
          height: 150,
        ),
      ),
      Positioned(
        bottom: size.height * 0.1,
        left: 20.0,
        right: 20.0,
        child: ButtonCustom(text: 'Ingresar', onPressed: () {}),
      )
    ]);
  }
}
