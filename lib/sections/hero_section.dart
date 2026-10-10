import 'package:flutter/material.dart';

import '../config/site_config.dart';
import '../core/app_theme.dart';
import '../core/links.dart';
import '../widgets/marquee.dart';
import '../widgets/poster_image.dart';
import '../widgets/reveal.dart';
import '../widgets/ui.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key, required this.onWatchReel});
  final VoidCallback onWatchReel;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    final dark = context.isDark;
    final e = siteConfig.editor;
    
    // More sophisticated font sizing based on both width and height
    final size = (context.width * 0.08).clamp(42.0, 96.0); // enlarged font size
    final accent = dark
        ? const [Color(0xFFFBF7F3), Color(0xFFE2BE98), Color(0xFFBE895D)]
        : const [Color(0xFF9A6542), Color(0xFF5E3722)];

    return Stack(children: [
      Positioned.fill(
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: dark
                  ? [const Color(0xFF100906), c.bg]
                  : [const Color(0xFFF8F0E8), const Color(0xFFF2E7DC), c.bg],
            ),
          ),
        ),
      ),
      Positioned.fill(
        child: IgnorePointer(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0, -1.15),
                radius: 1.0,
                colors: [c.accent.withOpacity(dark ? .42 : .20), Colors.transparent],
              ),
            ),
          ),
        ),
      ),
      Column(children: [
        SizedBox(height: context.isXs ? 100 : (context.isSm ? 120 : 130)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: context.isXs ? 16 : 20),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: context.isXs ? 320 : 940),
            child: Reveal(
              child: Column(children: [
                Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text('Turning raw footage ', style: display(context, size, weight: FontWeight.w700).copyWith(fontFamily: 'Roboto')),
                    Text('into ', style: displaySerif(context, size, italic: true).copyWith(fontFamily: 'Times New Roman')),
                    Text('videos ', style: displaySerif(context, size).copyWith(fontFamily: 'Times New Roman')),
                    GradientText('people finish.', colors: accent, style: display(context, size, weight: FontWeight.w700).copyWith(fontFamily: 'Roboto')),
                  ],
                ),
                const SizedBox(height: 26),
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: context.isXs ? 280 : 620),
                  child: Text(e.subheadline,
                      textAlign: TextAlign.center, style: body(context, size: 19, color: c.muted)),
                ),
                const SizedBox(height: 34),
                Wrap(spacing: context.isXs ? 12 : 14, runSpacing: 12, alignment: WrapAlignment.center, children: [
                  AppButton(label: siteConfig.cta.label, onPressed: () => openLink(siteConfig.cta.url)),
                  AppButton(label: siteConfig.cta.secondaryLabel, primary: false, onPressed: onWatchReel),
                ]),
                const SizedBox(height: 38),
                _Proof(),
              ]),
            ),
          ),
        ),
        const SizedBox(height: 32),
        const _ClipStrip(),
        const SizedBox(height: 40),
      ]),
    ]);
  }
}

class _Proof extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final c = context.c;
    final names = siteConfig.creators.take(4).toList();
    return Wrap(spacing: context.isXs ? 10 : 14, runSpacing: context.isXs ? 8 : 10, alignment: WrapAlignment.center, crossAxisAlignment: WrapCrossAlignment.center, children: [
      SizedBox(
        width: context.isXs ? 36 + (names.length - 1) * 22.0 : 40 + (names.length - 1) * 29.0,
        height: context.isXs ? 36 : 40,
        child: Stack(children: [
          for (var i = 0; i < names.length; i++) Positioned(left: context.isXs ? i * 22.0 : i * 29.0, child: InitialAvatar(names[i].name[0], size: context.isXs ? 36 : 40)),
        ]),
      ),
      Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
        Text(siteConfig.proofText, style: body(context, size: context.isXs ? 14 : 15, weight: FontWeight.w600, height: 1.3)),
        Text(siteConfig.ratingText, style: body(context, size: context.isXs ? 12 : 14, color: c.muted, height: 1.3)),
      ]),
    ]);
  }
}

/// Auto-scrolling strip of poster frames under the hero.
class _ClipStrip extends StatelessWidget {
  const _ClipStrip();

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    const gap = 18.0;
    final tileW = context.width >= 480 ? 420.0 : (context.width * 0.85).clamp(280.0, 420.0);
    final height = context.isMobile ? 180.0 : 236.0;
    final projects = siteConfig.projects;
    return Marquee(
      itemExtent: tileW + gap,
      height: height + 12,
      children: [
        for (var i = 0; i < projects.length; i++)
          Padding(
            padding: const EdgeInsets.only(right: gap),
            child: Container(
              height: height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: c.line),
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(fit: StackFit.expand, children: [
                PosterImage(url: projects[i].poster, hue: 14.0 + i * 7),
                Positioned(
                  left: 14,
                  bottom: 12,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: context.isMobile ? 3 : 3),
                    decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(999)),
                    child: Text(projects[i].duration, style: body(context, size: context.isMobile ? 11 : 12, color: Colors.white, height: 1.3)),
                  ),
                ),
              ]),
            ),
          ),
      ],
    );
  }
}
