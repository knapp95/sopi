import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sopi/factory/field_builder_factory.dart';
import 'package:sopi/models/assets/asset_item_model.dart';
import 'package:sopi/models/assets/assets_model.dart';
import 'package:sopi/models/user/user_model.dart';
import 'package:sopi/ui/shared/app_colors.dart';
import 'package:sopi/ui/shared/shared_styles.dart';
import 'package:sopi/ui/widgets/common/loadingDataInProgress/loading_data_in_progress_widget.dart';

@immutable
class ExampleDragAndDrop extends StatefulWidget {
  @override
  _ExampleDragAndDropState createState() => _ExampleDragAndDropState();
}

class _ExampleDragAndDropState extends State<ExampleDragAndDrop>
    with TickerProviderStateMixin {
  final FieldBuilderFactory _formFactory = FieldBuilderFactory();
  bool _isInit = true;
  bool _isLoading = false;
  List<AssetItemModel> _assets = [];
  List<UserModel> _employees = [];

  Future<Null> _loadData() async {
    AssetsModel assets = Provider.of<AssetsModel>(context);
    if (!assets.isInit) {
      await assets.fetchAssets();
    }
    _employees = await UserModel.fetchAllEmployees();

    setState(() {
      _isLoading = false;
    });
    _assets = assets.assets;
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      _loadData();
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  final GlobalKey _draggableKey = GlobalKey();

  void assignEmployeeToAsset({
    UserModel employee,
    AssetItemModel asset,
  }) {
    if (!asset.assignedEmployees
        .any((assignedEmployee) => assignedEmployee.uid == employee.uid)) {
      asset.assignedEmployees.add(employee);
      asset.updateAssignedEmployeesIds();
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

  void _removeAsset(AssetItemModel asset) {
    asset.removeAsset();
    setState(() {
      _assets.removeWhere((element) => element.aid == asset.aid);
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? LoadingDataInProgressWidget()
        : Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    flex: 3,
                    child: _buildAssetsList(),
                  ),
                  Expanded(child: _buildEmployees()),
                ],
              ),
            ],
          );
  }

  Widget _buildAssetsList() {
    return ListView.separated(
      padding: const EdgeInsets.all(8.0),
      itemCount: _assets.length,
      separatorBuilder: (context, index) {
        return const SizedBox(
          height: 10.0,
        );
      },
      itemBuilder: (context, index) {
        final asset = _assets[index];
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 6.0,
          ),
          child: DragTarget<UserModel>(
            builder: (context, assignEmployee, _) {
              return _buildAssetItem(
                asset,
                assignEmployee.isNotEmpty,
              );
            },
            onAccept: (employee) {
              assignEmployeeToAsset(
                employee: employee,
                asset: asset,
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildEmployees() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
      ),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hold employee to assign',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: fontSize20,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Wrap(
                  spacing: 5,
                  children: _employees
                      .map(
                        (employee) => LongPressDraggable<UserModel>(
                            data: employee,
                            dragAnchor: DragAnchor.pointer,
                            feedback: FractionalTranslation(
                              key: _draggableKey,
                              translation: const Offset(-0.5, -0.5),
                              child: Material(
                                  child: _buildEmployeeWidget(employee)),
                            ),
                            child: _buildEmployeeWidget(employee)),
                      )
                      .toList()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssetItem(AssetItemModel asset, bool assignEmployee) {
    final textColor = assignEmployee ? Colors.white : Colors.black;
    print(asset.name);

    return Transform.scale(
      scale: assignEmployee ? 1.075 : 1.0,
      child: Material(
        borderRadius: BorderRadius.circular(22.0),
        elevation: assignEmployee ? 8.0 : 4.0,
        color: assignEmployee ? primaryColor : Colors.white,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10.0,
            vertical: 10.0,
          ),
          height: 150,
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
              !assignEmployee
                  ? asset.assignedEmployees.length == 0
                      ? _buildUnAssignedEmployeeWarningWidget()
                      : Expanded(
                          child: SingleChildScrollView(
                            child: Wrap(
                                spacing: 5,
                                children: asset.assignedEmployees
                                    .map((employee) =>
                                        _buildEmployeeWidget(employee))
                                    .toList()),
                          ),
                        )
                  : Expanded(
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
                          )),
                        ],
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmployeeWidget(UserModel employee) {
    return Chip(
      backgroundColor: Colors.white,
      shape: shapeDialog,
      avatar: ClipOval(
        child: SizedBox(
          width: 46,
          height: 46,
          child: Image.network(
            employee.profilePhoto,
            fit: BoxFit.cover,
          ),
        ),
      ),
      label: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          employee.username,
        ),
      ),
    );
  }

  Widget _buildUnAssignedEmployeeWarningWidget() {
    return Chip(
      backgroundColor: Colors.white,
      shape: shapeDialogRed,
      avatar: ClipOval(
        child: SizedBox(
          width: 46,
          height: 46,
          child: Icon(
            Icons.warning,
            color: Colors.red,
          ),
        ),
      ),
      label: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          'Not assigned employee',
          style: TextStyle(color: Colors.red),
        ),
      ),
    );
  }

  Widget _buildRemoveAssetButton(AssetItemModel asset) {
    return IconButton(
      onPressed: () => _removeAsset(asset),
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
