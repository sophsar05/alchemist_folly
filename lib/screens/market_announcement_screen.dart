import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_state.dart';
import '../widgets/background_scaffold.dart';
import '../widgets/primary_button.dart';
import '../widgets/game_overlays.dart';
import 'game_master_screen.dart';

class MarketAnnouncementScreen extends StatelessWidget {
  static const routeName = '/market-announcement';

  const MarketAnnouncementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameState>();
    final event = game.currentMarketEvent;

    return BackgroundScaffold(
      backgroundAsset: 'assets/images/bg_default.png',
      child: SafeArea(
        child: Stack(
          children: [
            // MAIN CONTENT
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 80, 24, 24),
              child: Center(
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
                        const Text(
                          'Market Announcement !',
                          style: TextStyle(
                            fontFamily: 'Pixel Game',
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF351B10),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          event.title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'JMH Cthulhumbus Arcade',
                            fontSize: 24,
                            height: 1.2,
                            color: Color(0xFF8B4513),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          event.description,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'Pixel Game',
                            fontSize: 18,
                            height: 1.3,
                            color: Color(0xFF351B10),
                          ),
                        ),
                        const SizedBox(height: 32),
                        PrimaryButton(
                          label: 'Begin Turns',
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                              context,
                              GameMasterScreen.routeName,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

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
