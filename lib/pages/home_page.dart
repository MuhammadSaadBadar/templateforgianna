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
import '../widgets/lazy_section.dart';
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
            LazySection(builder: (_) => const TrustSection()),
            KeyedSubtree(key: _keys['work'], child: LazySection(builder: (_) => const WorkSection())),
            LazySection(builder: (_) => const ResultsSection()),
            KeyedSubtree(key: _keys['services'], child: LazySection(builder: (_) => const Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [PositioningSection(), ServicesSection()]))),
            KeyedSubtree(key: _keys['process'], child: LazySection(builder: (_) => const ProcessSection())),
            LazySection(builder: (_) => const TestimonialsSection()),
            if (siteConfig.showPackages) LazySection(builder: (_) => const PackagesSection()),
            KeyedSubtree(key: _keys['faq'], child: LazySection(builder: (_) => const FaqSection())),
            LazySection(builder: (_) => const FinalCtaSection()),
            LazySection(builder: (_) => const FooterSection()),
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
