import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

int _countCounter = 0;

/// Counts from 0 to [value] the first time it becomes visible.
class CountUp extends StatefulWidget {
  const CountUp({super.key, required this.value, required this.suffix, required this.style});
  final int value;
  final String suffix;
  final TextStyle style;

  @override
  State<CountUp> createState() => _CountUpState();
}

class _CountUpState extends State<CountUp> {
  final String _id = 'count-${_countCounter++}';
  bool _go = false;

  @override
  Widget build(BuildContext context) {
    final instant = MediaQuery.disableAnimationsOf(context);
    return VisibilityDetector(
      key: Key(_id),
      onVisibilityChanged: (info) {
        if (!_go && info.visibleFraction > .3) setState(() => _go = true);
      },
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0, end: (_go || instant) ? widget.value.toDouble() : 0),
        duration: instant ? Duration.zero : const Duration(milliseconds: 1200),
        curve: Curves.easeOutCubic,
        builder: (context, v, _) => Text('${v.round()}${widget.suffix}', style: widget.style),
      ),
    );
  }
}
