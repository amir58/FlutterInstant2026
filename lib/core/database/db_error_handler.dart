import 'package:navigations/core/api/exceptions/failure.dart';
import 'package:navigations/core/database/db_failure.dart';
import 'package:sqflite/sqflite.dart';


class DatabaseErrorHandler {
  DatabaseErrorHandler._();

  static Failure handle(Object error) {
    if (error is! DatabaseException) {
      return const UnknownFailure('حصل خطأ غير متوقع');
    }
    if (error.isUniqueConstraintError()) {
      return const DuplicateFailure('العنصر ده موجود قبل كده');
    }
    // sqflite مالوش helper جاهز للـ Foreign Key — بنقرا رسالة SQLite نفسها
    if (error.toString().contains('FOREIGN KEY constraint failed')) {
      return const InUseFailure('مينفعش — فيه بيانات تانية مربوطة بيه');
    }
    return const DatabaseFailure();
  }
}