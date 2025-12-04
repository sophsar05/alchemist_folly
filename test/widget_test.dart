// test/widget_test.dart

import 'package:flutter_test/flutter_test.dart';

// Update this import if your package name is different
import 'package:alchemist_folly/main.dart';
import 'package:alchemist_folly/screens/main_menu_screen.dart';
import 'package:alchemist_folly/screens/player_count_screen.dart';

void main() {
  testWidgets('App loads main menu screen', (WidgetTester tester) async {
    // Build the app
    await tester.pumpWidget(const AlchemistFollyApp());
    await tester.pumpAndSettle();

    // Check that the main menu screen is shown
    expect(find.byType(MainMenuScreen), findsOneWidget);

    // Check that the title text appears
    expect(find.text('Alchemist Folly'), findsOneWidget);

    // Check that the "New Game" button exists
    expect(find.text('New Game'), findsOneWidget);
  });

  testWidgets('Tapping "New Game" navigates to player count screen',
      (WidgetTester tester) async {
    await tester.pumpWidget(const AlchemistFollyApp());
    await tester.pumpAndSettle();

    // Tap the "New Game" button
    await tester.tap(find.text('New Game'));
    await tester.pumpAndSettle();

    // Now we should be on the PlayerCountScreen
    expect(find.byType(PlayerCountScreen), findsOneWidget);

    // Optional: verify the prompt text
    expect(
      find.text('How many players are playing?'),
      findsOneWidget,
    );
  });
}
