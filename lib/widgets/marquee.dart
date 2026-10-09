import 'dart:math';
import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// Endlessly scrolling horizontal strip. Every child is given [itemExtent] width
/// (include the gap in it). Pass enough children to cover roughly one screen width.
class Marquee extends StatefulWidget {
  const Marquee({
    super.key,
    required this.children,
    required this.itemExtent,
    required this.height,
    this.duration = const Duration(seconds: 60),
  });
  final List<Widget> children;
  final double itemExtent, height;
  final Duration duration;

  @override
  State<Marquee> createState() => _MarqueeState();
}

class _MarqueeState extends State<Marquee> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: widget.duration,
  );
  int _duplicateCount = 3;
  bool _visible = false;
  late final String _id = 'marquee-${_MarqueeState._counter++}';
  static int _counter = 0;

  @override
  void initState() {
    super.initState();
    _updateDuplicateCount();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _updateDuplicateCount(),
    );
  }

  void _updateDuplicateCount() {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final tileWithGap = widget.itemExtent + 20.0;
    final minDuplicates = (screenWidth / tileWithGap).ceil() + 2;
    final maxDuplicates = 6;
    final newCount = min(maxDuplicates, minDuplicates).clamp(2, 6);

    if (newCount != _duplicateCount && mounted) {
      setState(() => _duplicateCount = newCount);
    }
  }

  void _onVisibility(VisibilityInfo info) {
    final wasVisible = _visible;
    _visible = info.visibleFraction > 0.1;
    if (_visible != wasVisible) {
      if (_visible) {
        if (!_c.isAnimating) _c.repeat();
      } else {
        _c.stop();
      }
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) {
      _c.stop();
    } else if (!_c.isAnimating && _visible) {
      _c.repeat();
    }

    final total = widget.children.length * widget.itemExtent;
    final row = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var copy = 0; copy < _duplicateCount; copy++)
          for (final child in widget.children)
            SizedBox(width: widget.itemExtent, child: child),
      ],
    );
    return VisibilityDetector(
      key: Key(_id),
      onVisibilityChanged: _onVisibility,
      child: ExcludeSemantics(
        child: ClipRect(
          child: SizedBox(
            height: widget.height,
            child: AnimatedBuilder(
              animation: _c,
              child: row,
              builder: (context, child) => OverflowBox(
                alignment: Alignment.centerLeft,
                minWidth: 0,
                maxWidth: double.infinity,
                child: Transform.translate(
                  offset: Offset(-_c.value * total, 0),
                  child: child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
