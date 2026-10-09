import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../config/site_config.dart';
import '../core/app_theme.dart';
import '../core/links.dart';
import 'poster_image.dart';
import 'ui.dart';

/// Full-screen viewer: full video with controls, brief, tags and result.
Future<void> showProjectDialog(BuildContext context, Project project) {
  return showGeneralDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Close project',
    barrierColor: const Color(0xF0120A06),
    transitionDuration: const Duration(milliseconds: 220),
    pageBuilder: (context, _, __) => Material(
      type: MaterialType.transparency,
      child: ProjectDialog(project: project),
    ),
    transitionBuilder: (context, anim, _, child) =>
        FadeTransition(opacity: anim, child: child),
  );
}

class ProjectDialog extends StatefulWidget {
  const ProjectDialog({super.key, required this.project});
  final Project project;

  @override
  State<ProjectDialog> createState() => _ProjectDialogState();
}

class _ProjectDialogState extends State<ProjectDialog> {
  VideoPlayerController? _ctl;
  bool _failed = false;
  bool _muted = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _failed = false);
    final ctl = VideoPlayerController.networkUrl(
      Uri.parse(widget.project.full),
    );
    _ctl = ctl;
    try {
      await ctl.initialize();
      if (!mounted || _ctl != ctl) return;
      await ctl.setLooping(true);
      await ctl.play(); // opened by a tap, so playback with sound is allowed
      setState(() {});
    } catch (_) {
      if (mounted && _ctl == ctl) setState(() => _failed = true);
    }
  }

  @override
  void dispose() {
    final ctl = _ctl;
    _ctl = null;
    ctl?.dispose();
    super.dispose();
  }

  void _toggleMute() {
    _muted = !_muted;
    _ctl?.setVolume(_muted ? 0 : 1);
    setState(() {});
  }

  Widget _player(BuildContext context) {
    final p = widget.project;
    final ctl = _ctl;
    final ready = ctl != null && ctl.value.isInitialized;
    final ratio = ready
        ? ctl.value.aspectRatio
        : (p.vertical ? 9 / 16 : 16 / 9);

    final maxH = MediaQuery.sizeOf(context).height * (p.vertical ? .72 : .6);
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxH),
      child: AspectRatio(
        aspectRatio: ratio,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              PosterImage(url: p.poster),
              if (ready) VideoPlayer(ctl),
              if (!ready && !_failed)
                const Center(
                  child: CircularProgressIndicator(color: AppColors.onDark),
                ),
              if (_failed)
                Container(
                  color: Colors.black54,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Could not load this video. Check the Cloudinary link.',
                        textAlign: TextAlign.center,
                        style: body(context, color: AppColors.onDark),
                      ),
                      const SizedBox(height: 14),
                      AppButton(
                        label: 'Try again',
                        onPressed: _load,
                        compact: true,
                      ),
                    ],
                  ),
                ),
              if (ready)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    color: Colors.black54,
                    padding: const EdgeInsets.fromLTRB(8, 4, 12, 4),
                    child: Row(
                      children: [
                        ValueListenableBuilder<VideoPlayerValue>(
                          valueListenable: ctl,
                          builder: (context, v, _) => IconButton(
                            tooltip: v.isPlaying ? 'Pause' : 'Play',
                            color: AppColors.onDark,
                            icon: Icon(
                              v.isPlaying ? Icons.pause : Icons.play_arrow,
                            ),
                            onPressed: () =>
                                v.isPlaying ? ctl.pause() : ctl.play(),
                          ),
                        ),
                        Expanded(
                          child: VideoProgressIndicator(
                            ctl,
                            allowScrubbing: true,
                            colors: const VideoProgressColors(
                              playedColor: Color(0xFFD2A97F),
                              bufferedColor: Color(0x55FFFFFF),
                              backgroundColor: Color(0x33FFFFFF),
                            ),
                          ),
                        ),
                        IconButton(
                          tooltip: _muted ? 'Unmute' : 'Mute',
                          color: AppColors.onDark,
                          icon: Icon(
                            _muted ? Icons.volume_off : Icons.volume_up,
                          ),
                          onPressed: _toggleMute,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.project;
    final wide =
        context.isMd; // Use medium breakpoint (tablet and up) for wide layout

    final details = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(p.title, style: display(context, 32, color: AppColors.onDark)),
        const SizedBox(height: 10),
        Text(p.brief, style: body(context, color: AppColors.onDarkMuted)),
        const SizedBox(height: 14),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final t in p.tags)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF54392A)),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  t,
                  style: body(context, size: 13, color: AppColors.onDarkMuted),
                ),
              ),
          ],
        ),
      ],
    );

    final result = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GradientText(
          p.resultValue,
          textAlign: TextAlign.left,
          style: display(context, 46, weight: FontWeight.w600),
          colors: const [Color(0xFFE2BE98), Color(0xFFB07A52)],
        ),
        Text(p.resultLabel, style: body(context, color: AppColors.onDarkMuted)),
        const SizedBox(height: 14),
        Text(
          'Client: ${p.client}',
          style: body(context, size: 14, color: AppColors.onDarkMuted),
        ),
        Text(
          'Role: ${p.role}',
          style: body(context, size: 14, color: AppColors.onDarkMuted),
        ),
        const SizedBox(height: 18),
        AppButton(
          label: siteConfig.cta.label,
          onPressed: () => openLink(siteConfig.cta.url),
          compact: true,
        ),
      ],
    );

    return SafeArea(
      child: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 64, 20, 32),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1000),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _player(context),
                    const SizedBox(height: 26),
                    if (wide)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 2, child: details),
                          const SizedBox(width: 32),
                          Expanded(child: result),
                        ],
                      )
                    else ...[
                      details,
                      const SizedBox(height: 22),
                      Align(alignment: Alignment.centerLeft, child: result),
                    ],
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 12,
            right: 12,
            child: IconButton.outlined(
              tooltip: 'Close',
              onPressed: () => Navigator.of(context).pop(),
              style: IconButton.styleFrom(
                foregroundColor: AppColors.onDark,
                side: const BorderSide(color: Color(0xFF54392A)),
                backgroundColor: const Color(0xFF2A1A10),
              ),
              icon: const Icon(Icons.close),
            ),
          ),
        ],
      ),
    );
  }
}
