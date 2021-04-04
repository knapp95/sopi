import 'package:sopi/models/assets/enums/asset_enum_type.dart';

import 'asset_type_model.dart';

class Types {
  static List<AssetTypeModel> types = [
    AssetTypeModel(AssetsEnumType.DESSERT, 'Dessert'),
    AssetTypeModel(AssetsEnumType.BURGER, 'Burger'),
    AssetTypeModel(AssetsEnumType.PIZZA, 'Pizza'),
    AssetTypeModel(AssetsEnumType.PASTA, 'Pasta'),
    AssetTypeModel(AssetsEnumType.OTHER, 'Other'),
  ];

}

