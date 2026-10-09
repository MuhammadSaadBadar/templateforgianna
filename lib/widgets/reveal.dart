import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

int _revealCounter = 0;

/// Fades and slides its child in once, the first time it scrolls into view.
class Reveal extends StatefulWidget {
  const Reveal({super.key, required this.child, this.delay = Duration.zero});
  final Widget child;
  final Duration delay;

  @override
  State<Reveal> createState() => _RevealState();
}

class _RevealState extends State<Reveal> {
  final String _id = 'reveal-${_revealCounter++}';
  bool _shown = false;

  void _onVisible(VisibilityInfo info) {
    if (_shown || info.visibleFraction < 0.1) return;
    Future<void>.delayed(widget.delay, () {
      if (mounted) setState(() => _shown = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) return widget.child;
    return VisibilityDetector(
      key: Key(_id),
      onVisibilityChanged: _onVisible,
      child: AnimatedOpacity(
        opacity: _shown ? 1 : 0,
        duration: const Duration(milliseconds: 650),
        curve: Curves.easeOut,
        child: AnimatedSlide(
          offset: _shown ? Offset.zero : const Offset(0, .05),
          duration: const Duration(milliseconds: 650),
          curve: Curves.easeOutCubic,
          child: widget.child,
        ),
      ),
    );
  }
}
