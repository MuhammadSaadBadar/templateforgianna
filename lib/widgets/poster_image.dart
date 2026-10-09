import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

int _posterCounter = 0;

/// Poster frame for a video, with a warm-brown gradient fallback while loading
/// or if the image URL is empty/broken. Supports lazy loading and explicit dimensions.
class PosterImage extends StatefulWidget {
  const PosterImage({
    super.key,
    required this.url,
    this.hue = 25,
    this.width,
    this.height,
    this.cacheWidth,
    this.cacheHeight,
  });
  final String url;
  final double hue;
  final double? width;
  final double? height;
  final int? cacheWidth;
  final int? cacheHeight;

  Widget _fallback(double hue) => DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              HSLColor.fromAHSL(1, hue, .52, .38).toColor(),
              HSLColor.fromAHSL(1, hue + 14, .48, .14).toColor(),
            ],
          ),
        ),
      );

  @override
  State<PosterImage> createState() => _PosterImageState();
}

class _PosterImageState extends State<PosterImage> {
  bool _visible = false;
  late final String _id = 'poster-${_posterCounter++}';

  void _onVisibility(VisibilityInfo info) {
    if (!_visible && info.visibleFraction > 0.05) {
      setState(() => _visible = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.url.isEmpty) {
      return widget._fallback(widget.hue);
    }

    return VisibilityDetector(
      key: Key(_id),
      onVisibilityChanged: _onVisibility,
      child: _visible
          ? Image.network(
              widget.url,
              width: widget.width,
              height: widget.height,
              fit: BoxFit.cover,
              cacheWidth: widget.cacheWidth,
              cacheHeight: widget.cacheHeight,
              errorBuilder: (_, __, ___) => widget._fallback(widget.hue),
              loadingBuilder: (context, child, progress) =>
                  progress == null ? child : widget._fallback(widget.hue),
            )
          : widget._fallback(widget.hue),
    );
  }
}
