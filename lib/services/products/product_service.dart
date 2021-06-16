import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sopi/models/products/product_item_model.dart';

class ProductService {
  final _productsCollection = FirebaseFirestore.instance.collection('products');
  static final ProductService _singleton = ProductService._internal();

  factory ProductService() {
    return _singleton;
  }

  ProductService._internal();

  static ProductService get singleton => _singleton;

  Future<ProductItemModel> getProductById(String? oid) async {
    DocumentSnapshot documentSnapshot =
        await _productsCollection.doc(oid).get();
    final data = documentSnapshot.data()! as Map<String, dynamic>;
    return ProductItemModel.fromJson(data);
  }

  Future<void> removeDoc(String? pid) async =>
      _productsCollection.doc(pid).delete();

  Future<List<ProductItemModel>> fetchProducts() async {
    final docs = (await _productsCollection.get()).docs;

    List<ProductItemModel> products = [];
    docs.forEach((doc) {
      final productTmp = ProductItemModel.fromJson(doc.data());
      products.add(productTmp);
    });
    return products;
  }

  DocumentReference getDoc(String? pid) {
    return _productsCollection.doc(pid);
  }
}
