import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/game_state.dart';
import '../widgets/background_scaffold.dart';
import '../widgets/primary_button.dart';
import 'main_menu_screen.dart';

class SecretRevealScreen extends StatefulWidget {
  static const routeName = '/secret-reveal';

  const SecretRevealScreen({super.key});

  @override
  State<SecretRevealScreen> createState() => _SecretRevealScreenState();
}

class _SecretRevealScreenState extends State<SecretRevealScreen> {
  int _currentPage = 0;
  final PageController _pageController = PageController();

  void _nextPage() {
    if (_currentPage < 2) {
      setState(() {
        _currentPage++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      context.read<GameState>().reset();
      Navigator.pushNamedAndRemoveUntil(
        context,
        MainMenuScreen.routeName,
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundScaffold(
      backgroundAsset: 'assets/images/bg_secret.png',
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Column(
            children: [
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildAnnouncementPage(),
                    _buildScoreboardPage(),
                    _buildWinnerPage(),
                  ],
                ),
              ),
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: PrimaryButton(
                    label: _currentPage == 2 ? 'End Game' : 'Next',
                    onPressed: _nextPage,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnnouncementPage() {
    final game = context.watch<GameState>();
    final secret = game.secretPotion;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'THE SECRET POTION\nHAS BEEN FOUND!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'JMH Cthulhumbus Arcade',
            fontSize: 40,
            height: 1.2,
            color: Color(0xFFFFF6E3),
            shadows: [
              Shadow(
                blurRadius: 12.0,
                color: Colors.black,
              ),
            ],
          ),
        ),
        if (secret != null) ...[
          const SizedBox(height: 32),
          Text(
            secret.name.toUpperCase(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Pixel Game',
              fontSize: 32,
              height: 1.3,
              color: Color(0xFFFFDB8D),
              shadows: [
                Shadow(
                  blurRadius: 8.0,
                  color: Colors.black,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: 150,
            height: 150,
            child: Image.asset(
              'assets/images/potions/${secret.id}.png',
              fit: BoxFit.contain,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildScoreboardPage() {
    final game = context.watch<GameState>();
    final players = game.players;

    // winner already determined (secret potion discoverer)
    final winnerId = game.winner?.id;

    const iconColors = [
      Color.fromARGB(255, 180, 67, 67),
      Color.fromARGB(255, 42, 210, 240),
      Color(0xFFFFDB8D),
      Color.fromARGB(255, 148, 122, 250),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxHeight = (constraints.maxHeight * 0.7).clamp(200.0, 400.0);

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'FINAL STANDINGS',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'JMH Cthulhumbus Arcade',
                fontSize: 32,
                height: 1.2,
                color: Color(0xFFFFF6E3),
                shadows: [
                  Shadow(
                    blurRadius: 10.0,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              constraints: BoxConstraints(
                maxWidth: 350,
                maxHeight: maxHeight,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF6E3).withValues(alpha: 0.95),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFF351B10),
                  width: 4,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    offset: const Offset(4, 4),
                    blurRadius: 8,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ...players.asMap().entries.map((entry) {
                      final index = entry.key;
                      final player = entry.value;
                      final isWinner = player.id == winnerId;
                      final playerColor = (index < iconColors.length)
                          ? iconColors[index]
                          : const Color(0xFF351B10);

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 28,
                              child: Text(
                                '${index + 1}.',
                                style: const TextStyle(
                                  fontFamily: 'Pixel Game',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF351B10),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: playerColor,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFF351B10),
                                  width: 2,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                player.name,
                                style: TextStyle(
                                  fontFamily: 'Pixel Game',
                                  fontSize: 16,
                                  fontWeight: isWinner
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: isWinner
                                      ? const Color(0xFF8B4513)
                                      : const Color(0xFF351B10),
                                ),
                              ),
                            ),
                            Text(
                              '${player.prestige} pts',
                              style: TextStyle(
                                fontFamily: 'Pixel Game',
                                fontSize: 16,
                                fontWeight: isWinner
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: isWinner
                                    ? const Color(0xFF8B4513)
                                    : const Color(0xFF351B10),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildWinnerPage() {
    final game = context.watch<GameState>();
    final winner = game.winner;
    final secret = game.secretPotion;

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxHeight = (constraints.maxHeight * 0.8).clamp(250.0, 450.0);

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              constraints: BoxConstraints(
                maxWidth: 350,
                maxHeight: maxHeight,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFFFDB8D),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: const Color(0xFFFFDB8D),
                  width: 5,
                ),
              ),
              child: Container(
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF6E3),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: const Color(0xFF351B10),
                    width: 4,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFFE5A8).withValues(alpha: 0.9),
                      blurRadius: 0.6,
                      spreadRadius: 1.2,
                    ),
                    BoxShadow(
                      color: const Color(0xFFCC9A4B).withValues(alpha: 0.5),
                      blurRadius: 0.6,
                      spreadRadius: 0.4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(24),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'VICTORY!',
                        style: TextStyle(
                          fontFamily: 'JMH Cthulhumbus Arcade',
                          fontSize: 32,
                          height: 1.2,
                          color: Color(0xFF8B4513),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (winner != null)
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: const TextStyle(
                              fontFamily: 'Pixel Game',
                              fontSize: 20,
                              height: 1.3,
                              color: Color(0xFF351B10),
                            ),
                            children: [
                              TextSpan(
                                text: winner.name.toUpperCase(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                  color: Color(0xFF8B4513),
                                ),
                              ),
                              const TextSpan(text: '\nwins!\n\n'),
                              if (secret != null)
                                TextSpan(
                                  text:
                                      'By discovering the secret ${secret.name}, they have proven themselves the greatest alchemist!',
                                  style: const TextStyle(fontSize: 16),
                                ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
