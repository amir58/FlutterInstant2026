sealed class SignInState {
  const SignInState();
}

class LoginIdle extends SignInState {
  const LoginIdle();
}

class LoginSubmitting extends SignInState {
  const LoginSubmitting();
}

class LoginError extends SignInState {
  final String message;
  const LoginError(this.message);
}

class LoginInfo extends SignInState {
  final String message;
  const LoginInfo(this.message);
}
