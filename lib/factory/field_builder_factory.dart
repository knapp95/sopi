import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:sopi/factory/field_validation_factory.dart';
import 'package:sopi/models/generic/generic_item_model.dart';
import 'package:sopi/ui/shared/app_colors.dart';
import 'package:sopi/ui/shared/styles/shared_style.dart';

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
    String fieldName = 'field',
    dynamic initialValue,
    bool isVisible = true,
    Color? valueColor,
    TextInputType? keyboardType,
    TextEditingController? controller,
    int maxLines = 1,
    String? labelText,
    Color? labelColor,
    bool obscureText = false,
    Widget? suffixIcon,
    Function? onChangedHandler,
  }) {
    return !isVisible
        ? Container()
        : Column(
            mainAxisAlignment: MainAxisAlignment.start,
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
                  alignLabelWithHint: true,
                  labelStyle: TextStyle(
                    color: labelColor,
                  ),
                  suffixIcon: suffixIcon,
                ),
                validator: (input) =>
                    _fieldValidate.validateFields(fieldName, input!),
                onChanged: (value) => _onChanged(fieldName, value,
                    onChangedHandler: onChangedHandler),
              ),
              formSizedBoxHeight
            ],
          );
  }

  Widget buildSliderField({
    required double initialValue,
    required double min,
    required double max,
    String fieldName = 'field',
    String? labelText,
    Color labelColor = primaryColor,
    Function? onChangedHandler,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        FormBuilderSlider(
          decoration: InputDecoration(
            border: InputBorder.none,
            labelText: labelText,
            labelStyle: TextStyle(
              color: labelColor,
            ),
          ),
          onChanged: (dynamic value) =>
              _onChanged(fieldName, value, onChangedHandler: onChangedHandler),
          displayValues: DisplayValues.none,
          initialValue: initialValue,
          min: min,
          max: max,
          name: fieldName,
        ),
        formSizedBoxHeight
      ],
    );
  }

  Widget buildNumberPicker({
    String? fieldName,
    required dynamic value,
    required int max,
    bool isVisible = true,
    Widget? suffixIcon,
    String? labelText,
    Function? onChangedHandler,
  }) {
    final canSubtraction = value > 1;
    final canAdd = value < max;
    return !isVisible
        ? Container()
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  icon: Icon(Icons.arrow_left),
                  onPressed: () => canSubtraction
                      ? _onChanged(fieldName, value - 1,
                          onChangedHandler: onChangedHandler)
                      : null),
              Text(
                '$value',
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: fontSize20),
              ),
              IconButton(
                icon: Icon(Icons.arrow_right),
                onPressed: () => canAdd
                    ? _onChanged(fieldName, value + 1,
                        onChangedHandler: onChangedHandler)
                    : null,
              ),
            ],
          );
  }

  Widget buildDropdownField({
    String? fieldName,
    bool isVisible = true,
    String? labelText,
    Color? labelColor,
    Color? labelDropdownColor,
    Color? dropdownColor,
    InputBorder? border,
    List<GenericItemModel>? items,
    Function? onChangedHandler,
    dynamic initialValue,
  }) {
    return !isVisible
        ? Container()
        : Column(
            children: [
              FormBuilderDropdown(
                name: labelText!,
                decoration: InputDecoration(
                  border: border,
                  labelText: labelText,
                  labelStyle: TextStyle(
                    color: labelColor,
                  ),
                ),
                items: items!
                    .map((GenericItemModel item) => DropdownMenuItem(
                          child: Text(
                            item.name!,
                            style: TextStyle(color: labelDropdownColor),
                          ),
                          value: item.id,
                        ))
                    .toList(),
                dropdownColor: dropdownColor,
                onChanged: (dynamic value) => _onChanged(fieldName, value,
                    onChangedHandler: onChangedHandler),
                initialValue: initialValue,
              ),
              SizedBox(height: 15),
            ],
          );
  }

  void _onChanged(String? fieldName, value, {Function? onChangedHandler}) {
    this.data?.changeValueInForm(fieldName, value);
    if (onChangedHandler != null) {
      onChangedHandler(value);
    }
  }
}
