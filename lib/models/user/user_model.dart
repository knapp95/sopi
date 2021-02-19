
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {




  static void addUserToFirebase(String uid, typeAccount) {
    try {
      DocumentReference user = FirebaseFirestore.instance.collection('users').doc(uid);
      final data = {
        'uid': uid,
        'typeAccount' : typeAccount,
      };
      user.set(data);
    } catch (e) {
      return e;
    }
  }

  static Future<String> getUserTypeAccountFromFirebase(String uid) async {
    String typeAccount;
    try {
      DocumentReference user = FirebaseFirestore.instance.collection('users').doc(uid);
      final result = await user.get();
      typeAccount =  result.data()['typeAccount'];
    } catch (e) {
      return e;
    }
    return typeAccount;
  }

}
