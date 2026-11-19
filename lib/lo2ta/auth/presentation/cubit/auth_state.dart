import 'package:navigations/lo2ta/auth/domain/entities/app_user.dart';

sealed class AuthState {
  const AuthState();
}

class AuthUnknown extends AuthState {
  const AuthUnknown();
}

class Authenticated extends AuthState {
  AppUser appUser;
  Authenticated(this.appUser);
}

class Unauthenticated extends AuthState {
  const Unauthenticated();
}
