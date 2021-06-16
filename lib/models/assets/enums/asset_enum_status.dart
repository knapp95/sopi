enum AssetEnumStatus { PAST, PROCESSING, WAITING }

AssetEnumStatus? getAssetStatusFromString(String? statusAsString) {
  for (AssetEnumStatus element in AssetEnumStatus.values) {
    if (element.toString() == statusAsString) {
      return element;
    }
  }
  return null;
}
