enum UserType { CLIENT, MANAGER, EMPLOYEE }

UserType getUserTypeFromString(String statusAsString) {
  for (UserType element in UserType.values) {
    if (element.toString() == statusAsString) {
      return element;
    }
  }
  return null;
}