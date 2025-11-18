import 'package:flutter/material.dart';
import '../widgets/background_scaffold.dart';
import '../widgets/primary_button.dart';
import 'round_start_screen.dart';
import 'package:provider/provider.dart';
import '../providers/game_state.dart';
import 'round_start_screen.dart';

class PlayerNamesScreen extends StatefulWidget {
  static const routeName = '/player-names';

  const PlayerNamesScreen({super.key});

  @override
  State<PlayerNamesScreen> createState() => _PlayerNamesScreenState();
}

class _PlayerNamesScreenState extends State<PlayerNamesScreen> {
  late int playerCount;
  late List<TextEditingController> controllers;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arg = ModalRoute.of(context)!.settings.arguments as int?;
    playerCount = arg ?? 2;
    controllers = List.generate(
      playerCount,
      (index) => TextEditingController(text: 'Player ${index + 1}'),
    );
  }

  @override
  void dispose() {
    for (final c in controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundScaffold(
      backgroundAsset: 'assets/images/bg_default.png',
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              'Please input your names',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: playerCount,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Player ${index + 1}',
                          style: const TextStyle(
                            fontFamily: 'Pixel Game',
                            fontSize: 18,
                            color: Color(0xFFFFDB8D),
                          ),
                        ),
                        const SizedBox(height: 4),
                        TextField(
                          controller: controllers[index],
                          style: const TextStyle(
                            fontFamily: 'Pixel Game',
                            fontSize: 18,
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.9),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Colors.black,
                                width: 3,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            PrimaryButton(
              label: 'Start Game',
              onPressed: () {
                final names = controllers.map((c) => c.text.trim()).toList();
                context.read<GameState>().setPlayerNames(names);

                Navigator.pushReplacementNamed(
                  context,
                  RoundStartScreen.routeName,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
