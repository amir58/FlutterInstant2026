import 'package:firebase_crashlytics/firebase_crashlytics.dart';

abstract class CrashReporter {
  Future<void> recordError(Object error, StackTrace stackTrace, {String? reason});
  Future<void> log(String message);
  Future<void> setUserId(String userId);
}

class CrashlyticsReporter implements CrashReporter {
  CrashlyticsReporter(this._crashlytics);

  final FirebaseCrashlytics _crashlytics;

  @override
  Future<void> recordError(Object error, StackTrace stackTrace, {String? reason}) =>
      _crashlytics.recordError(error, stackTrace, reason: reason);

  @override
  Future<void> log(String message) => _crashlytics.log(message);

  @override
  Future<void> setUserId(String userId) => _crashlytics.setUserIdentifier(userId);
}