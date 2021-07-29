import 'package:sopi/models/generic/generic_item_model.dart';

// ignore: avoid_classes_with_only_static_members
class AssetTimelineSettingsDefaultModel {
  static const int differenceInMinutes = 15;
  static const double rangeForwards = 6;
  static const double rangeBackwards = -5;

  static List<GenericItemModel> availableDifferenceInMinutes = [
    GenericItemModel(id: 5, name: '5'),
    GenericItemModel(id: 10, name: '10'),
    GenericItemModel(id: 15, name: '15'),
    GenericItemModel(id: 20, name: '20'),
    GenericItemModel(id: 30, name: '30'),
  ];
}
