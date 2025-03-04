import 'package:flutter/material.dart';
import 'package:icon_maker/src/components/home.dart';
import 'package:icon_maker/src/utils/styles.dart';
import 'package:toastification/toastification.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: ProviderScope(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: Styles.lightTheme,
          home: Home(),
        ),
      ),
    );
  }
}
