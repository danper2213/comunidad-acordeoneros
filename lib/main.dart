import 'package:comunidad_acordeoneros/pages/home.dart';
import 'package:comunidad_acordeoneros/pages/login.dart';
import 'package:flutter/material.dart';
import 'theme/theme_app.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Comunidad Acordeoneros',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: const LoginPage(),
    );
  }
}
