import 'package:flutter/material.dart';
import 'package:icon_maker/src/app.dart';
import 'package:icon_maker/src/utils/styles.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  WindowOptions windowOptions = WindowOptions(
    size: Styles.size,
    minimumSize: Styles.size,
    backgroundColor: Colors.white,
    skipTaskbar: false,
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(App());
}
