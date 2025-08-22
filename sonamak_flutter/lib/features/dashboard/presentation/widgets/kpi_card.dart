
import 'package:flutter/material.dart';

class KpiCard extends StatelessWidget {
  const KpiCard({
    super.key,
    required this.title,
    required this.value,
    this.deltaLabel,
    this.suffix,
    this.gradient,
    this.valueColor,
  });

  final String title;
  final String value;
  final String? deltaLabel;
  final String? suffix;
  final Gradient? gradient;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: gradient ?? LinearGradient(
          colors: const [Color(0xFFFFF4F2), Color(0xFFFFE9E4)],
          begin: Alignment.topRight, end: Alignment.bottomLeft,
        ),
      ),
      child: Stack(
        children: [
          // subtle arcs to mimic website background sweeps
          Positioned(
            top: -40, right: -20, left: -60, bottom: 20,
            child: IgnorePointer(
              child: CustomPaint(
                painter: _ArcPainter(color: Colors.white.withOpacity(0.36)),
              ),
            ),
          ),
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    const Icon(Icons.show_chart, size: 18, color: Color(0xFF1F2937)),
                    const SizedBox(width: 6),
                    Text(title, style: theme.textTheme.bodyMedium?.copyWith(color: const Color(0xFF1F2937))),
                  ]),
                  const Spacer(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        value,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: valueColor ?? const Color(0xFF0F172A),
                        ),
                      ),
                      if (suffix != null) ...[
                        const SizedBox(width: 4),
                        Text(suffix!, style: theme.textTheme.titleMedium?.copyWith(color: const Color(0xFF0F172A))),
                      ],
                    ],
                  ),
                  if (deltaLabel != null) ...[
                    const SizedBox(height: 6),
                    Row(children: [
                      const Icon(Icons.south_east, size: 16, color: Color(0xFFFB5D3E)),
                      const SizedBox(width: 6),
                      Text(deltaLabel!, style: theme.textTheme.bodySmall?.copyWith(color: const Color(0xFF475569))),
                    ]),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ArcPainter extends CustomPainter {
  _ArcPainter({required this.color});
  final Color color;
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = 60;
    final rect = Rect.fromLTWH(size.width * -0.2, size.height * -0.6, size.width*1.4, size.height*1.6);
    canvas.drawArc(rect, 0.8, 1.8, false, paint);
    final paint2 = Paint()..color = color.withOpacity(0.5)..style = PaintingStyle.stroke..strokeWidth = 40;
    final rect2 = rect.deflate(50);
    canvas.drawArc(rect2, 0.8, 1.8, false, paint2);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
