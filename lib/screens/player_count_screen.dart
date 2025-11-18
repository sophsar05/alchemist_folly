import 'package:flutter/material.dart';
import '../widgets/background_scaffold.dart';
import '../widgets/primary_button.dart';
import 'player_names_screen.dart';

class PlayerCountScreen extends StatefulWidget {
  static const routeName = '/player-count';

  const PlayerCountScreen({super.key});

  @override
  State<PlayerCountScreen> createState() => _PlayerCountScreenState();
}

class _PlayerCountScreenState extends State<PlayerCountScreen> {
  int _playerCount = 2;

  @override
  Widget build(BuildContext context) {
    return BackgroundScaffold(
      backgroundAsset: 'assets/images/bg_default.png',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'How many players are playing?',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) {
              final value = index + 2;
              final isSelected = value == _playerCount;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _playerCount = value;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF351B10)
                          : Colors.black.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.black,
                        width: 3,
                      ),
                    ),
                    child: Text(
                      value.toString(),
                      style: TextStyle(
                        fontFamily: 'Pixel Game',
                        fontSize: 24,
                        color: isSelected
                            ? const Color(0xFFFFDB8D)
                            : Colors.black,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 40),
          PrimaryButton(
            label: 'Continue',
            onPressed: () {
              Navigator.pushNamed(
                context,
                PlayerNamesScreen.routeName,
                arguments: _playerCount,
              );
            },
          ),
        ],
      ),
    );
  }
}
