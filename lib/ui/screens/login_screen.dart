import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/auth/auth_state.dart';
import '../widgets/error_banner.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static final _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  final _formKey = GlobalKey<FormState>();
  final _nicknameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLogin = true;
  bool _obscure = true;

  @override
  void dispose() {
    _nicknameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final bloc = context.read<AuthBloc>();
    if (_isLogin) {
      bloc.add(
        AuthSignInRequested(
          email: _emailController.text,
          password: _passwordController.text,
        ),
      );
    } else {
      bloc.add(
        AuthRegisterRequested(
          nickname: _nicknameController.text,
          email: _emailController.text,
          password: _passwordController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  final busy = state is AuthUnauthenticated && state.isBusy;
                  final error = state is AuthUnauthenticated
                      ? state.error
                      : null;

                  return Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          _isLogin ? 'Вход' : 'Регистрация',
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _isLogin
                              ? 'Войдите, чтобы работать со снимками и запросами'
                              : 'Создайте аккаунт, чтобы сохранять свои запросы',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 24),
                        if (error != null) ...[
                          ErrorBanner(error),
                          const SizedBox(height: 16),
                        ],
                        if (!_isLogin) ...[
                          TextFormField(
                            controller: _nicknameController,
                            enabled: !busy,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              labelText: 'Имя пользователя',
                            ),
                            validator: (v) {
                              final value = (v ?? '').trim();
                              if (value.isEmpty) {
                                return 'Введите имя пользователя';
                              }
                              if (value.length < 3) {
                                return 'Имя должно быть не короче 3 символов';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                        ],
                        TextFormField(
                          controller: _emailController,
                          enabled: !busy,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            labelText: 'Почта',
                            hintText: 'test@example.com',
                          ),
                          validator: (v) {
                            final value = (v ?? '').trim();
                            if (value.isEmpty) return 'Введите адрес почты';
                            if (!value.contains('@')) {
                              return 'В адресе почты должен быть символ @, '
                                  'например name@example.com';
                            }
                            if (!_emailRegex.hasMatch(value)) {
                              return 'После @ должен быть домен, '
                                  'например name@example.com';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _passwordController,
                          enabled: !busy,
                          obscureText: _obscure,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) => busy ? null : _submit(),
                          decoration: InputDecoration(
                            labelText: 'Пароль',
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscure
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () =>
                                  setState(() => _obscure = !_obscure),
                            ),
                          ),
                          validator: (v) {
                            final value = v ?? '';
                            if (value.isEmpty) return 'Введите пароль';
                            if (value.length < 8) return 'Пароль должен быть не короче 8 символов';
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: busy ? null : _submit,
                          child: busy
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(_isLogin ? 'Войти' : 'Зарегистрироваться'),
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: busy
                              ? null
                              : () => setState(() => _isLogin = !_isLogin),
                          child: Text(
                            _isLogin
                                ? 'Нет аккаунта? Зарегистрироваться'
                                : 'Уже есть аккаунт? Войти',
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
