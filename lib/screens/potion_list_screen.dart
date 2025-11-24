// lib/screens/potion_list_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/background_scaffold.dart';
import '../widgets/primary_button.dart';
import '../providers/game_state.dart';
import '../game_logic/game_models.dart';

class PotionListScreen extends StatefulWidget {
  static const routeName = '/potion-list';

  const PotionListScreen({super.key});

  @override
  State<PotionListScreen> createState() => _PotionListScreenState();
}

class _PotionListScreenState extends State<PotionListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';
  Potion? _selectedPotion; // for overlay
  

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Color _colorForCategory(IngredientCategory category) {
    switch (category) {
      case IngredientCategory.herb: // Obsidian Caves – lavender/purple
        return const Color(0xFF7F5FFF);
      case IngredientCategory.mineral: // Sunstone Mine – orange/yellow
        return const Color(0xFFFE7305);
      case IngredientCategory.creature: // Azure Forest – blue
        return const Color(0xFF009EBA);
      case IngredientCategory.essence: // Crimson Volcano – reddish
        return const Color(0xFFD9408F);
    }
  }

  List<Potion> _filteredPotions(GameState game) {
    final q = _searchText.trim().toLowerCase();
    if (q.isEmpty) return kPotions;

    return kPotions.where((p) {
      final nameMatch = p.name.toLowerCase().contains(q);

      final herb = ingredientById(p.herbId);
      final mineral = ingredientById(p.mineralId);
      final creature = ingredientById(p.creatureId);
      final essence = ingredientById(p.essenceId);

      final ingredientMatch = [
        herb?.name,
        mineral?.name,
        creature?.name,
        essence?.name,
      ].whereType<String>().any(
            (n) => n.toLowerCase().contains(q),
          );

      return nameMatch || ingredientMatch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameState>();
    final brewedIds = game.brewedPotionIds;
    final potions = _filteredPotions(game);

    return BackgroundScaffold(
      backgroundAsset: 'assets/images/bg_potionlist.png',
      child: SafeArea(
        child: Stack(
          children: [
            // MAIN CONTENT
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                children: [
               
                  const SizedBox(height: 20),

                  // PARCHMENT PANEL
                  Expanded(
                    child: Center(
                      child: Container(
                        width: 350,
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
                              const SizedBox(height: 12),
                              const Text(
                                'List of Potions',
                                style: TextStyle(
                                  fontFamily: 'JMH Cthulhumbus Arcade',
                                  fontSize: 30,
                                  color: Color(0xFF351B10),
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 12),

                              // SEARCH BAR
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16),
                                child: Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFFFFF),
                                    borderRadius: BorderRadius.circular(24),
                                    border: Border.all(
                                      color: const Color(0xFFFFDB8D),
                                      width: 2,
                                    ),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.search,
                                        size: 20,
                                        color: Color(0xFF351B10),
                                      ),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: TextField(
                                          controller: _searchController,
                                          onChanged: (value) {
                                            setState(() {
                                              _searchText = value;
                                            });
                                          },
                                          style: const TextStyle(
                                            fontFamily: 'Merchant Copy',
                                            fontSize: 16,
                                            color: Color(0xFF351B10),
                                          ),
                                          decoration: const InputDecoration(
                                            isDense: true,
                                            border: InputBorder.none,
                                            hintText:
                                                'Search by ingredient, potion...',
                                            hintStyle: TextStyle(
                                              fontFamily: 'Merchant Copy',
                                              fontSize: 16,
                                              color: Color(0xFFD9D9D9),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              const SizedBox(height: 12),

                              // LIST
                              Expanded(
                                child: ListView.separated(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 4),
                                  itemCount: potions.length,
                                  separatorBuilder: (_, __) =>
                                      const SizedBox(height: 10),
                                  itemBuilder: (context, index) {
                                    final potion = potions[index];
                                    final isBrewed =
                                        brewedIds.contains(potion.id);
                                    return _PotionCard(
                                      potion: potion,
                                      isBrewed: isBrewed,
                                      colorForCategory: _colorForCategory,
                                      onTap: () {
                                        setState(() {
                                          _selectedPotion = potion;
                                        });
                                      },
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 8),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // BACK BUTTON
                  PrimaryButton(
                    label: 'Back',
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),

            // OVERLAY DETAIL VIEW
            if (_selectedPotion != null)
              Positioned.fill(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedPotion = null;
                    });
                  },
                  child: Container(
                    color: Colors.black.withOpacity(0.6),
                    child: Center(
                      child: _PotionDetailOverlay(
                        potion: _selectedPotion!,
                        colorForCategory: _colorForCategory,
                        onClose: () {
                          setState(() {
                            _selectedPotion = null;
                          });
                        },
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
// POTION LIST CARD
// -----------------------------------------------------------------------------

class _PotionCard extends StatelessWidget {
  final Potion potion;
  final bool isBrewed;
  final Color Function(IngredientCategory) colorForCategory;
  final VoidCallback onTap;

  const _PotionCard({
    required this.potion,
    required this.isBrewed,
    required this.colorForCategory,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final herb = ingredientById(potion.herbId);
    final mineral = ingredientById(potion.mineralId);
    final creature = ingredientById(potion.creatureId);
    final essence = ingredientById(potion.essenceId);

    final baseTextColor =
        isBrewed ? const Color(0xFFA7A7A7) : const Color(0xFF351B10);

    final borderColor =
        isBrewed ? const Color(0xFFCCCCCC) : const Color(0xFFFFDB8D);

    final ppColor =
        isBrewed ? const Color(0xFFA7A7A7) : const Color(0xFFFE7305);

    final ingredients = [creature, mineral, herb, essence];

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 97,
        decoration: BoxDecoration(
          color: const Color(0xFFFFF6E3),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: borderColor,
            width: 2.1,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Potion image (small thumbnail)
            SizedBox(
              width: 80,
              height: 80,
              child: Image.asset(
                // assumes assets/images/potions/<potion.id>.png
                'assets/images/potions/${potion.id}.png',
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(width: 0),

            // Name + ingredients
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // POTION NAME
                  Text(
                    potion.name.toUpperCase(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Pixel Game',
                      fontSize: 18,
                      height: 0.8,
                      letterSpacing: -0.01,
                      color: baseTextColor,
                      decoration: isBrewed
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  const SizedBox(height: 2),

                  // 4 ingredient rows (tighter spacing)
                  if (ingredients.every((i) => i != null))
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: ingredients.map((ingredient) {
                        final ing = ingredient!;
                        final textColor = isBrewed
                            ? baseTextColor
                            : colorForCategory(ing.category);
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // small icon
                              SizedBox(
                                width: 16,
                                height: 16,
                                child: Image.asset(
                                  ingredientAsset(ing.id),
                                  fit: BoxFit.contain,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  ing.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: 'Merchant Copy',
                                    fontSize: 19,
                                    height: 0, // tighter line height
                                    letterSpacing: -0.01,
                                    color: textColor,
                                    decoration: isBrewed
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
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
                fontSize: 20,
                height: 1.0,
                letterSpacing: -0.01,
                color: ppColor,
                decoration:
                    isBrewed ? TextDecoration.lineThrough : TextDecoration.none,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// OVERLAY DETAIL VIEW
// -----------------------------------------------------------------------------
class _PotionDetailOverlay extends StatelessWidget {
  final Potion potion;
  final VoidCallback onClose;
  final Color Function(IngredientCategory) colorForCategory;

  const _PotionDetailOverlay({
    required this.potion,
    required this.onClose,
    required this.colorForCategory,
  });

  @override
  Widget build(BuildContext context) {
    final herb = ingredientById(potion.herbId);
    final mineral = ingredientById(potion.mineralId);
    final creature = ingredientById(potion.creatureId);
    final essence = ingredientById(potion.essenceId);

    return Positioned.fill(
      child: GestureDetector(
        onTap: onClose,
        child: Container(
          color: Colors.black54,
          alignment: Alignment.center,
          child: GestureDetector(
            onTap: () {}, // absorb taps so card itself doesn't close
            child: Container(
              width: 300,
              decoration: BoxDecoration(
                color: const Color(0xFFFFDB8D),
                borderRadius: BorderRadius.circular(26),
                border: Border.all(
                  color: const Color(0xFFFFDB8D),
                  width: 12,
                ),
              ),
              child: Container(
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF6E3),
                  borderRadius: BorderRadius.circular(26),
                  border: Border.all(
                    color: const Color(0xFF351B10),
                    width: 4,
                  ),
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // main content
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 40, 20, 24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // title
                          Text(
                            potion.name,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontFamily: 'JMH Cthulhumbus Arcade',
                              fontSize: 26,
                              height: 1.1,
                              color: Color(0xFF351B10),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // image square
                          Container(
                            height: 130,
                            width: 160,
                            decoration: BoxDecoration(
                              color: const Color(0xFFA5DCE5),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: const Color(0xFF351B10),
                                width: 4,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: SizedBox(
                              width: 110,
                              height: 110,
                              child: Image.asset(
                                _potionAsset(potion),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),

                          const SizedBox(height: 18),

                          // HOW TO MAKE
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'HOW TO MAKE:',
                                style: TextStyle(
                                  fontFamily: 'Pixel Game',
                                  fontSize: 16,
                                  height: 1.0,
                                  color: Color(0xFF351B10),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Container(
                                height: 2,
                                width: 83,
                                color: const Color(0xFF351B10),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          // four rows always (if some null, we just skip icons)
                          if (creature != null)
                            _IngredientDetailRow(
                              ingredient: creature,
                              colorForCategory: colorForCategory,
                            ),
                          if (mineral != null)
                            _IngredientDetailRow(
                              ingredient: mineral,
                              colorForCategory: colorForCategory,
                            ),
                          if (herb != null)
                            _IngredientDetailRow(
                              ingredient: herb,
                              colorForCategory: colorForCategory,
                            ),
                          if (essence != null)
                            _IngredientDetailRow(
                              ingredient: essence,
                              colorForCategory: colorForCategory,
                            ),
                        ],
                      ),
                    ),

                    // +PP badge on top
                    Positioned(
                      top: -10,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 248, 198, 91),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: const Color(0xFF351B10),
                              width: 3,
                            ),
                            boxShadow: const [
                              BoxShadow(
                                blurRadius: 4,
                                color: Colors.black26,
                              ),
                            ],
                          ),
                          child: Text(
                            '+${potion.points} PP',
                            style: const TextStyle(
                              fontFamily: 'Pixel Game',
                              fontSize: 24,
                              height: 1.0,
                              color: Color(0xFFFE7305),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // small close "X"
                    Positioned(
                      right: 10,
                      top: 8,
                      child: GestureDetector(
                        onTap: onClose,
                        child: const Icon(
                          Icons.close,
                          size: 20,
                          color: Color(0xFF351B10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _IngredientDetailRow extends StatelessWidget {
  final Ingredient ingredient;
  final Color Function(IngredientCategory) colorForCategory;

  const _IngredientDetailRow({
    required this.ingredient,
    required this.colorForCategory,
  });

  @override
  Widget build(BuildContext context) {
    final color = colorForCategory(ingredient.category);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 4),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 55,
                height: 30,
                child: Image.asset(
                  ingredientAsset(ingredient.id),
                  fit: BoxFit.contain,
                ),
              ),
              Text(
                ingredient.name,
                style: TextStyle(
                  fontFamily: 'Merchant Copy',
                  fontSize: 25,
                  height: 1.0,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          // horizontal line under each ingredient
          Container(
            margin: const EdgeInsets.only(left: 8, right: 0),
            height: 2,
            color: const Color(0xFFFFDB8D),
          ),
        ],
      ),
    );
  }
}

// simple helper – assumes potion.id matches filename in assets/images/potions/
String _potionAsset(Potion potion) {
  return 'assets/images/potions/${potion.id}.png';
}