import 'package:navigations/core/api/exceptions/failure.dart';

class DatabaseFailure extends Failure {
  const DatabaseFailure() : super('حصلت مشكلة في حفظ البيانات، حاول تاني');
}

class DuplicateFailure extends Failure {
  const DuplicateFailure(super.message);
}

class InUseFailure extends Failure {
  const InUseFailure(super.message);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure(super.message);
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}