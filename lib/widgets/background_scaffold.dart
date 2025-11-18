import 'package:flutter/material.dart';

class BackgroundScaffold extends StatelessWidget {
  final String backgroundAsset;
  final Widget child;
  final PreferredSizeWidget? appBar;

  const BackgroundScaffold({
    super.key,
    required this.backgroundAsset,
    required this.child,
    this.appBar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            backgroundAsset,
            fit: BoxFit.cover,
          ),
          Container(
            color: Colors.black.withOpacity(0.15),
          ),
          SafeArea(
            child: child,
          ),
        ],
      ),
    );
  }
}
