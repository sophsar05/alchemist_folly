// lib/game_logic/game_models.dart

import 'dart:math';

// ============================================================================
// ENUMS & BASIC MODELS
// ============================================================================

enum IngredientCategory { herb, mineral, creature, essence }

class Ingredient {
  final String id; // unique ID, ex: "moonleaf"
  final String name; // display name, ex: "Moonleaf"
  final IngredientCategory category;

  const Ingredient({
    required this.id,
    required this.name,
    required this.category,
  });
}

class Potion {
  final String id;
  final String name;
  final String herbId;
  final String mineralId;
  final String creatureId;
  final String essenceId;
  final int points;
  final bool isSecretCandidate;
  final String? hint;

  const Potion({
    required this.id,
    required this.name,
    required this.herbId,
    required this.mineralId,
    required this.creatureId,
    required this.essenceId,
    required this.points,
    this.isSecretCandidate = false,
    this.hint,
  });
}

enum MarketEventType { calm, inDemand, surplus, folly }

class MarketEvent {
  final MarketEventType type;
  final String title;
  final String description;
  final String? ingredientId;
  final int bonusOrPenalty;

  const MarketEvent({
    required this.type,
    required this.title,
    required this.description,
    this.ingredientId,
    this.bonusOrPenalty = 0,
  });

  static const calm = MarketEvent(
    type: MarketEventType.calm,
    title: 'The Market is Calm',
    description: 'No special changes this round. Brew as usual, apprentices.',
  );
}

class Player {
  final String id;
  final String name;
  int prestige;
  int potionsBrewed;
  int stardust;
  bool discoveredSecretPotion;

  Player({
    required this.id,
    required this.name,
    this.prestige = 0,
    this.potionsBrewed = 0,
    this.stardust = 1,
    this.discoveredSecretPotion = false,
  });
}

class BrewResult {
  final bool success;
  final String message;
  final Potion? potion;
  final int basePoints;
  final int bonusPoints;
  final int totalPoints;
  final bool isSecretPotion;
  final bool triggeredFolly;
  final int apSpent;

  const BrewResult({
    required this.success,
    required this.message,
    required this.potion,
    required this.basePoints,
    required this.bonusPoints,
    required this.totalPoints,
    required this.isSecretPotion,
    required this.triggeredFolly,
    required this.apSpent,
  });
}

// ============================================================================
// INGREDIENTS CATALOG
// ============================================================================

const List<Ingredient> kIngredients = [
  // Herbs
  Ingredient(
    id: 'moonleaf',
    name: 'Moonleaf',
    category: IngredientCategory.herb,
  ),
  Ingredient(
    id: 'emberroot',
    name: 'Emberroot',
    category: IngredientCategory.herb,
  ),
  Ingredient(
    id: 'frostmint',
    name: 'Frostmint',
    category: IngredientCategory.herb,
  ),
  Ingredient(
    id: 'nightshade',
    name: 'Nightshade',
    category: IngredientCategory.herb,
  ),

  // Minerals
  Ingredient(
    id: 'crystal_dust',
    name: 'Crystal Dust',
    category: IngredientCategory.mineral,
  ),
  Ingredient(
    id: 'iron_shard',
    name: 'Iron Shard',
    category: IngredientCategory.mineral,
  ),
  Ingredient(
    id: 'sulfur_stone',
    name: 'Sulfur Stone',
    category: IngredientCategory.mineral,
  ),
  Ingredient(
    id: 'blue_ore',
    name: 'Blue Ore',
    category: IngredientCategory.mineral,
  ),

  // Creature parts
  Ingredient(
    id: 'dragon_scale',
    name: 'Dragon Scale',
    category: IngredientCategory.creature,
  ),
  Ingredient(
    id: 'phoenix_feather',
    name: 'Phoenix Feather',
    category: IngredientCategory.creature,
  ),
  Ingredient(
    id: 'kraken_ink',
    name: 'Kraken Ink',
    category: IngredientCategory.creature,
  ),
  Ingredient(
    id: 'basilisk_fang',
    name: 'Basilisk Fang',
    category: IngredientCategory.creature,
  ),

  // Essences
  Ingredient(
    id: 'light_essence',
    name: 'Light Essence',
    category: IngredientCategory.essence,
  ),
  Ingredient(
    id: 'shadow_oil',
    name: 'Shadow Oil',
    category: IngredientCategory.essence,
  ),
  Ingredient(
    id: 'spirit_dew',
    name: 'Spirit Dew',
    category: IngredientCategory.essence,
  ),
  Ingredient(
    id: 'forest_blood',
    name: 'Forest Blood',
    category: IngredientCategory.essence,
  ),
];

Ingredient? ingredientByName(String? name) {
  if (name == null) return null;
  for (final ing in kIngredients) {
    if (ing.name == name) return ing;
  }
  return null;
}

Ingredient? ingredientById(String id) {
  for (final ing in kIngredients) {
    if (ing.id == id) return ing;
  }
  return null;
}

// Maps ingredient IDs to their asset paths.
String ingredientAsset(String id) {
  switch (id) {
    // AZURE FOREST (creatures)
    case 'basilisk_fang':
      return 'assets/images/ingredients/azure-forest/basiliskfang.png';
    case 'dragon_scale':
      return 'assets/images/ingredients/azure-forest/dragonscale.png';
    case 'kraken_ink':
      return 'assets/images/ingredients/azure-forest/krakenink.png';
    case 'phoenix_feather':
      return 'assets/images/ingredients/azure-forest/phoenixfeather.png';

    // CRIMSON VOLCANO (essences)
    case 'forest_blood':
      return 'assets/images/ingredients/crimson-volcano/forestblood.png';
    case 'light_essence':
      return 'assets/images/ingredients/crimson-volcano/lightessence.png';
    case 'shadow_oil':
      return 'assets/images/ingredients/crimson-volcano/shadowoil.png';
    case 'spirit_dew':
      return 'assets/images/ingredients/crimson-volcano/spiritdew.png';

    // OBSIDIAN CAVES (herbs)
    case 'emberroot':
      return 'assets/images/ingredients/obsidian-caves/emberroot.png';
    case 'frostmint':
      return 'assets/images/ingredients/obsidian-caves/frostmint.png';
    case 'moonleaf':
      return 'assets/images/ingredients/obsidian-caves/moonleaf.png';
    case 'nightshade':
      return 'assets/images/ingredients/obsidian-caves/nightshade.png';

    // SUNSTONE MINE (minerals)
    case 'blue_ore':
      return 'assets/images/ingredients/sunstone-mine/blueore.png';
    case 'crystal_dust':
      return 'assets/images/ingredients/sunstone-mine/crystaldust.png';
    case 'iron_shard':
      return 'assets/images/ingredients/sunstone-mine/ironshard.png';
    case 'sulfur_stone':
      return 'assets/images/ingredients/sunstone-mine/sulfurstone.png';
  }

  // Fallback (optional placeholder if you add one)
  return 'assets/images/ingredients/placeholder.png';
}


// ============================================================================
// POTIONS CATALOG – ALL 15 POTIONS
// ============================================================================

const List<Potion> kPotions = [
  Potion(
    id: 'invisibility',
    name: 'Invisibility Potion',
    herbId: 'nightshade',
    mineralId: 'blue_ore',
    creatureId: 'kraken_ink',
    essenceId: 'shadow_oil',
    points: 8,
    isSecretCandidate: true,
    hint: 'Eyes search, yet I slip between their gaze.',
  ),
  Potion(
    id: 'sleep',
    name: 'Sleep Potion',
    herbId: 'moonleaf',
    mineralId: 'blue_ore',
    creatureId: 'kraken_ink',
    essenceId: 'spirit_dew',
    points: 7,
    isSecretCandidate: true,
    hint: 'When the silver tides rise, I cradle the restless.',
  ),
  Potion(
    id: 'frost',
    name: 'Frost Potion',
    herbId: 'frostmint',
    mineralId: 'blue_ore',
    creatureId: 'basilisk_fang',
    essenceId: 'spirit_dew',
    points: 7,
    isSecretCandidate: true,
    hint: 'A cold whisper lingers where the world slows.',
  ),
  Potion(
    id: 'curse_breaking',
    name: 'Curse-Breaking Potion',
    herbId: 'nightshade',
    mineralId: 'sulfur_stone',
    creatureId: 'basilisk_fang',
    essenceId: 'light_essence',
    points: 7,
    hint: 'Dark threads unravel, but only if you see them first.',
  ),
  Potion(
    id: 'luck',
    name: 'Luck Potion',
    herbId: 'nightshade',
    mineralId: 'sulfur_stone',
    creatureId: 'kraken_ink',
    essenceId: 'forest_blood',
    points: 7,
    hint: 'Fate smiles quietly when chance stirs the air.',
  ),
  Potion(
    id: 'water_breathing',
    name: 'Water Breathing Potion',
    herbId: 'frostmint',
    mineralId: 'blue_ore',
    creatureId: 'kraken_ink',
    essenceId: 'spirit_dew',
    points: 7,
    hint: 'Where the world is liquid, silence becomes breath.',
  ),
  Potion(
    id: 'clarity',
    name: 'Clarity Potion',
    herbId: 'moonleaf',
    mineralId: 'crystal_dust',
    creatureId: 'basilisk_fang',
    essenceId: 'spirit_dew',
    points: 6,
    hint: 'The haze recedes, but only in fleeting glimpses.',
  ),
  Potion(
    id: 'poison_antidote',
    name: 'Poison Antidote',
    herbId: 'moonleaf',
    mineralId: 'iron_shard',
    creatureId: 'basilisk_fang',
    essenceId: 'light_essence',
    points: 5,
    hint: 'Where venom lingers, I offer silent counsel.',
  ),
  Potion(
    id: 'energy',
    name: 'Energy Potion',
    herbId: 'emberroot',
    mineralId: 'sulfur_stone',
    creatureId: 'phoenix_feather',
    essenceId: 'forest_blood',
    points: 5,
    hint: 'A spark unseen quickens what slumbers within.',
  ),
  Potion(
    id: 'levitation',
    name: 'Levitation Potion',
    herbId: 'moonleaf',
    mineralId: 'crystal_dust',
    creatureId: 'phoenix_feather',
    essenceId: 'spirit_dew',
    points: 5,
    hint: 'The ground grows distant, and even shadows hesitate.',
  ),
  Potion(
    id: 'speed',
    name: 'Speed Potion',
    herbId: 'frostmint',
    mineralId: 'sulfur_stone',
    creatureId: 'phoenix_feather',
    essenceId: 'forest_blood',
    points: 5,
    hint: 'Time bends where I pass, yet no one notices.',
  ),
  Potion(
    id: 'love',
    name: 'Love Potion',
    herbId: 'emberroot',
    mineralId: 'crystal_dust',
    creatureId: 'phoenix_feather',
    essenceId: 'light_essence',
    points: 4,
    hint: 'Hearts may flutter where warmth meets flame.',
  ),
  Potion(
    id: 'healing',
    name: 'Healing Potion',
    herbId: 'moonleaf',
    mineralId: 'crystal_dust',
    creatureId: 'phoenix_feather',
    essenceId: 'light_essence',
    points: 4,
    hint: 'Beneath gentle hands, fractures mend quietly.',
  ),
  Potion(
    id: 'fire_resistance',
    name: 'Fire Resistance Potion',
    herbId: 'emberroot',
    mineralId: 'iron_shard',
    creatureId: 'dragon_scale',
    essenceId: 'light_essence',
    points: 4,
    hint: 'I walk among heat yet leave no mark.',
  ),
  Potion(
    id: 'strength',
    name: 'Strength Potion',
    herbId: 'emberroot',
    mineralId: 'iron_shard',
    creatureId: 'dragon_scale',
    essenceId: 'forest_blood',
    points: 4,
    hint: 'Beneath strain and weight, hidden power awakens.',
  ),
];

// ============================================================================
// HELPERS USED BY GAMESTATE
// ============================================================================

Potion? findPotionMatch({
  required String herbId,
  required String mineralId,
  required String creatureId,
  required String essenceId,
}) {
  for (final p in kPotions) {
    if (p.herbId == herbId &&
        p.mineralId == mineralId &&
        p.creatureId == creatureId &&
        p.essenceId == essenceId) {
      return p;
    }
  }
  return null;
}

Potion pickRandomSecretPotion(Random random) {
  return kPotions[random.nextInt(kPotions.length)];
}
