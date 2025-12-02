// lib/screens/black_market_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/game_state.dart';
import '../widgets/background_scaffold.dart';
import '../widgets/game_overlays.dart';
import '../game_logic/game_models.dart';

class BlackMarketScreen extends StatefulWidget {
  static const routeName = '/black-market';

  const BlackMarketScreen({super.key});

  @override
  State<BlackMarketScreen> createState() => _BlackMarketScreenState();
}

class _BlackMarketScreenState extends State<BlackMarketScreen> {
  // Maps ingredient ID to selection order (1, 2, 3, etc.)
  final Map<String, int> _selectedIngredients = {};
  int _nextSelectionOrder = 1;

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

  int get _totalSelectedCount => _selectedIngredients.length;

  bool get _canUseFence => _totalSelectedCount == 2;

  bool get _canUseSmuggler => _totalSelectedCount == 3;

  void _toggleIngredient(String ingredientId) {
    setState(() {
      if (_selectedIngredients.containsKey(ingredientId)) {
        // Remove this ingredient and reorder the rest
        final removedOrder = _selectedIngredients[ingredientId]!;
        _selectedIngredients.remove(ingredientId);

        // Decrement order for all ingredients that came after this one
        _selectedIngredients.forEach((key, order) {
          if (order > removedOrder) {
            _selectedIngredients[key] = order - 1;
          }
        });

        _nextSelectionOrder--;
      } else {
        // Add new ingredient with next order number
        _selectedIngredients[ingredientId] = _nextSelectionOrder;
        _nextSelectionOrder++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameState>();

    return BackgroundScaffold(
      backgroundAsset: 'assets/images/bg_market.png',
      child: SafeArea(
        child: Stack(
          children: [
            // MAIN COLUMN
            Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 80, 16, 16),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 380),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A0F1F),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFF8E5CF4),
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.5),
                          offset: const Offset(3, 3),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Black Market',
                          style: TextStyle(
                            fontFamily: 'JMH Cthulhumbus Arcade',
                            fontSize: 30,
                            color: Color(0xFF8E5CF4),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // GRID OF INGREDIENT TILES
                        Flexible(
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                // ROW 1: CREATURES – purple
                                _buildCategorySection(
                                  'Creature Parts',
                                  creatures,
                                  const Color(0xFF8E5CF4),
                                ),
                                const SizedBox(height: 6),

                                // ROW 2: MINERALS – yellow
                                _buildCategorySection(
                                  'Minerals',
                                  minerals,
                                  const Color(0xFFFFC037),
                                ),
                                const SizedBox(height: 6),

                                // ROW 3: HERBS – cyan
                                _buildCategorySection(
                                  'Herbs',
                                  herbs,
                                  const Color(0xFF009EBA),
                                ),
                                const SizedBox(height: 6),

                                // ROW 4: ESSENCES – red
                                _buildCategorySection(
                                  'Essences',
                                  essences,
                                  const Color(0xFFE53E3E),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),

                        // ACTION BUTTONS
                        _buildActionButtons(context, game),

                        const SizedBox(height: 60),

                        // BACK BUTTON
                        SizedBox(
                          width: 140,
                          height: 45,
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFF3D2B3D),
                                borderRadius: BorderRadius.circular(11.6),
                                border: Border.all(
                                  color: const Color(0xFF8E5CF4),
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
                                  color: Color(0xFFE2E8F0),
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),
                      ],
                    ),
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

  Widget _buildCategorySection(String title, List<String> names, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(4, (i) {
            final Ingredient? ingredient = ingredientByName(names[i]);
            final String ingredientId = ingredient?.id ?? '';
            final int count = _selectedIngredients[ingredientId] ?? 0;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _IngredientTile(
                    color: color,
                    ingredientId: ingredientId,
                    count: count,
                    onTap: () => _toggleIngredient(ingredientId),
                    onIncrement: () => _toggleIngredient(ingredientId),
                    onDecrement: () => _toggleIngredient(ingredientId),
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    width: 66,
                    height: 32,
                    child: Text(
                      names[i].toUpperCase(),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Pixel Game',
                        fontSize: 15,
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
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, GameState game) {
    return Column(
      children: [
        // THE FENCE
        _BlackMarketActionButton(
          label: 'The Fence',
          description: 'Trade 2 different ingredients for 1 of your choice',
          enabled: _canUseFence,
          color: const Color(0xFF6B4423),
          onPressed: () => _showFenceDialog(context, game),
        ),

        const SizedBox(height: 8),

        // THE SMUGGLER
        _BlackMarketActionButton(
          label: 'The Smuggler',
          description: 'Trade 3 different ingredients for 1 Stardust',
          enabled: _canUseSmuggler,
          color: const Color(0xFF8E5CF4),
          onPressed: () => _useSmugglerTrade(context, game),
        ),
      ],
    );
  }

  void _showFenceDialog(BuildContext context, GameState game) {
    if (!_canUseFence) return;

    showDialog(
      context: context,
      builder: (ctx) {
        String? selectedIngredientId;

        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return Center(
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: 320,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A1B2A).withValues(alpha: 0.95),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFF6B4423),
                      width: 3,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'The Fence',
                        style: TextStyle(
                          fontFamily: 'JMH Cthulhumbus Arcade',
                          fontSize: 28,
                          color: Color(0xFFE2E8F0),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Choose which ingredient you want to receive:',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Pixel Game',
                          fontSize: 20,
                          color: Color(0xFFE2E8F0),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Ingredient selection dropdown
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF6E3),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: const Color(0xFF351B10),
                            width: 2,
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedIngredientId,
                            hint: const Text(
                              'Select ingredient...',
                              style: TextStyle(
                                fontFamily: 'Pixel Game',
                                fontSize: 14,
                                color: Color(0xFF666666),
                              ),
                            ),
                            isExpanded: true,
                            items: kIngredients.map((ingredient) {
                              return DropdownMenuItem<String>(
                                value: ingredient.id,
                                child: Text(
                                  ingredient.name,
                                  style: const TextStyle(
                                    fontFamily: 'Pixel Game',
                                    fontSize: 18,
                                    color: Color(0xFF351B10),
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setDialogState(() {
                                selectedIngredientId = value;
                              });
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () => Navigator.of(ctx).pop(),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                fontFamily: 'Pixel Game',
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: selectedIngredientId != null
                                ? () {
                                    Navigator.of(ctx).pop();
                                    _completeFenceTrade(
                                        context, game, selectedIngredientId!);
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6B4423),
                              foregroundColor: Colors.white,
                            ),
                            child: const Text(
                              'Trade',
                              style: TextStyle(
                                fontFamily: 'Pixel Game',
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _completeFenceTrade(
      BuildContext context, GameState game, String receivedIngredientId) {
    final error =
        game.useFenceTrade(_selectedIngredients, receivedIngredientId);

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
    } else {
      setState(() {
        _selectedIngredients.clear();
        _nextSelectionOrder = 1;
      });
      _showTradeSuccessDialog(
        context,
        'The Fence',
        'You successfully traded 2 ingredients for ${ingredientById(receivedIngredientId)?.name ?? "an ingredient"}!',
      );
    }
  }

  void _useSmugglerTrade(BuildContext context, GameState game) {
    if (!_canUseSmuggler) return;

    final error = game.useSmugglerTrade(_selectedIngredients);

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
    } else {
      setState(() {
        _selectedIngredients.clear();
        _nextSelectionOrder = 1;
      });
      _showTradeSuccessDialog(
        context,
        'The Smuggler',
        'You successfully traded 3 different ingredients for 1 Stardust!\n\nThe shadows whisper their approval...',
      );
    }
  }

  void _showTradeSuccessDialog(
      BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (ctx) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: 300,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF2A1B2A).withValues(alpha: 0.95),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFF8E5CF4),
                  width: 3,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'JMH Cthulhumbus Arcade',
                      fontSize: 24,
                      color: Color(0xFF4ADE80),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Merchant Copy',
                      fontSize: 22,
                      color: Color(0xFFE2E8F0),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8E5CF4),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text(
                      'Excellent',
                      style: TextStyle(
                        fontFamily: 'Pixel Game',
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// -----------------------------------------------------------------------------
// INGREDIENT TILE WIDGET
// -----------------------------------------------------------------------------

class _IngredientTile extends StatelessWidget {
  final Color color;
  final String ingredientId;
  final int count;
  final VoidCallback onTap;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const _IngredientTile({
    required this.color,
    required this.ingredientId,
    required this.count,
    required this.onTap,
    required this.onIncrement,
    required this.onDecrement,
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
                  width: count > 0 ? 5 : 4,
                ),
              ),
            ),

            // Ingredient icon
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

            // Count badge (selection order indicator)
            if (count > 0)
              Positioned(
                right: -6,
                top: -6,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: const Color(0xFF8E5CF4),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF351B10),
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '$count',
                      style: const TextStyle(
                        fontFamily: 'Pixel Game',
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
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

// -----------------------------------------------------------------------------
// BLACK MARKET ACTION BUTTON WIDGET
// -----------------------------------------------------------------------------

class _BlackMarketActionButton extends StatelessWidget {
  final String label;
  final String description;
  final bool enabled;
  final Color color;
  final VoidCallback onPressed;

  const _BlackMarketActionButton({
    required this.label,
    required this.description,
    required this.enabled,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onPressed : null,
      child: Container(
        width: 320,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: enabled
              ? color.withValues(alpha: 0.3)
              : Colors.grey.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: enabled ? color : Colors.grey,
            width: 3,
          ),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                fontFamily: 'JMH Cthulhumbus Arcade',
                fontSize: 24,
                color: enabled ? const Color(0xFFE2E8F0) : Colors.grey,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Pixel Game',
                fontSize: 14,
                color: enabled ? const Color(0xFFE2E8F0) : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
