import '../../domain/entities/app_user.dart';

sealed class AuthState {}

/// Ещё не знаем, вошёл ли пользователь.
class AuthInitial extends AuthState {}

class AuthAuthenticated extends AuthState {
  final AppUser user;
  AuthAuthenticated(this.user);
}

class AuthUnauthenticated extends AuthState {
  final bool isBusy;
  final String? error;
  AuthUnauthenticated({this.isBusy = false, this.error});
}
