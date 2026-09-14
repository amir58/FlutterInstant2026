import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:navigations/features/login/data/repo/auth_repo.dart';

import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._authRepo) : super(LoginInitState());

  final AuthRepo _authRepo;

  Future<void> login({
    required String username,
    required String password,
  }) async {
    // Loading UI
    // Check Database
    // if (success) SuccessState Ui
    // else FailureState Ui
    emit(LoginLoadingState());

    try {
      // final auth =
      await _authRepo.login(username: username, password: password);

      emit(LoginSuccessState());
    } catch (e) {
      emit(
        LoginFailureState(
          errorMeassage: 'Invalid email or password!',
        ),
      );
    }
  }
}
