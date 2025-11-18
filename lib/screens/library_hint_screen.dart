import 'package:flutter/material.dart';
import '../widgets/background_scaffold.dart';
import '../widgets/primary_button.dart';

class LibraryHintScreen extends StatelessWidget {
  static const routeName = '/library-hint';

  const LibraryHintScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // placeholder text; will later be linked to actual secret potion hint logic
    const hintTitle = 'Grand Library';
    const hintBody =
        '"When the silver tides rise, I cradle the restless."\n\n(Example hint for Sleep Potion)';

    return BackgroundScaffold(
      backgroundAsset: 'assets/images/bg_library.png',
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              hintTitle,
              style: const TextStyle(
                fontFamily: 'JMH Cthulhumbus Arcade',
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              hintBody,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'JMH Cthulhumbus Arcade',
                fontSize: 18,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 32),
            PrimaryButton(
              label: 'Back',
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
