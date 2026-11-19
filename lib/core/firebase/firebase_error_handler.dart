import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:navigations/core/api/exceptions/failure.dart';

class FirebaseErrorHandler {
  FirebaseErrorHandler._();

  static Failure handle(Object error) {
    return switch (error) {
      // FirebaseAuthException بيورث من FirebaseException — لازم ييجي الأول
      FirebaseAuthException(:final code) => _auth(code),
      FirebaseException(:final code) => _firebase(code),
      GoogleSignInException(
        code: GoogleSignInExceptionCode.canceled,
      ) =>
        const CancelledFailure(),
      _ => UnknownFailure('خطأ غير معروف'),
    };
  }

  static Failure _auth(String code) => switch (code) {
    // مع Email Enumeration Protection (شغّالة افتراضي في المشاريع الجديدة)
    // الإيميل الغلط والباسورد الغلط الاتنين بيرجعوا invalid-credential
    'invalid-credential' ||
    'user-not-found' ||
    'wrong-password' => const AuthFailure('الإيميل أو الباسورد غلط'),
    'invalid-email' => const AuthFailure('الإيميل مكتوب غلط'),
    'missing-email' => const AuthFailure('اكتب الإيميل الأول'),
    'missing-password' => const AuthFailure('اكتب الباسورد'),
    'email-already-in-use' => const AuthFailure(
      'الإيميل ده متسجل قبل كده — جرّب تسجّل دخول',
    ),
    'weak-password' => const AuthFailure(
      'الباسورد ضعيف — ٦ حروف على الأقل',
    ),
    'user-disabled' => const AuthFailure('الحساب ده متوقف'),
    'too-many-requests' => const AuthFailure(
      'محاولات كتير — استنى شوية وجرّب تاني',
    ),
    'network-request-failed' => const NetworkFailure(),
    _ => UnknownFailure('خطأ غير معروف'),
  };

  static Failure _firebase(String code) => switch (code) {
    'permission-denied' ||
    'unauthorized' ||
    'unauthenticated' => const PermissionFailure(),
    'not-found' || 'object-not-found' =>  NotFoundFailure('غير موجود'),
    'unavailable' ||
    'deadline-exceeded' ||
    'retry-limit-exceeded' => const NetworkFailure(),
    'canceled' || 'cancelled' => const CancelledFailure(),
    'resource-exhausted' || 'quota-exceeded' => const ServerFailure(),
    _ => UnknownFailure('خطأ غير معروف'),
  };
}
