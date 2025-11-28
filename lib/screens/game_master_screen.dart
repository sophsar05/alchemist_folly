// lib/screens/game_master_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/background_scaffold.dart';
import '../widgets/primary_button.dart'; // used inside overlays + End Turn button
import '../providers/game_state.dart';

import 'brew_screen.dart';
import 'potion_list_screen.dart';
import 'library_hint_screen.dart';
import 'market_screen.dart';

import 'round_start_screen.dart';

import '../widgets/alchemists_folly_logo.dart';
import '../widgets/game_overlays.dart'; // pause + scoreboard + circle buttons

class GameMasterScreen extends StatefulWidget {
  static const routeName = '/game-master';

  const GameMasterScreen({super.key});

  @override
  State<GameMasterScreen> createState() => _GameMasterScreenState();
}

class _GameMasterScreenState extends State<GameMasterScreen> {
  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameState>();
    final player = game.currentPlayer;

    // Same palette as the avatars:
    const iconColors = [
      Color.fromARGB(255, 180, 67, 67), // Player 1 - red 0xFF983333
      Color.fromARGB(255, 42, 210, 240), // Player 2 - blue
      Color(0xFFFFDB8D), // Player 3 - yellow
      Color.fromARGB(255, 148, 122, 250), // Player 4 - purple
    ];

    // Find this player's index so we can color their name
    final playerIndex =
        game.players.indexWhere((p) => p.id == player.id);
    final Color nameColor = (playerIndex >= 0 &&
            playerIndex < iconColors.length)
        ? iconColors[playerIndex]
        : const Color(0xFFFFF6E3); // fallback

    return BackgroundScaffold(
      backgroundAsset: 'assets/images/bg_default.png',
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
                    const SizedBox(height: 12),

                    // ROUND LABEL
                    const Text(
                      'ROUND',
                      style: TextStyle(
                        fontFamily: 'Pixel Game',
                        fontSize: 60,
                        height: 0.71,
                        color: Color(0xFFFFF6E3),
                        letterSpacing: -0.01,
                        shadows: [
                          Shadow(
                            blurRadius: 8.9,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 6),

                    // ROUND NUMBER CIRCLE
                    Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color:
                            const Color(0xFFFFF6E3).withValues(alpha: 0.96),
                        border: Border.all(
                          color: const Color(0xFF351B10),
                          width: 4,
                        ),
                      ),
                      alignment: Alignment.center,
    
                      child: Text(
                      '${game.currentRound}',
                      style: TextStyle(
                        fontFamily: 'Pixel Game',
                        fontSize: 55,
                        height: 0.71,
                        color: nameColor, // 🔥 color changes based on player index
                      ),
                    ),
                    ),
                    
                    const SizedBox(height: 16),

                    // PLAYER NAME TURN – colored by player
                    Stack(
                    children: [
                      // OUTLINE — black, drawn 4 times around the text
                      for (final offset in [
                        const Offset(-2, -2),
                        const Offset(2, -2),
                        const Offset(-2, 2),
                        const Offset(2, 2),
                      ])
                        Positioned(
                          left: offset.dx,
                          top: offset.dy,
                          child: Text(
                            "${player.name.toUpperCase()}'S TURN",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontFamily: 'Pixel Game',
                              fontSize: 32,
                              height: 0.71,
                              color: Colors.black, // outline color
                              letterSpacing: -0.01,
                            ),
                          ),
                        ),

                      // MAIN TEXT — uses player color
                      Text(
                        "${player.name.toUpperCase()}'S TURN",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Pixel Game',
                          fontSize: 32,
                          height: 0.71,
                          color: nameColor, // center colored text
                          letterSpacing: -0.01,
                        ),
                      ),
                    ],
                  ),

                    const SizedBox(height: 4),

                    // UNDERLINE
                    Container(
                      width: 190,
                      height: 4,
                      color: const Color(0xFF351B10),
                    ),

                    const SizedBox(height: 4),

                    // POINTS LABEL (kept white for readability)
                    const SizedBox(height: 4),
                    Text(
                      'POINTS: ${player.prestige}'
                      '${player.stardust > 0 ? ' | STARDUST: ${player.stardust}' : ''}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'Pixel Game',
                        fontSize: 24,
                        height: 0.71,
                        color: Color(0xFFFFF6E3),
                        letterSpacing: -0.01,
                        shadows: [
                          Shadow(
                            blurRadius: 8.9,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),

                    // ACTION POINTS DISPLAY
                    Text(
                      'ACTION POINTS: ${game.currentAP}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Pixel Game',
                        fontSize: 20,
                        height: 0.71,
                        color: game.currentAP >= 2 
                            ? const Color(0xFF4ADE80)  // Green when can brew
                            : game.currentAP >= 1
                                ? const Color(0xFFFFC037)  // Yellow when can shop
                                : const Color(0xFFEF4444),  // Red when no AP
                        letterSpacing: -0.01,
                        shadows: const [
                          Shadow(
                            blurRadius: 6.0,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),

                    // BIG SCROLL BUTTONS
                    _MenuScrollButton(
                      label: 'Potion List',
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          PotionListScreen.routeName,
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    _MenuScrollButton(
                      label: 'Brew',
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          BrewScreen.routeName,
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    _MenuScrollButton(
                      label: 'Library',
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          LibraryHintScreen.routeName,
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    _MenuScrollButton(
                      label: 'Market',
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          MarketScreen.routeName,
                        );
                      },
                    ),

                    const SizedBox(height: 28),

                    // END TURN / END GAME (smaller scroll-style)
                    SizedBox(
                      width: 180,
                      child: PrimaryButton(
                        label: game.isGameOverByPoints ? 'End Game' : 'End Turn',
                        onPressed: () {
                          if (game.isGameOverByPoints) {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              '/end-game-flow',
                              (route) => false,
                            );
                          } else {
                            final startedNewRound =
                                context.read<GameState>().nextTurn();

                            if (startedNewRound) {
                              Navigator.pushReplacementNamed(
                                context,
                                RoundStartScreen.routeName,
                              );
                            }
                          }
                        },
                      ),
                    ),

                    const SizedBox(height: 55),

                    // LOGO
                    const AlchemistsFollyLogo(),

                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),

            // ORANGE PAUSE BUTTON
            Positioned(
              left: 14,
              top: 16,
              child: CircleIconButton(
                backgroundColor: const Color(0xFFFE7305),
                icon: Icons.menu,
                onTap: () => showPauseDialog(context),
              ),
            ),

            // YELLOW SCOREBOARD BUTTON
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
              label, // ✅ now uses the passed-in label
              textAlign: TextAlign.center,
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
