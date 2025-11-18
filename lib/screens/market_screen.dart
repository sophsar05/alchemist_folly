import 'package:flutter/material.dart';
import '../widgets/background_scaffold.dart';
import '../widgets/primary_button.dart';

class MarketScreen extends StatefulWidget {
  static const routeName = '/market';

  const MarketScreen({super.key});

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      _buildPage(
        title: 'Grand Bazaar',
        text:
            'Spend PP to buy ingredients.\n\nThis screen will later show a list of available ingredients and prices.',
      ),
      _buildPage(
        title: 'Black Market',
        text:
            'Trade two different ingredients for Stardust.\n\nThis will later have an interface for selecting ingredients.',
      ),
      _buildPage(
        title: 'Market Status',
        text:
            'In Demand / Surplus effects will be summarised here.\n\nThis will later reflect the current round\'s event.',
      ),
    ];

    return BackgroundScaffold(
      backgroundAsset: 'assets/images/bg_market.png',
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Market',
              style: const TextStyle(
                fontFamily: 'JMH Cthulhumbus Arcade',
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: pages[pageIndex],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (pageIndex > 0)
                  PrimaryButton(
                    label: 'Prev',
                    onPressed: () {
                      setState(() {
                        pageIndex--;
                      });
                    },
                  )
                else
                  const SizedBox(width: 100),
                PrimaryButton(
                  label: 'Close',
                  onPressed: () => Navigator.pop(context),
                ),
                if (pageIndex < pages.length - 1)
                  PrimaryButton(
                    label: 'Next',
                    onPressed: () {
                      setState(() {
                        pageIndex++;
                      });
                    },
                  )
                else
                  const SizedBox(width: 100),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage({required String title, required String text}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'Pixel Game',
            fontSize: 22,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: 'Pixel Game',
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
