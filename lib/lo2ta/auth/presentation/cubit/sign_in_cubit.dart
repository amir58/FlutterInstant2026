import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:navigations/core/api/api_result.dart';
import 'package:navigations/core/api/exceptions/failure.dart';
import 'package:navigations/lo2ta/auth/domain/usecases/google_sign_in_usecase.dart';
import 'package:navigations/lo2ta/auth/domain/usecases/reset_password_usecase.dart';
import 'package:navigations/lo2ta/auth/domain/usecases/sigin_in_usecase.dart';
import 'package:navigations/lo2ta/auth/domain/usecases/sign_up_usecase.dart';
import 'package:navigations/lo2ta/auth/presentation/cubit/sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  SignInCubit(
    this._signIn,
    this._signUp,
    this._google,
    this._resetPassword,
  ) : super(const LoginIdle());

  final SignInUseCase _signIn;
  final SignUpUseCase _signUp;
  final GoogleSignInUseCase _google;
  final ResetPasswordUseCase _resetPassword;

  Future<void> signIn(String email, String password) =>
      _submit(() => _signIn(email: email, password: password));

  Future<void> signUp(String name, String email, String password) =>
      _submit(
        () => _signUp(name: name, email: email, password: password),
      );

  Future<void> signInWithGoogle() => _submit(_google.call);

  Future<void> resetPassword(String email) => _submit(
    () => _resetPassword(email),
    onSuccess: const LoginInfo(
      'بعتنالك لينك تغيير الباسورد على الإيميل',
    ),
  );

  // النجاح مش محتاج نقل لشاشة: AuthCubit هيسمع الدخول والراوتر هيحوّل لوحده
  Future<void> _submit(
    Future<ApiResult<void>> Function() action, {
    SignInState onSuccess = const LoginIdle(),
  }) async {
    if (state is LoginSubmitting) return;

    emit(const LoginSubmitting());

    final result = await action();

    if (isClosed) return;

    switch (result) {
      case ApiSuccess():
        emit(onSuccess);
      case ApiFailure(failure: CancelledFailure()):
        emit(const LoginIdle());
      case ApiFailure(:final failure):
        emit(LoginError(failure.message));
    }
  }
}
