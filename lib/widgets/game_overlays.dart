import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/primary_button.dart';
import '../providers/game_state.dart';
import '../screens/main_menu_screen.dart';

/// Round icon button used for pause (orange) and scoreboard (yellow)
class CircleIconButton extends StatelessWidget {
  final Color backgroundColor;
  final IconData icon;
  final VoidCallback onTap;

  const CircleIconButton({
    super.key,
    required this.backgroundColor,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            color: backgroundColor,
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFF351B10),
              width: 4,
            ),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 26,
          ),
        ),
      ),
    );
  }
}

/// PAUSE OVERLAY (Resume / Restart / Quit game)
void showPauseDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (ctx) {
      return Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: 320,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
            decoration: BoxDecoration(
              color: const Color(0xFFFFDB8D),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: const Color(0xFF351B10),
                width: 4,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'GAME PAUSED',
                  style: TextStyle(
                    fontFamily: 'Pixel Game',
                    fontSize: 28,
                    color: Color(0xFF351B10),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: PrimaryButton(
                    label: 'Resume',
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: PrimaryButton(
                    label: 'Restart',
                    onPressed: () {
                      // Just go back to main menu; GameState can decide how to reset
                      Navigator.of(ctx).pop(); // close dialog
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        MainMenuScreen.routeName,
                        (route) => false,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: PrimaryButton(
                    label: 'Quit game',
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        MainMenuScreen.routeName,
                        (route) => false,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

/// SCOREBOARD OVERLAY (shows each player's PP)
void showScoreboardDialog(BuildContext context) {
  final game = context.read<GameState>();
  final players = [...game.players];

  // sort high to low PP
  players.sort((a, b) => b.prestige.compareTo(a.prestige));

  final dotColors = <Color>[
    const Color(0xFF983333), // red
    const Color(0xFF1E90D2), // blue
    const Color(0xFFE9B33B), // yellow
    const Color(0xFF7A5AE6), // purple for extras
  ];

  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (ctx) {
      return Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: 320,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
            decoration: BoxDecoration(
              color: const Color(0xFFFFDB8D),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: const Color(0xFF351B10),
                width: 4,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'SCOREBOARD',
                  style: TextStyle(
                    fontFamily: 'Pixel Game',
                    fontSize: 26,
                    color: Color(0xFF351B10),
                  ),
                ),
                const SizedBox(height: 16),
                for (var i = 0; i < players.length; i++) ...[
                  Row(
                    children: [
                      Container(
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: dotColors[i % dotColors.length],
                          border: Border.all(
                            color: const Color(0xFF351B10),
                            width: 2,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        players[i].name,
                        style: const TextStyle(
                          fontFamily: 'JMH Cthulhumbus Arcade',
                          fontSize: 22,
                          color: Color(0xFF351B10),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${players[i].prestige}',
                        style: const TextStyle(
                          fontFamily: 'JMH Cthulhumbus Arcade',
                          fontSize: 22,
                          color: Color(0xFF351B10),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
              ],
            ),
          ),
        ),
      );
    },
  );
}
