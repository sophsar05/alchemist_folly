import 'package:flutter/material.dart';
import '../widgets/background_scaffold.dart';
import '../widgets/primary_button.dart';

class SecretRevealScreen extends StatelessWidget {
  static const routeName = '/secret-reveal';

  const SecretRevealScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // placeholder: later this will show winning secret potion details
    const title = 'Secret Potion Revealed!';
    const body =
        'When the game ends, this screen will reveal which potion was the secret one and who discovered it first.';

    return BackgroundScaffold(
      backgroundAsset: 'assets/images/bg_secret.png',
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'JMH Cthulhumbus Arcade',
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              body,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Pixel Game',
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 32),
            PrimaryButton(
              label: 'Back',
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}
