import 'package:flutter/material.dart';

import '../config/site_config.dart';
import '../core/app_theme.dart';
import '../core/links.dart';
import '../widgets/marquee.dart';
import '../widgets/reveal.dart';
import '../widgets/ui.dart';

class TrustSection extends StatelessWidget {
  const TrustSection({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    final creators = siteConfig.creators;
    final mid = (creators.length / 2).ceil();
    final firstHalf = creators.sublist(0, mid);
    final secondHalf = creators.sublist(mid);

    Widget buildCreatorCard(Creator cr) {
      return MouseRegion(
        cursor: cr.url.isEmpty ? MouseCursor.defer : SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => openLink(cr.url),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
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
      );
    }

    final itemExtent = context.isMobile ? 200.0 : 240.0;
    final height = context.isMobile ? 80.0 : 100.0;

    return SectionShell(
      child: Column(children: [
        SectionHeader(chip: 'Trusted by', title: siteConfig.trustHeading),
        Reveal(
          child: Column(
            children: [
              // First row: right to left (default)
              Marquee(
                itemExtent: itemExtent,
                height: height,
                duration: const Duration(seconds: 40),
                children: firstHalf.map(buildCreatorCard).toList(),
              ),
              const SizedBox(height: 16),
              // Second row: left to right (reverse)
              Marquee(
                itemExtent: itemExtent,
                height: height,
                duration: const Duration(seconds: 40),
                reverse: true,
                children: secondHalf.map(buildCreatorCard).toList(),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
