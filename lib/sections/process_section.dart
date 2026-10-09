import 'package:flutter/material.dart';

import '../config/site_config.dart';
import '../core/app_theme.dart';
import '../widgets/reveal.dart';
import '../widgets/ui.dart';

class ProcessSection extends StatelessWidget {
  const ProcessSection({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    final steps = siteConfig.steps;
    return SectionShell(
      child: Column(children: [
        const SectionHeader(chip: 'Process', title: 'How a project runs'),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: Column(children: [
            for (var i = 0; i < steps.length; i++)
              Reveal(
                child: Stack(
                  children: [
                    if (i != steps.length - 1)
                      Positioned(
                        left: 16.5,
                        top: 56,
                        bottom: 0,
                        child: Container(
                          width: 3,
                          color: c.accent.withOpacity(.6),
                        ),
                      ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: context.isMd ? 40 : 36,
                          child: Column(children: [
                            const SizedBox(height: 30),
                            Container(
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: c.tan,
                                boxShadow: [BoxShadow(color: c.bg, spreadRadius: 5), BoxShadow(color: c.tan, spreadRadius: 7)],
                              ),
                            ),
                          ]),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 22),
                            child: Container(
                              padding: const EdgeInsets.all(26),
                              decoration: BoxDecoration(
                                color: c.tint,
                                border: Border.all(color: c.line),
                                borderRadius: BorderRadius.circular(22),
                              ),
                              child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Text(steps[i].title, style: display(context, 24, weight: FontWeight.w600)),
                                const SizedBox(height: 6),
                                Text(steps[i].text, style: body(context, color: c.muted)),
                                const SizedBox(height: 10),
                                Text(steps[i].time, style: body(context, size: 14, weight: FontWeight.w600, color: c.tan)),
                              ]),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
          ]),
        ),
      ]),
    );
  }
}
