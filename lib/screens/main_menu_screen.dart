import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_state.dart';
import 'player_count_screen.dart';

class MainMenuScreen extends StatelessWidget {
  static const routeName = '/';

  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/bg_default.png',
            fit: BoxFit.cover,
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/logo.png',
                        width: 380,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 60),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 750),
                        child: const Text(
                          'Brew. Sabotage. Survive. \n\n  The ingredients are gathered, and the Prism is waiting. Only one of you will claim the title of Master Alchemist. \n\n Let the mixing begin!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Pixel Game',
                            fontSize: 25,
                            height: 0.71,
                            letterSpacing: -0.36,
                            color: Color(0xFFFFF6E3),
                            shadows: [
                              Shadow(
                                offset: Offset(0, 0),
                                blurRadius: 8.9,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 50),
                      GestureDetector(
                        onTap: () {
                          context.read<GameState>().reset();
                          Navigator.pushNamed(
                            context,
                            PlayerCountScreen.routeName,
                          );
                        },
                        child: Container(
                          width: 265.31,
                          height: 78.75,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF0D0),
                            borderRadius: BorderRadius.circular(32),
                            border: Border.all(
                              color: const Color(0xFF351B10),
                              width: 4,
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0xFFFFDB8D),
                                blurRadius: 0,
                                spreadRadius: 8,
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            'START A GAME',
                            style: TextStyle(
                              fontFamily: 'JMH Cthulhumbus Arcade',
                              fontSize: 21.75,
                              height: 0.7855,
                              color: Color(0xFF351B10),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
