// lib/screens/player_names_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/primary_button.dart';
import '../widgets/background_scaffold.dart';
import '../widgets/alchemists_folly_logo.dart';
import '../providers/game_state.dart';

class PlayerNamesScreen extends StatefulWidget {
  static const routeName = '/player-names';

  const PlayerNamesScreen({super.key});

  @override
  State<PlayerNamesScreen> createState() => _PlayerNamesScreenState();
}

class _PlayerNamesScreenState extends State<PlayerNamesScreen> {
  int _playerCount = 2;
  bool _initialized = false;
  final List<TextEditingController> _controllers = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final arg = ModalRoute.of(context)?.settings.arguments;
      _playerCount = (arg is int && arg >= 2 && arg <= 4) ? arg : 2;

      _controllers.clear();
      for (int i = 0; i < _playerCount; i++) {
        _controllers.add(TextEditingController());
      }
      _initialized = true;
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _startGame() {
    final names = List<String>.generate(
      _playerCount,
      (i) {
        final raw = _controllers[i].text.trim();
        return raw.isEmpty ? 'Player ${i + 1}' : raw;
      },
    );

    final game = context.read<GameState>();
    game.setPlayerNames(names);

    Navigator.pushReplacementNamed(context, '/game-master');
  }

  @override
  Widget build(BuildContext context) {
    const iconColors = [
      Color(0xFF983333), // red
      Color(0xFF009EBA), // blue
      Color(0xFFFFDB8D), // yellow
      Color(0xFF7F5FFF), // purple
    ];

    return BackgroundScaffold(
      backgroundAsset: 'assets/images/bg_default.png',
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 150),

              // TITLE
              const Text(
                'PLEASE ENTER \nPLAYER NAMES:',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Pixel Game',
                  fontSize: 42,
                  height: 0.71,
                  letterSpacing: -0.01,
                  color: Color(0xFFFFF6E3),
                  shadows: [
                    Shadow(
                      blurRadius: 8.9,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 42),

              // NAME FIELDS
              Flexible(
              fit: FlexFit.loose,
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _playerCount,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        _PlayerIconBubble(color: iconColors[index]),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _NameScrollField(
                            playerIndex: index,
                            controller: _controllers[index],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
              const SizedBox(height: 42),


              SizedBox(
                width: 120,
                height: 40,
                child: PrimaryButton(
                  label: 'PROCEED',
                      onPressed: _startGame,
                ),
              ),

              const SizedBox(height: 50),
              const AlchemistsFollyLogo(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// SUBWIDGETS
// -----------------------------------------------------------------------------

class _PlayerIconBubble extends StatelessWidget {
  final Color color;

  const _PlayerIconBubble({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 54,
      height: 54,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(80),
        border: Border.all(
          color: const Color(0xFF351B10),
          width: 4,
        ),
        boxShadow: const [
          BoxShadow(
            blurRadius: 8,
            color: Colors.black,
          ),
        ],
      ),
      child: const Icon(
        Icons.person,
        color: Colors.white,
        size: 28,
      ),
    );
  }
}

// Scroll-style text field container
class _NameScrollField extends StatelessWidget {
  final int playerIndex;
  final TextEditingController controller;

  const _NameScrollField({
    required this.playerIndex,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Stack(
        children: [
          // Outer parchment
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFFFDB8D),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: const Color(0xFFFFDB8D),
                  width: 8,
                ),
              ),
            ),
          ),
          // Inner parchment
          Positioned(
            left: 4,
            right: 4,
            top: 4,
            bottom: 4,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFFFF0D0),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: const Color(0xFF351B10),
                  width: 3,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Center(
                  child: TextField(
                    controller: controller,
                    style: const TextStyle(
                      fontFamily: 'Pixel Game',
                      fontSize: 18,
                      color: Color(0xFF351B10),
                    ),
                    cursorColor: const Color(0xFF351B10),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      hintText: 'Player ${playerIndex + 1}',
                      hintStyle: const TextStyle(
                        fontFamily: 'Pixel Game',
                        fontSize: 18,
                        color: Color(0x80351B10),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Scroll-style button (same vibe as PROCEED scroll)
class _ScrollButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _ScrollButton({
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 212.69,
      height: 79.29,
      child: GestureDetector(
        onTap: onPressed,
        child: Stack(
          children: [
            // Outer scroll
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFFFDB8D),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: const Color(0xFFFFDB8D),
                    width: 12,
                  ),
                ),
              ),
            ),
            // Inner scroll
            Positioned(
              left: 4,
              right: 4,
              top: 4,
              bottom: 4,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF0D0),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: const Color(0xFF351B10),
                    width: 4,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 8.3,
                      color: Colors.black,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'JMH Cthulhumbus Arcade',
                      fontSize: 21.75,
                      height: 0.79,
                      color: Color(0xFF351B10),
                      letterSpacing: -0.01,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
