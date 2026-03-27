import 'package:flutter/material.dart';

class ElevatedButtonCarWash extends StatelessWidget {
  const ElevatedButtonCarWash({
    super.key,
    required this.onPressed,
    required this.child,
  });
  final VoidCallback? onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ElevatedButton(onPressed: onPressed, child: child),
    );
  }
}
