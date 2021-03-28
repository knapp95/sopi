import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sopi/common/collections.dart';
import 'package:sopi/models/user/user_model.dart';

class AssetItemModel {
  String aid;
  String name;
  bool editMode = false;
  List<UserModel> assignedEmployees = [];

  AssetItemModel.fromJson(Map<String, dynamic> data) {
    try {
      this.aid = data['aid'];
      this.name = data['name'];
    } catch (e) {
      throw e;
    }
  }

  Future<Null> setAssignedEmployees(List<String> assignedEmployeesIds) async {
    print(assignedEmployeesIds);
    List<UserModel> assignedEmployees = [];
    for (String id in assignedEmployeesIds) {
      DocumentSnapshot user = await usersCollection.doc(id).get();
      final data = user.data();
      assignedEmployees.add(UserModel.fromJson(data));
    }
    this.assignedEmployees = assignedEmployees;
  }

  Future<Null> updateAssignedEmployeesIds() async {
    List<String> assignedEmployeesIds = this.assignedEmployees.map((employee) => employee.uid).toList();
    await assetsCollection.doc(this.aid).update({'assignedEmployeesIds': assignedEmployeesIds});
  }

  Future<Null> updateName() async {
    await assetsCollection.doc(this.aid).update({'name': this.name});
  }

  Future<void> removeAsset() async {
    try {
      assetsCollection.doc(this.aid).delete();
    } catch (e) {
      return e;
    }
  }
}
