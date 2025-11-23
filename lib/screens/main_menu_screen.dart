import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_state.dart';
import '../widgets/alchemists_folly_logo.dart';
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
          // Background image – your forest art
          Image.asset(
            'assets/images/bg_default.png',
            fit: BoxFit.cover,
          ),

          // Positioned elements
          LayoutBuilder(
            builder: (context, constraints) {
              final height = constraints.maxHeight;

              final titleTop = height * (200 / 852);
              final quoteTop = height * (404 / 852);
              final buttonTop = height * (543 / 852);

              return Stack(
                children: [
                Positioned(
                  top: titleTop,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 380,          // tweak as needed to match your desired size
                      fit: BoxFit.contain,
                    ),
                  ),
                ),


                  // Quote text
                  Positioned(
                    top: quoteTop,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: SizedBox(
                        width: 265,
                        child: Text(
                          '"CUTE QUOTE OR\nSPIEL OR SMTH SO ITS\nNOT SO EMPTY"',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'Pixel Game',
                            fontSize: 36,
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
                    ),
                  ),

                  // START A GAME Button
                  Positioned(
                    top: buttonTop,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: GestureDetector(
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
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
