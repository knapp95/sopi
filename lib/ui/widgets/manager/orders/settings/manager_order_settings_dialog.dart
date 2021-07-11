import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sopi/common/scripts.dart';
import 'package:sopi/factory/field_builder_factory.dart';
import 'package:sopi/models/assets/asset_model.dart';
import 'package:sopi/models/assets/timeline/asset_timeline_settings_default_model.dart';
import 'package:sopi/models/assets/timeline/asset_timeline_settings_model.dart';
import 'package:sopi/ui/shared/app_colors.dart';
import 'package:sopi/ui/shared/styles/shared_style.dart';
import 'package:sopi/ui/widgets/common/loadingDataInProgress/loading_data_in_progress_widget.dart';

class ManagerOrderSettingsDialog extends StatefulWidget {
  @override
  _ManagerOrderSettingsDialogState createState() =>
      _ManagerOrderSettingsDialogState();
}

class _ManagerOrderSettingsDialogState
    extends State<ManagerOrderSettingsDialog> {
  final FieldBuilderFactory _formFactory = FieldBuilderFactory();
  final AssetTimelineSettingsModel _assetTimelineSettingsModel =
      Provider.of<AssetModel>(Get.context!).assetTimelineSettings!;
  late int _selectedDifferenceInMinutes;
  late double _selectedRangeForwards;
  late double _selectedRangeBackwards;
  bool _isLoading = false;

  void _assignTimelineSettingsData() async {
    _selectedDifferenceInMinutes =
        _assetTimelineSettingsModel.differenceInMinutes;
    _selectedRangeBackwards = _assetTimelineSettingsModel.rangeBackwards;
    _selectedRangeForwards = _assetTimelineSettingsModel.rangeForwards;

    setState(() {
      _isLoading = false;
    });
  }

  void _setTimelineSettings() async {
    _assetTimelineSettingsModel.update(
      selectedDifferenceInMinutes: _selectedDifferenceInMinutes,
      selectedRangeBackwards: _selectedRangeBackwards,
      selectedRangeForwards: _selectedRangeForwards,
    );
    Get.back();
  }

  void _changeSelectedDifferenceInMinutes(int value) {
    setState(() {
      _selectedDifferenceInMinutes = value;
    });
  }

  void _changeSelectedRangeForwards(double value) {
    setState(() {
      _selectedRangeForwards = double.parse(value.toStringAsFixed(2));
    });
  }

  void _changeSelectedRangeBackwards(double value) {
    setState(() {
      _selectedRangeBackwards = double.parse(value.toStringAsFixed(2));
    });
  }

  String get selectedRange {
    String selectedRangeBackwards = formatDateToString(
        _assetTimelineSettingsModel.getRangeDate(_selectedRangeBackwards),
        format: 'HH:mm');
    String selectedRangeForwards = formatDateToString(
        _assetTimelineSettingsModel.getRangeDate(_selectedRangeForwards),
        format: 'HH:mm');
    return '$selectedRangeBackwards - $selectedRangeForwards';
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _assignTimelineSettingsData();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: shapeDialog,
      elevation: defaultElevation,
      content: SingleChildScrollView(
        reverse: true,
        child: _isLoading
            ? LoadingDataInProgressWidget()
            : Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      width: 100,
                      child: _formFactory.buildDropdownField(
                          fieldName: 'spaceTime',
                          initialValue: _selectedDifferenceInMinutes,
                          labelText: 'Space time',
                          labelColor: primaryColor,
                          labelDropdownColor: primaryColor,
                          border: InputBorder.none,
                          items: AssetTimelineSettingsDefaultModel
                              .availableDifferenceInMinutes,
                          onChangedHandler: _changeSelectedDifferenceInMinutes),
                    ),
                  ),
                  _formFactory.buildSliderField(
                    initialValue: _selectedRangeBackwards,
                    min: -12,
                    max: 0,
                    labelText: 'Od',
                    onChangedHandler: _changeSelectedRangeBackwards,
                  ),
                  Text(
                    selectedRange,
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  _formFactory.buildSliderField(
                    initialValue: _selectedRangeForwards,
                    min: 0,
                    max: 12,
                    labelText: 'Do',
                    onChangedHandler: _changeSelectedRangeForwards,
                  ),

                ],
              ),
      ),
      actions: [
        backDialogButton,
        TextButton(
          onPressed: _setTimelineSettings,
          child: Text(
            'Confirm',
            style: TextStyle(color: primaryColor),
          ),
        ),
      ],
    );
  }
}
