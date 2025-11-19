import 'package:flutter/material.dart';
import '../widgets/background_scaffold.dart';
import '../widgets/game_overlays.dart';
import 'library_hint_view.dart';
import 'game_master_screen.dart';

class LibraryHintScreen extends StatelessWidget {
  static const routeName = '/library-hint';

  const LibraryHintScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BackgroundScaffold(
      backgroundAsset: 'assets/images/bg_library.png',
      child: SafeArea(
        child: Stack(
          children: [
            // MAIN CONTENT
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 150, 24, 100),
              child: Align(
                alignment: Alignment.topCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // FLOATING WHITE TEXT WITH OUTLINE
                    Stack(
                      children: [
                        // Outline text
                        Text(
                          'Searching for the secret potion?\nYou\'ve come to the right place.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'JMH Cthulhumbus Arcade',
                            fontSize: 24,
                            height: 1.2,
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 3
                              ..color = Colors.black,
                          ),
                        ),
                        // Filled text
                        const Text(
                          'Searching for the secret potion?\nYou\'ve come to the right place.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'JMH Cthulhumbus Arcade',
                            fontSize: 24,
                            height: 1.2,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),

                    //view hint button
                    _MenuScrollButton(
                      label: 'View Hint',
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          LibraryHintView.routeName,
                        );
                      },
                    ),

                    const SizedBox(height: 20),

                    // BACK BUTTON (styled like End Turn button)
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacementNamed(
                          context,
                          GameMasterScreen.routeName,
                        );
                      },
                      child: Container(
                        width: 80,
                        padding: const EdgeInsets.symmetric(
                            vertical: 6, horizontal: 12),
                        decoration: BoxDecoration(
                          color: const Color(
                              0xFF351B10), // Same as End Turn button
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.black, // Same as End Turn button
                            width: 3,
                          ),
                        ),
                        child: const Text(
                          'Back',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Pixel Game',
                            fontSize: 18,
                            color: Color(
                                0xFFFFDB8D), // Same as End Turn button text
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // pause
            Positioned(
              left: 14,
              top: 16,
              child: CircleIconButton(
                backgroundColor: const Color(0xFFFE7305),
                icon: Icons.menu,
                onTap: () => showPauseDialog(context),
              ),
            ),

            // score
            Positioned(
              right: 14,
              top: 16,
              child: CircleIconButton(
                backgroundColor: const Color(0xFFFFC037),
                icon: Icons.group,
                onTap: () => showScoreboardDialog(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuScrollButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _MenuScrollButton({
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 315,
          decoration: BoxDecoration(
            color: const Color(0xFFFFDB8D),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: const Color(0xFFFFDB8D),
              width: 5,
            ),
          ),
          child: Container(
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF6E3),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: const Color(0xFF351B10),
                width: 4,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFFE5A8).withValues(alpha: 0.9),
                  blurRadius: 0.6,
                  spreadRadius: 1.2,
                ),
                BoxShadow(
                  color: const Color(0xFFCC9A4B).withValues(alpha: 0.5),
                  blurRadius: 0.6,
                  spreadRadius: 0.4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              label,
              style: const TextStyle(
                fontFamily: 'JMH Cthulhumbus Arcade',
                fontSize: 28,
                height: 0.9,
                color: Color(0xFF351B10),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
