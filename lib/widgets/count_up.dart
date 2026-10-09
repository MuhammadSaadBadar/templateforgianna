import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

int _countCounter = 0;

/// Counts from 0 to [value] the first time it becomes visible.
/// If [controller] is provided, it will be used for the animation.
class CountUp extends StatefulWidget {
  const CountUp({
    super.key,
    required this.value,
    required this.suffix,
    required this.style,
    this.controller,
  });
  final int value;
  final String suffix;
  final TextStyle style;
  final AnimationController? controller;

  @override
  State<CountUp> createState() => _CountUpState();
}

class _CountUpState extends State<CountUp> with SingleTickerProviderStateMixin {
  final String _id = 'count-${_countCounter++}';
  bool _go = false;
  late AnimationController _localController;
  Animation<double>? _animation;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _localController = AnimationController(
        duration: const Duration(milliseconds: 1200),
        vsync: this,
      );
      _animation = Tween<double>(begin: 0, end: widget.value.toDouble()).animate(
        CurvedAnimation(parent: _localController, curve: Curves.easeOutCubic),
      );
    }
  }

  @override
  void didUpdateWidget(CountUp old) {
    super.didUpdateWidget(old);
    if (old.value != widget.value) {
      if (widget.controller != null) {
        // External controller - we can't easily reset it, so recreate animation
        _animation = Tween<double>(begin: 0, end: widget.value.toDouble()).animate(
          CurvedAnimation(parent: widget.controller!, curve: Curves.easeOutCubic),
        );
      } else {
        _animation = Tween<double>(begin: 0, end: widget.value.toDouble()).animate(
          CurvedAnimation(parent: _localController, curve: Curves.easeOutCubic),
        );
        _localController.reset();
        if (_go) _localController.forward();
      }
    }
  }

  @override
  void dispose() {
    _localController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final instant = MediaQuery.disableAnimationsOf(context);
    final controller = widget.controller ?? _localController;
    final animation = _animation ?? Tween<double>(begin: 0, end: widget.value.toDouble()).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeOutCubic),
    );

    return VisibilityDetector(
      key: Key(_id),
      onVisibilityChanged: (info) {
        if (!_go && info.visibleFraction > .3) {
          setState(() => _go = true);
          if (!instant) controller.forward(from: 0);
        }
      },
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, _) => Text('${animation.value.round()}${widget.suffix}', style: widget.style),
      ),
    );
  }
}
