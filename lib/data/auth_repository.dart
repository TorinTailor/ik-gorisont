import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../domain/entities/app_user.dart';

class AuthRepository {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  Stream<AppUser?> userChanges() => _auth.authStateChanges().map(_toUser);

  AppUser? _toUser(User? user) {
    if (user == null) return null;
    return AppUser(
      uid: user.uid,
      email: user.email ?? '',
      nickname: user.displayName ?? '',
    );
  }

  Future<void> signIn({required String email, required String password}) =>
      _auth.signInWithEmailAndPassword(email: email.trim(), password: password);

  Future<AppUser> register({
    required String nickname,
    required String email,
    required String password,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    final user = credential.user!;

    try {
      await user.updateDisplayName(nickname.trim());
      await _db.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'nickname': nickname.trim(),
        'email': email.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (_) {
      // Не оставляем аккаунт без профиля в базе.
      try {
        await user.delete();
      } catch (_) {}
      rethrow;
    }

    return AppUser(
      uid: user.uid,
      email: email.trim(),
      nickname: nickname.trim(),
    );
  }

  Future<void> signOut() => _auth.signOut();
}
