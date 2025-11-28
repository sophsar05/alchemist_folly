import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/game_state.dart';
import '../widgets/background_scaffold.dart';
import '../widgets/game_overlays.dart'; // CircleIconButton + dialogs
import '../widgets/primary_button.dart';
import '../widgets/alchemists_folly_logo.dart';
import 'main_menu_screen.dart';


class SecretRevealScreen extends StatefulWidget {
  static const routeName = '/secret-reveal';

  const SecretRevealScreen({super.key});

  @override
  State<SecretRevealScreen> createState() => _SecretRevealScreenState();
}

class _SecretRevealScreenState extends State<SecretRevealScreen> {
  int _step = 0; // 0 = "has been found", 1 = "was...", 2 = potion

  @override
  void initState() {
    super.initState();
    _runSequence();
  }

  Future<void> _runSequence() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _step = 1);

    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _step = 2);
  }

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameState>();
    final secret = game.secretPotion;

    return BackgroundScaffold(
      backgroundAsset: 'assets/images/bg_secret.png',
      child: SafeArea(
        child: Stack(
          children: [
            // top HUD buttons
            Positioned(
              left: 14,
              top: 16,
              child: CircleIconButton(
                backgroundColor: const Color(0xFFFE7305),
                icon: Icons.menu,
                onTap: () => showPauseDialog(context),
              ),
            ),
            Positioned(
              right: 14,
              top: 16,
              child: CircleIconButton(
                backgroundColor: const Color(0xFFFFC037),
                icon: Icons.group,
                onTap: () => showScoreboardDialog(context),
              ),
            ),

            // main column
            Column(
              children: [
                const SizedBox(height: 80),

                // ROUND label
                Text(
                  'ROUND ${game.currentRound}',
                  style: const TextStyle(
                    fontFamily: 'Pixel Game',
                    fontSize: 32,
                    height: 0.71,
                    letterSpacing: -0.01,
                    color: Color(0xFFFFF6E3),
                    shadows: [
                      Shadow(
                        blurRadius: 8.9,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // 🔸 CENTERED SECRET CONTENT
                Expanded(
                  child: Center(
                    child: () {
                      if (_step == 0) {
                        return const _SecretTitle(
                          text: 'THE SECRET\nPOTION HAS\nBEEN FOUND!',
                        );
                      } else if (_step == 1) {
                        return const _SecretTitle(
                          text: 'THE SECRET\nPOTION WAS...',
                        );
                      } else if (_step == 2 && secret != null) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              secret.name.toUpperCase(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontFamily: 'Pixel Game',
                                fontSize: 30,
                                height: 0.9,
                                letterSpacing: -0.01,
                                color: Color(0xFFFFF6E3),
                                shadows: [
                                  Shadow(
                                    blurRadius: 8.9,
                                    color: Colors.black,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: 140,
                              height: 140,
                              child: Image.asset(
                                'assets/images/potion.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              width: 160,
                              child: PrimaryButton(
                                label: 'Done',
                                onPressed: () {
                                  // Reset game and return to main menu for secret potion win
                                  context.read<GameState>().reset();
                                  Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    MainMenuScreen.routeName,
                                    (route) => false,
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      } else {
                        // fallback (shouldn’t normally hit)
                        return const SizedBox.shrink();
                      }
                    }(),
                  ),
                ),

                const AlchemistsFollyLogo(),
                const SizedBox(height: 16),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SecretTitle extends StatelessWidget {
  final String text;
  const _SecretTitle({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontFamily: 'Pixel Game',
        fontSize: 34,
        height: 0.9,
        letterSpacing: -0.01,
        color: Color(0xFFFFF6E3),
        shadows: [
          Shadow(
            blurRadius: 8.9,
            color: Colors.black,
          ),
        ],
      ),
    );
  }
}
