import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/background_scaffold.dart';
import '../widgets/primary_button.dart';
import '../providers/game_state.dart';
import '../game_logic/game_models.dart';

class PotionListScreen extends StatelessWidget {
  static const routeName = '/potion-list';

  const PotionListScreen({super.key});

  Color _colorForCategory(IngredientCategory category) {
    switch (category) {
      case IngredientCategory.herb:
        return const Color(0xFF009EBA); // blue
      case IngredientCategory.mineral:
        return const Color(0xFFFE7305); // orange
      case IngredientCategory.creature:
        return const Color(0xFFD9408F); // pink/red
      case IngredientCategory.essence:
        return const Color(0xFF8E5CF4); // purple
    }
  }

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameState>();
    final brewedIds = game.brewedPotionIds;

    return BackgroundScaffold(
      backgroundAsset: 'assets/images/bg_potionlist.png',
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            children: [
              // TOP: ROUND badge
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'ROUND ',
                    style: const TextStyle(
                      fontFamily: 'Pixel Game',
                      fontSize: 40,
                      color: Color(0xFFFFF6E3),
                      shadows: [
                        Shadow(
                          blurRadius: 8.9,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    width: 33,
                    height: 33,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF6E3).withValues(alpha: 0.96),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF351B10),
                        width: 4,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${game.currentRound}',
                      style: const TextStyle(
                        fontFamily: 'Pixel Game',
                        fontSize: 20,
                        color: Color(0xFFFFC037),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // CENTER: parchment with list
              Expanded(
                child: Center(
                  child: Container(
                    width: 350, // close to your Figma width
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFDB8D),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFFFFDB8D),
                        width: 12,
                      ),
                    ),
                    child: Container(
                      margin: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF6E3),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFF351B10),
                          width: 4,
                        ),
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          Text(
                            'List of Potions',
                            style: const TextStyle(
                              fontFamily: 'JMH Cthulhumbus Arcade',
                              fontSize: 30,
                              color: Color(0xFF351B10),
                              fontWeight: FontWeight.w900, // ← fake bold
                            ),
                          ),
                          const SizedBox(height: 16),

                          // scrollable list
                          Expanded(
                            child: ListView.separated(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 14),
                              itemCount: kPotions.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 10),
                              itemBuilder: (context, index) {
                                final potion = kPotions[index];
                                final isBrewed =
                                    brewedIds.contains(potion.id);

                                return _PotionCard(
                                  potion: potion,
                                  isBrewed: isBrewed,
                                  colorForCategory: _colorForCategory,
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // BOTTOM: back scroll button
              PrimaryButton(
                label: 'Back',
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PotionCard extends StatelessWidget {
  final Potion potion;
  final bool isBrewed;
  final Color Function(IngredientCategory) colorForCategory;

  const _PotionCard({
    required this.potion,
    required this.isBrewed,
    required this.colorForCategory,
  });

  @override
  Widget build(BuildContext context) {
    final herb = ingredientById(potion.herbId);
    final mineral = ingredientById(potion.mineralId);
    final creature = ingredientById(potion.creatureId);
    final essence = ingredientById(potion.essenceId);

    final baseTextColor = isBrewed
        ? const Color(0xFFA7A7A7)
        : const Color(0xFF351B10);

    final borderColor = isBrewed
        ? const Color(0xFFCCCCCC)
        : const Color(0xFFFFDB8D);

    final ppColor = isBrewed
        ? const Color(0xFFA7A7A7)
        : const Color(0xFFFE7305);

    return Container(
      height: 72, // tighter like your Figma card height
      decoration: BoxDecoration(
        color: const Color(0xFFFFF6E3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: borderColor,
          width: 2.1,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // small potion icon
          SizedBox(
            width: 50,
            height: 50,
            child: Image.asset(
              'assets/images/potion.png',
              fit: BoxFit.contain,
            ),
          ),

          const SizedBox(width: 8),

          // text block
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // potion name
                Text(
                  potion.name.toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Pixel Game',
                    fontSize: 20,
                    height: 0.7,
                    letterSpacing: -0.01,
                    color: baseTextColor,
                    decoration: isBrewed
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
                const SizedBox(height: 4),
                // colored ingredient line
                if (herb != null &&
                    mineral != null &&
                    creature != null &&
                    essence != null)
                  RichText(
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      style: TextStyle(
                        fontFamily: 'Merchant Copy',
                        fontSize: 18,
                        height: 0.8,
                        letterSpacing: -0.01,
                        color: baseTextColor,
                        decoration: isBrewed
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                      children: [
                        TextSpan(
                          text: herb.name,
                          style: TextStyle(
                            color: isBrewed
                                ? baseTextColor
                                : colorForCategory(herb.category),
                          ),
                        ),
                        const TextSpan(text: ', '),
                        TextSpan(
                          text: mineral.name,
                          style: TextStyle(
                            color: isBrewed
                                ? baseTextColor
                                : colorForCategory(mineral.category),
                          ),
                        ),
                        const TextSpan(text: ', '),
                        TextSpan(
                          text: creature.name,
                          style: TextStyle(
                            color: isBrewed
                                ? baseTextColor
                                : colorForCategory(creature.category),
                          ),
                        ),
                        const TextSpan(text: ', '),
                        TextSpan(
                          text: essence.name,
                          style: TextStyle(
                            color: isBrewed
                                ? baseTextColor
                                : colorForCategory(essence.category),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(width: 6),

          // PP label
          Text(
            '+${potion.points} PP',
            textAlign: TextAlign.right,
            style: TextStyle(
              fontFamily: 'Pixel Game',
              fontSize: 16,
              height: 1.0,
              letterSpacing: -0.01,
              color: ppColor,
              decoration: isBrewed
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
            ),
          ),
        ],
      ),
    );
  }
}
