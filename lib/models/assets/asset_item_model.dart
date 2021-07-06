import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:json_annotation/json_annotation.dart';
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

part 'asset_item_model.g.dart';

@JsonSerializable(explicitToJson: true)
class AssetItemModel {
  final _orderService = OrderService.singleton;
  final _userService = UserService.singleton;
  final _assetService = AssetService.singleton;
  String? aid;
  String? name;
  @JsonKey(ignore: true)
  bool editMode = false;
  late ProductType assignedProductType;
  @JsonKey(ignore: true)
  List<UserModel?> assignedEmployees = [];
  List<AssetProductModel> queueProducts = [];

  AssetItemModel();

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
      return product.plannedStartProcessingDate
              .isAfter(AssetTimelineSettings.availableStartTimeline) &&
          product.plannedEndProcessingDate
              .isBefore(AssetTimelineSettings.availableEndTimeline);
    }).toList();
  }

  factory AssetItemModel.fromJson(Map<String, dynamic> json) =>
      _$AssetItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$AssetItemModelToJson(this);

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
  Future<void> addProductsFromOrderToQueue(String oid,
      DateTime theLatestAssetEnd, List<OrderProductModel> products) async {
    int totalTime = products.fold(0,
        (previousValue, element) => previousValue + element.totalPrepareTime);
    for (OrderProductModel product in products) {
      AssetProductModel assetProductModel = AssetProductModel.fromOrder(
        product.name,
        product.pid,
        oid,
        product.totalPrepareTime,
      );
      if (this.processingProduct == null) {
        assetProductModel.status = AssetEnumStatus.PROCESSING;
      }
      assetProductModel.plannedStartProcessingDate =
          theLatestAssetEnd.add(Duration(minutes: -totalTime));
      totalTime = totalTime - product.totalPrepareTime;
      this.queueProducts.add(assetProductModel);
      await this.updateQueueProducts();
    }
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
