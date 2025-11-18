// lib/providers/game_state.dart

import 'dart:math';

import 'package:flutter/foundation.dart';

import '../game_logic/game_models.dart';

class GameState extends ChangeNotifier {
  static const int maxRounds = 15;
  static const int apPerTurn = 2;

  final Random _random = Random();

  final List<Player> _players = [];
  int _currentPlayerIndex = 0;
  int _currentRound = 1;
  int _currentAP = apPerTurn;

  Potion? _secretPotion;
  MarketEvent _currentMarketEvent = MarketEvent.calm;

  /// IDs of potions that have been successfully brewed at least once.
  /// Used by the Potion List screen to gray out & strike-through.
  final Set<String> brewedPotionIds = {};

  // ---------------------------------------------------------------------------
  // GETTERS
  // ---------------------------------------------------------------------------

  List<Player> get players => List.unmodifiable(_players);
  int get currentRound => _currentRound;
  int get currentAP => _currentAP;

  Player get currentPlayer {
    if (_players.isEmpty) {
      // Fallback dummy player to avoid crashes, but in practice
      // you should always set players before starting a round.
      return Player(id: 'none', name: 'No Players');
    }
    return _players[_currentPlayerIndex];
  }

  MarketEvent get currentMarketEvent => _currentMarketEvent;
  Potion? get secretPotion => _secretPotion;

  bool get isGameOver => _currentRound > maxRounds;

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
    _currentAP = apPerTurn;
    _secretPotion = null;
    _currentMarketEvent = MarketEvent.calm;
    brewedPotionIds.clear();
    notifyListeners();
  }

  /// Initializes players and starts a new game.
  void setPlayerNames(List<String> names) {
    _players
      ..clear()
      ..addAll(
        names
            .where((n) => n.trim().isNotEmpty)
            .map(
              (n) => Player(
                id: n.trim().toLowerCase().replaceAll(' ', '_'),
                name: n.trim(),
              ),
            ),
      );

    _currentPlayerIndex = 0;
    _currentRound = 1;
    _currentAP = apPerTurn;

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
    // 0 = calm, 1 = inDemand, 2 = surplus, 3 = folly
    final roll = _random.nextInt(4);

    if (roll == 0) {
      _currentMarketEvent = MarketEvent.calm;
      return;
    }

    final ingredient = kIngredients[_random.nextInt(kIngredients.length)];

    switch (roll) {
      case 1:
        _currentMarketEvent = MarketEvent(
          type: MarketEventType.inDemand,
          title: 'In Demand: ${ingredient.name}',
          description:
              '${ingredient.name} is in high demand. Potions using it gain +2 PP.',
          ingredientId: ingredient.id,
          bonusOrPenalty: 2,
        );
        break;
      case 2:
        _currentMarketEvent = MarketEvent(
          type: MarketEventType.surplus,
          title: 'Surplus: ${ingredient.name}',
          description:
              '${ingredient.name} is flooding the market. Potions using it lose 1 PP (minimum 0).',
          ingredientId: ingredient.id,
          bonusOrPenalty: -1,
        );
        break;
      default:
        _currentMarketEvent = MarketEvent(
          type: MarketEventType.folly,
          title: 'Folly Ingredient: ${ingredient.name}',
          description:
              'If a brew fails and contains ${ingredient.name}, the alchemist suffers -2 PP.',
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

  // --- your existing "advance turn" logic below ---
  // This part assumes you already have:
  //   - players
  //   - currentPlayerIndex
  //   - currentRound
  //   - maxRounds
  //   - isGameOver flag, etc.

  if (players.isEmpty) {
    return false;
  }

  // move to next player
  _currentPlayerIndex++;

  // wrap around player index
  if (_currentPlayerIndex >= players.length) {
    _currentPlayerIndex = 0;
    _currentRound++;

    // if you have per-round setup (new AP, new market event, etc),
    // make sure you call it here:
    _startNewRoundIfNeeded();
  }

  // check for game over condition
  if (!isGameOver) {
        _rollMarketEvent();
      }

  notifyListeners();

  final startedNewRound = currentRound != oldRound;
  return startedNewRound;
}

/// Optional helper if you already had round setup logic somewhere.
/// If you don't use it, just inline and delete this.
void _startNewRoundIfNeeded() {
  // example:
  // currentAP = baseAPPerRound;
  // rollMarketConditionForRound();
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

    if (_currentAP < 2) {
      return const BrewResult(
        success: false,
        message: 'Not enough AP. You need 2 AP to brew.',
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

    if (herb == null || mineral == null || creature == null || essence == null) {
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

    final potion = findPotionMatch(
      herbId: herb.id,
      mineralId: mineral.id,
      creatureId: creature.id,
      essenceId: essence.id,
    );

    int base = 0;
    int bonus = 0;
    bool isSecret = false;
    bool follyPenalty = false;
    String message;

    if (potion != null) {
      base = potion.points;
      message = 'You brewed ${potion.name}!';

      // Market effects
      if (_currentMarketEvent.type == MarketEventType.inDemand &&
          _currentMarketEvent.ingredientId != null &&
          [
            herb.id,
            mineral.id,
            creature.id,
            essence.id,
          ].contains(_currentMarketEvent.ingredientId)) {
        bonus += 2;
      } else if (_currentMarketEvent.type == MarketEventType.surplus &&
          _currentMarketEvent.ingredientId != null &&
          [
            herb.id,
            mineral.id,
            creature.id,
            essence.id,
          ].contains(_currentMarketEvent.ingredientId)) {
        bonus -= 1;
      }

      // Secret potion bonus
    if (_secretPotion != null && potion.id == _secretPotion!.id) {
      isSecret = true;
      bonus += 3;
      currentPlayer.discoveredSecretPotion = true;

      if (kDebugMode) {
        debugPrint(
          '🎉 SECRET POTION DISCOVERED by ${currentPlayer.name}: ${potion.name}',
        );
      }
    }

      // Don’t go below 0 total PP for a successful potion
      if (base + bonus < 0) {
        bonus = -base;
      }

      // Mark this potion as brewed for the list screen
      brewedPotionIds.add(potion.id);
    } else {
      // Mis-brew / Folly
      message =
          'The mixture fizzles into useless sludge. The Trial Masters are not impressed.';
      base = 0;

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

    // Apply to current player
    final player = currentPlayer;
    player.prestige += total;
    if (potion != null) {
      player.potionsBrewed++;
    }

    _currentAP -= 2;
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
}
