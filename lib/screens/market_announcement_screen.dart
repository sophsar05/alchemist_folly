import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_state.dart';
import '../widgets/background_scaffold.dart';
import '../widgets/primary_button.dart';
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
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              event.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'JMH Cthulhumbus Arcade',
                fontSize: 24,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              event.description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'JMH Cthulhumbus Arcade',
                fontSize: 18,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 32),
            PrimaryButton(
              label: 'Begin Turns',
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  GameMasterScreen.routeName,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
