
import 'package:flutter/material.dart';
import 'package:sopi/models/assets/enums/asset_enum_type.dart';

class AssetTypeModel {
  final AssetsEnumType type;
  final String name;
  final IconData icon;
  AssetTypeModel(this.type, this.name, [this.icon]);
}
