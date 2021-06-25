import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:sopi/models/user/enums/user_enum_type.dart';
import 'package:sopi/models/user/user_model.dart';

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
        .where('typeAccount', isEqualTo: EnumToString.convertToString(UserType.EMPLOYEE))
        .get();
    querySnapshot.docs.forEach((userDoc) {

      final data = userDoc.data()! as Map<String, dynamic>;
      userList.add(UserModel.fromJson(data));
    });
    return userList;
  }

  DocumentReference getDoc({String? uid}) {
    return _usersCollection.doc(uid);
  }

  void addUser(String uid) {
    DocumentReference doc = _usersCollection.doc(uid);
    final data = {
      'uid': uid,
      'typeAccount': UserType.CLIENT,
    };
    doc.set(data);
  }

}
