import 'package:sopi/models/generic/generic_item_model.dart';
import 'package:sopi/models/product_item_model.dart';

class MenuModel {
  static const double maxAvailableRate = 6.0;
  static List<GenericItemModel> productsTypes = [
    GenericItemModel(id: 'special', name: 'Special for your'),
    GenericItemModel(id: 'dessert', name: 'Desserts'),
    GenericItemModel(id: 'burger', name: 'Burger'),
    GenericItemModel(id: 'pizza', name: 'Pizza'),
    GenericItemModel(id: 'pasta', name: 'Pastas'),
    GenericItemModel(id: 'vege', name: 'Vegan'),
    GenericItemModel(id: 'other', name: 'Other'),
  ];

  static const String imageUrl =
      'https://upload.wikimedia.org/wikipedia/commons/thumb/2/20/Spaghetti_Bolognese_mit_Parmesan_oder_Grana_Padano.jpg/800px-Spaghetti_Bolognese_mit_Parmesan_oder_Grana_Padano.jpg';
  static List<ProductItemModel> demoProducts = [
    ProductItemModel(
      pid: 1124312,
      name: "The Thunderbun",
      price: 25.99,
      imageUrl: imageUrl,
      description:
          'Our OG classic burger; A juicy chicken breast, slathered in Awesome Sauce (like a smoked burger sauce), some crunchy lettuce, snappy pickles and a squishy bun. That\'s it. Excellent.',
      type: 'burger',
    ),
    ProductItemModel(
      pid: 1124316,
      name: "The Meltdown",
      price: 28.99,
      imageUrl: imageUrl,
      description:
          'This one’s our favourite; oozing with molten miso-jalapeño cheese sauce, garlicky red pepper aioli, fresh lettuce, snappy pickles and a squishy bun',
      type: 'burger',
    ),
    ProductItemModel(
      pid: 112412431,
      name: "BBQ Burger",
      price: 29.99,
      imageUrl: imageUrl,
      description:
          'Sweet, sticky BBQ sauce, applewood smoked cheese, awesome sauce, crispy fresh lettuce & pickles, all in a squishy bun.',
      type: 'burger',
    ),
    ProductItemModel(
      pid: 23661341,
      name: "Jackfruit Chipuffalo Burger",
      price: 22.99,
      imageUrl: imageUrl,
      description:
          'The good stuff from our Chipuffalo Wings in burger format, with a jackfruit patty. Chipotle-Buffalo Sauce, blue cheese, pickles, lettuce and squishy bun',
      isVeg: true,
    ),
    ProductItemModel(
      pid: 243723,
      name: "3 Jackfruit Wings",
      price: 9.99,
      imageUrl: imageUrl,
      description:
          'We\'ve swapped out the chicken for crispy jackfruit wings; choose from any of our signature toppings',
      type: 'other',
      isVeg: true,
    ),
    ProductItemModel(
      pid: 164433,
      name: "Margherita",
      price: 19.99,
      imageUrl: imageUrl,
      description:
          'Tomato sauce, basil, Agerola fior di latte cheese, pecorino romano D.O.P. cheese, seed soya oil. Vegetarian.',
      type: 'pizza',
    ),
    ProductItemModel(
      pid: 34343,
      name: "Salsiccia & Friarielli",
      price: 25.99,
      imageUrl: imageUrl,
      description:
          'Pork sausages mince, broccoli rabe (friarielli), Agerola fior di latte cheese, pecorino romano D.O.P. cheese, seed soya oil.',
      type: 'pizza',
    ),
    ProductItemModel(
      pid: 856654,
      name: "Siciliana",
      price: 24.99,
      imageUrl: imageUrl,
      description:
          'Tomato sauce, basil, Agerola fior di latte cheese, pecorino romano D.O.P. cheese, aubergine parmigiana, red cows parmesan reggiano cheese 36 months aged and extra virgin olive oil. Vegetarian.',
      type: 'pizza',
    ),
    ProductItemModel(
      pid: 14783343,
      name: "Diavola",
      price: 29.99,
      imageUrl: imageUrl,
      description:
          'Tomato sauce, basil, Agerola fior di latte cheese, pecorino romano D.O.P. cheese, salami Napoli, fresh chilli and chilli extra virgin olive oil.',
      type: 'pizza',
    ),
    ProductItemModel(
      pid: 16121,
      name: "Spaghetti Carbonara",
      price: 17.99,
      imageUrl: imageUrl,
      description:
          'Spaghetti pasta, eggs yolk, pecorino romano D.O.P. Cheese, red cow parmesan reggiano cheese 36 months aged, aged guanciale.',
      type: 'pasta',
    ),
    ProductItemModel(
      pid: 34635643,
      name: "Tagliatella Bolognese",
      price: 19.99,
      imageUrl: imageUrl,
      description:
          'Fresh Tagliatelle pasta with Bolognese Beef ragu and red cow parmesan reggiano cheese 36 months aged.',
      type: 'pasta',
    ),
  ];


  static List<ProductItemModel> getSortedProductsByType(String type) {
    List<ProductItemModel> productsByType = [];
    switch (type) {
      case 'vege':
        productsByType =
            MenuModel.demoProducts.where((product) => product.isVeg).toList();
        break;
      case 'special':
        productsByType = MenuModel.demoProducts..shuffle();
        break;
      default:
        productsByType = MenuModel.demoProducts
            .where((product) => product.type == type)
            .toList();
    }
    productsByType.sort((a, b) => a.price.compareTo(b.price));
    return productsByType;
  }
}
