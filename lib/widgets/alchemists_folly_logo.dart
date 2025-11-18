import 'package:flutter/material.dart';

class AlchemistsFollyLogo extends StatelessWidget {
  const AlchemistsFollyLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      "Alchemist's\nFolly",
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: 'JMH Cthulhumbus Arcade',
        fontSize: 32,
        height: 0.85,
        letterSpacing: -0.05,
        color: const Color(0xFFFFDB8D), // main fill
        shadows: [
          // OUTLINE LAYER 1 (pixel outline)
          const Shadow(offset: Offset(0, 0), blurRadius: 0, color: Color(0xFF351B10)),
          const Shadow(offset: Offset(4, 0), blurRadius: 0, color: Color(0xFF351B10)),
          const Shadow(offset: Offset(-3, 0), blurRadius: 0, color: Color(0xFF351B10)),
          const Shadow(offset: Offset(0, 3), blurRadius: 0, color: Color(0xFF351B10)),
          const Shadow(offset: Offset(0, 3), blurRadius: 0, color: Color(0xFF351B10)),

          // OUTLINE LAYER 2 (soft glow)
          Shadow(
            offset: const Offset(0, 0),
            blurRadius: 20,
            color: const Color(0xFF351B10).withOpacity(0.6),
          ),
        ],
      ),
    );
  }
}
