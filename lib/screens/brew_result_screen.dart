// lib/screens/brew_result_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/background_scaffold.dart';
import '../widgets/game_overlays.dart';
import '../providers/game_state.dart';
import '../game_logic/game_models.dart';

class BrewResultScreen extends StatelessWidget {
  static const routeName = '/brew-result';

  const BrewResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final result =
        ModalRoute.of(context)!.settings.arguments as BrewResult?;

    if (result == null) {
      return const BackgroundScaffold(
        backgroundAsset: 'assets/images/bg_cauldron.png',
        child: Center(
          child: Text(
            'No brew data.',
            style: TextStyle(
              fontFamily: 'Pixel Game',
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ),
      );
    }

    final game = context.watch<GameState>();
    final currentRound = game.currentRound;
    final hasBonus = (result.bonusPoints ?? 0) > 0;

    // Colors from your Figma
    const cream = Color(0xFFFFF6E3);
    const darkBrown = Color(0xFF351B10);

    return BackgroundScaffold(
      backgroundAsset: 'assets/images/bg_cauldron.png',
      child: SafeArea(
        child: Stack(
          children: [
            // MAIN LAYOUT
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 4),

                    // ------------------ ROUND HEADER ------------------
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'ROUND',
                          style: TextStyle(
                            fontFamily: 'Pixel Game',
                            fontSize: 42,
                            height: 0.71,
                            color: cream,
                            letterSpacing: -0.01,
                            shadows: [
                              Shadow(
                                blurRadius: 8.9,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          width: 33,
                          height: 33,
                          decoration: BoxDecoration(
                            color: cream.withOpacity(0.96),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: darkBrown,
                              width: 4,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '$currentRound',
                            style: const TextStyle(
                              fontFamily: 'Pixel Game',
                              fontSize: 20,
                              height: 0.71,
                              color: Color(0xFF009EBA),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 50),

                
                    // ---------------- POTION NAME ---------------------
                    Text(
                      (result.potion?.name ?? 'Potion').toUpperCase(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'Pixel Game',
                        fontSize: 50,
                        height: 0.71,
                        letterSpacing: -0.01,
                        color: cream,
                        shadows: [
                          Shadow(
                            blurRadius: 10.7,
                            color: Colors.black,
                          ),
                          Shadow(
                            blurRadius: 10.7,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),


                    // ---------- POINTS + POTION IMAGE ROW -------------
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // LEFT: base points
                          SizedBox(
                            width: 130,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '+${result.basePoints}',
                                  style: const TextStyle(
                                    fontFamily: 'Pixel Game',
                                    fontSize: 86,
                                    height: 0.71,
                                    letterSpacing: -0.01,
                                    color: cream,
                                    shadows: [
                                      Shadow(
                                        blurRadius: 18.0,
                                        color: Colors.black,
                                      ),
                                      Shadow(
                                        blurRadius: 18.0,
                                        color: Colors.black,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'POINTS!',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'Pixel Game',
                                    fontSize: 32,
                                    height: 0.71,
                                    letterSpacing: -0.01,
                                    color: cream,
                                    shadows: [
                                      Shadow(
                                        blurRadius: 6.6,
                                        color: Colors.black,
                                      ),
                                      Shadow(
                                        blurRadius: 6.6,
                                        color: Colors.black,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // CENTER: potion image
                          Expanded(
                            child: Center(
                              child: SizedBox(
                                width: 220,
                                height: 220,
                                child: Image.asset(
                                  'assets/images/potion.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),

                          // RIGHT: bonus points (only if any)
                          SizedBox(
                            width: 130,
                            child: hasBonus
                                ? Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        '+${result.bonusPoints}',
                                        style: const TextStyle(
                                          fontFamily: 'Pixel Game',
                                          fontSize: 66,
                                          height: 0.71,
                                          letterSpacing: -0.01,
                                          color: Color(0xFFFFDB8D),
                                          shadows: [
                                            Shadow(
                                              blurRadius: 13.9,
                                              color: Colors.black,
                                            ),
                                            Shadow(
                                              blurRadius: 13.9,
                                              color: Colors.black,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      const Text(
                                        'POINTS FOR USING\nIN-DEMAND\nINGREDIENTS!',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: 'Pixel Game',
                                          fontSize: 14,
                                          height: 0.9,
                                          letterSpacing: -0.01,
                                          color: cream,
                                          shadows: [
                                            Shadow(
                                              blurRadius: 6.1,
                                              color: Colors.black,
                                            ),
                                            Shadow(
                                              blurRadius: 6.1,
                                              color: Colors.black,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                : const SizedBox.shrink(),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ------------------- DONE BUTTON -------------------
                    SizedBox(
                      width: 140,
                      height: 46,
                      child: GestureDetector(
                        onTap: () {
                          // Back to Game Master / turn screen
                          Navigator.popUntil(
                            context,
                            ModalRoute.withName('/game-master'),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF0D0),
                            borderRadius: BorderRadius.circular(11.6),
                            border: Border.all(
                              color: darkBrown,
                              width: 3.1,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            'Done',
                            style: TextStyle(
                              fontFamily: 'JMH Cthulhumbus Arcade',
                              fontSize: 22,
                              height: 0.79,
                              color: darkBrown,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),

            // ---------- TOP-LEFT MENU / TOP-RIGHT SCOREBOARD ----------
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
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// TOP INGREDIENT STRIP (JUST VISUAL, MATCHES FIGMA)
// -----------------------------------------------------------------------------

class _ResultIngredientStrip extends StatelessWidget {
  const _ResultIngredientStrip();

  @override
  Widget build(BuildContext context) {
    // Colors in order: blue, yellow, lavender, peach
    const tileColors = [
      Color(0xFFA5DCE5),
      Color(0xFFFFDB8D),
      Color(0xFFDFD0F3),
      Color(0xFFFFDCC9),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        final Color color = tileColors[index];
        final bool showThumb = index == 2; // third tile has thumbs-up badge
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: _SmallResultTile(
            color: color,
            showThumb: showThumb,
          ),
        );
      }),
    );
  }
}

class _SmallResultTile extends StatelessWidget {
  final Color color;
  final bool showThumb;

  const _SmallResultTile({
    required this.color,
    required this.showThumb,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      height: 40,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFF351B10),
                width: 4,
              ),
            ),
          ),

          // thumbs-up bubble (for in-demand ingredient)
          if (showThumb)
            Positioned(
              top: -10,
              right: -6,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF6E3),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF351B10),
                    width: 3,
                  ),
                ),
                child: const Icon(
                  Icons.thumb_up,
                  size: 14,
                  color: Color(0xFF983333),
                ),
              ),
            ),

          // orange check at bottom
          Positioned(
            bottom: -7,
            left: 10,
            right: 10,
            child: Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: const Color(0xFFFF913B),
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF351B10),
                  width: 1.9,
                ),
              ),
              child: const Icon(
                Icons.check,
                size: 13,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
