import 'package:flutter/material.dart';

import '../config/site_config.dart';
import '../core/app_theme.dart';
import '../widgets/count_up.dart';
import '../widgets/reveal.dart';
import '../widgets/ui.dart';

class ResultsSection extends StatefulWidget {
  const ResultsSection({super.key});

  @override
  State<ResultsSection> createState() => _ResultsSectionState();
}

class _ResultsSectionState extends State<ResultsSection> with SingleTickerProviderStateMixin {
  late final AnimationController _countController = AnimationController(
    duration: const Duration(milliseconds: 1200),
    vsync: this,
  );

  @override
  void dispose() {
    _countController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    final size = (context.w * 0.1).clamp(52.0, 96.0);
    return SectionShell(
      child: Column(children: [
        const SectionHeader(chip: 'Results', title: 'What the edits did for their channels'),
        Reveal(
          child: Container(
            decoration: BoxDecoration(border: Border(top: BorderSide(color: c.line))),
            child: ResponsiveGrid(
              desktop: 3,
              tablet: 3,
              spacing: 0,
              children: [
                for (final s in siteConfig.stats)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 12),
                    child: Column(children: [
                      ShaderMask(
                        blendMode: BlendMode.srcIn,
                        shaderCallback: (r) => LinearGradient(
                          colors: context.isDark
                              ? const [Color(0xFFE2BE98), Color(0xFFB07A52)]
                              : const [Color(0xFF9A6542), Color(0xFF5E3722)],
                        ).createShader(Rect.fromLTWH(0, 0, r.width, r.height)),
                        child: CountUp(
                          value: s.value,
                          suffix: s.suffix,
                          style: display(context, size, weight: FontWeight.w600, color: Colors.white),
                          controller: _countController,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(s.label, textAlign: TextAlign.center, style: body(context, color: c.muted)),
                    ]),
                  ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
