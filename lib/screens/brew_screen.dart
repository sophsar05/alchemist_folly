// lib/screens/brew_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/game_state.dart';
import '../widgets/background_scaffold.dart';
import '../widgets/game_overlays.dart';
import '../game_logic/game_models.dart';
import 'brew_result_screen.dart';
import 'secret_reveal_screen.dart';

class BrewScreen extends StatefulWidget {
  static const routeName = '/brew';

  const BrewScreen({super.key});

  @override
  State<BrewScreen> createState() => _BrewScreenState();
}

class _BrewScreenState extends State<BrewScreen> {
  // indexes 0–3 for each row, or null if none selected yet
  int? _herbIndex;
  int? _mineralIndex;
  int? _creatureIndex;
  int? _essenceIndex;
  bool _useStardust = false;

  // Must match Ingredient.name in game_models.dart
  final herbs = const ['Moonleaf', 'Emberroot', 'Frostmint', 'Nightshade'];
  final minerals = const [
    'Crystal Dust',
    'Iron Shard',
    'Sulfur Stone',
    'Blue Ore'
  ];
  final creatures = const [
    'Dragon Scale',
    'Phoenix Feather',
    'Kraken Ink',
    'Basilisk Fang'
  ];
  final essences = const [
    'Light Essence',
    'Shadow Oil',
    'Spirit Dew',
    'Forest Blood'
  ];

  bool _canBrew(GameState game) =>
      _herbIndex != null &&
      _mineralIndex != null &&
      _creatureIndex != null &&
      _essenceIndex != null &&
      (!_useStardust || game.currentPlayer.stardust >= 1);

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameState>();
    final marketEvent = game.currentMarketEvent;

    final player = game.currentPlayer;
    // Only show boost badge for inDemand events, NOT folly
    final bool isInDemandEvent = marketEvent.type == MarketEventType.inDemand;
    final bool isFollyEvent = marketEvent.type == MarketEventType.folly;
    // Treat this as an ingredient *ID*, not name
    final String? boostedIngredientId =
        isInDemandEvent ? marketEvent.ingredientId : null;
    final String? follyIngredientId =
        isFollyEvent ? marketEvent.ingredientId : null;
    const iconColors = [
      Color.fromARGB(255, 180, 67, 67), // Player 1 - red 0xFF983333
      Color.fromARGB(255, 42, 210, 240), // Player 2 - blue
      Color(0xFFFFDB8D), // Player 3 - yellow
      Color.fromARGB(255, 148, 122, 250), // Player 4 - purple
    ];

    // Find this player's index so we can color their name
    final playerIndex = game.players.indexWhere((p) => p.id == player.id);
    final Color nameColor =
        (playerIndex >= 0 && playerIndex < iconColors.length)
            ? iconColors[playerIndex]
            : const Color(0xFFFFF6E3); // fallback

    return BackgroundScaffold(
      backgroundAsset: 'assets/images/bg_cauldron.png',
      child: SafeArea(
        child: Stack(
          children: [
            // MAIN COLUMN
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),

                      // ROUND LABEL + NUMBER
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'ROUND',
                            style: TextStyle(
                              fontFamily: 'Pixel Game',
                              fontSize: 42,
                              height: 0.71,
                              color: Color(0xFFFFF6E3),
                              letterSpacing: -0.01,
                              shadows: [
                                Shadow(blurRadius: 8.9, color: Colors.black),
                              ],
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            width: 33,
                            height: 33,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF6E3)
                                  .withValues(alpha: 0.96),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFF351B10),
                                width: 4,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '${game.currentRound}',
                              style: TextStyle(
                                fontFamily: 'Pixel Game',
                                fontSize: 20,
                                height: 0.71,
                                color: nameColor,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // GRID OF INGREDIENT TILES
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // ROW 1: CREATURES – purple
                          _IngredientRow(
                            colors: const [
                              Color(0xFF8E5CF4),
                              Color(0xFF8E5CF4),
                              Color(0xFF8E5CF4),
                              Color(0xFF8E5CF4),
                            ],
                            names: creatures,
                            selectedIndex: _creatureIndex,
                            boostedIngredientId: boostedIngredientId,
                            follyIngredientId: follyIngredientId,
                            onTapIndex: (i) {
                              setState(() {
                                _creatureIndex =
                                    (_creatureIndex == i) ? null : i;
                              });
                            },
                          ),
                          const SizedBox(height: 8),

                          // ROW 2: MINERALS – yellow
                          _IngredientRow(
                            colors: const [
                              Color(0xFFFFC037),
                              Color(0xFFFFC037),
                              Color(0xFFFFC037),
                              Color(0xFFFFC037),
                            ],
                            names: minerals,
                            selectedIndex: _mineralIndex,
                            boostedIngredientId: boostedIngredientId,
                            follyIngredientId: follyIngredientId,
                            onTapIndex: (i) {
                              setState(() {
                                _mineralIndex = (_mineralIndex == i) ? null : i;
                              });
                            },
                          ),
                          const SizedBox(height: 8),

                          // ROW 3: HERBS – cyan
                          _IngredientRow(
                            colors: const [
                              Color(0xFF009EBA),
                              Color(0xFF009EBA),
                              Color(0xFF009EBA),
                              Color(0xFF009EBA),
                            ],
                            names: herbs,
                            selectedIndex: _herbIndex,
                            boostedIngredientId: boostedIngredientId,
                            follyIngredientId: follyIngredientId,
                            onTapIndex: (i) {
                              setState(() {
                                _herbIndex = (_herbIndex == i) ? null : i;
                              });
                            },
                          ),
                          const SizedBox(height: 8),

                          // ROW 4: ESSENCES – red
                          _IngredientRow(
                            colors: const [
                              Color(0xFFE53E3E),
                              Color(0xFFE53E3E),
                              Color(0xFFE53E3E),
                              Color(0xFFE53E3E),
                            ],
                            names: essences,
                            selectedIndex: _essenceIndex,
                            boostedIngredientId: boostedIngredientId,
                            follyIngredientId: follyIngredientId,
                            onTapIndex: (i) {
                              setState(() {
                                _essenceIndex = (_essenceIndex == i) ? null : i;
                              });
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // STARDUST SCROLL BUTTON
                      _StardustScrollButton(
                        isOn: _useStardust,
                        onTap: () {
                          setState(() {
                            _useStardust = !_useStardust;
                          });
                        },
                      ),

                      const SizedBox(height: 32),

                      // BOTTOM BUTTONS: Back + Brew!
                      Padding(
                        padding: const EdgeInsets.only(bottom: 24),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Back
                            SizedBox(
                              width: 122,
                              height: 45,
                              child: GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFF0D0),
                                    borderRadius: BorderRadius.circular(11.6),
                                    border: Border.all(
                                      color: const Color(0xFF351B10),
                                      width: 3.1,
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: const Text(
                                    'Back',
                                    style: TextStyle(
                                      fontFamily: 'JMH Cthulhumbus Arcade',
                                      fontSize: 21.7,
                                      height: 0.79,
                                      color: Color(0xFF351B10),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),

                            // Brew!
                            SizedBox(
                              width: 122,
                              height: 45,
                              child: GestureDetector(
                                onTap: _canBrew(game)
                                    ? () => _onBrewPressed(context, game)
                                    : null,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: _canBrew(game)
                                        ? const Color(0xFFFFA35B)
                                        : const Color(0xFFCCCCCC),
                                    borderRadius: BorderRadius.circular(11.6),
                                    border: Border.all(
                                      color: const Color(0xFF351B10),
                                      width: 3.1,
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Brew!',
                                    style: TextStyle(
                                      fontFamily: 'JMH Cthulhumbus Arcade',
                                      fontSize: 21.7,
                                      height: 0.79,
                                      color: _canBrew(game)
                                          ? const Color(0xFF351B10)
                                          : const Color(0xFF8C8C8C),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // PAUSE + SCOREBOARD
            Positioned(
              left: 14,
              top: 16,
              child: CircleIconButton(
                backgroundColor: const Color(0xFFFE7305),
                icon: Icons.menu,
                onTap: () => showPauseDialog(context),
              ),
            ),
            Positioned(
              right: 14,
              top: 16,
              child: CircleIconButton(
                backgroundColor: const Color(0xFFFFC037),
                icon: Icons.group,
                onTap: () => showScoreboardDialog(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onBrewPressed(BuildContext context, GameState game) {
    if (!_canBrew(game)) return;

    final result = game.brew(
      herbName: herbs[_herbIndex!],
      mineralName: minerals[_mineralIndex!],
      creatureName: creatures[_creatureIndex!],
      essenceName: essences[_essenceIndex!],
      useStardust: _useStardust,
    );

    if (result.isSecretPotion) {
      Navigator.pushReplacementNamed(
        context,
        SecretRevealScreen.routeName,
      );
    } else {
      Navigator.pushNamed(
        context,
        BrewResultScreen.routeName,
        arguments: result,
      );
    }
  }
}

// -----------------------------------------------------------------------------
// INGREDIENT ROW + TILE WIDGETS
// -----------------------------------------------------------------------------

class _IngredientRow extends StatelessWidget {
  final List<Color> colors; // 4 colors for the 4 tiles
  final List<String> names; // 4 ingredient names (display)
  final int? selectedIndex;
  final String? boostedIngredientId; // from MarketEvent (inDemand)
  final String? follyIngredientId; // from MarketEvent (folly)
  final ValueChanged<int> onTapIndex;

  const _IngredientRow({
    required this.colors,
    required this.names,
    required this.selectedIndex,
    required this.boostedIngredientId,
    required this.follyIngredientId,
    required this.onTapIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (i) {
        final Ingredient? ingredient = ingredientByName(names[i]);
        final String ingredientId = ingredient?.id ?? '';
        final bool isSelected = selectedIndex == i;
        final bool showBoostBadge =
            boostedIngredientId != null && boostedIngredientId == ingredientId;
        final bool showFollyBadge =
            follyIngredientId != null && follyIngredientId == ingredientId;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _IngredientTile(
                color: colors[i],
                ingredientId: ingredientId,
                isSelected: isSelected,
                showBoostBadge: showBoostBadge,
                showFollyBadge: showFollyBadge,
                onTap: () => onTapIndex(i),
              ),
              const SizedBox(height: 4),
              SizedBox(
                width: 70,
                height: 32,
                child: Text(
                  names[i].toUpperCase(),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Pixel Game',
                    fontSize: 16,
                    height: 1.0,
                    color: Color(0xFFFFF6E3),
                    shadows: [
                      Shadow(blurRadius: 4, color: Colors.black),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _IngredientTile extends StatelessWidget {
  final Color color;
  final String ingredientId;
  final bool isSelected;
  final bool showBoostBadge;
  final bool showFollyBadge;
  final VoidCallback onTap;

  const _IngredientTile({
    required this.color,
    required this.ingredientId,
    required this.isSelected,
    required this.showBoostBadge,
    required this.showFollyBadge,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 66,
        height: 56,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Colored square background
            Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: const Color(0xFF351B10),
                  width: isSelected ? 7 : 4,
                ),
              ),
            ),

            // Ingredient icon (smaller, so color is still visible)
            if (ingredientId.isNotEmpty)
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.all(0),
                  child: Image.asset(
                    ingredientAsset(ingredientId),
                    fit: BoxFit.contain,
                  ),
                ),
              ),

            // Thumbs-up badge for in-demand ingredient
            if (showBoostBadge)
              Positioned(
                left: -8,
                top: -8,
                child: Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF6E3),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF351B10),
                      width: 3,
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.thumb_up,
                      size: 14,
                      color: Color(0xFF983333),
                    ),
                  ),
                ),
              ),

            // Skull/Warning badge for folly ingredient
            if (showFollyBadge)
              Positioned(
                left: -8,
                top: -8,
                child: Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEF4444),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF351B10),
                      width: 3,
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.warning,
                      size: 14,
                      color: Color(0xFFFFF6E3),
                    ),
                  ),
                ),
              ),

            // Orange check badge when selected
            if (isSelected)
              Positioned(
                right: -6,
                bottom: -6,
                child: Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF913B),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF351B10),
                      width: 1.9,
                    ),
                  ),
                  child: const Icon(
                    Icons.check,
                    size: 14,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// STARDUST TOGGLE SCROLL
// -----------------------------------------------------------------------------

class _StardustScrollButton extends StatelessWidget {
  final bool isOn;
  final VoidCallback onTap;

  const _StardustScrollButton({
    required this.isOn,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 191,
      height: 54,
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // outer parchment
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color:
                      isOn ? const Color(0xFF8E5CF4) : const Color(0xFFD4AF37),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            // inner parchment
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              bottom: 0,
              child: Container(
                margin: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(11)),
                  color: Color(0xFF202253),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Stardust icon
                      SizedBox(
                        width: 50,
                        height: 50,
                        child: ClipRect(
                          child: OverflowBox(
                            maxWidth: 60,
                            maxHeight: 60,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Image.asset(
                                'assets/images/ingredients/special/stardust.png',
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Stardust text
                      Text(
                        'STARDUST',
                        style: TextStyle(
                          fontFamily: 'Pixel Game',
                          fontSize: 26,
                          height: 0.85,
                          letterSpacing: 0.01,
                          color: isOn
                              ? const Color(0xFF8E5CF4)
                              : const Color(0xFFD4AF37),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // check badge when selected
            if (isOn)
              Positioned(
                right: -6,
                bottom: -6,
                child: Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF913B),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF351B10),
                      width: 1.9,
                    ),
                  ),
                  child: const Icon(
                    Icons.check,
                    size: 14,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
