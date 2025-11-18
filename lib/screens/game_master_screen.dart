import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_state.dart';
import '../widgets/background_scaffold.dart';
import '../widgets/primary_button.dart';
import 'brew_screen.dart';
import 'potion_list_screen.dart';
import 'library_hint_screen.dart';
import 'market_screen.dart';
import 'secret_reveal_screen.dart';
import 'end_game_screen.dart';

class GameMasterScreen extends StatelessWidget {
  static const routeName = '/game-master';

  const GameMasterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameState>();
    final player = game.currentPlayer;

    return BackgroundScaffold(
      backgroundAsset: 'assets/images/bg_default.png',
      appBar: AppBar(
        title: const Text(
          'Alchemist Folly',
          style: TextStyle(
            fontFamily: 'Pixel Game',
            color: Color(0xFFFFDB8D),
          ),
        ),
        backgroundColor: const Color(0xFF351B10),
        centerTitle: true,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Round ${game.currentRound}',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 8),
            Text(
              "It's ${player.name}'s turn!",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'AP: ${game.currentAP}   |   PP: ${player.prestige}',
              style: const TextStyle(
                fontFamily: 'Pixel Game',
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  Text(
                    'Quick Actions',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      PrimaryButton(
                        label: 'Brew',
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            BrewScreen.routeName,
                          );
                        },
                      ),
                      PrimaryButton(
                        label: 'Potion List',
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            PotionListScreen.routeName,
                          );
                        },
                      ),
                      PrimaryButton(
                        label: 'Library (Hints)',
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            LibraryHintScreen.routeName,
                          );
                        },
                      ),
                      PrimaryButton(
                        label: 'Market',
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            MarketScreen.routeName,
                          );
                        },
                      ),
                      PrimaryButton(
                        label: 'Secret Reveal',
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            SecretRevealScreen.routeName,
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Players Summary',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  ...game.players.map(
                    (p) => Card(
                      color: Colors.white.withValues(alpha: 0.9),
                      child: ListTile(
                        title: Text(
                          p.name,
                          style: const TextStyle(
                            fontFamily: 'Pixel Game',
                          ),
                        ),
                        subtitle: Text(
                          'PP: ${p.prestige}   |   Potions brewed: ${p.potionsBrewed}',
                          style: const TextStyle(
                            fontFamily: 'Pixel Game',
                            fontSize: 14,
                          ),
                        ),
                        trailing: p.discoveredSecretPotion
                            ? const Icon(Icons.star, color: Colors.amber)
                            : null,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PrimaryButton(
                  label: 'End Game',
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      EndGameScreen.routeName,
                    );
                  },
                ),
                PrimaryButton(
                  label: game.isGameOver ? 'Game Over' : 'End Turn',
                  // Always pass a non-null callback (PrimaryButton expects VoidCallback)
                  onPressed: () {
                    if (!game.isGameOver) {
                      context.read<GameState>().nextTurn();
                    }
                    // If game.isGameOver, button does nothing but still satisfies type.
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
