import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sopi/models/assets/asset_product_model.dart';
import 'package:sopi/models/assets/asset_timeline_settings.dart';
import 'package:sopi/models/orders/order_item_model.dart';
import 'package:sopi/models/orders/products/order_product_model.dart';
import 'package:sopi/models/products/enums/product_enum_type.dart';
import 'package:sopi/models/user/user_model.dart';
import 'package:sopi/services/assets/asset_service.dart';
import 'package:sopi/services/orders/order_service.dart';
import 'package:sopi/services/users/user_service.dart';

class AssetItemModel {
  final _orderService = OrderService.singleton;
  final _userService = UserService.singleton;
  final _assetService = AssetService.singleton;
  String aid;
  String name;
  bool editMode = false;
  ProductType assignedProductType;
  List<UserModel> assignedEmployees = [];
  AssetProductModel processingProduct;
  List<AssetProductModel> waitingProducts = [];

  /// Get's only waiting product who startTimeline < product < endTimeline
  List<AssetProductModel> get availableWaitingProducts {
    return waitingProducts.where((product) {
      DateTime productEndDate = product.startProcessingDate.add(Duration(minutes: product.totalPrepareTime));
      return productEndDate.isAfter(AssetTimelineSettings.availableStartTimeline) && product.startProcessingDate.isBefore(AssetTimelineSettings.availableEndTimeline);
    }
    ).toList();
  }

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

  /// CALLING WHEN CLIENT ORDERED A NEW ORDER
  Future<void> addProduct(
      String name, String pid, String oid, int totalPrepareTime) async {
    AssetProductModel assetProductModel =
        AssetProductModel(name, pid, oid, totalPrepareTime);
    this.processingProduct == null
        ? await this.updateProcessingProduct(assetProductModel)
        : await this.addWaitingProduct(assetProductModel);
  }

  /// CALLING WHEN EMPLOYEE SET ACTUAL PREPARE PRODUCT AS COMPLETED
  Future<Null> completeProcessingProduct() async {
    final AssetProductModel firstWaitingProduct =
        await this.getFirstWaitingProductForProcessing();

    firstWaitingProduct != null
        ? this.updateProcessingProduct(firstWaitingProduct)
        : this.removeProcessingProduct();
  }

  Future<void> removeProcessingProduct() async {
    this.processingProduct = null;
    final data = {'processingProduct': FieldValue.delete()};
    await _assetService.updateDoc(this.aid, data);
  }

  Future<void> updateProcessingProduct(
      AssetProductModel assetProductModel) async {
    this.processingProduct = assetProductModel;
    final oid = assetProductModel.oid;
    final pid = assetProductModel.pid;

    OrderItemModel order = await _orderService.getOrderById(oid);

    OrderProductModel orderProductModel = order.getProductByPid(pid);
    orderProductModel.startProcessingDate = DateTime.now();

    _orderService.updateOrder(oid, order);

    final data = {
      'processingProduct': this.processingProduct.toJson(),
    };
    await _assetService.updateDoc(this.aid, data);
  }

  Future<AssetProductModel> getFirstWaitingProductForProcessing() async {
    AssetProductModel firstWaiting;

    if (this.waitingProducts.isNotEmpty) {
      firstWaiting = this.waitingProducts.first;
      this.waitingProducts.removeAt(0);
      await this.updateWaitingProducts();
    }
    return firstWaiting;
  }

  /// Add product to waiting queque, sort by totalPrepareTime and set in db
  Future<void> addWaitingProduct(AssetProductModel assetProductModel) async {
    this.waitingProducts.add(assetProductModel);
    await this.sortWaitingProducts();
    await this.updateWaitingProducts();
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

  Future<Null> sortWaitingProducts() async {
    this
        .waitingProducts
        .sort((a, b) => a.totalPrepareTime.compareTo(b.totalPrepareTime));
  }

  Future<void> updateWaitingProducts() async {
    List<dynamic> waitingProductsJson = [];
    for (AssetProductModel assetProduct in this.waitingProducts) {
      waitingProductsJson.add(assetProduct.toJson());
    }
    final data = {'waitingProducts': waitingProductsJson};
    await _assetService.updateDoc(this.aid, data);
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
