import 'package:flutter/material.dart';

import '../config/site_config.dart';
import '../core/app_theme.dart';
import '../core/links.dart';
import '../widgets/reveal.dart';
import '../widgets/ui.dart';

class PackagesSection extends StatelessWidget {
  const PackagesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    return SectionShell(
      child: Column(children: [
        const SectionHeader(chip: 'Pricing', title: 'Simple packages'),
        Reveal(
          child: ResponsiveGrid(
            desktop: 3,
            tablet: 1,
            children: [
              for (final t in siteConfig.tiers)
                Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: t.popular ? c.tint : null,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: t.popular ? c.accent : c.line, width: t.popular ? 2 : 1),
                    boxShadow: t.popular ? [BoxShadow(color: c.accent.withOpacity(.25), blurRadius: 50, offset: const Offset(0, 24))] : null,
                  ),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      Expanded(child: Text(t.name, style: display(context, 24, weight: FontWeight.w600))),
                      if (t.popular)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                          decoration: BoxDecoration(gradient: c.buttonGradient, borderRadius: BorderRadius.circular(999)),
                          child: Text('Most booked', style: body(context, size: 13, weight: FontWeight.w600, color: Colors.white, height: 1.3)),
                        ),
                    ]),
                    const SizedBox(height: 14),
                    Text.rich(TextSpan(children: [
                      TextSpan(text: t.price, style: display(context, 48, weight: FontWeight.w600)),
                      if (t.unit.isNotEmpty) TextSpan(text: ' ${t.unit}', style: body(context, color: c.muted)),
                    ])),
                    const SizedBox(height: 18),
                    for (final f in t.features)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text('✓', style: body(context, weight: FontWeight.w700, color: c.tan)),
                          const SizedBox(width: 10),
                          Expanded(child: Text(f, style: body(context))),
                        ]),
                      ),
                    const SizedBox(height: 14),
                    AppButton(label: siteConfig.cta.label, primary: t.popular, onPressed: () => openLink(siteConfig.cta.url)),
                  ]),
                ),
            ],
          ),
        ),
      ]),
    );
  }
}
