enum ProductType { DESSERT, BURGER, PIZZA, PASTA, OTHER, VEGE, SPECIAL }

ProductType? getProductTypeFromString(String? statusAsString) {
  for (ProductType element in ProductType.values) {
    if (element.toString() == statusAsString) {
      return element;
    }
  }
  return null;
}
