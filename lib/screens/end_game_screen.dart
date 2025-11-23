import 'package:flutter/material.dart';
import '../widgets/background_scaffold.dart';
import '../widgets/primary_button.dart';

class EndGameScreen extends StatelessWidget {
  static const routeName = '/end-game';

  const EndGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // placeholder scoreboard, later will show real winners
    final dummyScores = [
      {'name': 'Player 1', 'pp': 22},
      {'name': 'Player 2', 'pp': 18},
    ];

    return BackgroundScaffold(
      backgroundAsset: 'assets/images/bg_default.png',
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              'Total Points Per Player',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'JMH Cthulhumbus Arcade',
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: dummyScores.length,
                itemBuilder: (context, index) {
                  final s = dummyScores[index];
                  return Card(
                    color: Colors.white.withOpacity(0.95),
                    child: ListTile(
                      leading: Text(
                        '#${index + 1}',
                        style: const TextStyle(
                          fontFamily: 'Pixel Game',
                          fontSize: 18,
                        ),
                      ),
                      title: Text(
                        s['name'] as String,
                        style: const TextStyle(
                          fontFamily: 'Pixel Game',
                          fontSize: 18,
                        ),
                      ),
                      trailing: Text(
                        '${s['pp']} PP',
                        style: const TextStyle(
                          fontFamily: 'Pixel Game',
                          fontSize: 16,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            PrimaryButton(
              label: 'Back to Main Menu',
              onPressed: () {
                Navigator.popUntil(
                  context,
                  ModalRoute.withName('/'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
