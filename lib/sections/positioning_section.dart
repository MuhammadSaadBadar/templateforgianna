import 'package:flutter/material.dart';

import '../config/site_config.dart';
import '../core/app_theme.dart';
import '../widgets/reveal.dart';
import '../widgets/ui.dart';

/// "The usual editor" vs "working with me".
class PositioningSection extends StatelessWidget {
  const PositioningSection({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    final first = siteConfig.editor.name.split(' ').first;

    Widget card({required String title, required List<String> items, required bool mine}) {
      final fg = mine ? Colors.white : c.ink;
      final padding = context.isMobile
          ? const EdgeInsets.symmetric(horizontal: 20, vertical: 24)
          : const EdgeInsets.all(30);
      final titleSize = context.isMobile ? 24.0 : 26.0;
      final itemSpacing = context.isMobile ? 10.0 : 12.0;
      final iconSize = context.isMobile ? 16.0 : 20.0;
      
      return Container(
        padding: padding,
        decoration: BoxDecoration(
          gradient: mine ? c.buttonGradient : null,
          color: mine ? null : c.tint,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: mine ? c.tan.withOpacity(.25) : c.line),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: display(context, titleSize, weight: FontWeight.w600, color: fg)),
          SizedBox(height: context.isMobile ? 14.0 : 18.0),
          for (final item in items)
            Padding(
              padding: EdgeInsets.only(bottom: itemSpacing),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(mine ? '✓' : '✕', style: body(context, weight: FontWeight.w700, color: mine ? Colors.white : c.muted, size: context.isMobile ? iconSize : 20.0)),
                SizedBox(width: context.isMobile ? 10.0 : 12.0),
                Expanded(child: Text(item, style: body(context, color: fg, size: context.isMobile ? 14.0 : 16.0))),
              ]),
            ),
        ]),
      );
    }

    return SectionShell(
      tinted: true,
      child: Column(children: [
        const SectionHeader(chip: 'Why me', title: 'Not every editor is built the same'),
        Reveal(
          child: ResponsiveGrid(desktop: 2, tablet: 2, children: [
            card(title: 'The usual editor', items: siteConfig.typical, mine: false),
            card(title: 'Working with $first', items: siteConfig.mine, mine: true),
          ]),
        ),
      ]),
    );
  }
}
