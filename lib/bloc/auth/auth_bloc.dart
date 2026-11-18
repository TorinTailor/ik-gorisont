import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/auth_repository.dart';
import '../../domain/entities/app_user.dart';
import '../../utils/connectivity.dart';
import '../../utils/error_messages.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _repository;

  // Пока идёт регистрация, игнорируем промежуточные события потока Firebase,
  // чтобы пользователь не увидел главный экран до записи профиля в базу.
  bool _registering = false;

  AuthBloc(this._repository) : super(AuthInitial()) {
    on<AuthStarted>(_onStarted);
    on<AuthSignInRequested>(_onSignIn);
    on<AuthRegisterRequested>(_onRegister);
    on<AuthSignOutRequested>(_onSignOut);
  }

  Future<void> _onStarted(AuthStarted event, Emitter<AuthState> emit) {
    return emit.forEach<AppUser?>(
      _repository.userChanges(),
      onData: (user) {
        if (user == null) {
          return state is AuthUnauthenticated ? state : AuthUnauthenticated();
        }
        if (_registering) return state;
        return AuthAuthenticated(user);
      },
      onError: (error, _) => AuthUnauthenticated(error: errorMessage(error)),
    );
  }

  Future<void> _onSignIn(
    AuthSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    if (!await hasInternet()) {
      emit(AuthUnauthenticated(error: noInternetActionMessage));
      return;
    }
    emit(AuthUnauthenticated(isBusy: true));
    try {
      await _repository.signIn(email: event.email, password: event.password);
      // Дальше состояние обновит поток userChanges.
    } catch (e) {
      emit(AuthUnauthenticated(error: errorMessage(e)));
    }
  }

  Future<void> _onRegister(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    if (!await hasInternet()) {
      emit(AuthUnauthenticated(error: noInternetActionMessage));
      return;
    }
    _registering = true;
    emit(AuthUnauthenticated(isBusy: true));
    try {
      final user = await _repository.register(
        nickname: event.nickname,
        email: event.email,
        password: event.password,
      );
      _registering = false;
      emit(AuthAuthenticated(user));
    } catch (e) {
      _registering = false;
      emit(AuthUnauthenticated(error: errorMessage(e)));
    }
  }

  Future<void> _onSignOut(
    AuthSignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _repository.signOut();
  }
}
