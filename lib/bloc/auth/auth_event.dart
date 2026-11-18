sealed class AuthEvent {}

class AuthStarted extends AuthEvent {}

class AuthSignInRequested extends AuthEvent {
  final String email;
  final String password;
  AuthSignInRequested({required this.email, required this.password});
}

class AuthRegisterRequested extends AuthEvent {
  final String nickname;
  final String email;
  final String password;
  AuthRegisterRequested({
    required this.nickname,
    required this.email,
    required this.password,
  });
}

class AuthSignOutRequested extends AuthEvent {}
