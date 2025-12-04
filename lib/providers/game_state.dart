// lib/providers/game_state.dart

import 'dart:math';

import 'package:flutter/foundation.dart';

import '../game_logic/game_models.dart';

class GameState extends ChangeNotifier {
  static const int maxRounds = 100;

  final Random _random = Random();

  final List<Player> _players = [];
  int _currentPlayerIndex = 0;
  int _currentRound = 1;

  Player? _winner;
  bool _secretFound = false;

  Player? get winner => _winner;
  bool get secretFound => _secretFound;

  bool get isGameOver => _secretFound || players.any((p) => p.prestige >= 20);

  // 20 pp or secret potion check
  bool get isGameOverByPoints =>
      !_secretFound && players.any((p) => p.prestige >= 20);

  Potion? _secretPotion;
  MarketEvent _currentMarketEvent = MarketEvent.calm;
  int _marketEventTurnsRemaining = 0;

  /// IDs of potions that have been successfully brewed at least once.
  /// Used by the Potion List screen to gray out & strike-through.
  final Set<String> brewedPotionIds = {};

  // ---------------------------------------------------------------------------
  // GETTERS
  // ---------------------------------------------------------------------------

  List<Player> get players => List.unmodifiable(_players);
  int get currentRound => _currentRound;

  Player get currentPlayer {
    if (_players.isEmpty) {
      // Fallback dummy player to avoid crashes, but in practice
      // you should always set players before starting a round.
      return Player(id: 'none', name: 'No Players');
    }
    return _players[_currentPlayerIndex];
  }

  MarketEvent get currentMarketEvent => _currentMarketEvent;

  // surplus check
  bool isSurplusActive(String ingredientId) {
    return _currentMarketEvent.type == MarketEventType.surplus &&
        _currentMarketEvent.ingredientId == ingredientId;
  }

  // ingredient collection amount
  int getIngredientCollectionAmount(String ingredientId) {
    return isSurplusActive(ingredientId) ? 2 : 1;
  }

  Potion? get secretPotion => _secretPotion;

  /// Standings sorted by highest prestige first.
  List<Player> get standings {
    final copy = List<Player>.from(_players);
    copy.sort((a, b) => b.prestige.compareTo(a.prestige));
    return copy;
  }

  // ---------------------------------------------------------------------------
  // SETUP
  // ---------------------------------------------------------------------------

  /// Clears all game data.
  void reset() {
    _players.clear();
    _currentPlayerIndex = 0;
    _currentRound = 1;
    _secretPotion = null;
    _currentMarketEvent = MarketEvent.calm;
    _marketEventTurnsRemaining = 0;
    brewedPotionIds.clear();
    _winner = null;
    _secretFound = false;
    notifyListeners();
  }

  /// Initializes players and starts a new game.
  void setPlayerNames(List<String> names) {
    _players
      ..clear()
      ..addAll(
        names.where((n) => n.trim().isNotEmpty).map(
              (n) => Player(
                id: n.trim().toLowerCase().replaceAll(' ', '_'),
                name: n.trim(),
              ),
            ),
      );

    _currentPlayerIndex = 0;
    _currentRound = 1;

    // Pick a secret potion from the allowed candidates.
    _secretPotion = pickRandomSecretPotion(_random);
    if (kDebugMode && _secretPotion != null) {
      debugPrint('🧪 SECRET POTION SELECTED: ${_secretPotion!.name}');
      debugPrint('   Recipe: '
          'Herb=${_secretPotion!.herbId}, '
          'Mineral=${_secretPotion!.mineralId}, '
          'Creature=${_secretPotion!.creatureId}, '
          'Essence=${_secretPotion!.essenceId}');
      if (_secretPotion!.hint != null) {
        debugPrint('   Hint: ${_secretPotion!.hint}');
      }
    }

    _rollMarketEvent();
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // MARKET EVENTS
  // ---------------------------------------------------------------------------

  void _rollMarketEvent() {
    if (_marketEventTurnsRemaining > 0) {
      _marketEventTurnsRemaining--;
      return;
    }

    // 0 = calm, 1 = inDemand, 2 = surplus, 3 = folly
    final roll = _random.nextInt(4);

    if (roll == 0) {
      _currentMarketEvent = MarketEvent.calm;
      _marketEventTurnsRemaining = 0;
      return;
    }

    _marketEventTurnsRemaining = (3 * players.length) - 1;

    final ingredient = kIngredients[_random.nextInt(kIngredients.length)];

    switch (roll) {
      case 1:
        _currentMarketEvent = MarketEvent(
          type: MarketEventType.inDemand,
          title: 'In Demand: ${ingredient.name}',
          description:
              '${ingredient.name} is in high demand. Potions using it gain +2 PP!',
          ingredientId: ingredient.id,
          bonusOrPenalty: 2,
        );
        break;
      case 2:
        final location = getIngredientLocation(ingredient.id);
        _currentMarketEvent = MarketEvent(
          type: MarketEventType.surplus,
          title: 'Ingredient Overflow at $location',
          description:
              'Ingredients are overflowing at $location! Take 2 ingredients instead of 1 this turn.',
          ingredientId: ingredient.id,
          locationName: location,
        );
        break;
      default:
        _currentMarketEvent = MarketEvent(
          type: MarketEventType.folly,
          title: 'Folly Ingredient: ${ingredient.name}',
          description:
              'If a brew fails and contains ${ingredient.name}, the alchemist suffers -2 PP!',
          ingredientId: ingredient.id,
          bonusOrPenalty: -2,
        );
        break;
    }
  }

  // ---------------------------------------------------------------------------
  // TURN / ROUND FLOW
  // ---------------------------------------------------------------------------

  /// Advances to the next player's turn.
  /// Returns `true` if this call started a NEW ROUND.
  bool nextTurn() {
    final oldRound = currentRound;

    if (players.isEmpty) {
      return false;
    }

    // move to next player
    _currentPlayerIndex++;

    // wrap around player index
    if (_currentPlayerIndex >= players.length) {
      _currentPlayerIndex = 0;
      _currentRound++;

      _startNewRoundIfNeeded();
    }

    if (!isGameOver) {
      _rollMarketEvent();
    }

    notifyListeners();

    final startedNewRound = currentRound != oldRound;
    return startedNewRound;
  }

  void _startNewRoundIfNeeded() {
    // Round start logic
  }

  // ---------------------------------------------------------------------------
  // BREWING
  // ---------------------------------------------------------------------------
  BrewResult brew({
    required String? herbName,
    required String? mineralName,
    required String? creatureName,
    required String? essenceName,
    required bool useStardust,
  }) {
    if (_players.isEmpty) {
      return const BrewResult(
        success: false,
        message: 'No players have joined the game yet.',
        potion: null,
        basePoints: 0,
        bonusPoints: 0,
        totalPoints: 0,
        isSecretPotion: false,
        triggeredFolly: false,
        apSpent: 0,
      );
    }

    // stardust check
    if (useStardust && currentPlayer.stardust < 1) {
      return const BrewResult(
        success: false,
        message:
            'Not enough Stardust. You need 1 Stardust to attempt a secret potion.',
        potion: null,
        basePoints: 0,
        bonusPoints: 0,
        totalPoints: 0,
        isSecretPotion: false,
        triggeredFolly: false,
        apSpent: 0,
      );
    }

    final herb = ingredientByName(herbName);
    final mineral = ingredientByName(mineralName);
    final creature = ingredientByName(creatureName);
    final essence = ingredientByName(essenceName);

    if (herb == null ||
        mineral == null ||
        creature == null ||
        essence == null) {
      return const BrewResult(
        success: false,
        message: 'Choose one ingredient from each category before brewing.',
        potion: null,
        basePoints: 0,
        bonusPoints: 0,
        totalPoints: 0,
        isSecretPotion: false,
        triggeredFolly: false,
        apSpent: 0,
      );
    }

    // debug
    if (kDebugMode) {
      debugPrint(' BREW ATTEMPT:');
      debugPrint('  Herb: ${herb.name} (${herb.id})');
      debugPrint('  Mineral: ${mineral.name} (${mineral.id})');
      debugPrint('  Creature: ${creature.name} (${creature.id})');
      debugPrint('  Essence: ${essence.name} (${essence.id})');
    }

    Potion? potion = findPotionMatch(
      herbId: herb.id,
      mineralId: mineral.id,
      creatureId: creature.id,
      essenceId: essence.id,
    );

    if (kDebugMode) {
      debugPrint('  Found potion: ${potion?.name ?? 'None'}');
      if (potion != null) {
        debugPrint('  Expected points: ${potion.points}');
      }
    }

    int base = 0;
    int bonus = 0;
    bool isSecret = false;
    bool follyPenalty = false;
    String message = '';

    // ------------------------------------------------------------------
    // 1) STARDUST SECRET CHECK – ONLY Stardust can unlock the secret
    // ------------------------------------------------------------------
    if (useStardust && _secretPotion != null) {
      int matches = 0;
      if (herb.id == _secretPotion!.herbId) matches++;
      if (mineral.id == _secretPotion!.mineralId) matches++;
      if (creature.id == _secretPotion!.creatureId) matches++;
      if (essence.id == _secretPotion!.essenceId) matches++;

      if (matches >= 3) {
        potion = _secretPotion;
        isSecret = true;

        if (kDebugMode) {
          debugPrint(
            ' STARDUST SECRET DISCOVERY by ${currentPlayer.name}: '
            '${potion!.name} with $matches/4 matches',
          );
        }
      }
    }

    // ------------------------------------------------------------------
    // 2) NORMAL POTION + MARKET EFFECTS
    // ------------------------------------------------------------------
    if (potion != null) {
      if (!isSecret && brewedPotionIds.contains(potion.id)) {
        message =
            'This potion has already been brewed by another alchemist! You gain nothing from duplicating their work.';
        base = -2;
        potion = null;

        if (_currentMarketEvent.type == MarketEventType.folly &&
            _currentMarketEvent.ingredientId != null &&
            [
              herb.id,
              mineral.id,
              creature.id,
              essence.id,
            ].contains(_currentMarketEvent.ingredientId)) {
          bonus -= 2;
          follyPenalty = true;
        }
      } else {
        base = potion.points;

        if (_currentMarketEvent.type == MarketEventType.inDemand &&
            _currentMarketEvent.ingredientId != null &&
            [
              herb.id,
              mineral.id,
              creature.id,
              essence.id,
            ].contains(_currentMarketEvent.ingredientId)) {
          bonus += 2;
        }

        if (isSecret) {
          currentPlayer.discoveredSecretPotion = true;
          _secretFound = true;
          _winner = currentPlayer;

          message =
              'The Stardust guides your hand! You brewed the secret ${potion.name}!';
        } else {
          message = 'You brewed ${potion.name}!';
        }

        if (base + bonus < 0) {
          bonus = -base;
        }

        brewedPotionIds.add(potion.id);
      }
    } else {
      message =
          'The mixture fizzles into useless sludge. The Trial Masters are not impressed.';
      base = -2;

      if (_currentMarketEvent.type == MarketEventType.folly &&
          _currentMarketEvent.ingredientId != null &&
          [
            herb.id,
            mineral.id,
            creature.id,
            essence.id,
          ].contains(_currentMarketEvent.ingredientId)) {
        bonus -= 2;
        follyPenalty = true;
      }
    }

    final total = base + bonus;

    if (kDebugMode) {
      debugPrint('  POINTS CALCULATION:');
      debugPrint('    Base points: $base');
      debugPrint('    Bonus points: $bonus');
      debugPrint('    Total points: $total');
      debugPrint(
          '    Player ${currentPlayer.name} prestige before: ${currentPlayer.prestige}');
    }

    // award points
    final player = currentPlayer;
    player.prestige += total;
    if (potion != null) {
      player.potionsBrewed++;
    }

    if (kDebugMode) {
      debugPrint(
          '    Player ${currentPlayer.name} prestige after: ${currentPlayer.prestige}');
    }

    if (useStardust) {
      player.stardust -= 1;
    }

    notifyListeners();

    return BrewResult(
      success: potion != null,
      message: message,
      potion: potion,
      basePoints: base,
      bonusPoints: bonus,
      totalPoints: total,
      isSecretPotion: isSecret,
      triggeredFolly: follyPenalty,
      apSpent: 2,
    );
  }

  // ---------------------------------------------------------------------------
  // SHOPPING
  // ---------------------------------------------------------------------------

  String? shopForGoods(Map<String, int> selectedIngredients) {
    int totalCost = 0;
    for (final count in selectedIngredients.values) {
      totalCost += count * 2; // Each ingredient costs 2 PP
    }

    if (currentPlayer.prestige < totalCost) {
      return 'Not enough PP. You need $totalCost PP to buy these ingredients.';
    }

    // Deduct PP
    currentPlayer.prestige -= totalCost;
    notifyListeners();

    return null; // No error, purchase successful
  }

  /// trade ingredient from two diff categories: herb, mineral, creature, essence to gain 1 Stardust.
  String? tradeForStardust(Map<String, int> ingredientsToTrade) {
    if (ingredientsToTrade.isEmpty) {
      return 'Select at least one ingredient to trade.';
    }

    int totalIngredients = 0;
    final Set<IngredientCategory> usedCategories = {};

    for (final entry in ingredientsToTrade.entries) {
      final ingredientId = entry.key;
      final count = entry.value;

      if (count > 0) {
        totalIngredients += count;

        // Find the ingredient and track its category
        final ingredient = ingredientById(ingredientId);
        if (ingredient != null) {
          usedCategories.add(ingredient.category);
        }
      }
    }

    if (totalIngredients != 2) {
      return 'You must trade exactly 2 ingredients.';
    }

    if (usedCategories.length < 2) {
      return 'You must trade 2 ingredients from different types (herb, mineral, creature, or essence).';
    }

    // Award 1 Stardust
    currentPlayer.stardust += 1;
    notifyListeners();

    return null;
  }
}
