import 'package:app_links/app_links.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:navigations/core/bloc/my_bloc_observer.dart';
import 'package:navigations/core/di/dependency_injection.dart';
import 'package:navigations/core/routing/deep_links.dart';
import 'package:navigations/core/routing/router.dart';
import 'package:navigations/core/theme/app_theme.dart';
import 'package:navigations/core/theme/theme_cubit.dart';
import 'package:navigations/firebase_options.dart';

// App id = Package name = Bundle id
// Package name => android
// Bundle id => iOS

final remoteConfig = FirebaseRemoteConfig.instance;
final appLinks = AppLinks(); // AppLinks is singleton

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  setupGetIt();

  await EasyLocalization.ensureInitialized();

  Bloc.observer = MyBlocObserver();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await setupCrashlytics();

  await setupRemoteConfig();

  // Subscribe to all events (initial link and further)
  appLinks.uriLinkStream.listen(handleDeepLink);

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

void handleDeepLink(Uri uri) {
  debugPrint('Received URI: $uri');

  if (uri.host != DeepLinks.host) return;

  // `go` is safe before the router is mounted (cold start), it only updates
  // the route information that the router reads on its first build.
  router.go(uri.path);
}

Future<void> setupCrashlytics() async {
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(
    !kDebugMode,
  );

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
}

Future<void> setupRemoteConfig() async {
  await remoteConfig.setDefaults(const {
    'killApp': false,
    'min_supported_version': '1.0.0',
  });

  await remoteConfig.setConfigSettings(
    RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 10),
      minimumFetchInterval: Duration.zero,
    ),
  );

  await remoteConfig.fetchAndActivate();

  final killApp = remoteConfig.getBool('killApp');

  debugPrint('Kill App ? $killApp');
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
