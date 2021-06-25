import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sopi/models/user/enums/user_enum_type.dart';
import 'package:sopi/services/authentication/authentication_service.dart';
import 'package:sopi/services/users/user_service.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel with ChangeNotifier {
  UserType? typeAccount;
  String? uid;
  String? name;
  String? email;
  String? username;
  String? status;
  int? state;
  String? profilePhoto;

  UserModel();

  Future<void> setTypeAccount() async {
    if (this.typeAccount != null || AuthenticationService.uid == null) return;
    final userService = UserService.singleton;

    DocumentSnapshot user =
        await userService.getDoc(uid: AuthenticationService.uid).get();
    final data = user.data()! as Map<String, dynamic>;
    this.typeAccount = UserModel.fromJson(data).typeAccount;
    notifyListeners();
  }

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
