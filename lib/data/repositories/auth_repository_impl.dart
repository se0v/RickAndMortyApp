import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';

class FirebaseAuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Stream<AppUser?> get authStateChanges => 
      _auth.authStateChanges().map((user) => user != null ? AppUser.fromFirebase(user) : null);

  @override
  Future<AppUser> signIn(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return AppUser.fromFirebase(credential.user!);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Ошибка входа');
    }
  }

  @override
  Future<AppUser> signUp(String email, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return AppUser.fromFirebase(credential.user!);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Ошибка регистрации');
    }
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
  }
  
  @override
AppUser? get currentUser {
  final user = _auth.currentUser;
  return user != null ? AppUser.fromFirebase(user) : null;
}
}