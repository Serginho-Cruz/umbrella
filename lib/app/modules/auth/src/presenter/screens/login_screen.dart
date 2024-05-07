import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:umbrella_echonomics/app/modules/auth/src/presenter/widgets/auth_field.dart';
import '../controllers/auth_controller.dart';
import '../widgets/auth_button.dart';
import '../widgets/error_dialog.dart';
import '../widgets/link.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required AuthController controller})
      : _controller = controller;

  final AuthController _controller;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  late final FocusNode _emailFocusNode;
  late final FocusNode _passwordFocusNode;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late bool isToRemindUser;

  String? _validateEmail(String? email) {
    if (email == null || email.trim().isEmpty) {
      return 'O Campo E-mail é obrigatório';
    }
    if (!EmailValidator.validate(email)) return 'O E-mail informado é inválido';

    return null;
  }

  String? _validatePassword(String? password) {
    if (password == null || password.trim().isEmpty) {
      return 'O Campo Senha é obrigatório';
    }
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
    return SafeArea(
      child: DecoratedBox(
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
                Form(
                  key: _formKey,
                  child: Container(
                    width: MediaQuery.sizeOf(context).width * 0.8,
                    height: 400.0,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 2.0,
                        color: Colors.white.withOpacity(0.2),
                      ),
                      borderRadius: BorderRadius.circular(25.0),
                      color: Colors.white.withOpacity(0.65),
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
                          validate: _validateEmail,
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
                              validate: _validatePassword,
                            ),
                            Material(
                              type: MaterialType.transparency,
                              child: ListTile(
                                title: const Text(
                                  "Lembre de Mim",
                                  style: TextStyle(fontSize: 14.0),
                                ),
                                trailing: IgnorePointer(
                                  child: Checkbox.adaptive(
                                    value: isToRemindUser,
                                    semanticLabel:
                                        'Gostaria de entrar diretamente no app nos próximos acessos? Sem precisar passar pela fase de login',
                                    onChanged: (value) {
                                      setState(() {
                                        isToRemindUser = value!;
                                      });
                                    },
                                  ),
                                ),
                                hoverColor: Colors.grey,
                                contentPadding: EdgeInsets.zero,
                                onTap: () {
                                  setState(() {
                                    isToRemindUser = !isToRemindUser;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        AuthButton(
                          text: 'Entrar',
                          size: Size(
                            MediaQuery.sizeOf(context).width * 0.8 - 20.0,
                            50.0,
                          ),
                          onPressed: _onPressed,
                        ),
                      ],
                    ),
                  ),
                ),
                const Link(
                  destinyRoute: './register',
                  text: 'Novo por aqui? Cadastre-se!',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onPressed() {
    if (_formKey.currentState!.validate()) {
      widget._controller
          .login(
        email: _emailController.text,
        password: _passwordController.text,
        isToRemember: isToRemindUser,
      )
          .then((error) {
        if (error != null) {
          ErrorDialog.show(context, error: error);
          return;
        }

        Navigator.of(context).pushReplacementNamed('/finance_manager/');
      });
    }
  }
}
