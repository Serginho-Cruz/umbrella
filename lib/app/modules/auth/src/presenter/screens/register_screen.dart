import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';

import '../../domain/entities/user_state.dart';
import '../../domain/usecases/validate.dart';
import '../stores/auth_store.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_field.dart';
import '../widgets/error_dialog.dart';
import '../widgets/link.dart';
import '../widgets/loading_dialog.dart';
import '../widgets/success_dialog.dart';
import '../widgets/tappable_icon.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({
    super.key,
    required AuthStore store,
  }) : _store = store;

  final AuthStore _store;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late final FocusNode _nameFocusNode;
  late final FocusNode _emailFocusNode;
  late final FocusNode _passwordFocusNode;
  late final FocusNode _confirmPasswordFocusNode;

  late final ReactionDisposer _disposer;

  final GlobalKey<FormState> _formKey = GlobalKey();

  bool _isDialogBeingShown = false;

  @override
  void initState() {
    super.initState();

    _nameFocusNode = FocusNode();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    _confirmPasswordFocusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
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
                    Observer(builder: (_) {
                      return AuthTextField(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        keyboardType: TextInputType.name,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        icon: Icons.person_rounded,
                        focusNode: _nameFocusNode,
                        label: 'Nome',
                        readOnly: widget._store.state is LoadingState,
                        onChanged: widget._store.setName,
                        onSubmitted: (_) {
                          if (widget._store.email.isEmpty) {
                            _emailFocusNode.requestFocus();
                          }
                        },
                        onTapOutside: (_) {
                          _nameFocusNode.unfocus();
                        },
                        validate: widget._store.validateName,
                      );
                    }),
                    Observer(builder: (_) {
                      return AuthTextField(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        focusNode: _emailFocusNode,
                        icon: Icons.email,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        label: 'E-mail',
                        onChanged: widget._store.setEmail,
                        keyboardType: TextInputType.emailAddress,
                        readOnly: widget._store.state is LoadingState,
                        onSubmitted: (_) {
                          if (widget._store.password.isEmpty) {
                            _passwordFocusNode.requestFocus();
                          }
                        },
                        onTapOutside: (_) {
                          _emailFocusNode.unfocus();
                        },
                        validate: widget._store.validateEmail,
                      );
                    }),
                    Observer(
                      builder: (_) => AuthTextField(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        focusNode: _passwordFocusNode,
                        icon: Icons.lock,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        label: 'Senha',
                        readOnly: widget._store.state is LoadingState,
                        obscureText: !widget._store.isPasswordVisible,
                        suffixIcon: TappableIcon(
                          icon: widget._store.isPasswordVisible
                              ? const Icon(
                                  Icons.visibility_off,
                                  color: Colors.black,
                                )
                              : const Icon(
                                  Icons.visibility,
                                  color: Colors.black,
                                ),
                          onTap: widget._store.togglePasswordVisibility,
                        ),
                        onTapOutside: (_) {
                          _passwordFocusNode.unfocus();
                        },
                        onChanged: widget._store.setPassword,
                        onSubmitted: (_) {
                          if (widget._store.confirmPassword.isEmpty) {
                            _confirmPasswordFocusNode.requestFocus();
                          }
                        },
                        validate: (str) {
                          return widget._store.validatePassword(
                            str,
                            mode: PasswordValidationMode.granular,
                          );
                        },
                      ),
                    ),
                    Observer(
                      builder: (_) => AuthTextField(
                        padding: const EdgeInsets.only(bottom: 40.0),
                        focusNode: _confirmPasswordFocusNode,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        icon: Icons.lock,
                        label: 'Confirmar Senha',
                        readOnly: widget._store.state is LoadingState,
                        obscureText: !widget._store.isPasswordVisible,
                        suffixIcon: TappableIcon(
                          icon: widget._store.isPasswordVisible
                              ? const Icon(
                                  Icons.visibility_off,
                                  color: Colors.black,
                                )
                              : const Icon(
                                  Icons.visibility,
                                  color: Colors.black,
                                ),
                          onTap: widget._store.togglePasswordVisibility,
                        ),
                        onTapOutside: (_) {
                          _confirmPasswordFocusNode.unfocus();
                        },
                        onChanged: widget._store.setConfirmPassword,
                        validate: widget._store.validateConfirmPassword,
                      ),
                    ),
                    AuthButton(
                      text: 'Cadastrar-se',
                      size: Size(MediaQuery.sizeOf(context).width * 0.8, 60.0),
                      onPressed: _register,
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
    );
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      await widget._store.register();

      if (widget._store.state is! FailState &&
          widget._store.state is! LoadingState &&
          mounted) {
        await SuccessDialog.show(context,
            title: 'Cadastro Realizado',
            successMessage:
                'Seu cadastro foi finalizado com sucesso. Iremos redirecionar você a tela inicial.');

        if (mounted) Navigator.pushReplacementNamed(context, './');
      }
    }
  }

  @override
  void didChangeDependencies() {
    _setUpReaction();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    _disposer();
    widget._store.resetFields();
    super.dispose();
  }

  void _setUpReaction() {
    _disposer = reaction((_) => widget._store.state, (state) {
      switch (state) {
        case LoadingState():
          LoadingDialog.show(context);
          _isDialogBeingShown = true;
          break;
        case FailState():
          if (_isDialogBeingShown) {
            Navigator.pop(context);
          }
          _isDialogBeingShown = true;
          ErrorDialog.show(context, error: state.fail.message);
          break;
        default:
          if (_isDialogBeingShown) Navigator.pop(context);
          break;
      }
    });
  }
}
