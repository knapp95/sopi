import 'package:flutter/material.dart';

class GenericItemModel {
  String id;
  Object name;
  Color color;
  IconData icon;
  Function funHandler;
  GenericItemModel({this.id, this.name, this.color, this.icon, this.funHandler});
}
