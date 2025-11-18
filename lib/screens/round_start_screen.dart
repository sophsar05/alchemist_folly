import 'package:flutter/material.dart';
import '../widgets/background_scaffold.dart';
import '../widgets/primary_button.dart';
import 'market_announcement_screen.dart';
import 'package:provider/provider.dart';

import '../providers/game_state.dart';
import '../widgets/game_overlays.dart';
import '../widgets/alchemists_folly_logo.dart';

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
            // pause + scoreboard buttons re-used
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

            // center content
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'COMMENCING',
                    style: TextStyle(
                      fontFamily: 'Pixel Game',
                      fontSize: 40,
                      color: Color(0xFFFFF6E3),
                      shadows: [Shadow(blurRadius: 8.9, color: Colors.black)],
                    ),
                  ),
                  const Text(
                    'ROUND',
                    style: TextStyle(
                      fontFamily: 'Pixel Game',
                      fontSize: 40,
                      color: Color(0xFFFFF6E3),
                      shadows: [Shadow(blurRadius: 8.9, color: Colors.black)],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFFFF6E3),
                      border: Border.all(
                        color: const Color(0xFF351B10),
                        width: 10,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${game.currentRound}',
                      style: const TextStyle(
                        fontFamily: 'Pixel Game',
                        fontSize: 90,
                        color: Color(0xFF983333),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  const AlchemistsFollyLogo(),
                  const SizedBox(height: 40),
                  PrimaryButton(
                    label: 'Continue',
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                        context,
                        MarketAnnouncementScreen.routeName,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
