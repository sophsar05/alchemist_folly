import 'package:flutter/material.dart';
import '../widgets/background_scaffold.dart';
import '../widgets/primary_button.dart';
import 'market_announcement_screen.dart';
import 'game_master_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_state.dart';
import '../widgets/background_scaffold.dart';
import '../widgets/primary_button.dart';
import 'market_announcement_screen.dart';
class RoundStartScreen extends StatelessWidget {
  static const routeName = '/round-start';

  const RoundStartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameState>();

    return BackgroundScaffold(
      backgroundAsset: 'assets/images/bg_default.png',
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Round ${game.currentRound}',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 16),
            Text(
              'Prepare your components and pawns on the board.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 32),
            Text(
              'Players:',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            ...game.players.map(
              (p) => Text(
                '• ${p.name}',
                style: const TextStyle(
                  fontFamily: 'Pixel Game',
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(height: 40),
            PrimaryButton(
              label: 'Continue',
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  MarketAnnouncementScreen.routeName,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}