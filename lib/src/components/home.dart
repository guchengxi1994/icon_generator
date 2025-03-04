// ignore_for_file: avoid_init_to_null

import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icon_maker/src/components/bg_painter.dart';
import 'package:icon_maker/src/components/img_info.dart';
import 'package:icon_maker/src/components/pb.dart';
import 'package:icon_maker/src/notifiers/notifier.dart';
import 'package:icon_maker/src/utils/styles.dart';
import 'package:icon_maker/src/utils/toast_utils.dart';
import 'package:path_provider/path_provider.dart';

const XTypeGroup typeGroup = XTypeGroup(
  label: 'images',
  extensions: <String>['jpg', 'png'],
);

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  final GlobalKey _globalKey = GlobalKey();
  bool hovering = false;

  late XFile? file = null;
  late double padding = 0;
  late double radius = 0;

  Future<void> _captureScreenshot() async {
    try {
      RenderRepaintBoundary boundary =
          _globalKey.currentContext!.findRenderObject()
              as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0); // 高像素比
      ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      // 可选：保存到本地
      final directory = await getDownloadsDirectory();
      String filePath = '${directory!.path}/screenshot.png';
      File file = File(filePath);
      await file.writeAsBytes(pngBytes);
      // print("截图已保存: $filePath");
      ToastUtils.sucess(null, title: "Saved", description: "截图已保存: $filePath");
    } catch (e) {
      // print("截图失败: $e");
      ToastUtils.error(null, title: "Error", description: "截图失败: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final _ = ref.watch(homeNotifierProvider);

    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            MouseRegion(
              cursor: SystemMouseCursors.click,
              onEnter: (event) {
                setState(() {
                  hovering = true;
                });
              },
              onExit: (event) {
                setState(() {
                  hovering = false;
                });
              },
              child: Center(
                child: DropTarget(
                  onDragDone: (details) {
                    file = details.files.first;
                    ref.read(homeNotifierProvider.notifier).addMessage(file!);
                    setState(() {});
                  },
                  child: GestureDetector(
                    onTap: () async {
                      file = await openFile(
                        acceptedTypeGroups: <XTypeGroup>[typeGroup],
                      );
                      if (file == null) {
                        return;
                      }

                      ref.read(homeNotifierProvider.notifier).addMessage(file!);
                      setState(() {});
                    },
                    child: Stack(
                      children: [
                        CustomPaint(
                          size: Size(400, 400),
                          painter: TransparentBackgroundPainter(),
                        ),
                        RepaintBoundary(
                          key: _globalKey,
                          child: SizedBox(
                            width: 400,
                            height: 400,
                            child: Center(
                              child: Container(
                                width: 400 - padding * 2,
                                height: 400 - padding * 2,
                                // padding: EdgeInsets.all(padding),
                                decoration: BoxDecoration(
                                  color:
                                      file == null
                                          ? hovering
                                              ? Styles.lightTheme.cardColor
                                              : Colors.grey[200]
                                          : Colors.transparent,
                                ),
                                child:
                                    file == null
                                        ? Center(
                                          child: Text("Drag/select image here"),
                                        )
                                        : Center(
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              radius,
                                            ),
                                            child: Image.file(
                                              File(file!.path),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            ImgInfoWidget(),
            Row(
              children: [
                Text("Padding"),
                DraggableProgressBar(
                  max: 100,
                  min: 0,
                  initialValue: 0,
                  onChanged: (value) {
                    padding = value;
                    setState(() {});
                  },
                ),
              ],
            ),
            Row(
              children: [
                Text("Radius"),
                DraggableProgressBar(
                  max: 100,
                  min: 0,
                  initialValue: 0,
                  onChanged: (value) {
                    radius = value;
                    setState(() {});
                  },
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                _captureScreenshot();
              },
              child: Text("Save icon"),
            ),
          ],
        ),
      ),
    );
  }
}
