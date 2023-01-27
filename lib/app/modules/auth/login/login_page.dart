import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_app/app/core/notifier/default_listener_notifier.dart';
import 'package:todo_list_app/app/core/ui/messages.dart';
import 'package:todo_list_app/app/core/ui/theme_extensions.dart';
import 'package:todo_list_app/app/core/widget/todo_list_field.dart';
import 'package:todo_list_app/app/core/widget/todo_list_logo.dart';
import 'package:todo_list_app/app/modules/auth/login/login_controller.dart';
import 'package:validatorless/validatorless.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailEC = TextEditingController();
  final _passwordEC = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _emailFocus = FocusNode();

  @override
  void dispose() {
    super.dispose();
    _emailEC.dispose();
    _passwordEC.dispose();
  }

  @override
  void initState() {
    super.initState();
    DefaultListenerNotifier(changeNotifier: context.read<LoginController>())
        .listener(
      context: context,
      everCallback: (notifier, listenerInstance) {
        if (notifier is LoginController) {
          if (notifier.hasInfo) {
            Messages.of(context).showSuccess(notifier.infoMessage!);
          }
        }
      },
      successCallback: (notifier, listenerInstance) {
        // Navigator.of(context).pushNamed('/splash');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                  minWidth: constraints.maxWidth),
              child: IntrinsicHeight(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    TodoListLogo(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 20),
                      child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TodoListField(
                                controller: _emailEC,
                                label: 'E-mail',
                                focusNode: _emailFocus,
                                validator: Validatorless.multiple([
                                  Validatorless.required(
                                      'E-mail é obrigatório!'),
                                  Validatorless.email('E-mail inválido!')
                                ]),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              TodoListField(
                                controller: _passwordEC,
                                label: 'Senha',
                                validator: Validatorless.multiple([
                                  Validatorless.required(
                                      'A senha é obrigatória!'),
                                  Validatorless.min(6,
                                      'A senha deve conter pelo menos 6 caracteres!')
                                ]),
                                obscureText: true,
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      if (_emailEC.text.isEmpty) {
                                        _emailFocus.requestFocus();
                                        Messages.of(context).showError(
                                            'Digite um e-mail para recuperar a senha!');
                                      } else {
                                        context
                                            .read<LoginController>()
                                            .forgotPassword(_emailEC.text);
                                      }
                                    },
                                    child: Text(
                                      'Esqueceu sua senha?',
                                      style: TextStyle(
                                          color: context.primaryColor),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      final formValid =
                                          _formKey.currentState?.validate() ??
                                              false;
                                      if (formValid) {
                                        context.read<LoginController>().login(
                                            _emailEC.text, _passwordEC.text);
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Text('Login'),
                                    ),
                                  )
                                ],
                              )
                            ],
                          )),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xffF0F3F7),
                          border: Border(
                            top: BorderSide(
                              width: 2,
                              color: Colors.grey.withAlpha(50),
                            ),
                          ),
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: 30),
                            SignInButton(
                              Buttons.Google,
                              text: 'Continue com o Google',
                              padding: EdgeInsets.all(5),
                              shape: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide.none),
                              onPressed: () {
                                context.read<LoginController>().googleLogin();
                              },
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Não tem conta?'),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pushNamed('/register');
                                      },
                                      child: Text(
                                        'Cadastre-se',
                                        style: TextStyle(
                                            color: context.primaryColor),
                                      ))
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
