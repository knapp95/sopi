import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sopi/common/collections.dart';
import 'package:sopi/models/user/enums/user_enum_type.dart';
import 'package:sopi/services/authentication_service.dart';

class UserModel with ChangeNotifier {
  UserType typeAccount;
  String uid;
  String name;
  String email;
  String username;
  String status;
  int state;
  String profilePhoto;

  UserModel();

  UserModel.fromJson(Map<String, dynamic> data) {
    this.uid = data['uid'];
    this.name = data['name'];
    this.email = data['email'];
    this.username = data['username'];
    this.status = data['status'];
    this.state = data['state'];
    this.profilePhoto = data['profilePhoto'];
  }

  static void addUserToFirebase(String uid) {
    try {
      DocumentReference user = usersCollection.doc(uid);

      final data = {
        'uid': uid,
        'typeAccount': UserType.CLIENT.toString(),
      };
      user.set(data);
    } catch (e) {
      return e;
    }
  }

  Future<void> getUserTypeAccountFromFirebase() async {
    try {
      DocumentReference user = usersCollection
          .doc(AuthenticationService.uid);
      final result = await user.get();
      this.typeAccount = getUserTypeFromString(result.data()['typeAccount']);
      notifyListeners();
    } catch (e) {
      return e;
    }
  }

  static Future<List<UserModel>> fetchAllEmployees() async {
    List<UserModel> userList = List<UserModel>();
    QuerySnapshot querySnapshot = await usersCollection
        .where('typeAccount', isEqualTo: UserType.EMPLOYEE.toString()).get();
    querySnapshot.docs.forEach((userDoc) {
      userList.add(UserModel.fromJson(userDoc.data()));
    });
    return userList;
  }
}
