import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/user.dart';
import '../controllers/user_controller.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_field.dart';
import '../widgets/error_dialog.dart';
import '../widgets/link.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({
    super.key,
    required UserController controller,
  }) : _controller = controller;

  final UserController _controller;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;

  late final FocusNode _nameFocusNode;
  late final FocusNode _emailFocusNode;
  late final FocusNode _passwordFocusNode;
  late final FocusNode _confirmPasswordFocusNode;

  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();

    _nameFocusNode = FocusNode();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    _confirmPasswordFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();

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
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: MediaQuery.sizeOf(context).width * 0.1,
                  ),
                  child: const Text(
                    'Criar Conta',
                    style: TextStyle(fontSize: 24.0),
                  ),
                ),
              ),
              Form(
                key: _formKey,
                child: SizedBox(
                  width: MediaQuery.sizeOf(context).width * 0.8,
                  child: Column(
                    children: [
                      AuthTextField(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        controller: _nameController,
                        focusNode: _nameFocusNode,
                        icon: Icons.person_rounded,
                        label: 'Nome',
                        validate: _validateName,
                      ),
                      AuthTextField(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        controller: _emailController,
                        focusNode: _emailFocusNode,
                        icon: Icons.email,
                        label: 'E-mail',
                        validate: _validateEmail,
                      ),
                      AuthTextField(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        controller: _passwordController,
                        focusNode: _passwordFocusNode,
                        icon: Icons.lock,
                        label: 'Senha',
                        isPassword: true,
                        validate: _validatePassword,
                      ),
                      AuthTextField(
                        padding: const EdgeInsets.only(bottom: 40.0),
                        controller: _confirmPasswordController,
                        focusNode: _confirmPasswordFocusNode,
                        icon: Icons.lock,
                        label: 'Confirmar Senha',
                        isPassword: true,
                        validate: (text) {
                          if (text != _passwordController.text) {
                            return "A Senha informada é diferente da anterior";
                          }

                          return null;
                        },
                      ),
                      AuthButton(
                        text: 'Cadastrar-se',
                        size:
                            Size(MediaQuery.sizeOf(context).width * 0.8, 60.0),
                        onPressed: _onRegisterTap,
                      ),
                    ],
                  ),
                ),
              ),
              const Link(
                destinyRoute: './',
                text: 'Já possui uma conta? Clique aqui!',
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onRegisterTap() {
    if (_formKey.currentState!.validate()) {
      User user = User(
        id: 0,
        name: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
      );

      Future(() async {
        var result = await widget._controller.register(user);

        return result;
      }).then((result) {
        var (:hasError, :error) = result;
        if (hasError) {
          ErrorDialog.show(context, error: error);
          return;
        }

        Navigator.pushReplacementNamed(context, '/');
      });
    }
  }

  String? _validateName(String? text) {
    if (text == null || text.trim().isEmpty) return "O Nome é Obrigatório";

    if (text.length < 5 || text.length >= 20) {
      return "O Nome deve ter entre 5 e 20 caracteres";
    }

    return null;
  }

  String? _validateEmail(String? text) {
    if (text == null || text.trim().isEmpty) return "O Email é Obrigatório";

    if (EmailValidator.validate(text) == false) {
      return "E-mail Inválido, confira se não há erros";
    }

    return null;
  }

  String? _validatePassword(String? text) {
    if (text == null || text.trim().isEmpty) return "A Senha é Obrigatória";

    if (text.length < 6 || text.length > 10) {
      return "A Senha deve ter entre 6 e 10 caracteres";
    }

    return null;
  }
}
