import 'package:flutter/material.dart';

class FadeSlidePageTransitionsBuilder extends PageTransitionsBuilder {
  const FadeSlidePageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    const begin = Offset(0, 0.04);
    const end = Offset.zero;
    final tween = Tween(begin: begin, end: end).chain(
      CurveTween(curve: Curves.easeOutCubic),
    );
    final fade = CurvedAnimation(parent: animation, curve: Curves.easeOut);
    return FadeTransition(
      opacity: fade,
      child: SlideTransition(position: animation.drive(tween), child: child),
    );
  }
}
