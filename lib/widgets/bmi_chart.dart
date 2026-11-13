import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import '../models/models.dart';

class BmiChart extends StatelessWidget {
  const BmiChart({super.key, required this.items});
  final List<BmiResult> items;

  @override
  Widget build(BuildContext context) {
    final data = items.take(5).toList().reversed.toList();
    if (data.length < 2) {
      return Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
        child: const Text('Diperlukan minimal 2 hasil BMI untuk melihat tren.'),
      );
    }
    return Container(
      height: 220,
      padding: const EdgeInsets.fromLTRB(14, 18, 14, 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
      child: CustomPaint(
        painter: _BmiChartPainter(data),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _BmiChartPainter extends CustomPainter {
  _BmiChartPainter(this.items);
  final List<BmiResult> items;

  @override
  void paint(Canvas canvas, Size size) {
    final values = items.map((e) => e.bmi).toList();
    double minV = values.reduce(math.min);
    double maxV = values.reduce(math.max);
    if ((maxV - minV).abs() < 1) {
      minV -= 1;
      maxV += 1;
    } else {
      minV -= 1.5;
      maxV += 1.5;
    }

    const left = 28.0;
    const top = 12.0;
    const bottom = 32.0;
    final chartW = size.width - left - 8;
    final chartH = size.height - top - bottom;

    final gridPaint = Paint()..color = const Color(0xFFE8ECF3)..strokeWidth = 1;
    for (var i = 0; i <= 4; i++) {
      final y = top + chartH * i / 4;
      canvas.drawLine(Offset(left, y), Offset(size.width - 8, y), gridPaint);
    }

    final points = <Offset>[];
    for (var i = 0; i < values.length; i++) {
      final x = left + (values.length == 1 ? 0 : chartW * i / (values.length - 1));
      final ratio = (values[i] - minV) / (maxV - minV);
      final y = top + chartH * (1 - ratio);
      points.add(Offset(x, y));
    }

    final line = Paint()
      ..color = AppColors.pink
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (var i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }
    canvas.drawPath(path, line);

    final dot = Paint()..color = AppColors.pink;
    for (var i = 0; i < points.length; i++) {
      canvas.drawCircle(points[i], 4.5, dot);
      _text(canvas, values[i].toStringAsFixed(1), points[i] + const Offset(-12, -22), 11, AppColors.darkBlue);
      _text(canvas, '${items[i].createdAt.day}/${items[i].createdAt.month}', Offset(points[i].dx - 12, size.height - 22), 10, Colors.grey.shade700);
    }
  }

  void _text(Canvas canvas, String text, Offset offset, double size, Color color) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: TextStyle(fontSize: size, color: color)),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant _BmiChartPainter oldDelegate) => oldDelegate.items != items;
}
