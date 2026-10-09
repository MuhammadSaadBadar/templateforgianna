import 'package:flutter/material.dart';

import '../config/site_config.dart';
import '../core/app_theme.dart';
import '../core/links.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    final year = DateTime.now().year;
    return Padding(
      padding: EdgeInsets.fromLTRB(24, 48, 24, 48 + (context.isMobile ? 70 : 0)),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1180),
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            runSpacing: 16,
            spacing: 20,
            children: [
              Text('© $year ${siteConfig.editor.name}', style: body(context, size: 15, color: c.muted)),
              Wrap(spacing: 20, children: [
                for (final s in siteConfig.socials)
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () => openLink(s.url),
                      child: Text(s.label, style: body(context, size: 15, color: c.muted)),
                    ),
                  ),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
