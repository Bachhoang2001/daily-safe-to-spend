import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:safe_to_spend/core/theme/app_colors.dart';

/// Circular progress ring displaying budget utilization or goal percentage.
class ProgressRing extends StatelessWidget {
  /// Creates a [ProgressRing].
  const ProgressRing({
    required this.progress,
    super.key,
    this.size = 120,
    this.strokeWidth = 10,
    this.color,
    this.backgroundColor,
    this.child,
    this.semanticsLabel,
  });

  /// Normalized progress from 0.0 to 1.0 (clamped).
  final double progress;

  /// Diameter of the ring.
  final double size;

  /// Thickness of the progress stroke.
  final double strokeWidth;

  /// Foreground stroke color.
  final Color? color;

  /// Background track color.
  final Color? backgroundColor;

  /// Optional widget rendered at the center of the ring.
  final Widget? child;

  /// Optional semantics label for accessibility.
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final effectiveProgress = progress.clamp(0.0, 1.0);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final ringColor =
        color ?? (isDark ? AppColors.primaryDark : AppColors.primaryLight);
    final trackColor =
        backgroundColor ??
        (isDark ? AppColors.surfaceVariantDark : AppColors.surfaceVariantLight);

    final percent = (effectiveProgress * 100).toInt();

    return Semantics(
      label: semanticsLabel ?? 'Progress $percent%',
      value: '$percent%',
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            CustomPaint(
              size: Size(size, size),
              painter: _RingPainter(
                progress: effectiveProgress,
                strokeWidth: strokeWidth,
                color: ringColor,
                backgroundColor: trackColor,
              ),
            ),
            if (child != null) child!,
          ],
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  const _RingPainter({
    required this.progress,
    required this.strokeWidth,
    required this.color,
    required this.backgroundColor,
  });

  final double progress;
  final double strokeWidth;
  final Color color;
  final Color backgroundColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Background track
    final trackPaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, radius, trackPaint);

    // Active progress arc
    if (progress > 0) {
      final progressPaint = Paint()
        ..color = color
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      final sweepAngle = 2 * math.pi * progress;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2,
        sweepAngle,
        false,
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.color != color ||
        oldDelegate.backgroundColor != backgroundColor;
  }
}
