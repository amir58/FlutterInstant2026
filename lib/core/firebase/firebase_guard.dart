import 'dart:async';

import 'package:navigations/core/api/api_result.dart';
import 'package:navigations/core/api/exceptions/failure.dart';
import 'package:navigations/core/crash/crash_report.dart';
import 'package:navigations/core/firebase/firebase_error_handler.dart';

/// كل نداء لفايربيز بيعدّي من هنا: الـ exception بيموت هنا ويطلع Failure
class FirebaseGuard {
  FirebaseGuard(this._crash);

  final CrashReporter _crash;

  Future<ApiResult<T>> call<T>(Future<T> Function() action) async {
    try {
      return ApiSuccess(await action());
    } catch (error, stackTrace) {
      return ApiFailure(_toFailure(error, stackTrace));
    }
  }

  Stream<ApiResult<T>> stream<T>(Stream<T> source) {
    return source.transform(
      StreamTransformer<T, ApiResult<T>>.fromHandlers(
        handleData: (data, sink) => sink.add(ApiSuccess(data)),
        handleError: (error, stackTrace, sink) =>
            sink.add(ApiFailure(_toFailure(error, stackTrace))),
      ),
    );
  }

  Failure _toFailure(Object error, StackTrace stackTrace) {
    final failure = FirebaseErrorHandler.handle(error);
    // باسورد غلط أو نت فاصل مش باج — Crashlytics للحاجات اللي محدش متوقعها بس
    if (failure is UnknownFailure || failure is ServerFailure) {
      unawaited(_crash.recordError(error, stackTrace, reason: 'firebase call'));
    }
    return failure;
  }
}