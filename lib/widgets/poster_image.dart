import 'package:flutter/material.dart';

/// Poster frame for a video, with a warm-brown gradient fallback while loading
/// or if the image URL is empty/broken.
class PosterImage extends StatelessWidget {
  const PosterImage({super.key, required this.url, this.hue = 25});
  final String url;
  final double hue;

  Widget _fallback() => DecoratedBox(
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
  Widget build(BuildContext context) {
    if (url.isEmpty) return _fallback();
    return Image.network(
      url,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _fallback(),
      loadingBuilder: (context, child, progress) => progress == null ? child : _fallback(),
    );
  }
}
