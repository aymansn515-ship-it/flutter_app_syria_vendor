import 'dart:ui';

import 'package:flutter/material.dart';

class LoginBackground extends StatelessWidget {
  const LoginBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [

        /// White
        Container(color: Colors.white),

        /// Blue blur top
        Positioned(
          top: -120,
          left: -100,
          child: _blurCircle(
            260,
            const Color(0xff4D7CFE).withOpacity(.12),
          ),
        ),

        /// Right blur
        Positioned(
          top: 180,
          right: -120,
          child: _blurCircle(
            250,
            const Color(0xff4D7CFE).withOpacity(.08),
          ),
        ),

        /// Bottom blur
        Positioned(
          bottom: -120,
          left: -80,
          child: _blurCircle(
            220,
            const Color(0xff4D7CFE).withOpacity(.10),
          ),
        ),

        /// Top Right Hexagon
        Positioned(
          top: 80,
          right: -40,
          child: Opacity(
            opacity: .07,
            child: Icon(
              Icons.hexagon,
              size: 220,
              color: Colors.blue,
            ),
          ),
        ),

        /// Bottom Left Hexagon
        Positioned(
          bottom: -20,
          left: -20,
          child: Opacity(
            opacity: .07,
            child: Icon(
              Icons.hexagon,
              size: 170,
              color: Colors.blue,
            ),
          ),
        ),

        /// Dots left
        Positioned(
          top: 110,
          left: 10,
          child: _Dots(),
        ),

        /// Dots right bottom
        Positioned(
          bottom: 70,
          right: 12,
          child: _Dots(),
        ),
      ],
    );
  }

  Widget _blurCircle(double size, Color color) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(
        sigmaX: 70,
        sigmaY: 70,
      ),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
      ),
    );
  }
}

class _Dots extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        5,
            (i) => Row(
          children: List.generate(
            4,
                (j) => Container(
              margin: const EdgeInsets.all(5),
              width: 5,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(.18),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}