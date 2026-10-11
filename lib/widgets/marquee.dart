import 'dart:math';
import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// Endlessly scrolling horizontal strip with manual scroll support.
/// Every child is given [itemExtent] width (include the gap in it).
/// Pass enough children to cover roughly one screen width.
class Marquee extends StatefulWidget {
  const Marquee({
    super.key,
    required this.children,
    required this.itemExtent,
    required this.height,
    this.duration = const Duration(seconds: 60),
    this.reverse = false,
  });
  final List<Widget> children;
  final double itemExtent, height;
  final Duration duration;
  final bool reverse;

  @override
  State<Marquee> createState() => _MarqueeState();
}

class _MarqueeState extends State<Marquee> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: widget.duration,
  );
  late final ScrollController _scrollController = ScrollController();
  int _duplicateCount = 3;
  bool _visible = false;
  bool _userInteracting = false;
  late final String _id = 'marquee-${_MarqueeState._counter++}';
  static int _counter = 0;

  @override
  void initState() {
    super.initState();
    _c.addListener(_onAnimationTick);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateDuplicateCount();
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
      if (_visible && !_userInteracting) {
        if (!_c.isAnimating) _c.repeat();
      } else {
        _c.stop();
      }
    }
  }

  void _onAnimationTick() {
    if (!_userInteracting && _scrollController.hasClients) {
      final total = widget.children.length * widget.itemExtent;
      final maxScroll = total * _duplicateCount;
      double currentOffset = _scrollController.offset;
      final pixelsPerTick = total / (widget.duration.inMilliseconds / 16.67);

      if (widget.reverse) {
        currentOffset += pixelsPerTick;
        if (currentOffset >= maxScroll) {
          currentOffset -= total;
        }
      } else {
        currentOffset -= pixelsPerTick;
        if (currentOffset <= 0) {
          currentOffset += total;
        }
      }
      _scrollController.jumpTo(currentOffset.clamp(0.0, maxScroll));
    }
  }

  void _onPointerDown(PointerDownEvent _) {
    setState(() => _userInteracting = true);
    _c.stop();
  }

  void _onPointerUp(PointerUpEvent _) {
    setState(() => _userInteracting = false);
    if (_visible && !MediaQuery.disableAnimationsOf(context)) {
      _c.repeat();
    }
  }

  void _onPointerCancel(PointerCancelEvent _) {
    setState(() => _userInteracting = false);
    if (_visible && !MediaQuery.disableAnimationsOf(context)) {
      _c.repeat();
    }
  }

  @override
  void dispose() {
    _c.removeListener(_onAnimationTick);
    _c.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) {
      _c.stop();
    } else if (!_c.isAnimating && _visible && !_userInteracting) {
      _c.repeat();
    }

    final total = widget.children.length * widget.itemExtent;
    final itemWidth = widget.itemExtent;

    return VisibilityDetector(
      key: Key(_id),
      onVisibilityChanged: _onVisibility,
      child: ExcludeSemantics(
        child: ClipRect(
          child: SizedBox(
            height: widget.height,
            child: Listener(
              onPointerDown: _onPointerDown,
              onPointerUp: _onPointerUp,
              onPointerCancel: _onPointerCancel,
              behavior: HitTestBehavior.translucent,
              child: NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if (notification is ScrollUpdateNotification) {
                    final maxScroll = total * _duplicateCount;
                    if (_scrollController.offset >= maxScroll - total) {
                      _scrollController.jumpTo(_scrollController.offset - total);
                    } else if (_scrollController.offset <= 0) {
                      _scrollController.jumpTo(_scrollController.offset + total);
                    }
                  }
                  return false;
                },
                child: ListView.builder(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  physics: const ClampingScrollPhysics(),
                  itemCount: widget.children.length * _duplicateCount,
                  itemBuilder: (context, index) {
                    final childIndex = index % widget.children.length;
                    return SizedBox(
                      width: itemWidth,
                      child: widget.children[childIndex],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
