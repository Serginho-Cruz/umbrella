import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:umbrella_echonomics/app/modules/auth/src/presenter/widgets/auth_field.dart';
import '../../domain/entities/user_state.dart';
import '../stores/auth_store.dart';
import '../widgets/auth_button.dart';
import '../widgets/error_dialog.dart';
import '../widgets/link.dart';
import '../widgets/loading_dialog.dart';
import '../widgets/tappable_icon.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required AuthStore store}) : _store = store;

  final AuthStore _store;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final FocusNode _emailFocusNode;
  late final FocusNode _passwordFocusNode;
  late final ReactionDisposer _disposer;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isDialogBeingShown = false;

  @override
  void initState() {
    super.initState();
    _passwordFocusNode = FocusNode();
    _emailFocusNode = FocusNode();
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
                        Observer(
                          builder: (_) {
                            return AuthTextField(
                              label: "E-mail",
                              icon: Icons.mail,
                              focusNode: _emailFocusNode,
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
                              onChanged: widget._store.setEmail,
                              validate: widget._store.validateEmail,
                            );
                          },
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Observer(
                              builder: (_) => AuthTextField(
                                focusNode: _passwordFocusNode,
                                label: "Senha",
                                icon: Icons.lock,
                                obscureText: !widget._store.isPasswordVisible,
                                suffixIcon: TappableIcon(
                                  onTap: widget._store.togglePasswordVisibility,
                                  icon: widget._store.isPasswordVisible
                                      ? const Icon(
                                          Icons.visibility_off,
                                          color: Colors.black,
                                        )
                                      : const Icon(
                                          Icons.visibility,
                                          color: Colors.black,
                                        ),
                                ),
                                readOnly: widget._store.state is LoadingState,
                                onTapOutside: (_) {
                                  _passwordFocusNode.unfocus();
                                },
                                onChanged: widget._store.setPassword,
                                validate: widget._store.validatePassword,
                              ),
                            ),
                            Material(
                              type: MaterialType.transparency,
                              child: Observer(builder: (_) {
                                return CheckboxListTile(
                                  title: const Text(
                                    "Lembre de Mim",
                                    style: TextStyle(fontSize: 14.0),
                                  ),
                                  onChanged: (newValue) {
                                    widget._store
                                        .setRememberUser(newValue ?? false);
                                  },
                                  value: widget._store.isToRemember,
                                  hoverColor: Colors.grey,
                                  contentPadding: EdgeInsets.zero,
                                );
                              }),
                            ),
                          ],
                        ),
                        AuthButton(
                          text: 'Entrar',
                          size: Size(
                            MediaQuery.sizeOf(context).width * 0.8 - 20.0,
                            50.0,
                          ),
                          onPressed: () {
                            debugPrint(
                                '${widget._store.email} / ${widget._store.password}');
                            if (_formKey.currentState!.validate()) {
                              widget._store.login();
                            }
                          },
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

  @override
  void didChangeDependencies() {
    _setUpReaction();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _disposer();

    _passwordFocusNode
      ..unfocus()
      ..dispose();
    _emailFocusNode
      ..unfocus()
      ..dispose();
    widget._store.resetFields();

    super.dispose();
  }

  void _setUpReaction() {
    _disposer = reaction((_) {
      return widget._store.state;
    }, (state) {
      switch (state) {
        case InitialState():
          if (_isDialogBeingShown) {
            Navigator.pop(context);
            _isDialogBeingShown = false;
          }
          break;
        case SuccessState():
          if (_isDialogBeingShown) {
            Navigator.pop(context);
            _isDialogBeingShown = false;
          }
          Navigator.pushReplacementNamed(context, '/finance_manager/');
          break;
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
      }
    });
  }
}
