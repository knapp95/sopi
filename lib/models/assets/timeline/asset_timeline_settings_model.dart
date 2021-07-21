import 'package:json_annotation/json_annotation.dart';
import 'package:sopi/common/scripts.dart';
import 'package:sopi/models/assets/timeline/asset_timeline_settings_default_model.dart';
import 'package:sopi/services/settings/settings_service.dart';

part 'asset_timeline_settings_model.g.dart';

@JsonSerializable()
class AssetTimelineSettingsModel {
  static const id = 'timeline';
  final _settingsService = SettingsService.singleton;
  int? selectedDifferenceInMinutes;
  double? selectedRangeForwards;
  double? selectedRangeBackwards;

  int get differenceInMinutes =>
      this.selectedDifferenceInMinutes ??
      AssetTimelineSettingsDefaultModel.differenceInMinutes;

  double get rangeForwards =>
      this.selectedRangeForwards ??
      AssetTimelineSettingsDefaultModel.rangeForwards;

  double get rangeBackwards =>
      this.selectedRangeBackwards ??
      AssetTimelineSettingsDefaultModel.rangeBackwards;

  AssetTimelineSettingsModel();

  factory AssetTimelineSettingsModel.fromJson(Map<String, dynamic> json) =>
      _$AssetTimelineSettingsModelFromJson(json);

  Map<String, dynamic> toJson() => _$AssetTimelineSettingsModelToJson(this);

  DateTime getRangeDate(double range) {
    int flooredValue = range.floor();
    double decimalValue = range - flooredValue;
    DateTime now = DateTime.now();
    DateTime rangeDate = DateTime(
      now.year,
      now.month,
      now.day,
      now.hour + flooredValue,
      now.minute + (decimalValue * 60).toInt(),
    );
    return getRoundingTime(sourceDate: rangeDate);
  }

  DateTime get availableStartTimeline => this.getRangeDate(this.rangeBackwards);

  DateTime get availableEndTimeline => this.getRangeDate(this.rangeForwards);

  Future<void> update({
    selectedDifferenceInMinutes,
    selectedRangeForwards,
    selectedRangeBackwards,
  }) async {
    this.selectedDifferenceInMinutes = selectedDifferenceInMinutes;
    this.selectedRangeForwards = selectedRangeForwards;
    this.selectedRangeBackwards = selectedRangeBackwards;
    final data = this.toJson();
    await _settingsService.updateDoc(AssetTimelineSettingsModel.id, data);
  }
}
