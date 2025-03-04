import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('Canvas 透明背景')),
        body: Center(
          child: CustomPaint(
            size: Size(300, 300), // 自定义画布大小
            painter: TransparentBackgroundPainter(),
          ),
        ),
      ),
    );
  }
}

class TransparentBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const double squareSize = 20; // 棋盘格的单元大小
    final Paint lightPaint = Paint()..color = Colors.grey[300]!; // 亮色方格
    final Paint darkPaint = Paint()..color = Colors.grey[500]!; // 暗色方格

    // 1. 画交错的方格
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

    // 2. 额外绘制其他内容（可选）
    // ignore: deprecated_member_use
    final Paint circlePaint = Paint()..color = Colors.blue.withOpacity(0.5);
    canvas.drawCircle(size.center(Offset.zero), 50, circlePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
