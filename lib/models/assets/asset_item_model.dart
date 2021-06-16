import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:sopi/models/assets/asset_product_model.dart';
import 'package:sopi/models/assets/asset_timeline_settings.dart';
import 'package:sopi/models/assets/enums/asset_enum_status.dart';
import 'package:sopi/models/orders/order_model.dart';
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
  String? aid;
  String? name;
  bool editMode = false;
  ProductType? assignedProductType;
  List<UserModel?> assignedEmployees = [];
  List<AssetProductModel> queueProducts = [];

  List<AssetProductModel> get waitingProducts {
    return this
        .queueProducts
        .where((element) => element.status == AssetEnumStatus.WAITING)
        .toList();
  }

  AssetProductModel? get processingProduct {
    return this.queueProducts.firstWhereOrNull(
        (element) => element.status == AssetEnumStatus.PROCESSING);
  }

  /// Get's products from queue who startTimeline < product < endTimeline
  List<AssetProductModel> get queueProductsTimeline {
    return this.queueProducts.where((product) {
      DateTime productEndDate =
          product.createDate!.add(Duration(minutes: product.totalPrepareTime!));
      return productEndDate
              .isAfter(AssetTimelineSettings.availableStartTimeline) &&
          product.createDate!
              .isBefore(AssetTimelineSettings.availableEndTimeline);
    }).toList();
  }

  AssetItemModel.fromJson(Map<String, dynamic> data) {
    try {
      this.aid = data['aid'];
      this.name = data['name'];
      this.assignedProductType =
          getProductTypeFromString(data['assignedProductType']);
      List<dynamic>? extractedQueueProducts = data['queueProducts'];
      if (extractedQueueProducts != null) {
        List<AssetProductModel> queueProductsTmp = [];
        for (dynamic product in extractedQueueProducts) {
          queueProductsTmp.add(AssetProductModel.fromJson(product));
        }
        this.queueProducts = queueProductsTmp;
      }
    } catch (e) {
      throw e;
    }
  }

  /// CALLING WHEN CLIENT ORDERED A NEW ORDER
  Future<void> addProduct(
      String? name, String? pid, String oid, int totalPrepareTime) async {
    AssetProductModel assetProductModel =
        AssetProductModel(name, pid, oid, totalPrepareTime);
    await this.addProductToQueue(assetProductModel);
  }

  /// CALLING WHEN EMPLOYEE SET ACTUAL PREPARE PRODUCT AS COMPLETED
  Future<void> completeProcessingProduct() async {
    this.processingProduct!.status = AssetEnumStatus.PAST;
    AssetProductModel? firstWaitingProduct =
        this.waitingProducts.length > 0 ? this.waitingProducts.first : null;
    if (firstWaitingProduct != null) {
      firstWaitingProduct.status = AssetEnumStatus.PROCESSING;
      this.updateProcessingProduct(firstWaitingProduct);
    }
    await this.updateQueueProducts();
  }

  Future<void> updateProcessingProduct(
      AssetProductModel assetProductModel) async {
    final oid = assetProductModel.oid;
    final pid = assetProductModel.pid;

    OrderModel order = await _orderService.getOrderById(oid);

    OrderProductModel orderProductModel = order.getProductByPid(pid)!;
    orderProductModel.startProcessingDate = DateTime.now();
    _orderService.updateOrder(oid, order);
  }

  /// Add product to queque as WAITING, if queue don't have PROCESSING product set it
  Future<void> addProductToQueue(AssetProductModel assetProductModel) async {
    if (this.processingProduct == null) {
      assetProductModel.status = AssetEnumStatus.PROCESSING;
    }
    this.queueProducts.add(assetProductModel);

    /// await this.sortProductsByPriorityAndPrepareTime();
    await this.updateQueueProducts();
  }

  Future<void> setAssignedEmployees(List<String> assignedEmployeesIds) async {
    List<UserModel?> assignedEmployees = [];
    for (String id in assignedEmployeesIds) {
      DocumentSnapshot user = await _userService.getDoc(uid: id).get();
      final data = user.data()! as Map<String, dynamic>;
      assignedEmployees.add(UserModel.fromJson(data));
    }
    this.assignedEmployees = assignedEmployees;
  }

  Future<void> updateQueueProducts() async {
    List<dynamic> queueProductsJson = [];
    for (AssetProductModel assetProduct in this.queueProducts) {
      queueProductsJson.add(assetProduct.toJson());
    }
    final data = {'queueProducts': queueProductsJson};
    await _assetService.updateDoc(this.aid, data);
  }

  Future<void> updateAssignedEmployeesIds() async {
    List<String?> assignedEmployeesIds =
        this.assignedEmployees.map((employee) => employee!.uid).toList();

    final data = {'assignedEmployeesIds': assignedEmployeesIds};
    await _assetService.updateDoc(this.aid, data);
  }

  Future<void> updateName() async {
    final data = {'name': this.name};
    await _assetService.updateDoc(this.aid, data);
  }

  Future<void> removeAssignedEmployee(String id) async {
    this.assignedEmployees.removeWhere((employee) => employee!.uid == id);
    this.updateAssignedEmployeesIds();
  }
}
