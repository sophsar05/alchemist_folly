import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'theme/app_theme.dart';
import 'providers/game_state.dart';
import 'screens/main_menu_screen.dart';
import 'screens/player_count_screen.dart';
import 'screens/player_names_screen.dart';
import 'screens/round_start_screen.dart';
import 'screens/market_announcement_screen.dart';
import 'screens/game_master_screen.dart';
import 'screens/brew_screen.dart';
import 'screens/brew_result_screen.dart';
import 'screens/potion_list_screen.dart';
import 'screens/library_hint_screen.dart';
import 'screens/library_hint_view.dart';
import 'screens/market_screen.dart';
import 'screens/black_market_screen.dart';
import 'screens/secret_reveal_screen.dart';
import 'screens/end_game_flow_screen.dart';

void main() {
  runApp(const AlchemistFollyApp());
}

class AlchemistFollyApp extends StatelessWidget {
  const AlchemistFollyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GameState(),
      child: MaterialApp(
        title: 'Alchemist Folly',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,
        initialRoute: MainMenuScreen.routeName,
        routes: {
          MainMenuScreen.routeName: (_) => const MainMenuScreen(),
          PlayerCountScreen.routeName: (_) => const PlayerCountScreen(),
          PlayerNamesScreen.routeName: (_) => const PlayerNamesScreen(),
          RoundStartScreen.routeName: (_) => const RoundStartScreen(),
          MarketAnnouncementScreen.routeName: (_) =>
              const MarketAnnouncementScreen(),
          GameMasterScreen.routeName: (_) => const GameMasterScreen(),
          BrewScreen.routeName: (_) => const BrewScreen(),
          BrewResultScreen.routeName: (_) => const BrewResultScreen(),
          PotionListScreen.routeName: (_) => const PotionListScreen(),
          LibraryHintScreen.routeName: (_) => const LibraryHintScreen(),
          LibraryHintView.routeName: (_) => const LibraryHintView(),
          MarketScreen.routeName: (_) => const MarketScreen(),
          BlackMarketScreen.routeName: (_) => const BlackMarketScreen(),
          SecretRevealScreen.routeName: (_) => const SecretRevealScreen(),
          EndGameFlowScreen.routeName: (_) => const EndGameFlowScreen(),
        },
      ),
    );
  }
}
