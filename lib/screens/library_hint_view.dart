import 'package:alchemist_folly/screens/game_master_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_state.dart';
import '../widgets/background_scaffold.dart';
import '../widgets/primary_button.dart';
import '../widgets/game_overlays.dart';

class LibraryHintView extends StatelessWidget {
  static const routeName = '/library-hint-view';

  const LibraryHintView({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameState>();
    final secretPotion = game.secretPotion;

    // Get the hint text or fallback
    String hintText;
    if (secretPotion?.hint != null) {
      hintText = '"${secretPotion!.hint}"';
    } else {
      hintText =
          'The ancient tome\'s pages remain blank...\nThe secret has not yet been chosen.';
    }

    return BackgroundScaffold(
      backgroundAsset: 'assets/images/bg_library.png',
      child: SafeArea(
        child: Stack(
          children: [
            // MAIN CONTENT
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 120, 24, 100),
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 400),
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
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 8),
                        Text(
                          hintText,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'JMH Cthulhumbus Arcade',
                            fontSize: 20,
                            color: Color(0xFF351B10),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 32),
                        PrimaryButton(
                          label: 'Done',
                          onPressed: () {
                            Navigator.pushNamed(
                                context, GameMasterScreen.routeName);
                          },
                        ),
                      ],
                    ),
                  ),
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

