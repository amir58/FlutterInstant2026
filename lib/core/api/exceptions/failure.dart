 class Failure {
  final String message;
  const Failure(this.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure() : super('مفيش اتصال بالإنترنت، اتأكد من الشبكة');
}

class TimeoutFailure extends Failure {
  const TimeoutFailure() : super('السيرفر أخد وقت طويل، حاول تاني');
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure() : super('انتهت الجلسة، سجّل دخول تاني');
}

class NotFoundFailure extends Failure {
  const NotFoundFailure(super.message);
}

class BadRequestFailure extends Failure {
  const BadRequestFailure(super.message);
}

class ServerFailure extends Failure {
  const ServerFailure() : super('عطل مؤقت في السيرفر، حاول بعد شوية');
}

class CancelledFailure extends Failure {
  const CancelledFailure() : super('اتلغى الطلب');
}

class DataFormatFailure extends Failure {
  const DataFormatFailure(super.message);
}

class UnknownFailure extends Failure {
  const UnknownFailure(super.message);
}

// Firebase 

/// أخطاء المستخدم يقدر يصلّحها: باسورد غلط، إيميل متسجل قبل كده…
class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

/// الـ Security Rules رفضت الطلب
class PermissionFailure extends Failure {
  const PermissionFailure() : super('مش مسموحلك تعمل كده');
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

class NotificationsDeniedFailure extends Failure {
  const NotificationsDeniedFailure()
      : super('الإشعارات مقفولة — فعّلها من إعدادات الموبايل');
}