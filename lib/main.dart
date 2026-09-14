import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:navigations/core/bloc/my_bloc_observer.dart';
import 'package:navigations/core/routing/router.dart';

void main() {
  Bloc.observer = MyBlocObserver();

  runApp(
    DevicePreview(
      enabled: false,
      // enabled: kDebugMode || kProfileMode,
      builder: (context) {
        return MainApp();
      },
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(routerConfig: router);
  }
}
