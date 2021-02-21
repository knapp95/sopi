import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String uid;
  String typeAccount;


  void setUser(String uid) {
    this.uid = uid;
    this.getUserTypeAccountFromFirebase();
  }


  static void addUserToFirebase(String uid, typeAccount) {
    try {
      DocumentReference user =
          FirebaseFirestore.instance.collection('users').doc(uid);
      final data = {
        'uid': uid,
        'typeAccount': typeAccount,
      };
      user.set(data);
    } catch (e) {
      return e;
    }
  }

  Future<void> getUserTypeAccountFromFirebase() async {
    try {
      DocumentReference user =
          FirebaseFirestore.instance.collection('users').doc(this.uid);
      final result = await user.get();
      this.typeAccount = result.data()['typeAccount'];
    } catch (e) {
      return e;
    }
  }
}
