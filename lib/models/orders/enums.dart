enum Status { WAITING, PROCESSING, COMPLETED, CANCELLED }

Status getStatusFromString(String statusAsString) {
  for (Status element in Status.values) {
    if (element.toString() == statusAsString) {
      return element;
    }
  }
  return null;
}