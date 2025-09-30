import 'package:comunidad_acordeoneros/pages/player_video.dart';
import 'package:comunidad_acordeoneros/theme/theme_app.dart';
import 'package:comunidad_acordeoneros/widgets/card_todo.dart';
import 'package:comunidad_acordeoneros/widgets/program_card.dart';
import 'package:comunidad_acordeoneros/widgets/separator.dart';
import 'package:comunidad_acordeoneros/pages/detail_program.dart';
// import 'package:comunidad_acordeoneros/pages/player_video.dart';
import 'package:comunidad_acordeoneros/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    _HomeContent(),
    const DetailProgramPage(
      name: 'Programa VIP',
      level: 'Nivel 1',
      image: 'assets/images/fer-festival.jpg',
      description:
          'Este es un programa especializado para aprender acordeón desde cero. Incluye lecciones paso a paso, ejercicios prácticos y seguimiento personalizado con nuestro instructor experto Ferney Arrieta.',
    ),
    const PlayerVideoPage(
      videoPath: 'assets/videos/test.mp4',
      title: 'Introducción al Acordeón',
      instructor: 'Ferney Arrieta',
      description:
          'En esta clase introductoria, aprenderás los conceptos básicos del acordeón y las técnicas fundamentales para comenzar tu viaje musical.',
      programName: 'Programa VIP',
      views: 1250,
      chapterNumber: '1',
    ),
    const LoginPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
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
}

class _HomeContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Image.asset('assets/images/logo.png', width: 100, height: 100),
          leading: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.menu),
          ),
        ),
        body: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Hola,'),
                Text('Ferney Arrieta',
                    style: AppTheme.lightTheme.textTheme.headlineMedium),
                const SizedBox(height: 16),
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
    );
  }
}
