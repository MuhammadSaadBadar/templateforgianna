import 'package:flutter/material.dart';

import '../config/site_config.dart';
import '../core/app_theme.dart';
import '../widgets/reveal.dart';
import '../widgets/ui.dart';

class ServicesSection extends StatelessWidget {
  const ServicesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    return SectionShell(
      child: Column(children: [
        const SectionHeader(chip: 'Services', title: 'What I edit'),
        Reveal(
          child: ResponsiveGrid(
            desktop: 2,
            tablet: 2,
            children: [
              for (final s in siteConfig.services)
                Container(
                  constraints: const BoxConstraints(minHeight: 230),
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: c.card,
                    border: Border.all(color: c.stageLine),
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(s.name, style: display(context, 27, weight: FontWeight.w600, color: AppColors.onDark)),
                        const SizedBox(height: 10),
                        Text(s.description, style: body(context, color: AppColors.onDarkMuted)),
                      ]),
                      const SizedBox(height: 24),
                      Wrap(spacing: 8, runSpacing: 8, children: [
                        for (final t in s.tags)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                            decoration: BoxDecoration(
                              color: const Color(0xFF3A261A),
                              border: Border.all(color: const Color(0xFF54392A)),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(t, style: body(context, size: 14, color: AppColors.onDark, height: 1.3)),
                          ),
                      ]),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ]),
    );
  }
}
