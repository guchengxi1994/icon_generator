import 'package:flutter/material.dart';

class TransparentBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const double squareSize = 20; // 棋盘格的单元大小
    final Paint lightPaint = Paint()..color = Colors.grey[300]!; // 亮色方格
    final Paint darkPaint = Paint()..color = Colors.grey[500]!; // 暗色方格

    for (double y = 0; y < size.height; y += squareSize) {
      for (double x = 0; x < size.width; x += squareSize) {
        bool isLight =
            ((x / squareSize).floor() + (y / squareSize).floor()) % 2 == 0;
        canvas.drawRect(
          Rect.fromLTWH(x, y, squareSize, squareSize),
          isLight ? lightPaint : darkPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
