import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_webapi_first_course/exceptions/user_not_find_exception.dart';
import 'package:flutter_webapi_first_course/screens/common/confirmation_dialog.dart';
import 'package:flutter_webapi_first_course/screens/common/exception_dialog.dart';
import 'package:flutter_webapi_first_course/services/auth_service.dart';

// ignore: must_be_immutable
class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  login(BuildContext context) async {
    String email = _emailController.text;
    String password = _passController.text;

    AuthService authService = AuthService();

    bool result =
        await authService.login(email: email, password: password).catchError(
      (error) {
        showExceptionDialog(context, content: error.message);
        return false;
      },
      test: (error) => error is HttpException,
    ).catchError(
      (error) async {
        final dynamic confirm = await showConfirmationDialog(
          context,
          content: 'Deseja criar novo usuário com este email e senha?',
          okOption: 'Criar',
        );

        if (confirm) {
          bool result = await authService.register(
            email: email,
            password: password,
          );

          if (result) Navigator.pushNamed(context, 'home');
        }

        return false;
      },
      test: (error) => error is UserNotFindException,
    ).catchError(
      (error) {
        showExceptionDialog(context, content: 'Server not respond');
        return false;
      },
      test: (error) => error is TimeoutException,
    );

    if (result) Navigator.pushNamed(context, 'home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.all(32),
        decoration:
            BoxDecoration(border: Border.all(width: 8), color: Colors.white),
        child: Form(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Icon(Icons.bookmark, size: 64, color: Colors.brown),
                  const Text(
                    'Simple Journal',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Divider(thickness: 2),
                  ),
                  const Text('Entre ou Registre-se'),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      label: Text('E-mail'),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  TextFormField(
                    controller: _passController,
                    decoration: const InputDecoration(label: Text('Senha')),
                    keyboardType: TextInputType.visiblePassword,
                    maxLength: 16,
                    obscureText: true,
                  ),
                  ElevatedButton(
                    onPressed: () => login(context),
                    child: const Text('Login'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
