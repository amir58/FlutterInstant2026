import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:navigations/core/bloc/my_bloc_observer.dart';
import 'package:navigations/core/routing/router.dart';

// App id = Package name = Bundle id 
// Package name => android
// Bundle id => iOS

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await EasyLocalization.ensureInitialized();

  Bloc.observer = MyBlocObserver();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      useOnlyLangCode: true,
      child: MainApp(),
    ),
  );

  // runApp(
  //   DevicePreview(
  //     enabled: false,
  //     // enabled: kDebugMode || kProfileMode,
  //     builder: (context) {
  //       return MainApp();
  //     },
  //   ),
  // );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
    );
  }
}
