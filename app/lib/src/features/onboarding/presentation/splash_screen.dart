import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/maju_colors.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [MajuColors.blue800, MajuColors.blue900],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/maju-logo.png',
                  width: 190,
                  color: Colors.white,
                ),
                const SizedBox(height: 26),
                const Text(
                  'Organize Hoje.\nProspere Amanhã.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Prosperidade financeira familiar · Angola',
                  style: TextStyle(color: Colors.white60, fontSize: 13),
                ),
                const Spacer(),
                FilledButton(
                  onPressed: () => context.push(Routes.persona),
                  child: const Text('Começar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
