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
    final List<UserModel> userList = [];
    final QuerySnapshot querySnapshot = await _usersCollection
        .where('typeAccount',
            isEqualTo: EnumToString.convertToString(UserType.employee))
        .get();

    for (final QueryDocumentSnapshot userDoc in querySnapshot.docs) {
      final data = userDoc.data()! as Map<String, dynamic>;
      userList.add(UserModel.fromJson(data));
    }

    return userList;
  }

  DocumentReference getDoc({String? uid}) {
    return _usersCollection.doc(uid);
  }

  void addUser(String uid) {
    final DocumentReference doc = _usersCollection.doc(uid);
    final data = {
      'uid': uid,
      'typeAccount': UserType.client,
    };
    doc.set(data);
  }
}
