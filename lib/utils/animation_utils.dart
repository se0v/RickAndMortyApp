import 'package:flutter/material.dart';

class ListAnimation {
  final AnimationController controller;
  final int index;
  final int totalItems;

  ListAnimation({
    required this.controller,
    required this.index,
    required this.totalItems,
  });

  Animation<double> get animation =>
      Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: controller,
          curve: Interval(index / totalItems, 1.0, curve: Curves.easeInOut),
        ),
      );

  Widget buildAnimatedItem(Widget child) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        return Opacity(
          opacity: animation.value,
          child: Transform.scale(
            scale: animation.value,
            child: child,
          ),
        );
      },
    );
  }
}
