import 'package:flutter/material.dart';

class AncestorWidget extends InheritedWidget {
  const AncestorWidget({
    super.key,
    required Widget child,
    required this.reference,
  }) : super(child: child);

  final Widget reference;

  @override
  bool updateShouldNotify(covariant AncestorWidget oldWidget) {
    return reference != oldWidget.reference;
  }

  static AncestorWidget? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AncestorWidget>();
  }
}
