import 'package:flutter/material.dart';

class BackgroundScaffold extends StatelessWidget {
  final String backgroundAsset;
  final Widget child;
  final PreferredSizeWidget? appBar;
  final bool resizeToAvoidBottomInset;

  const BackgroundScaffold({
    super.key,
    required this.backgroundAsset,
    required this.child,
    this.appBar,
    this.resizeToAvoidBottomInset = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
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
