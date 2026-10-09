import 'dart:ui';
import 'package:flutter/material.dart';

import '../config/site_config.dart';
import '../core/app_theme.dart';
import '../core/links.dart';
import '../widgets/ui.dart';

/// Floating pill navigation. `onNavigate` receives a section id.
class NavBar extends StatelessWidget {
  const NavBar({super.key, required this.onNavigate});
  final void Function(String id) onNavigate;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    final links = <(String, String)>[('Work', 'work'), ('Services', 'services'), ('Process', 'process'), ('FAQ', 'faq')];
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 940),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
            child: Container(
              padding: const EdgeInsets.fromLTRB(22, 8, 8, 8),
              decoration: BoxDecoration(
                color: c.bg.withOpacity(.78),
                border: Border.all(color: c.line),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Row(children: [
                Text(siteConfig.editor.name, style: display(context, 19, weight: FontWeight.w600)),
                const Spacer(),
                if (!context.isMobile)
                  for (final l in links)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () => onNavigate(l.$2),
                          child: Text(l.$1, style: body(context, size: 15, weight: FontWeight.w500, color: c.muted)),
                        ),
                      ),
                    ),
                const SizedBox(width: 8),
                IconButton(
                  tooltip: 'Toggle light or dark theme',
                  onPressed: themeController.toggle,
                  icon: Icon(context.isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined, color: c.ink),
                ),
                AppButton(label: siteConfig.cta.label, compact: true, onPressed: () => openLink(siteConfig.cta.url)),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
