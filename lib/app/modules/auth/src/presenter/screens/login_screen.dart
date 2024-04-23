import 'dart:ui';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:umbrella_echonomics/app/modules/auth/src/presenter/widgets/auth_field.dart';

import '../widgets/link.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  late final FocusNode _emailFocusNode;
  late final FocusNode _passwordFocusNode;

  late bool isToRemindUser;

  String? _validateEmail(String email) {
    if (email.trim().isEmpty) return 'O Campo E-mail é obrigatório';
    if (!EmailValidator.validate(email)) return 'O E-mail informado é inválido';

    return null;
  }

  String? _validatePassword(String password) {
    if (password.trim().isEmpty) return 'O Campo Senha é obrigatório';
    if (password.length < 6 || password.length > 10) {
      return 'A Senha deve ter de 6 a 10 dígitos';
    }

    return null;
  }

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();

    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    isToRemindUser = false;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    _emailFocusNode
      ..unfocus()
      ..dispose();
    _passwordFocusNode
      ..unfocus()
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6FDCFF), Color(0xFFB172FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: false,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Bem vindo ao',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24.0,
                      ),
                    ),
                    Text(
                      'Umbrella Echonomics',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24.0,
                      ),
                    ),
                  ],
                ),
                Container(
                  width: MediaQuery.sizeOf(context).width * 0.8,
                  height: 400.0,
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 2.0,
                      color: Colors.white.withOpacity(0.2),
                    ),
                    borderRadius: BorderRadius.circular(25.0),
                    color: Colors.white.withOpacity(0.7),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text(
                        'Entrar no Aplicativo',
                        style: TextStyle(fontSize: 20.0),
                      ),
                      AuthTextField(
                        controller: _emailController,
                        focusNode: _emailFocusNode,
                        nextFocusNode: _passwordFocusNode,
                        label: "E-mail",
                        icon: Icons.mail,
                        keyboardType: TextInputType.emailAddress,
                        validate: (email) {
                          String? error = _validateEmail(email);
                          bool isValid = error == null;

                          return (isValid: isValid, errorMessage: error ?? '');
                        },
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AuthTextField(
                            controller: _passwordController,
                            focusNode: _passwordFocusNode,
                            label: "Senha",
                            icon: Icons.lock_open_rounded,
                            isPassword: true,
                            validate: (password) {
                              String? error = _validatePassword(password);

                              bool isValid = error == null;
                              return (
                                isValid: isValid,
                                errorMessage: error ?? ''
                              );
                            },
                          ),
                          CheckboxListTile.adaptive(
                            value: isToRemindUser,
                            contentPadding: EdgeInsets.zero,
                            title: const Text(
                              "Lembre de Mim",
                              style: TextStyle(fontSize: 14.0),
                            ),
                            checkboxShape: const RoundedRectangleBorder(
                              side: BorderSide(),
                            ),
                            checkboxSemanticLabel:
                                'Gostaria de entrar diretamente no app nos próximos acessos? Sem precisar passar pela fase de login',
                            hoverColor: Colors.grey,
                            onChanged: (newValue) {
                              if (newValue == null) return;

                              setState(() {
                                isToRemindUser = newValue;
                              });
                            },
                          ),
                        ],
                      ),
                      MaterialButton(
                        minWidth: MediaQuery.sizeOf(context).width * 0.8 * 0.6,
                        height: 40.0,
                        color: const Color(0xFFC786F9),
                        elevation: 4.0,
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        animationDuration: const Duration(milliseconds: 500),
                        highlightColor: Colors.purple,
                        onPressed: () {},
                        child: const Text(
                          'Entrar',
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Link(
                  destinyRoute: '/register',
                  text: 'Novo por aqui? Cadastre-se!',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
