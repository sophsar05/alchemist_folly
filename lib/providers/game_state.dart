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

  List<Player> get players => List.unmodifiable(_players);
  int get currentRound => _currentRound;
  int get currentAP => _currentAP;
  Player get currentPlayer => _players[_currentPlayerIndex];
  MarketEvent get currentMarketEvent => _currentMarketEvent;
  Potion? get secretPotion => _secretPotion;

  bool get isGameOver => _currentRound > maxRounds;

  // ---------------------------------------------------------------------------
  // SETUP
  // ---------------------------------------------------------------------------

  void reset() {
    _players.clear();
    _currentPlayerIndex = 0;
    _currentRound = 1;
    _currentAP = apPerTurn;
    _secretPotion = null;
    _currentMarketEvent = MarketEvent.calm;
    notifyListeners();
  }

  void setPlayerNames(List<String> names) {
    _players
      ..clear()
      ..addAll(
        names.map(
          (n) => Player(
            id: n.trim().toLowerCase().replaceAll(' ', '_'),
            name: n.trim(),
          ),
        ),
      );
    _currentPlayerIndex = 0;
    _currentRound = 1;
    _currentAP = apPerTurn;
    _secretPotion = pickRandomSecretPotion(_random);
    _rollMarketEvent();
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // TURN / ROUND FLOW
  // ---------------------------------------------------------------------------

  void _rollMarketEvent() {
    // 0 = calm, 1 = inDemand, 2 = surplus, 3 = folly
    final roll = _random.nextInt(4);

    if (roll == 0) {
      _currentMarketEvent = MarketEvent.calm;
      return;
    }

    // pick a random ingredient
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
              '${ingredient.name} is flooding the market. Potions using it lose 1 PP (min 0).',
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

  void nextTurn() {
    if (_players.isEmpty) return;

    _currentPlayerIndex++;
    if (_currentPlayerIndex >= _players.length) {
      _currentPlayerIndex = 0;
      _currentRound++;
      if (!isGameOver) {
        _rollMarketEvent();
      }
    }
    _currentAP = apPerTurn;
    notifyListeners();
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
      }

      if (bonus < -base) {
        bonus = -base; // don’t go below 0 PP
      }
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

    // Apply to player
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

  // ---------------------------------------------------------------------------
  // STANDINGS
  // ---------------------------------------------------------------------------

  List<Player> get standings {
    final copy = List<Player>.from(_players);
    copy.sort((a, b) => b.prestige.compareTo(a.prestige));
    return copy;
  }
}
