import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sopi/factory/field_builder_factory.dart';
import 'package:sopi/models/assets/asset_item_model.dart';
import 'package:sopi/ui/shared/app_colors.dart';
import 'package:sopi/ui/shared/shared_styles.dart';
import 'employee/asset_employee_item_widget.dart';
import 'employee/asset_employee_unassigned_widget.dart';

class AssetItemWidget extends StatefulWidget {
  final AssetItemModel asset;
  final bool assignEmployee;
  final Function removeHandler;

  AssetItemWidget(this.asset, this.assignEmployee, this.removeHandler);

  @override
  _AssetItemWidgetState createState() => _AssetItemWidgetState(this.asset);
}

class _AssetItemWidgetState extends State<AssetItemWidget> {
  final AssetItemModel asset;

  _AssetItemWidgetState(this.asset);

  final FieldBuilderFactory _formFactory = FieldBuilderFactory();
  final GlobalKey _assetItemKey = GlobalKey();
  Size _assetItemSize;
  Offset cardPosition;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => getSizeAndPosition());
  }

  getSizeAndPosition() {
    if (_assetItemKey.currentContext != null) {
      RenderBox _cardBox = _assetItemKey.currentContext.findRenderObject();
      _assetItemSize = _cardBox.size;
    }
  }

  void _changeEditMode(AssetItemModel asset) {
    if (asset.editMode) {
      asset.updateName();
    }
    setState(() {
      asset.editMode = !asset.editMode;
    });
  }

  void _removeEmployee(String id) {
    setState(() {
      asset.removeAssignedEmployee(id);
    });
  }

  @override
  Widget build(BuildContext context) {
    getSizeAndPosition();
    final textColor = widget.assignEmployee ? Colors.white : Colors.black;

    return Transform.scale(
      scale: widget.assignEmployee ? 1.075 : 1.0,
      child: Material(
        borderRadius: BorderRadius.circular(22.0),
        elevation: widget.assignEmployee ? 8.0 : 4.0,
        color: widget.assignEmployee ? primaryColor : Colors.white,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10.0,
            vertical: 10.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (asset.editMode) _buildRemoveAssetButton(asset),
                  asset.editMode
                      ? Expanded(
                          child: _formFactory.buildTextField(
                          initialValue: asset.name,
                          onChangedHandler: (value) => asset.name = value,
                        ))
                      : Text(
                          asset.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: fontSize20,
                            color: textColor,
                          ),
                        ),
                  _buildEditModeAssetNameButtons(asset),
                ],
              ),
              Container(
                key: _assetItemKey,
                child: !widget.assignEmployee
                    ? asset.assignedEmployees.length == 0
                        ? AssetEmployeeUnassignedWidget()
                        : SingleChildScrollView(
                            child: Wrap(
                              spacing: 5,
                              children: asset.assignedEmployees
                                  .map((employee) => AssetEmployeeWidget(
                                        employee,
                                        onDeleteHandler: asset.editMode
                                            ? _removeEmployee
                                            : null,
                                      ))
                                  .toList(),
                            ),
                          )
                    : Container(
                        height: _assetItemSize.height,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.double_arrow, color: textColor),
                            Center(
                              child: Text(
                                'Drop here to assign',
                                style: TextStyle(
                                    color: textColor, fontSize: fontSize20),
                              ),
                            ),
                          ],
                        ),
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRemoveAssetButton(AssetItemModel asset) {
    return IconButton(
      onPressed: () => widget.removeHandler(asset),
      icon: FaIcon(
        FontAwesomeIcons.trash,
        color: Colors.red,
        size: 18,
      ),
    );
  }

  Widget _buildEditModeAssetNameButtons(AssetItemModel asset) {
    return IconButton(
      onPressed: () => _changeEditMode(asset),
      icon: FaIcon(
        asset.editMode ? FontAwesomeIcons.save : FontAwesomeIcons.pencilAlt,
        color: Colors.blue,
        size: 18,
      ),
    );
  }
}
