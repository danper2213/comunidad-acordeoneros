import 'package:comunidad_acordeoneros/theme/theme_app.dart';
import 'package:comunidad_acordeoneros/widgets/card_todo.dart';
import 'package:comunidad_acordeoneros/widgets/program_card.dart';
import 'package:comunidad_acordeoneros/widgets/separator.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
              Text(
                'Ferney Arrieta',
                style: AppTheme.lightTheme.textTheme.headlineMedium,
              ),
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
    ));
  }
}
