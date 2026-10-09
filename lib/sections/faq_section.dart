import 'package:flutter/material.dart';

import '../config/site_config.dart';
import '../core/app_theme.dart';
import '../widgets/reveal.dart';
import '../widgets/ui.dart';

class FaqSection extends StatelessWidget {
  const FaqSection({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    return SectionShell(
      child: Column(children: [
        const SectionHeader(chip: 'FAQ', title: 'Questions before you book'),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 780),
          child: Reveal(
            child: Theme(
              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: Column(children: [
                for (final f in siteConfig.faqs)
                  Container(
                    decoration: BoxDecoration(border: Border(bottom: BorderSide(color: c.line))),
                    child: ExpansionTile(
                      tilePadding: const EdgeInsets.symmetric(vertical: 10),
                      childrenPadding: const EdgeInsets.only(bottom: 20),
                      expandedCrossAxisAlignment: CrossAxisAlignment.start,
                      iconColor: c.tan,
                      collapsedIconColor: c.tan,
                      shape: const Border(),
                      collapsedShape: const Border(),
                      title: Text(f.q, style: display(context, 21, weight: FontWeight.w600)),
                      children: [Text(f.a, style: body(context, color: c.muted))],
                    ),
                  ),
              ]),
            ),
          ),
        ),
      ]),
    );
  }
}
