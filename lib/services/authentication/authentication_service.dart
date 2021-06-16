import 'package:firebase_auth/firebase_auth.dart';
import 'package:sopi/models/generic/generic_response_model.dart';
import 'package:sopi/services/users/user_service.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;
  final _userService = UserService.singleton;

  static String get uid => FirebaseAuth.instance.currentUser!.uid;

  AuthenticationService(this._firebaseAuth);

  Stream<User?> get authStateChanges => _firebaseAuth.idTokenChanges();

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<GenericResponseModel> signIn(
      {required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return GenericResponseModel("Signed in");
    } on FirebaseAuthException catch (e) {
      return GenericResponseModel(e.message, correct: false);
    }
  }

  Future<GenericResponseModel> signUp(
      {required String email, required String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      final uid = _firebaseAuth.currentUser!.uid;
      _userService.addUser(uid);
      return GenericResponseModel("Signed up");
    } on FirebaseAuthException catch (e) {
      return GenericResponseModel(e.message, correct: false);
    }
  }

  Future<GenericResponseModel> resetPassword({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return GenericResponseModel("Mail is sended");
    } on FirebaseAuthException catch (e) {
      return GenericResponseModel(e.message, correct: false);
    }
  }
}
