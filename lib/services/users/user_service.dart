import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sopi/models/user/enums/user_enum_type.dart';
import 'package:sopi/models/user/user_model.dart';

import '../authentication_service.dart';

class UserService {
  final _usersCollection = FirebaseFirestore.instance.collection('users');
  static final UserService _singleton = UserService._internal();

  factory UserService() {
    return _singleton;
  }

  UserService._internal();

  static UserService get singleton => _singleton;

  Future<List<UserModel>> fetchAllEmployees() async {
    List<UserModel> userList = [];
    QuerySnapshot querySnapshot = await _usersCollection
        .where('typeAccount', isEqualTo: UserType.EMPLOYEE.toString())
        .get();

    querySnapshot.docs.forEach((userDoc) {
      userList.add(UserModel.fromJson(userDoc.data()));
    });
    return userList;
  }

  DocumentReference getDoc({String uid}) {
    return _usersCollection.doc(uid);
  }

  void addUser(String uid) {
    DocumentReference doc = _usersCollection.doc(uid);
    final data = {
      'uid': uid,
      'typeAccount': UserType.CLIENT.toString(),
    };
    doc.set(data);
  }

  Future<String> getUserTypeAccount() async {
    try {
      DocumentReference doc = _usersCollection.doc(AuthenticationService.uid);
      final data = (await doc.get()).data();
      return data['typeAccount'];
    } catch (e) {
      return e;
    }
  }
}
