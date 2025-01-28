import 'package:flutter/material.dart';

class AnimationUtils {
  /// Bounce Animation for Undo/Redo
  static Widget bounceAnimation(
    Widget child,
    Animation<double> animation,
  ) {
    return ScaleTransition(
      scale: animation,
      child: child,
    );
  }

  /// Slide Animation for Adding/Removing Notes
  static Widget slideAnimation(
    Animation<double> animation,
    Widget child, {
    Offset begin = const Offset(1, 0),
    Offset end = Offset.zero,
  }) {
    return SlideTransition(
      position: Tween<Offset>(begin: begin, end: end).animate(animation),
      child: child,
    );
  }

  /// Fade Animation for Smooth Appearance
  static Widget fadeAnimation(
    Animation<double> animation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }

  /// Rotation Animation for FAB
  static Widget rotateAnimation(
    Animation<double> animation,
    Widget child,
  ) {
    return RotationTransition(
      turns: animation,
      child: child,
    );
  }

  /// Theme Change Animation
  static Widget themeTransition(
    Duration duration,
    Color beginColor,
    Color endColor,
    Widget child,
  ) {
    return TweenAnimationBuilder<Color?>(
      duration: duration,
      tween: ColorTween(begin: beginColor, end: endColor),
      builder: (context, color, child) {
        return Container(
          color: color, // This should work since `color` is a nullable Color.
          child: child,
        );
      },
    );
  }
}
