import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:navigations/lo2ta/auth/domain/entities/app_user.dart';
import 'package:navigations/lo2ta/auth/domain/usecases/signout_usecase.dart';
import 'package:navigations/lo2ta/auth/domain/usecases/watch_user_usecase.dart';
import 'package:navigations/lo2ta/auth/presentation/cubit/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {

  AuthCubit(this._watchUser, this._signOut)
    : super(const AuthUnknown());

  final SignOutUseCase _signOut;

  final WatchUserUseCase _watchUser;

  StreamSubscription<AppUser?>? _subscription;

  void start() {
    _subscription ??= _watchUser().listen((user) {
      emit(
        user == null ? const Unauthenticated() : Authenticated(user),
      );
    });
  }

  // مفيش emit هنا: الـ stream نفسه هيبعت null والراوتر هيرجعك للوجين
  Future<void> signOut() => _signOut();

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
