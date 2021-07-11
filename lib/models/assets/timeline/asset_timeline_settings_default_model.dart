import 'package:sopi/models/generic/generic_item_model.dart';

class AssetTimelineSettingsDefaultModel {
  static  const int differenceInMinutes = 15;
  static  const double rangeForwards = 6;
  static  const double rangeBackwards = -5;

  static List<GenericItemModel> availableDifferenceInMinutes = [
    GenericItemModel(id: 5, name: '5'),
    GenericItemModel(id: 10, name: '10'),
    GenericItemModel(id: 15, name: '15'),
    GenericItemModel(id: 20, name: '20'),
    GenericItemModel(id: 30, name: '30'),
    GenericItemModel(id: 40, name: '40'),
    GenericItemModel(id: 50, name: '50'),
    GenericItemModel(id: 60, name: '60'),
  ];
}