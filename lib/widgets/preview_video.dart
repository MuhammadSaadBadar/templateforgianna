import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'poster_image.dart';

/// Muted, looping preview. The video controller is only created while [active]
/// is true and disposed as soon as it is not, so lists stay light on memory/data.
/// If [controller] is provided, it will be used instead of creating a new one.
class PreviewVideo extends StatefulWidget {
  const PreviewVideo({
    super.key,
    required this.url,
    required this.poster,
    required this.active,
    this.hue = 25,
    this.controller,
  });
  final String url, poster;
  final bool active;
  final double hue;
  final VideoPlayerController? controller;

  @override
  State<PreviewVideo> createState() => _PreviewVideoState();
}

class _PreviewVideoState extends State<PreviewVideo> {
  VideoPlayerController? _ctl;
  bool _ready = false;
  bool _ownsController = false;

  @override
  void initState() {
    super.initState();
    if (widget.active) _start();
  }

  @override
  void didUpdateWidget(PreviewVideo old) {
    super.didUpdateWidget(old);
    if (old.active != widget.active || old.url != widget.url || old.controller != widget.controller) {
      _stop();
      if (widget.active) _start();
    }
  }

  Future<void> _start() async {
    // Use provided controller or create new one
    if (widget.controller != null) {
      _ctl = widget.controller;
      _ownsController = false;
      if (!_ctl!.value.isInitialized) {
        try {
          await _ctl!.initialize();
        } catch (_) {
          return;
        }
      }
      await _ctl!.setVolume(0);
      await _ctl!.setLooping(true);
      await _ctl!.play();
      if (mounted) setState(() => _ready = true);
      return;
    }

    _ownsController = true;
    final ctl = VideoPlayerController.networkUrl(
      Uri.parse(widget.url),
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );
    _ctl = ctl;
    try {
      await ctl.initialize();
      if (!mounted || _ctl != ctl) return; // already disposed by _stop()
      await ctl.setVolume(0);
      await ctl.setLooping(true);
      await ctl.play();
      if (mounted && _ctl == ctl) setState(() => _ready = true);
    } catch (_) {
      // Keep showing the poster if the preview cannot play.
    }
  }

  void _stop() {
    final ctl = _ctl;
    if (_ownsController) {
      _ctl = null;
      _ready = false;
      ctl?.dispose();
    } else {
      // Don't dispose external controller, just pause
      ctl?.pause();
      _ctl = null;
      _ready = false;
    }
  }

  @override
  void dispose() {
    _stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ctl = _ctl;
    return Stack(
      fit: StackFit.expand,
      children: [
        PosterImage(url: widget.poster, hue: widget.hue),
        if (_ready && ctl != null)
          FittedBox(
            fit: BoxFit.cover,
            clipBehavior: Clip.hardEdge,
            child: SizedBox(width: ctl.value.size.width, height: ctl.value.size.height, child: VideoPlayer(ctl)),
          ),
      ],
    );
  }
}
