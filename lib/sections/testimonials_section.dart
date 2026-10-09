import 'package:flutter/material.dart';

import '../config/site_config.dart';
import '../core/app_theme.dart';
import '../widgets/reveal.dart';
import '../widgets/ui.dart';

class TestimonialsSection extends StatelessWidget {
  const TestimonialsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    return SectionShell(
      tinted: true,
      child: Column(children: [
        const SectionHeader(chip: 'Testimonials', title: 'Creators who kept me on'),
        Reveal(
          child: ResponsiveGrid(
            desktop: 3,
            tablet: 1,
            children: [
              for (final t in siteConfig.testimonials)
                Container(
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: c.bg,
                    border: Border.all(color: c.line),
                    borderRadius: BorderRadius.circular(26),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('“${t.quote}”', style: display(context, 20, height: 1.4)),
                      const SizedBox(height: 22),
                      Text(t.result, style: body(context, size: 14, weight: FontWeight.w600, color: c.tan)),
                      const SizedBox(height: 14),
                      Row(children: [
                        InitialAvatar(t.name[0]),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(t.name, style: body(context, weight: FontWeight.w600, height: 1.2)),
                            Text('${t.channel}, ${t.audience}', style: body(context, size: 14, color: c.muted, height: 1.3)),
                          ]),
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
