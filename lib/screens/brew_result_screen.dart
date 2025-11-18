import 'package:flutter/material.dart';
import '../widgets/background_scaffold.dart';
import '../widgets/primary_button.dart';
import '../game_logic/game_models.dart';

class BrewResultScreen extends StatelessWidget {
  static const routeName = '/brew-result';

  const BrewResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final result =
        ModalRoute.of(context)!.settings.arguments as BrewResult?;

    if (result == null) {
      return BackgroundScaffold(
        backgroundAsset: 'assets/images/bg_cauldron.png',
        child: Center(
          child: Text(
            'No brew data.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      );
    }

    return BackgroundScaffold(
      backgroundAsset: 'assets/images/bg_cauldron.png',
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              result.success ? 'Brew Successful!' : 'Brew Failed',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 16),
            if (result.potion != null)
              Text(
                result.potion!.name,
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
            const SizedBox(height: 16),
            Text(
              result.message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            Text(
              'Base PP: ${result.basePoints}\n'
              'Bonus PP: ${result.bonusPoints}\n'
              'Total PP this brew: ${result.totalPoints}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Pixel Game',
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            if (result.isSecretPotion)
              const Text(
                'Secret potion discovered! +3 PP bonus!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Pixel Game',
                  fontSize: 16,
                ),
              ),
            if (result.triggeredFolly)
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  'Folly penalty applied!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Pixel Game',
                    fontSize: 16,
                    color: Colors.red,
                  ),
                ),
              ),
            const SizedBox(height: 32),
            PrimaryButton(
              label: 'Back to Turns',
              onPressed: () {
                Navigator.popUntil(
                  context,
                  ModalRoute.withName('/game-master'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
