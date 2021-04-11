import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:sopi/factory/field_validation_factory.dart';
import 'package:sopi/models/generic/generic_item_model.dart';

class FieldBuilderFactory {
  dynamic data;
  final FieldValidationFactory _fieldValidate = FieldValidationFactory();
  static final FieldBuilderFactory _singleton = FieldBuilderFactory._internal();

  factory FieldBuilderFactory() {
    return _singleton;
  }

  FieldBuilderFactory._internal();

  static FieldBuilderFactory get singleton => _singleton;

  Widget buildTextField({
    String fieldName,
    dynamic initialValue,
    bool isVisible = true,
    Color valueColor,
    TextInputType keyboardType,
    TextEditingController controller,
    int maxLines = 1,
    String labelText,
    Color labelColor,
    bool obscureText = false,
    Widget suffixIcon,
    Function onChangedHandler,
  }) {
   return !isVisible
       ? Container()
       : Column(
           children: [
             FormBuilderTextField(
               name: fieldName,
               initialValue: initialValue,
               keyboardType: keyboardType,
               controller: controller,
               maxLines: maxLines,
               style: TextStyle(
                 color: valueColor,
               ),
               obscureText: obscureText,
               decoration: InputDecoration(
                 labelText: labelText,
                 labelStyle: TextStyle(
                   color: labelColor,
                 ),
                 suffixIcon: suffixIcon,
               ),
               validator: (input) =>
                   _fieldValidate.validateFields(fieldName, input),
               onChanged: (value) => _onChanged(fieldName, value,onChangedHandler: onChangedHandler),
             ),
             SizedBox(height: 10),
           ],
         );
  }

  Widget buildTouchSpinField({
    String fieldName,
    dynamic initialValue,
    num max = 1.0,
    bool isVisible = true,
    Widget suffixIcon,
    String labelText,
    Function onChangedHandler,
  }) {
    return Text('WAITING FOR UPGRADE VERSION');
    /// TODO waiting FlutterFormBuilder support TouchSpin
   // return !isVisible
   //     ? Container()
   //     : Column(
   //         children: [
   //           FormBuilderTouchSpin(
   //             name: fieldName,
   //             displayFormat: NumberFormat.decimalPattern(),
   //             initialValue: initialValue,
   //             max: max,
   //             decoration: InputDecoration(
   //               labelText: labelText,
   //               suffixIcon: suffixIcon,
   //             ),
   //             onChanged: (value) => _onChanged(fieldName, value,
   //                 onChangedHandler: onChangedHandler),
   //           ),
   //           SizedBox(height: 10),
   //         ],
   //       );
  }

  Widget buildDropdownField({
    String fieldName,
    bool isVisible = true,
    String labelText,
    Color labelColor,
    Color labelDropdownColor,
    Color dropdownColor,
    List<GenericItemModel> items,
    Function onChangedHandler,
    dynamic initialValue,
  }) {
   return !isVisible
       ? Container()
       : Column(
           children: [
             FormBuilderDropdown(
               name: labelText,
               decoration: InputDecoration(
                 labelText: labelText,
                 labelStyle: TextStyle(
                   color: labelColor,
                 ),
               ),
               items: items
                   .map((GenericItemModel item) => DropdownMenuItem(
                         child: Text(
                           item.name,
                           style: TextStyle(color: labelDropdownColor),
                         ),
                         value: item.id,
                       ))
                   .toList(),
               dropdownColor: dropdownColor,
               onChanged: (value) => _onChanged(fieldName, value,
                   onChangedHandler: onChangedHandler),
               initialValue: initialValue,
             ),
             SizedBox(height: 15),
           ],
         );
  }

  void _onChanged(String fieldName, value, {Function onChangedHandler}) {
    this.data?.changeValueInForm(fieldName, value);
    if (onChangedHandler != null) {
      onChangedHandler(value);
    }
  }
}
