import 'package:flutter/material.dart';
import 'player_count_screen.dart';
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
          // Background image – your forest art
          Image.asset(
            'assets/images/bg_default.png',
            fit: BoxFit.cover,
          ),

          // Positioned elements matching the Figma layout (scaled)
          LayoutBuilder(
            builder: (context, constraints) {
              final height = constraints.maxHeight;

              // Figma positions (out of 852 px height)
              final titleTop = height * (231 / 852);  // ~27% from top
              final quoteTop = height * (404 / 852);  // ~47% from top
              final buttonTop = height * (543 / 852); // ~64% from top

              return Stack(
                children: [
                  // "Alchemist's Folly" title
                  Positioned(
                    top: titleTop,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Text(
                        "Alchemist's\nFolly",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: 'JMH Cthulhumbus Arcade',
                          fontSize: 57.07,
                          height: 0.85, // 85%
                          letterSpacing: -2.8, // ~ -0.05em
                          color: Color(0xFFFFDB8D),
                          shadows: [
                            Shadow(
                              offset: Offset(0, 0),
                              blurRadius: 6,
                              color: Colors.black,
                            ),
                          ],
                        ),
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
                        width: 265, // match Figma width
                        child: Text(
                          '"CUTE QUOTE OR\nSPIEL OR SMTH SO ITS\nNOT SO EMPTY"',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'Pixel Game',
                            fontSize: 36,
                            height: 0.71, // 71%
                            letterSpacing: -0.36, // ~ -0.01em
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

                  // "START A GAME" button
                  Positioned(
                    top: buttonTop,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: GestureDetector(
                        onTap: () {
                          // reset any previous game
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
                            // Inner cream panel
                            color: const Color(0xFFFFF0D0),
                            borderRadius: BorderRadius.circular(32),
                            border: Border.all(
                              color: const Color(0xFF351B10),
                              width: 4,
                            ),
                            // Outer golden "frame" glow
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
                            textAlign: TextAlign.center,
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
