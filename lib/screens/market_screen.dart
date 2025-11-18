import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_state.dart';
import '../game_logic/game_models.dart';
import '../widgets/background_scaffold.dart';
import '../widgets/primary_button.dart';
import '../widgets/secondary_button.dart';
import '../widgets/game_overlays.dart';

class MarketScreen extends StatefulWidget {
  static const routeName = '/market';

  const MarketScreen({super.key});

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  int pageIndex = 0;
  final Map<String, int> _shoppingCart = {};
  final Map<String, int> _tradingCart = {};

  static const Map<String, String> _ingredientDescriptions = {
    // herbs
    'moonleaf': 'calming, soothing plant used in sleep and vision potions',
    'emberroot': 'fiery root that adds warmth or energy',
    'frostmint': 'icy herb that chills or preserves',
    'nightshade': 'toxic but powerful for dark brews',
    // minerals
    'crystal_dust': 'amplifies other ingredients',
    'iron_shard': 'adds strength or durability',
    'sulfur_stone': 'unstable, used for explosive or reactive effects',
    'blue_ore': 'mystical mineral used in dream and illusion potions',
    // creature Parts
    'dragon_scale': 'gives power and protection',
    'phoenix_feather': 'healing and renewal properties',
    'kraken_ink': 'for concealment or invisibility',
    'basilisk_fang': 'venomous and powerful',
    // essences
    'light_essence': 'cleanses and restores',
    'shadow_oil': 'hides or distorts things',
    'spirit_dew': 'connects to spirits and memory',
    'forest_blood': 'strengthens effects, wild energy',
  };

  Color _getCategoryBackgroundColor(IngredientCategory category) {
    switch (category) {
      case IngredientCategory.herb:
        return const Color(0xFF009EBA);
      case IngredientCategory.mineral:
        return const Color(0xFFFFC037);
      case IngredientCategory.creature:
        return const Color(0xFF8E5CF4);
      case IngredientCategory.essence:
        return const Color(0xFFE53E3E);
    }
  }

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameState>();
    final marketEvent = game.currentMarketEvent;

    final pages = [
      _buildGrandBazaarPage(context, game),
      _buildBlackMarketPage(context, game),
      _buildMarketStatusPage(marketEvent),
    ];

    return BackgroundScaffold(
      backgroundAsset: 'assets/images/bg_market.png',
      child: SafeArea(
        child: Stack(
          children: [
            // main content
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 80, 16, 16),
              child: Column(
                children: [
                  Expanded(
                    child: pages[pageIndex],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (pageIndex > 0)
                        SecondaryButton(
                          label: 'Prev',
                          height: 40,
                          width: 80,
                          onPressed: () {
                            setState(() {
                              pageIndex--;
                            });
                          },
                        )
                      else
                        const SizedBox(width: 80),
                      SecondaryButton(
                        label: 'Close',
                        height: 40,
                        width: 90,
                        onPressed: () => Navigator.pop(context),
                      ),
                      if (pageIndex < pages.length - 1)
                        SecondaryButton(
                          label: 'Next',
                          height: 40,
                          width: 80,
                          onPressed: () {
                            setState(() {
                              pageIndex++;
                            });
                          },
                        )
                      else
                        const SizedBox(width: 80),
                    ],
                  ),
                ],
              ),
            ),

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

  Widget _buildGrandBazaarPage(BuildContext context, GameState game) {
    final totalCost =
        _shoppingCart.values.fold<int>(0, (sum, count) => sum + (count * 2));
    final canAfford = game.currentPlayer.prestige >= totalCost;
    final hasAP = game.currentAP >= 1;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3D6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF9E7A43),
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            offset: const Offset(3, 3),
            blurRadius: 6,
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text(
            'Grand Bazaar',
            style:
                TextStyle(fontFamily: 'JMH Cthulhumbus Arcade', fontSize: 30),
          ),

          const Text(
            'Shop for Goods (Cost: 1 AP)',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Pixel Game',
              fontSize: 14,
            ),
          ),

          Text(
            'Current PP: ${game.currentPlayer.prestige} | AP: ${game.currentAP}',
            style: const TextStyle(
              fontFamily: 'Pixel Game',
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          // ingredient list
          Expanded(
            child: ListView(
              children: [
                ...IngredientCategory.values.map((category) {
                  final categoryIngredients = kIngredients
                      .where((i) => i.category == category)
                      .toList();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getCategoryName(category),
                        style: const TextStyle(
                          fontFamily: 'Pixel Game',
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...categoryIngredients.map((ingredient) =>
                          _buildIngredientRow(
                              ingredient, game.currentMarketEvent)),
                      const SizedBox(height: 12),
                    ],
                  );
                }),
              ],
            ),
          ),
          const Divider(color: Color(0xFF9E7A43)),
          Text(
            'Total Cost: $totalCost PP',
            style: TextStyle(
              fontFamily: 'Pixel Game',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: canAfford ? Colors.green : Colors.red,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              PrimaryButton(
                label: 'Clear Cart',
                onPressed: () {
                  setState(() {
                    _shoppingCart.clear();
                  });
                },
              ),
              PrimaryButton(
                label: 'Purchase',
                onPressed: (canAfford && hasAP)
                    ? () => _makePurchase(context, game)
                    : () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIngredientRow(Ingredient ingredient, MarketEvent marketEvent) {
    final count = _shoppingCart[ingredient.id] ?? 0;
    final description =
        _ingredientDescriptions[ingredient.id] ?? 'No description available';
    final backgroundColor = _getCategoryBackgroundColor(ingredient.category);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Container(
        height: 90,
        decoration: BoxDecoration(
          color: backgroundColor.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: backgroundColor,
            width: 2,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                // ingredient name + description
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          ingredient.name.toUpperCase(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: 'Pixel Game',
                            fontSize: 25,
                            height: 1.0,
                            color: Color(0xFF351B10),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (_getMarketStatusIcon(ingredient.id, marketEvent) !=
                          null) ...[
                        const SizedBox(width: 8),
                        _getMarketStatusIcon(ingredient.id, marketEvent)!,
                      ],
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    maxLines: 2,
                    style: const TextStyle(
                      fontFamily: 'Merchant Copy',
                      fontSize: 18,
                      height: 1.1,
                      color: Color(0xFF351B10),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 6),
            // price
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  '2 PP',
                  style: const TextStyle(
                    fontFamily: 'Pixel Game',
                    fontSize: 14,
                    color: Color(0xFFFE7305),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: count > 0
                          ? () {
                              setState(() {
                                if (count == 1) {
                                  _shoppingCart.remove(ingredient.id);
                                } else {
                                  _shoppingCart[ingredient.id] = count - 1;
                                }
                              });
                            }
                          : null,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: count > 0 ? backgroundColor : Colors.grey[300],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Icon(
                          Icons.remove,
                          size: 14,
                          color: count > 0 ? Colors.white : Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    SizedBox(
                      width: 20,
                      child: Text(
                        '$count',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: 'Pixel Game',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF351B10),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _shoppingCart[ingredient.id] = count + 1;
                        });
                      },
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: backgroundColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Icon(
                          Icons.add,
                          size: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getCategoryName(IngredientCategory category) {
    return switch (category) {
      IngredientCategory.herb => 'Herbs',
      IngredientCategory.mineral => 'Minerals',
      IngredientCategory.creature => 'Creature Parts',
      IngredientCategory.essence => 'Essences',
    };
  }

  /// Returns the appropriate icon for an ingredient based on market status
  Widget? _getMarketStatusIcon(String ingredientId, MarketEvent marketEvent) {
    if (marketEvent.ingredientId != ingredientId) return null;

    switch (marketEvent.type) {
      case MarketEventType.inDemand:
        return Image.asset(
          'assets/images/demand-vector.png',
          width: 15,
          height: 15,
          fit: BoxFit.contain,
        );
      case MarketEventType.surplus:
        return Image.asset(
          'assets/images/surplus-vector.png',
          width: 15,
          height: 15,
          fit: BoxFit.contain,
        );
      default:
        return null;
    }
  }

  void _makePurchase(BuildContext context, GameState game) {
    final error = game.shopForGoods(_shoppingCart);
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
    } else {
      final itemCount =
          _shoppingCart.values.fold<int>(0, (sum, count) => sum + count);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Successfully purchased $itemCount ingredients!')),
      );
      setState(() {
        _shoppingCart.clear();
      });
    }
  }

  Widget _buildBlackMarketPage(BuildContext context, GameState game) {
    final totalIngredients =
        _tradingCart.values.fold<int>(0, (sum, count) => sum + count);
    final hasAP = game.currentAP >= 1;
    final hasIngredients = totalIngredients > 0;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2A1B2A).withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF8E5CF4),
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            offset: const Offset(3, 3),
            blurRadius: 8,
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text(
            'Black Market',
            style: TextStyle(
              fontFamily: 'JMH Cthulhumbus Arcade',
              fontSize: 30,
              color: Color(0xFFE2E8F0),
            ),
          ),
          const Text(
            'Trade Ingredients for Stardust (Cost: 1 AP)',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Pixel Game',
              fontSize: 14,
              color: Color(0xFFE2E8F0),
            ),
          ),
          Text(
            'Current Stardust: ${game.currentPlayer.stardust} | AP: ${game.currentAP}',
            style: const TextStyle(
              fontFamily: 'Pixel Game',
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFFC037),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: [
                ...IngredientCategory.values.map((category) {
                  final categoryIngredients = kIngredients
                      .where((i) => i.category == category)
                      .toList();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getCategoryName(category),
                        style: const TextStyle(
                          fontFamily: 'Pixel Game',
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFE2E8F0),
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...categoryIngredients.map((ingredient) =>
                          _buildTradingIngredientRow(
                              ingredient, game.currentMarketEvent)),
                      const SizedBox(height: 12),
                    ],
                  );
                }),
              ],
            ),
          ),
          const Divider(color: Color(0xFF8E5CF4)),
          Text(
            'Total Stardust Gained: $totalIngredients',
            style: const TextStyle(
              fontFamily: 'Pixel Game',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFFC037),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              PrimaryButton(
                label: 'Clear Cart',
                onPressed: () {
                  setState(() {
                    _tradingCart.clear();
                  });
                },
              ),
              PrimaryButton(
                label: 'Trade',
                onPressed: (hasIngredients && hasAP)
                    ? () => _makeTrade(context, game)
                    : () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTradingIngredientRow(
      Ingredient ingredient, MarketEvent marketEvent) {
    final count = _tradingCart[ingredient.id] ?? 0;
    final description =
        _ingredientDescriptions[ingredient.id] ?? 'No description available';
    final backgroundColor = _getCategoryBackgroundColor(ingredient.category);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Container(
        height: 90,
        decoration: BoxDecoration(
          color: backgroundColor.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: backgroundColor,
            width: 2,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                // ingredient name + description
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          ingredient.name.toUpperCase(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: 'Pixel Game',
                            fontSize: 25,
                            height: 0.9,
                            color: Color(0xFFE2E8F0),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (_getMarketStatusIcon(ingredient.id, marketEvent) !=
                          null) ...[
                        const SizedBox(width: 8),
                        _getMarketStatusIcon(ingredient.id, marketEvent)!,
                      ],
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    maxLines: 2,
                    style: const TextStyle(
                      fontFamily: 'Merchant Copy',
                      fontSize: 18,
                      height: 1.1,
                      color: Color(0xFFE2E8F0),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  '1 ✦',
                  style: TextStyle(
                    fontFamily: 'Pixel Game',
                    fontSize: 14,
                    color: Color(0xFFFFC037),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: count > 0
                          ? () {
                              setState(() {
                                if (count == 1) {
                                  _tradingCart.remove(ingredient.id);
                                } else {
                                  _tradingCart[ingredient.id] = count - 1;
                                }
                              });
                            }
                          : null,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: count > 0 ? backgroundColor : Colors.grey[600],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Icon(
                          Icons.remove,
                          size: 14,
                          color: count > 0 ? Colors.white : Colors.grey[400],
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    SizedBox(
                      width: 20,
                      child: Text(
                        '$count',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: 'Pixel Game',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFE2E8F0),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _tradingCart[ingredient.id] = count + 1;
                        });
                      },
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: backgroundColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Icon(
                          Icons.add,
                          size: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _makeTrade(BuildContext context, GameState game) {
    final error = game.tradeForStardust(_tradingCart);
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
    } else {
      final stardustGained =
          _tradingCart.values.fold<int>(0, (sum, count) => sum + count);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Successfully traded for $stardustGained Stardust!')),
      );
      setState(() {
        _tradingCart.clear();
      });
    }
  }

  Widget _buildMarketStatusPage(MarketEvent marketEvent) {
    return Center(
      child: Container(
        height: 300,
        width: double.infinity,
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Market Status :',
                style: TextStyle(
                  fontFamily: 'Pixel Game',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF351B10),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                marketEvent.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'JMH Cthulhumbus Arcade',
                  fontSize: 22,
                  height: 1.2,
                  color: Color(0xFF8B4513),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                marketEvent.description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Pixel Game',
                  fontSize: 18,
                  height: 1.3,
                  color: Color(0xFF351B10),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
