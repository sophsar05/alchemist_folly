import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/game_state.dart';
import '../widgets/background_scaffold.dart';
import '../widgets/primary_button.dart';
import 'brew_result_screen.dart';
import 'secret_reveal_screen.dart';

class BrewScreen extends StatefulWidget {
  static const routeName = '/brew';

  const BrewScreen({super.key});

  @override
  State<BrewScreen> createState() => _BrewScreenState();
}

class _BrewScreenState extends State<BrewScreen> {
  String? selectedHerb;
  String? selectedMineral;
  String? selectedCreature;
  String? selectedEssence;
  bool useStardust = false;

  final herbs = ['Moonleaf', 'Emberroot', 'Frostmint', 'Nightshade'];
  final minerals = ['Crystal Dust', 'Iron Shard', 'Sulfur Stone', 'Blue Ore'];
  final creatures = [
    'Dragon Scale',
    'Phoenix Feather',
    'Kraken Ink',
    'Basilisk Fang',
  ];
  final essences = [
    'Light Essence',
    'Shadow Oil',
    'Spirit Dew',
    'Forest Blood',
  ];

  @override
  Widget build(BuildContext context) {
    final currentPlayer =
        (ModalRoute.of(context)!.settings.arguments as String?) ?? 'Player';

    return BackgroundScaffold(
      backgroundAsset: 'assets/images/bg_cauldron.png',
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              '$currentPlayer is brewing…',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Column(
                children: [
                  _buildIngredientRow(
                    label: 'Herb',
                    options: herbs,
                    selected: selectedHerb,
                    onChanged: (value) {
                      setState(() {
                        selectedHerb = value;
                      });
                    },
                  ),
                  _buildIngredientRow(
                    label: 'Mineral',
                    options: minerals,
                    selected: selectedMineral,
                    onChanged: (value) {
                      setState(() {
                        selectedMineral = value;
                      });
                    },
                  ),
                  _buildIngredientRow(
                    label: 'Creature Part',
                    options: creatures,
                    selected: selectedCreature,
                    onChanged: (value) {
                      setState(() {
                        selectedCreature = value;
                      });
                    },
                  ),
                  _buildIngredientRow(
                    label: 'Essence',
                    options: essences,
                    selected: selectedEssence,
                    onChanged: (value) {
                      setState(() {
                        selectedEssence = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Checkbox(
                        value: useStardust,
                        onChanged: (value) {
                          setState(() {
                            useStardust = value ?? false;
                          });
                        },
                      ),
                      const Text(
                        'Use Stardust (secret potion attempt)',
                        style: TextStyle(
                          fontFamily: 'Pixel Game',
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            PrimaryButton(
              label: 'BREW!',
              onPressed: () {
                final game = context.read<GameState>();
                final result = game.brew(
                  herbName: selectedHerb,
                  mineralName: selectedMineral,
                  creatureName: selectedCreature,
                  essenceName: selectedEssence,
                  useStardust: useStardust,
                );

                // If secret potion: jump straight to reveal flow
                if (result.isSecretPotion) {
                  Navigator.pushReplacementNamed(
                    context,
                    SecretRevealScreen.routeName,
                  );
                  return;
                }

                // Otherwise go to normal result screen
                Navigator.pushNamed(
                  context,
                  BrewResultScreen.routeName,
                  arguments: result,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIngredientRow({
    required String label,
    required List<String> options,
    required String? selected,
    required ValueChanged<String?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Pixel Game',
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.black,
                width: 3,
              ),
            ),
            child: DropdownButton<String>(
              isExpanded: true,
              value: selected,
              underline: const SizedBox.shrink(),
              icon: const Icon(Icons.arrow_drop_down),
              items: options
                  .map(
                    (value) => DropdownMenuItem(
                      value: value,
                      child: Text(
                        value,
                        style: const TextStyle(
                          fontFamily: 'Pixel Game',
                          fontSize: 16,
                        ),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
