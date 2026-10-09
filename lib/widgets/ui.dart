import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../core/app_theme.dart';

/// Pill button. `primary` = brown gradient, otherwise outlined.
class AppButton extends StatefulWidget {
  const AppButton({super.key, required this.label, required this.onPressed, this.primary = true, this.compact = false, this.expand = false});
  final String label;
  final VoidCallback onPressed;
  final bool primary, compact, expand;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    final padding = widget.compact
        ? const EdgeInsets.symmetric(horizontal: 20, vertical: 12)
        : const EdgeInsets.symmetric(horizontal: 28, vertical: 16);
    return Semantics(
      button: true,
      label: widget.label,
      excludeSemantics: true,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hover = true),
        onExit: (_) => setState(() => _hover = false),
        child: GestureDetector(
          onTap: widget.onPressed,
          child: AnimatedScale(
            scale: _hover ? 1.03 : 1,
            duration: const Duration(milliseconds: 160),
            child: Container(
              padding: padding,
              alignment: widget.expand ? Alignment.center : null,
              decoration: BoxDecoration(
                gradient: widget.primary ? c.buttonGradient : null,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: widget.primary ? c.tan.withOpacity(.3) : c.line),
                boxShadow: widget.primary
                    ? [BoxShadow(color: Colors.black.withOpacity(.25), blurRadius: 24, offset: const Offset(0, 10))]
                    : null,
              ),
              child: Text(
                widget.label,
                style: body(context,
                    size: widget.compact ? 14 : 16,
                    weight: FontWeight.w600,
                    color: widget.primary ? Colors.white : c.ink),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Text filled with a gradient.
class GradientText extends StatelessWidget {
  const GradientText(this.text, {super.key, required this.style, required this.colors, this.textAlign = TextAlign.center});
  final String text;
  final TextStyle style;
  final List<Color> colors;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (rect) => LinearGradient(colors: colors).createShader(Rect.fromLTWH(0, 0, rect.width, rect.height)),
      child: Text(text, textAlign: textAlign, style: style.copyWith(color: Colors.white)),
    );
  }
}

class Pill extends StatelessWidget {
  const Pill(this.text, {super.key, this.onDark = false});
  final String text;
  final bool onDark;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
      decoration: BoxDecoration(
        color: onDark ? const Color(0xFF34221A) : c.bg,
        border: Border.all(color: onDark ? const Color(0xFF4A3426) : c.line),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text('✦ $text',
          style: body(context, size: 14, weight: FontWeight.w600, color: onDark ? const Color(0xFFE2BE98) : c.tan)),
    );
  }
}

/// Centered page section with max width and responsive padding.
/// `stage: true` renders it as the rounded, always-dark brown block.
class SectionShell extends StatelessWidget {
  const SectionShell({super.key, required this.child, this.stage = false, this.tinted = false});
  final Widget child;
  final bool stage, tinted;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    final inner = Padding(
      padding: EdgeInsets.symmetric(vertical: context.isMobile ? 64 : 120),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1180),
          child: Padding(padding: EdgeInsets.symmetric(horizontal: context.isMobile ? 20 : 24), child: child),
        ),
      ),
    );
    if (stage) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Container(
          decoration: BoxDecoration(
            color: c.stage,
            borderRadius: BorderRadius.circular(40),
            border: Border.all(color: c.stageLine),
          ),
          child: inner,
        ),
      );
    }
    return Container(color: tinted ? c.tint : null, child: inner);
  }
}

class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.chip, required this.title, this.subtitle, this.onDark = false});
  final String chip, title;
  final String? subtitle;
  final bool onDark;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    final size = (context.w * 0.055).clamp(32.0, 60.0);
    return Padding(
      padding: const EdgeInsets.only(bottom: 56),
      child: Column(
        children: [
          Pill(chip, onDark: onDark),
          const SizedBox(height: 18),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 820),
            child: Text(title,
                textAlign: TextAlign.center,
                style: display(context, size, color: onDark ? AppColors.onDark : c.ink)),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 18),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Text(subtitle!,
                  textAlign: TextAlign.center,
                  style: body(context, color: onDark ? AppColors.onDarkMuted : c.muted)),
            ),
          ],
        ],
      ),
    );
  }
}

/// Equal-height responsive grid built from rows (no LayoutBuilder inside rows,
/// so cards can use IntrinsicHeight safely).
class ResponsiveGrid extends StatelessWidget {
  const ResponsiveGrid({super.key, required this.children, this.desktop = 3, this.tablet = 2, this.spacing = 16});
  final List<Widget> children;
  final int desktop, tablet;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    final w = context.width;
    final cols = w >= Breakpoints.lg ? desktop : (w >= Breakpoints.sm ? tablet : 1);
    final rows = <Widget>[];
    for (var i = 0; i < children.length; i += cols) {
      final slice = children.sublist(i, math.min(i + cols, children.length));
      rows.add(Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var j = 0; j < cols; j++) ...[
            if (j > 0) SizedBox(width: spacing),
            Expanded(child: j < slice.length ? slice[j] : const SizedBox.shrink()),
          ],
        ],
      ));
      if (i + cols < children.length) rows.add(SizedBox(height: spacing));
    }
    return Column(children: rows);
  }
}

class InitialAvatar extends StatelessWidget {
  const InitialAvatar(this.letter, {super.key, this.size = 40});
  final String letter;
  final double size;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(shape: BoxShape.circle, gradient: c.buttonGradient, border: Border.all(color: c.bg, width: 3)),
      child: Text(letter, style: body(context, size: size * .36, weight: FontWeight.w600, color: Colors.white, height: 1)),
    );
  }
}
