import 'package:flutter/material.dart';
import '../widgets/background_scaffold.dart';

class PotionListScreen extends StatelessWidget {
  static const routeName = '/potion-list';

  const PotionListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // placeholder: static potion list; later replace with real data model
    final potions = [
      {
        'name': 'Invisibility Potion',
        'points': 8,
        'recipe':
            'Nightshade + Blue Ore + Kraken Ink + Shadow Oil',
      },
      {
        'name': 'Sleep Potion',
        'points': 7,
        'recipe':
            'Moonleaf + Blue Ore + Kraken Ink + Spirit Dew',
      },
      {
        'name': 'Frost Potion',
        'points': 7,
        'recipe':
            'Frostmint + Blue Ore + Basilisk Fang + Spirit Dew',
      },
      // ... add the rest later when we do full logic
    ];

    return BackgroundScaffold(
      backgroundAsset: 'assets/images/bg_potionlist.png',
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Potion List',
              style: const TextStyle(
                fontFamily: 'JMH Cthulhumbus Arcade',
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: potions.length,
                itemBuilder: (context, index) {
                  final potion = potions[index];
                  return Card(
                    color: Colors.white.withOpacity(0.95),
                    child: ListTile(
                      title: Text(
                        potion['name'] as String,
                        style: const TextStyle(
                          fontFamily: 'Pixel Game',
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text(
                        'Recipe: ${potion['recipe']}\nPoints: ${potion['points']} PP',
                        style: const TextStyle(
                          fontFamily: 'Pixel Game',
                          fontSize: 14,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
