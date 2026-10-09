import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

class LazySection extends StatefulWidget {
  const LazySection({
    super.key,
    required this.builder,
    this.visibleFraction = 0.05,
    this.placeholder,
  });
  final Widget Function(BuildContext) builder;
  final double visibleFraction;
  final Widget? placeholder;

  @override
  State<LazySection> createState() => _LazySectionState();
}

class _LazySectionState extends State<LazySection> {
  bool _mounted = false;
  late final String _id = 'lazy-section-${_LazySectionState._counter++}';
  static int _counter = 0;

  void _onVisibility(VisibilityInfo info) {
    if (!_mounted && info.visibleFraction >= widget.visibleFraction) {
      setState(() => _mounted = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key(_id),
      onVisibilityChanged: _onVisibility,
      child: _mounted
          ? widget.builder(context)
          : (widget.placeholder ?? const SizedBox(height: 1)),
    );
  }
}
