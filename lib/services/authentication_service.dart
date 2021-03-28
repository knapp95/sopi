
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sopi/models/generic/generic_response_model.dart';
import 'package:sopi/models/user/user_model.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;

  static String get uid => FirebaseAuth.instance.currentUser.uid;

  AuthenticationService(this._firebaseAuth);

  Stream<User> get authStateChanges => _firebaseAuth.idTokenChanges();

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<GenericResponseModel> signIn({String email, String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return GenericResponseModel("Signed in", true);
    } on FirebaseAuthException catch (e) {
      return GenericResponseModel(e.message, false);
    }
  }

  Future<GenericResponseModel> signUp({String email, String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      final uid = _firebaseAuth.currentUser.uid;
      UserModel.addUserToFirebase(uid);
      return GenericResponseModel("Signed up", false);
    } on FirebaseAuthException catch (e) {
      return GenericResponseModel(e.message, false);
    }
  }

  Future<GenericResponseModel> resetPassword({String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);

      return GenericResponseModel("Mail is sended", false);
    } on FirebaseAuthException catch (e) {
      return GenericResponseModel(e.message, false);
    }
  }

}
