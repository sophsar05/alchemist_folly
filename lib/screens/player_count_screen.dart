import 'package:flutter/material.dart';
import '../widgets/background_scaffold.dart';
import '../widgets/primary_button.dart';
import '../widgets/alchemists_folly_logo.dart';
import 'player_names_screen.dart';

class PlayerCountScreen extends StatefulWidget {
  static const routeName = '/player-count';

  const PlayerCountScreen({super.key});

  @override
  State<PlayerCountScreen> createState() => _PlayerCountScreenState();
}

class _PlayerCountScreenState extends State<PlayerCountScreen> {
  int _playerCount = 2; // starts at 2
  static const int _minPlayers = 2;
  static const int _maxPlayers = 4;

  void _changeCount(int delta) {
    setState(() {
      _playerCount =
          (_playerCount + delta).clamp(_minPlayers, _maxPlayers);
    });
  }

  @override
  Widget build(BuildContext context) {
    // fixed palette for up to 4 players
    const iconColors = [
      Color(0xFF983333), // red
      Color(0xFF009EBA), // blue
      Color(0xFFFFDB8D), // yellow
      Color(0xFF7F5FFF), // purple
    ];

    return BackgroundScaffold(
      backgroundAsset: 'assets/images/bg_default.png',
      child: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
            children: [
              const SizedBox(height: 150),

              // TITLE
              const Text(
                'HOW MANY PLAYERS\nARE PLAYING?',
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

              const SizedBox(height: 40),

              // PLAYER COUNT SELECTOR
              Center(
                child: Container(
                  width: 235,
                  height: 97,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFDB8D),
                    borderRadius: BorderRadius.circular(13),
                    border: Border.all(
                      color: const Color(0xFF351B10),
                      width: 4,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _CountSymbolButton(
                        symbol: '-',
                        onTap: () => _changeCount(-1),
                        enabled: _playerCount > _minPlayers,
                      ),
                      Container(
                        width: 78,
                        height: 59,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF6E3),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Center(
                          child: Text(
                            '$_playerCount',
                            style: const TextStyle(
                              fontFamily: 'Pixel Game',
                              fontSize: 68,
                              height: 0.71,
                              color: Color(0xFF351B10),
                            ),
                          ),
                        ),
                      ),
                      _CountSymbolButton(
                        symbol: '+',
                        onTap: () => _changeCount(1),
                        enabled: _playerCount < _maxPlayers,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // PLAYER ICONS — number of icons = _playerCount, always centered
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_playerCount, (index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: _PlayerIconBubble(
                      color: iconColors[index],
                    ),
                  );
                }),
              ),

              const SizedBox(height: 50),

              Center(
                child: SizedBox(
                  width: 140,
                  height: 45,
                  child: PrimaryButton(
                    label: 'PROCEED',
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        PlayerNamesScreen.routeName,
                        arguments: _playerCount,
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 50),

              const AlchemistsFollyLogo(),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// SUBWIDGETS
// -----------------------------------------------------------------------------

class _CountSymbolButton extends StatelessWidget {
  final String symbol;
  final VoidCallback onTap;
  final bool enabled;

  const _CountSymbolButton({
    required this.symbol,
    required this.onTap,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Opacity(
        opacity: enabled ? 1.0 : 0.4,
        child: Text(
          symbol,
          style: const TextStyle(
            fontFamily: 'Pixel Game',
            fontSize: 68,
            height: 0.71,
            color: Color(0xFF351B10),
          ),
        ),
      ),
    );
  }
}

class _PlayerIconBubble extends StatelessWidget {
  final Color color;

  const _PlayerIconBubble({
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
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
