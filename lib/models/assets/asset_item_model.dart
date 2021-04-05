import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sopi/models/assets/asset_product_model.dart';
import 'package:sopi/models/products/enums/product_enum_type.dart';
import 'package:sopi/models/user/user_model.dart';
import 'package:sopi/services/assets/asset_service.dart';
import 'package:sopi/services/users/user_service.dart';

class AssetItemModel {
  final _userService = UserService.singleton;
  final _assetService = AssetService.singleton;
  String aid;
  String name;
  bool editMode = false;
  ProductType assignedProductType;
  List<UserModel> assignedEmployees = [];
  AssetProductModel processingProduct;
  List<AssetProductModel> waitingProducts = [];

  AssetItemModel.fromJson(Map<String, dynamic> data) {
    try {
      this.aid = data['aid'];
      this.name = data['name'];
      this.assignedProductType =
          getProductTypeFromString(data['assignedProductType']);
      if (data['processingProduct'] != null) {
        this.processingProduct =
            AssetProductModel.fromJson(data['processingProduct']);
      }
      List<dynamic> extractedWaitingProducts = data['waitingProducts'];
      if (extractedWaitingProducts != null) {
        List<AssetProductModel> waitingProductsTmp = [];
        for (dynamic waitingProduct in extractedWaitingProducts) {
          waitingProductsTmp.add(AssetProductModel.fromJson(waitingProduct));
        }
        this.waitingProducts = waitingProductsTmp;
      }
    } catch (e) {
      throw e;
    }
  }

  Future<void> addProduct(String pid, String oid, int totalPrepareTime) async {
    AssetProductModel assetProductModel =
        AssetProductModel(pid, oid, totalPrepareTime);
    this.processingProduct == null
        ? this.updateProcessingProduct(assetProductModel)
        : this.updateWaitingProducts(assetProductModel);
  }

  Future<void> updateProcessingProduct(
      AssetProductModel assetProductModel) async {
    this.processingProduct = assetProductModel;
    final data = {'processingProduct': this.processingProduct.toJson()};
    await _assetService.updateDoc(this.aid, data);
  }

  /// Add product to waiting queque, sort by totalPrepareTime and set in db
  Future<void> updateWaitingProducts(
      AssetProductModel assetProductModel) async {
    this.waitingProducts.add(assetProductModel);
    this
        .waitingProducts
        .sort((a, b) => a.totalPrepareTime.compareTo(b.totalPrepareTime));

    List<dynamic> waitingProductsJson = [];
    for (AssetProductModel assetProduct in this.waitingProducts) {
      waitingProductsJson.add(assetProduct.toJson());
    }
    final data = {'waitingProducts': waitingProductsJson};
    await _assetService.updateDoc(this.aid, data);
  }

  Future<Null> setAssignedEmployees(List<String> assignedEmployeesIds) async {
    List<UserModel> assignedEmployees = [];
    for (String id in assignedEmployeesIds) {
      DocumentSnapshot user = await _userService.getDoc(uid: id).get();
      final data = user.data();
      assignedEmployees.add(UserModel.fromJson(data));
    }
    this.assignedEmployees = assignedEmployees;
  }

  Future<Null> updateAssignedEmployeesIds() async {
    List<String> assignedEmployeesIds =
        this.assignedEmployees.map((employee) => employee.uid).toList();

    final data = {'assignedEmployeesIds': assignedEmployeesIds};
    await _assetService.updateDoc(this.aid, data);
  }

  Future<Null> updateName() async {
    final data = {'name': this.name};
    await _assetService.updateDoc(this.aid, data);
  }

  Future<Null> removeAssignedEmployee(String id) async {
    this.assignedEmployees.removeWhere((employee) => employee.uid == id);
    this.updateAssignedEmployeesIds();
  }

}
