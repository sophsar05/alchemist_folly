import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/background_scaffold.dart';
import '../widgets/primary_button.dart';
import '../widgets/game_overlays.dart';
import '../widgets/alchemists_folly_logo.dart';
import '../providers/game_state.dart';
import 'market_announcement_screen.dart';

class RoundStartScreen extends StatefulWidget {
  static const routeName = '/round-start';

  const RoundStartScreen({super.key});

  @override
  State<RoundStartScreen> createState() => _RoundStartScreenState();
}

class _RoundStartScreenState extends State<RoundStartScreen> {
  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameState>();

    return BackgroundScaffold(
      backgroundAsset: 'assets/images/bg_default.png',
      child: SafeArea(
        child: Stack(
          children: [
            // ----- TOP LEFT / RIGHT ICONS -----
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

            // ----- MAIN CONTENT -----
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                // pushes everything down similar to Figma (around y ~ 130)
                padding: const EdgeInsets.only(top: 170),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // COMMENCING ROUND
                    const Text(
                      'COMMENCING',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Pixel Game',
                        fontSize: 55,
                        height: 0.71,
                        letterSpacing: -0.01,
                        color: Color(0xFFFFF6E3),
                        shadows: [
                          Shadow(
                            blurRadius: 11.57,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'ROUND',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Pixel Game',
                        fontSize: 55,
                        height: 0.71,
                        letterSpacing: -0.01,
                        color: Color(0xFFFFF6E3),
                        shadows: [
                          Shadow(
                            blurRadius: 11.57,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 50),

                    // ROUND NUMBER CIRCLE
                    Container(
                      width: 152,
                      height: 152,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFFFF6E3),
                        border: Border.all(
                          color: const Color(0xFF351B10),
                          width: 10.13,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${game.currentRound}',
                        style: const TextStyle(
                          fontFamily: 'Pixel Game',
                          fontSize: 160,
                          height: 0.71,
                          letterSpacing: -0.01,
                          color: Color(0xFF983333),
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // ROUND 1 INSTRUCTION (position & style like Figma)
                    if (game.currentRound == 1)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Text(
                          'TAKE 3 CARDS FROM THE\nBOTTOM OF THE DECK OF\nALL COLORS EXCEPT\nYOUR OWN.',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'Pixel Game',
                            fontSize: 32,
                            height: 0.9,
                            letterSpacing: -0.01,
                            color: Color(0xFFFFF6E3),
                            shadows: [
                              Shadow(
                                blurRadius: 29.5,
                                color: Colors.black,
                              ),
                              Shadow(
                                blurRadius: 29.5,
                                color: Colors.black,
                              ),
                              Shadow(
                                blurRadius: 29.5,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                      ),

                    const SizedBox(height: 40),

                    // DONE BUTTON
                    SizedBox(
                      width: 122,
                      height: 45,
                      child: PrimaryButton(
                        label: 'Done',
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                            context,
                            MarketAnnouncementScreen.routeName,
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 40),

                    // LOGO NEAR BOTTOM
                    const AlchemistsFollyLogo(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
