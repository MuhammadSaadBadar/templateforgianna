import 'package:flutter/material.dart';

import '../config/site_config.dart';
import '../core/app_theme.dart';
import '../core/links.dart';
import '../sections/faq_section.dart';
import '../sections/final_cta_section.dart';
import '../sections/footer_section.dart';
import '../sections/hero_section.dart';
import '../sections/nav_bar.dart';
import '../sections/packages_section.dart';
import '../sections/positioning_section.dart';
import '../sections/process_section.dart';
import '../sections/results_section.dart';
import '../sections/services_section.dart';
import '../sections/testimonials_section.dart';
import '../sections/trust_section.dart';
import '../sections/work_section.dart';
import '../widgets/project_dialog.dart';
import '../widgets/ui.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _keys = {for (final id in ['work', 'services', 'process', 'faq']) id: GlobalKey()};

  void _goTo(String id) {
    final ctx = _keys[id]?.currentContext;
    if (ctx == null) return;
    Scrollable.ensureVisible(ctx, duration: const Duration(milliseconds: 650), curve: Curves.easeInOutCubic, alignment: 0.02);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        SingleChildScrollView(
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            HeroSection(onWatchReel: () => showProjectDialog(context, siteConfig.projects.first)),
            const TrustSection(),
            KeyedSubtree(key: _keys['work'], child: const WorkSection()),
            const ResultsSection(),
            KeyedSubtree(key: _keys['services'], child: const Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [PositioningSection(), ServicesSection()])),
            KeyedSubtree(key: _keys['process'], child: const ProcessSection()),
            const TestimonialsSection(),
            if (siteConfig.showPackages) const PackagesSection(),
            KeyedSubtree(key: _keys['faq'], child: const FaqSection()),
            const FinalCtaSection(),
            const FooterSection(),
          ]),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 14),
              child: Center(child: NavBar(onNavigate: _goTo)),
            ),
          ),
        ),
        if (context.isMobile)
          Positioned(
            left: 14,
            right: 14,
            bottom: 14,
            child: SafeArea(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: SizedBox(
                    width: double.infinity,
                    child: AppButton(label: siteConfig.cta.label, expand: true, onPressed: () => openLink(siteConfig.cta.url)),
                  ),
                ),
              ),
            ),
          ),
      ]),
    );
  }
}
