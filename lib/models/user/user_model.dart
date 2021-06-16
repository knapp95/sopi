import 'package:flutter/material.dart';
import 'package:sopi/models/user/enums/user_enum_type.dart';
import 'package:sopi/services/users/user_service.dart';

class UserModel with ChangeNotifier {
  final _userService = UserService.singleton;
  UserType? typeAccount;
  String? uid;
  String? name;
  String? email;
  String? username;
  String? status;
  int? state;
  String? profilePhoto;

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

  Future<void> getUserTypeAccountFromFirebase() async {
    try {
      final typeAccountData = await _userService.getUserTypeAccount();
      this.typeAccount = getUserTypeFromString(typeAccountData);
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }
}
