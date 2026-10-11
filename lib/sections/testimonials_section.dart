import 'package:flutter/material.dart';

import '../config/site_config.dart';
import '../core/app_theme.dart';
import '../widgets/reveal.dart';
import '../widgets/ui.dart';

class TestimonialsSection extends StatefulWidget {
  const TestimonialsSection({super.key});

  @override
  State<TestimonialsSection> createState() => _TestimonialsSectionState();
}

class _TestimonialsSectionState extends State<TestimonialsSection> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final testimonials = siteConfig.testimonials;
    final isMobile = context.isMobile;

    // Group testimonials into pairs for 2-per-page mobile slider
    final pages = <List<Testimonial>>[];
    if (isMobile) {
      for (var i = 0; i < testimonials.length; i += 2) {
        pages.add(
          testimonials.sublist(i, (i + 2).clamp(0, testimonials.length)),
        );
      }
    }

    return SectionShell(
      tinted: true,
      child: Column(
        children: [
          const SectionHeader(
            chip: 'Testimonials',
            title: 'Creators who kept me on',
          ),
          Reveal(
            child: isMobile
                ? Column(
                    children: [
                      SizedBox(
                        height: 310,
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: pages.length,
                          onPageChanged: (i) =>
                              setState(() => _currentPage = i),
                          itemBuilder: (context, pageIndex) {
                            final pair = pages[pageIndex];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 2,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(child: _TestimonialCard(t: pair[0])),
                                  if (pair.length > 1) ...[
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: _TestimonialCard(t: pair[1]),
                                    ),
                                  ] else
                                    const Expanded(child: SizedBox.shrink()),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Animated pill dot indicators
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(pages.length, (i) {
                          final isActive = i == _currentPage;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeInOut,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: isActive ? 20 : 7,
                            height: 7,
                            decoration: BoxDecoration(
                              color: isActive
                                  ? context.c.accent
                                  : context.c.line,
                              borderRadius: BorderRadius.circular(999),
                            ),
                          );
                        }),
                      ),
                    ],
                  )
                : ResponsiveGrid(
                    desktop: 3,
                    tablet: 1,
                    children: [
                      for (final t in testimonials) _TestimonialCard(t: t),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _TestimonialCard extends StatelessWidget {
  const _TestimonialCard({required this.t});
  final Testimonial t;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    final mobile = context.isMobile;
    return Container(
      padding: EdgeInsets.all(mobile ? 12 : 30),
      decoration: BoxDecoration(
        color: c.bg,
        border: Border.all(color: c.line),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '"${t.quote}"',
            style: display(context, mobile ? 12 : 20, height: 1.4),
            maxLines: 6,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          Text(
            t.result,
            style: body(
              context,
              size: mobile ? 10 : 14,
              weight: FontWeight.w600,
              color: c.tan,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              InitialAvatar(t.name[0], size: mobile ? 26 : 40),
              SizedBox(width: mobile ? 6 : 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.name,
                      style: body(
                        context,
                        size: mobile ? 10 : 16,
                        weight: FontWeight.w600,
                        height: 1.2,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '${t.channel}, ${t.audience}',
                      style: body(
                        context,
                        size: mobile ? 9 : 14,
                        color: c.muted,
                        height: 1.3,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
