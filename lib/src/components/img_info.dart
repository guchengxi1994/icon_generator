import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icon_maker/src/notifiers/notifier.dart';

class ImgInfoWidget extends ConsumerStatefulWidget {
  const ImgInfoWidget({super.key});

  @override
  ConsumerState<ImgInfoWidget> createState() => _ImgInfoWidgetState();
}

class _ImgInfoWidgetState extends ConsumerState<ImgInfoWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: Center(
        child: StreamBuilder<(double, double)>(
          stream: ref.read(homeNotifierProvider.notifier).stream,
          builder: (c, s) {
            if (s.hasData) {
              return Text("(width) ${s.data!.$1} * ${s.data!.$2} (height)");
            }
            return Text("File not selected");
          },
        ),
      ),
    );
  }
}
