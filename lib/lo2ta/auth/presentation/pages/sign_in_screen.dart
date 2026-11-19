import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:navigations/core/routing/routes.dart';
import 'package:navigations/lo2ta/auth/presentation/cubit/auth_cubit.dart';
import 'package:navigations/lo2ta/auth/presentation/cubit/auth_state.dart';

import '../cubit/sign_in_cubit.dart';
import '../cubit/sign_in_state.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        switch (state) {
          case AuthUnknown():
            break;
          case Authenticated():
            context.go(Routes.home);
            break;
          case Unauthenticated():
            break;
        }
      },
      child: const Scaffold(body: SafeArea(child: _LoginForm())),
    );
  }
}

class _LoginForm extends StatefulWidget {
  const _LoginForm();

  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _isSignUp =
      false; // حالة UI محلية — مكانها setState مش الـ Cubit

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    initAuthCubit();
  }

  void _submit() {
    final cubit = context.read<SignInCubit>();
    if (_isSignUp) {
      cubit.signUp(_name.text, _email.text, _password.text);
    } else {
      cubit.signIn(_email.text, _password.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SignInCubit>();

    return BlocConsumer<SignInCubit, SignInState>(
      listener: (context, state) {
        final message = switch (state) {
          LoginError(:final message) ||
          LoginInfo(:final message) => message,
          _ => null,
        };

        if (message != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(message)));
        }
      },
      builder: (context, state) {
        final busy = state is LoginSubmitting;

        return ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const SizedBox(height: 40),
            Text(
              'لقطة',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const Text('بيع واشتري المستعمل في ثانية'),
            const SizedBox(height: 32),
            if (_isSignUp)
              TextField(
                controller: _name,
                decoration: const InputDecoration(labelText: 'الاسم'),
              ),
            TextField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'الإيميل'),
            ),
            TextField(
              controller: _password,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'الباسورد',
              ),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: busy ? null : _submit,
              child: Text(_isSignUp ? 'اعمل حساب' : 'تسجيل الدخول'),
            ),
            OutlinedButton.icon(
              onPressed: busy ? null : cubit.signInWithGoogle,
              icon: const Icon(Icons.g_mobiledata, size: 28),
              label: const Text('كمّل بجوجل'),
            ),
            TextButton(
              onPressed: busy
                  ? null
                  : () => setState(() => _isSignUp = !_isSignUp),
              child: Text(
                _isSignUp
                    ? 'عندك حساب؟ سجل دخول'
                    : 'أول مرة؟ اعمل حساب',
              ),
            ),
            if (!_isSignUp)
              TextButton(
                onPressed: busy
                    ? null
                    : () => cubit.resetPassword(_email.text),
                child: const Text('نسيت الباسورد'),
              ),
          ],
        );
      },
    );
  }

  void initAuthCubit() {
    context.read<AuthCubit>().start();
  }
}
