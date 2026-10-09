import 'package:flutter/material.dart';

import '../config/site_config.dart';
import '../core/app_theme.dart';
import '../core/links.dart';
import '../widgets/reveal.dart';
import '../widgets/ui.dart';

class TrustSection extends StatelessWidget {
  const TrustSection({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    return SectionShell(
      child: Column(children: [
        SectionHeader(chip: 'Trusted by', title: siteConfig.trustHeading),
        Reveal(
          child: ResponsiveGrid(
            desktop: 4,
            tablet: 2,
            children: [
              for (final cr in siteConfig.creators)
                MouseRegion(
                  cursor: cr.url.isEmpty ? MouseCursor.defer : SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () => openLink(cr.url),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: c.tint,
                        border: Border.all(color: c.line),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Row(children: [
                        InitialAvatar(cr.name[0], size: 44),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(cr.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: body(context, weight: FontWeight.w600, height: 1.2)),
                            Text(cr.subs, style: body(context, size: 14, weight: FontWeight.w600, color: c.tan)),
                          ]),
                        ),
                      ]),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ]),
    );
  }
}
