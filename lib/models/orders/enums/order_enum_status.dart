enum OrderStatus { WAITING, PROCESSING, COMPLETED, RECEIVED, CANCELLED }

OrderStatus? getOrderStatusFromString(String? statusAsString) {
  for (OrderStatus element in OrderStatus.values) {
    if (element.toString() == statusAsString) {
      return element;
    }
  }
  return null;
}
