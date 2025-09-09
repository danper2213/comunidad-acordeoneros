import 'package:comunidad_acordeoneros/widgets/program_card.dart';
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
      body: const SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Hola Ferney Arrieta'),
              SizedBox(height: 16),
              ProgramCard(
                name: 'Programa 1',
                level: 'Nivel 1',
                image: 'assets/images/fer-festival.jpg',
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
