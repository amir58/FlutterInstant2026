import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class AuthRemoteDataSource {
  Stream<User?> userChanges();
  Future<void> signIn({
    required String email,
    required String password,
  });

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  });

  Future<void> signInWithGoogle();
  Future<void> sendPasswordReset(String email);
  Future<void> signOut();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl(this._auth, this._firestore, this._google);

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn _google;

  // userChanges مش authStateChanges: بيبعت كمان لما الاسم يتغير بعد التسجيل
  @override
  Stream<User?> userChanges() => _auth.userChanges();

  @override
  Future<void> signIn({
    required String email,
    required String password,
  }) => _auth.signInWithEmailAndPassword(
    email: email,
    password: password,
  );

  @override
  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = credential.user!;
    await user.updateDisplayName(name);
    
    await _saveProfile(user, name: name);
  }

  @override
  Future<void> signInWithGoogle() async {
    final account = await _google.authenticate();

    final credential = GoogleAuthProvider.credential(
      idToken: account.authentication.idToken,
    );

    final result = await _auth.signInWithCredential(credential);

    if (result.additionalUserInfo?.isNewUser ?? false) {
      await _saveProfile(
        result.user!,
        name: account.displayName ?? '',
      );
    }
  }

  Future<void> _saveProfile(User user, {required String name}) {
    return _firestore.collection('users').doc(user.uid).set({
      'name': name,
      'email': user.email,
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  @override
  Future<void> sendPasswordReset(String email) =>
      _auth.sendPasswordResetEmail(email: email);

  @override
  Future<void> signOut() async {
    await _google.signOut();
    await _auth.signOut();
  }
}
