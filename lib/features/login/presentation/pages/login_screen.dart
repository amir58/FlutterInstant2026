import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:navigations/core/routing/routes.dart';
import 'package:navigations/features/login/presentation/cubit/login_cubit.dart';
import 'package:navigations/features/login/presentation/cubit/login_state.dart';
import 'package:toastification/toastification.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController =
      TextEditingController();

  final TextEditingController passwordController =
      TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        print(state);

        if (state is LoginSuccessState) {
          context.go(Routes.home);
        }

        if (state is LoginFailureState) {
          toastification.show(
            context: context,
            title: Text(state.errorMeassage),
            type: ToastificationType.error,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text('Login')),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 15,
              children: [
                TextFormField(
                  onChanged: (value) {
                    debugPrint(value);
                  },
                  controller: usernameController,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Username required";
                    }

                    // if (!value.contains('@')) {}
                    // if (!value.contains('.')) {}

                    return null;
                  },
                ),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Password required";
                    }
                    if (value.length < 6) {
                      return "Password short!";
                    }
                    return null;
                  },
                ),

                ElevatedButton(
                  onPressed: () {
                    login();
                  },
                  child: Text('Login'),
                ),
                BlocBuilder<LoginCubit, LoginState>(
                  builder: (context, state) {
                    print('BlocBuilder => $state');
                    return state is LoginLoadingState
                        ? CircularProgressIndicator()
                        : SizedBox();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void login() {
    final bool validate = formKey.currentState?.validate() ?? false;

    if (!validate) {
      return;
    }

    final String username = usernameController.text
        .trim(); //.replaceAll(" ", "");
    final String password = passwordController.text;

    context.read<LoginCubit>().login(
      username: username,
      password: password,
    );

    // if (email.isEmpty) {
    //   toastification.show(
    //     context: context,
    //     title: Text('Email required'),
    //     type: ToastificationType.warning,
    //   );
    //   return;
    // }
    // print(username);
    // print(username.length);

    // if (password.isEmpty) {
    //   toastification.show(
    //     context: context,
    //     title: Text('Password required'),
    //     type: ToastificationType.warning,
    //   );
    //   return;
    // }
    // print(password);
  }

  @override
  void dispose() {
    super.dispose();
    usernameController.dispose();
    passwordController.dispose();
  }
}
