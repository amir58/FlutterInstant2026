import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:navigations/core/bloc/my_bloc_observer.dart';
import 'package:navigations/core/di/dependency_injection.dart';
import 'package:navigations/core/routing/router.dart';
import 'package:navigations/core/theme/app_theme.dart';
import 'package:navigations/core/theme/theme_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

// App id = Package name = Bundle id
// Package name => android
// Bundle id => iOS

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  setupGetIt();

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
    return BlocProvider(
      create: (context) => ThemeCubit(getIt()),
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, mode) {
          return MaterialApp.router(
            routerConfig: router,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: mode,
          );
        },
      ),
    );
  }
}
