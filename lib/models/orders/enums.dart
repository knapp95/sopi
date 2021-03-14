enum Status { PROCESSING, CREATE, COMPLETED }

Status getStatusFromString(String statusAsString) {
  for (Status element in Status.values) {
    if (element.toString() == statusAsString) {
      return element;
    }
  }
  return null;
}