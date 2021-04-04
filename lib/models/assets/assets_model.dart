import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sopi/common/collections.dart';
import 'package:sopi/models/assets/asset_item_model.dart';
import 'package:flutter/material.dart';

import 'enums/assets_enum_bookmark.dart';



class AssetsModel with ChangeNotifier {
  bool isInit = false;
  List<AssetItemModel> assets = [];
  AssetsEnumBookmark displayBookmarks = AssetsEnumBookmark.EMPLOYEES;

  Future<void> fetchAssets() async {
    try {
      final docs = (await assetsCollection.get())?.docs;
      if (docs != null) {
        List<AssetItemModel> assets = [];
        for (QueryDocumentSnapshot doc in docs) {
          final assetTmp = AssetItemModel.fromJson(doc.data());
          List<String> assignedEmployeesIds =
              List<String>.from(doc.data()['assignedEmployeesIds']);
          await assetTmp.setAssignedEmployees(assignedEmployeesIds);
          assets.add(assetTmp);
        }
        this.assets = assets;
        this.isInit = true;
        notifyListeners();
      }
    } catch (e) {
      return e;
    }
  }
}
