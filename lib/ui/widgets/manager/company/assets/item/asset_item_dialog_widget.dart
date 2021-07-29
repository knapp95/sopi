import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:sopi/factory/field_builder_factory.dart';
import 'package:sopi/models/assets/asset_item_model.dart';
import 'package:sopi/models/products/products_model.dart';
import 'package:sopi/models/user/user_model.dart';
import 'package:sopi/services/assets/asset_service.dart';
import 'package:sopi/services/users/user_service.dart';
import 'package:sopi/ui/shared/animations.dart';
import 'package:sopi/ui/shared/app_colors.dart';
import 'package:sopi/ui/shared/styles/shared_style.dart';
import 'package:sopi/ui/widgets/common/dialogs/confirm_dialog.dart';
import 'package:sopi/ui/widgets/common/loadingDataInProgress/loading_data_in_progress_widget.dart';
import 'package:sopi/ui/widgets/manager/common/asset_show_image.dart';
import 'package:sopi/ui/widgets/manager/company/assets/assign/employee/asset_employee_item_widget.dart';
import 'package:sopi/ui/widgets/manager/company/assets/common/color_box_widget.dart';
import 'package:sopi/ui/widgets/manager/company/assets/pickers/picker_color_widget.dart';
import 'package:sopi/ui/widgets/manager/company/assets/pickers/picker_type_widget.dart';

class AssetItemDialogWidget extends StatefulWidget {
  final AssetItemModel? assetItem;

  const AssetItemDialogWidget([this.assetItem, Key? key]) : super(key: key);

  @override
  _AssetItemDialogWidgetState createState() => _AssetItemDialogWidgetState();
}

class _AssetItemDialogWidgetState extends State<AssetItemDialogWidget> {
  final _assetService = AssetService.singleton;
  late AssetItemModel _assetItem;
  final FieldBuilderFactory _formFactory = FieldBuilderFactory();
  final _userService = UserService.singleton;
  bool _isInit = true;
  bool _isLoading = false;
  List<UserModel> _employees = [];

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _assetItem = widget.assetItem ?? AssetItemModel();
      _formFactory.data = _assetItem;
      setState(() {
        _isLoading = true;
      });
      _loadData();
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  Future<void> _loadData() async {
    _employees = await _userService.fetchAllEmployees();
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<FormBuilderFieldOption> get employeesMultiSelectOption => _employees
      .map(
        (employee) => FormBuilderFieldOption(
          value: employee.uid,
          child: AssetEmployeeWidget(employee),
        ),
      )
      .toList();

  Future<void> _changeTypeImage() async {
    final String? imagePath =
        await showScaleDialog(PickerTypeWidget(_assetItem.imagePath))
            as String?;
    setState(() {
      _assetItem.imagePath = imagePath;
    });
  }

  Future<void> _changeColor() async {
    final Color? selectedColor =
        await showScaleDialog(const PickerColorWidget()) as Color?;
    setState(() {
      _assetItem.color = selectedColor ?? Colors.grey;
    });
  }

  Future<void> _submit() async {
    await _assetItem.saveAssetToFirebase();
    Navigator.of(context).pop();
  }

  Future<void> _removeAsset() async {
    final bool? confirm = await showScaleDialog(
      ConfirmDialog('Remove ${_assetItem.name}?'),
    ) as bool?;
    if (confirm == true) {
      await _assetService.removeDoc(_assetItem.aid);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_assetItem.isNew ? 'Add asset' : 'Edit asset'),
      shape: shapeDialog,
      elevation: defaultElevation,
      content: _isLoading
          ? const LoadingDataInProgressWidget()
          : SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: _changeTypeImage,
                        child: SizedBox(
                          width: 130,
                          height: 130,
                          child: Stack(
                            children: <Widget>[
                              AssetShowImage(
                                _assetItem.imagePath,
                                width: 130,
                                height: 130,
                              ),
                              Container(
                                padding: const EdgeInsets.all(8.0),
                                alignment: Alignment.bottomRight,
                                child: const Icon(
                                  Icons.change_circle,
                                  size: 40,
                                  color: primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      formSizedBoxWidth,
                      Expanded(
                        child: Column(
                          children: [
                            _formFactory.buildDropdownField(
                              fieldName: 'assignedProductType',
                              initialValue: _assetItem.assignedProductType,
                              labelText: 'Type',
                              items: ProductsModel.availableProductsTypes,
                            ),
                            _formFactory.buildDropdownField(
                              fieldName: 'maxWaitingTime',
                              initialValue: _assetItem.maxWaitingTime ?? 15,
                              labelText: 'Max waiting time',
                              items: ProductsModel.times,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      InkWell(
                        onTap: _changeColor,
                        child: ColorBoxWidget(_assetItem.color),
                      ),
                      formSizedBoxWidth,
                      Expanded(
                        child: _formFactory.buildTextField(
                          labelText: 'Name',
                          fieldName: 'name',
                          initialValue: _assetItem.name,
                        ),
                      ),
                    ],
                  ),
                  _formFactory.buildMultiSelectList(
                    fieldName: 'assignedEmployeesIds',
                    options: employeesMultiSelectOption,
                    initialValue: _assetItem.assignedEmployeesIds,
                    labelText: 'Select assigned employee',
                  ),
                ],
              ),
            ),
      actions: [
        if (_assetItem.aid != null) _buildRemoveButton(),
        backDialogButton,
        submitDialogButton(_submit)
      ],
    );
  }

  TextButton _buildRemoveButton() {
    return TextButton(
      onPressed: _removeAsset,
      child: const Text(
        'Remove',
        style: TextStyle(color: Colors.red),
      ),
    );
  }
}
