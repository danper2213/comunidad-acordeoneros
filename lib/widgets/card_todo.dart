import 'package:comunidad_acordeoneros/theme/theme_app.dart';
import 'package:flutter/material.dart';

class CardTodo extends StatelessWidget {
  const CardTodo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: AppTheme.accentBlue),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 20,
            right: 0,
            child: Container(
              padding: EdgeInsets.zero,
              margin: EdgeInsets.zero,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Image.asset(
                  'assets/images/corona.png',
                  width: 60,
                  height: 30,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const Positioned(
            bottom: 50,
            right: 10,
            child: Icon(
              Icons.arrow_right_alt_rounded,
              color: AppTheme.white,
              size: 50,
            ),
          ),
          Positioned(
              left: 20,
              bottom: 30,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.calendar_month_rounded,
                      color: AppTheme.white, size: 50),
                  const SizedBox(height: 30),
                  Text('Agendar',
                      style: AppTheme.lightTheme.textTheme.titleMedium),
                  Text('Clase',
                      style: AppTheme.lightTheme.textTheme.headlineMedium),
                ],
              ))
        ],
      ),
    );
  }
}
