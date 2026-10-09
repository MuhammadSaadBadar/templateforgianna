import 'package:flutter/material.dart';

import '../config/site_config.dart';
import '../core/app_theme.dart';
import '../core/links.dart';
import '../widgets/reveal.dart';
import '../widgets/ui.dart';

class FinalCtaSection extends StatelessWidget {
  const FinalCtaSection({super.key});

  @override
  Widget build(BuildContext context) {
    final size = (context.w * 0.06).clamp(34.0, 68.0);
    return SectionShell(
      stage: true,
      child: Reveal(
        child: Column(children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 820),
            child: Text(siteConfig.finalHeading,
                textAlign: TextAlign.center, style: display(context, size, weight: FontWeight.w600, color: AppColors.onDark)),
          ),
          const SizedBox(height: 20),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Text(siteConfig.finalText,
                textAlign: TextAlign.center, style: body(context, color: AppColors.onDarkMuted)),
          ),
          const SizedBox(height: 34),
          AppButton(label: siteConfig.cta.label, onPressed: () => openLink(siteConfig.cta.url)),
        ]),
      ),
    );
  }
}
