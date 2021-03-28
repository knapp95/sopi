import 'package:cloud_firestore/cloud_firestore.dart';


final assetsCollection = FirebaseFirestore.instance.collection('assets');

final usersCollection = FirebaseFirestore.instance.collection('users');

final ordersCollection = FirebaseFirestore.instance.collection('orders');


final productsCollection = FirebaseFirestore.instance.collection('products');