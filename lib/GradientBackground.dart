import 'package:flutter/material.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;

  const GradientBackground({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color.fromRGBO(60, 60, 60, 1),
            Color.fromRGBO(31, 83, 180, 1),
          ],
        ),
      ),
      child: child,
    );
  }
}