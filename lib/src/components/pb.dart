import 'package:flutter/material.dart';

class DraggableProgressBar extends StatefulWidget {
  final double min;
  final double max;
  final double initialValue;
  final ValueChanged<double> onChanged; // 进度回调

  const DraggableProgressBar({
    super.key,
    required this.min,
    required this.max,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  // ignore: library_private_types_in_public_api
  _DraggableProgressBarState createState() => _DraggableProgressBarState();
}

class _DraggableProgressBarState extends State<DraggableProgressBar> {
  late double _progress; // 当前进度

  @override
  void initState() {
    super.initState();
    _progress = widget.initialValue.clamp(widget.min, widget.max);
  }

  void _updateProgress(double newProgress) {
    setState(() {
      _progress = newProgress.clamp(widget.min, widget.max);
    });
    widget.onChanged(_progress); // 触发外部回调
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        RenderBox box = context.findRenderObject() as RenderBox;
        Offset localPosition = box.globalToLocal(details.globalPosition);
        double percent = localPosition.dx / box.size.width;
        double newProgress = widget.min + percent * (widget.max - widget.min);
        _updateProgress(newProgress);
      },
      onTapDown: (details) {
        RenderBox box = context.findRenderObject() as RenderBox;
        Offset localPosition = box.globalToLocal(details.globalPosition);
        double percent = localPosition.dx / box.size.width;
        double newProgress = widget.min + percent * (widget.max - widget.min);
        _updateProgress(newProgress);
      },
      child: CustomPaint(
        size: const Size(300, 40), // 进度条大小
        painter: ProgressBarPainter(
          progress: _progress,
          min: widget.min,
          max: widget.max,
        ),
      ),
    );
  }
}

/// 进度条绘制
class ProgressBarPainter extends CustomPainter {
  final double progress;
  final double min;
  final double max;

  ProgressBarPainter({
    required this.progress,
    required this.min,
    required this.max,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint backgroundPaint =
        Paint()
          ..color = Colors.grey[300]!
          ..style = PaintingStyle.fill
          ..strokeCap = StrokeCap.round;

    Paint progressPaint =
        Paint()
          ..color = Colors.blue
          ..style = PaintingStyle.fill
          ..strokeCap = StrokeCap.round;

    Paint thumbPaint =
        Paint()
          ..color = Colors.blue
          ..style = PaintingStyle.fill;

    // 计算进度百分比
    double percent = (progress - min) / (max - min);

    // 进度条的高度
    double barHeight = size.height * 0.3;
    double barTop = (size.height - barHeight) / 2;
    Rect barRect = Rect.fromLTWH(0, barTop, size.width, barHeight);

    // 当前进度条的长度
    double progressWidth = size.width * percent;
    Rect progressRect = Rect.fromLTWH(0, barTop, progressWidth, barHeight);

    // 滑块的位置
    double thumbRadius = size.height * 0.4;
    double thumbX = progressWidth.clamp(thumbRadius, size.width - thumbRadius);
    Offset thumbCenter = Offset(thumbX, size.height / 2);

    // 画背景条
    canvas.drawRRect(
      RRect.fromRectAndRadius(barRect, Radius.circular(barHeight / 2)),
      backgroundPaint,
    );

    // 画进度条
    canvas.drawRRect(
      RRect.fromRectAndRadius(progressRect, Radius.circular(barHeight / 2)),
      progressPaint,
    );

    // 画滑块
    canvas.drawCircle(thumbCenter, thumbRadius, thumbPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
