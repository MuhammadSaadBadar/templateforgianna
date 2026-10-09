import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../config/site_config.dart';
import '../core/app_theme.dart';
import '../widgets/preview_video.dart';
import '../widgets/project_dialog.dart';
import '../widgets/reveal.dart';
import '../widgets/ui.dart';

/// "Reel Index": a typographic project list on one side and a large stage that
/// plays the selected project's preview on the other. Click opens the full cut.
class WorkSection extends StatefulWidget {
  const WorkSection({super.key});

  @override
  State<WorkSection> createState() => _WorkSectionState();
}

class _WorkSectionState extends State<WorkSection> {
  int _selected = 0;
  final Map<int, VideoPlayerController> _controllers = {};

  Future<void> _ensureController(int index) async {
    if (_controllers.containsKey(index)) return;
    final p = siteConfig.projects[index];
    final ctl = VideoPlayerController.networkUrl(
      Uri.parse(p.preview),
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );
    _controllers[index] = ctl;
    try {
      await ctl.initialize();
      if (!mounted) return;
      await ctl.setVolume(0);
      await ctl.setLooping(true);
      await ctl.play();
    } catch (_) {
      // Keep showing the poster if the preview cannot play.
    }
  }

  void _select(int index) {
    setState(() => _selected = index);
    _ensureController(index);
    // Preload adjacent
    if (index > 0) _ensureController(index - 1);
    if (index < siteConfig.projects.length - 1) _ensureController(index + 1);
  }

  void _open(int i) {
    _select(i);
    showProjectDialog(context, siteConfig.projects[i]);
  }

  @override
  void dispose() {
    for (final ctl in _controllers.values) {
      ctl.dispose();
    }
    _controllers.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final index = _Index(selected: _selected, onSelect: _select, onOpen: _open);
    final stage = _Stage(index: _selected, onOpen: () => _open(_selected), getController: (i) => _controllers[i]);
    final desktop = !context.isMd;

    return SectionShell(
      stage: true,
      child: Column(children: [
        SectionHeader(chip: 'Portfolio', title: 'Selected work', subtitle: siteConfig.workIntro, onDark: true),
        Reveal(
          child: desktop
              ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Expanded(flex: 5, child: index),
                  const SizedBox(width: 44),
                  Expanded(flex: 7, child: stage),
                ])
              : Column(children: [stage, const SizedBox(height: 24), index]),
        ),
      ]),
    );
  }
}

class _Index extends StatelessWidget {
  const _Index({required this.selected, required this.onSelect, required this.onOpen});
  final int selected;
  final ValueChanged<int> onSelect, onOpen;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    final projects = siteConfig.projects;
    return Column(children: [
      for (var i = 0; i < projects.length; i++)
        MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => onSelect(i),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => onOpen(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              padding: EdgeInsets.fromLTRB(selected == i ? 16 : 4, 20, 4, 20),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: c.stageLine),
                  bottom: i == projects.length - 1 ? BorderSide(color: c.stageLine) : BorderSide.none,
                ),
              ),
              child: Row(children: [
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(projects[i].title,
                        style: display(context, context.isXs ? 22 : 26,
                            weight: FontWeight.w600,
                            color: selected == i ? AppColors.onDark : const Color(0xFFA99483))),
                    const SizedBox(height: 4),
                    Text('${projects[i].client} · ${projects[i].role}',
                        style: body(context, size: context.isXs ? 12 : 14, color: const Color(0xFFA99483))),
                  ]),
                ),
                const SizedBox(width: 16),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Text(projects[i].resultValue,
                      style: body(context, size: context.isXs ? 14 : 16, weight: FontWeight.w600, color: selected == i ? const Color(0xFFE2BE98) : const Color(0xFFA99483))),
                  Text(projects[i].resultLabel, style: body(context, size: context.isXs ? 10 : 12, color: const Color(0xFFA99483))),
                ]),
              ]),
            ),
          ),
        ),
    ]);
  }
}

class _Stage extends StatelessWidget {
  const _Stage({required this.index, required this.onOpen, required this.getController});
  final int index;
  final VoidCallback onOpen;
  final VideoPlayerController? Function(int) getController;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    final p = siteConfig.projects[index];
    final controller = getController(index);
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onOpen,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26),
            border: Border.all(color: c.stageLine),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(.4), blurRadius: 70, offset: const Offset(0, 30))],
          ),
          clipBehavior: Clip.antiAlias,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final aspectRatio = constraints.maxWidth > 0
                  ? (16 / 10).clamp(1.2, 2.0)
                  : 16 / 10;
              final maxHeight = context.isMobile ? constraints.maxWidth * 0.8 : constraints.maxWidth * 1.2;
              return ConstrainedBox(
                constraints: BoxConstraints(maxHeight: maxHeight),
                child: AspectRatio(
                  aspectRatio: aspectRatio,
                  child: Stack(fit: StackFit.expand, children: [
                    // Use PreviewVideo with the cached controller
                    PreviewVideo(
                      key: ValueKey('preview-$index'),
                      url: p.preview,
                      poster: p.poster,
                      active: true,
                      hue: 14.0 + index * 7,
                      controller: controller,
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: EdgeInsets.all(context.isMobile ? 16 : 22),
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Color(0xE0140A05)]),
                        ),
                        child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                          Expanded(
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                              Text(p.title, style: display(context, context.isMobile ? 18 : 21, weight: FontWeight.w600, color: AppColors.onDark)),
                              Text('${p.client} · ${p.resultValue} ${p.resultLabel}',
                                  style: body(context, size: context.isMobile ? 12 : 14, color: AppColors.onDarkMuted)),
                            ]),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            width: context.isMobile ? 50 : 60,
                            height: context.isMobile ? 50 : 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(.14),
                              border: Border.all(color: Colors.white.withOpacity(.28)),
                            ),
                            child: Icon(Icons.play_arrow_rounded, color: AppColors.onDark, size: context.isMobile ? 28 : 34),
                          ),
                        ]),
                      ),
                    ),
                  ]),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
