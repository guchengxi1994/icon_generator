import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeNotifier extends Notifier {
  final StreamController<(double, double)> _controller =
      StreamController.broadcast();

  Stream<(double, double)> get stream => _controller.stream;

  void addMessage(XFile message) async {
    _getImageSize(await message.readAsBytes());
  }

  Future<void> _getImageSize(Uint8List data) async {
    final Image image = Image.memory(data);
    final Completer<ui.Image> completer = Completer<ui.Image>();

    image.image
        .resolve(const ImageConfiguration())
        .addListener(
          ImageStreamListener((ImageInfo info, bool _) {
            completer.complete(info.image);
          }),
        );

    final ui.Image img = await completer.future;
    _controller.add((img.width.toDouble(), img.height.toDouble()));
  }

  @override
  build() {}
}

final homeNotifierProvider = NotifierProvider<HomeNotifier, void>(
  HomeNotifier.new,
);
