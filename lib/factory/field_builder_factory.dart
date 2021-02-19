import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:sopi/factory/field_validation_factory.dart';
import 'package:sopi/models/generic/generic_item_model.dart';

class FieldBuilderFactory {
  final FieldValidationFactory _fieldValidate = FieldValidationFactory();
  static final FieldBuilderFactory _singleton = FieldBuilderFactory._internal();

  factory FieldBuilderFactory() {
    return _singleton;
  }

  FieldBuilderFactory._internal();

  static FieldBuilderFactory get singleton => _singleton;

  Widget buildTextField({
    bool isVisible = true,
    TextEditingController controller,
    String labelText,
    bool obscureText = false,
    Widget suffixIcon,
    String fieldName,
  }) {
    return !isVisible
        ? Container()
        : FormBuilderTextField(
            name: fieldName,
            controller: controller,
            style: TextStyle(
              color: Colors.white,
            ),
            obscureText: obscureText,
            decoration: InputDecoration(
              labelText: labelText,
              labelStyle: TextStyle(
                color: Colors.white24,
              ),
              suffixIcon: suffixIcon,
            ),
            validator: (input) =>
                _fieldValidate.validateFields(fieldName, input),
          );
  }

  Widget buildDropdownField({
    bool isVisible = true,
    String labelText,
    List<GenericItemModel> items,
    Function onChanged,
    String initialValue,
  }) {
    return !isVisible
        ? Container()
        : FormBuilderDropdown(
            name: labelText,
            decoration: InputDecoration(
              labelText: labelText,
              labelStyle: TextStyle(
                color: Colors.white24,
              ),
            ),
            items: items
                .map((GenericItemModel item) => DropdownMenuItem(
                      child: Text(
                        item.name,
                        style: TextStyle(color: Colors.white),
                      ),
                      value: item.id,
                    ))
                .toList(),
            dropdownColor: Colors.lightGreen,
            onChanged: onChanged,
          initialValue: initialValue,
          );
  }
}
