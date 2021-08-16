import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sopi/models/assets/asset_item_model.dart';

import '../authentication/authentication_service.dart';

class AssetService {
  final _assetsCollection = FirebaseFirestore.instance.collection('assets');
  static final AssetService _singleton = AssetService._internal();

  factory AssetService() {
    return _singleton;
  }

  AssetService._internal();

  static AssetService get singleton => _singleton;

  Future<List<QueryDocumentSnapshot>> getDocs() async {
    return (await _assetsCollection.get()).docs;
  }

  Stream<QuerySnapshot> get queueProductsInAssetsForEmployee {
    return _assetsCollection
        .where('assignedEmployeesIds', arrayContains: AuthenticationService.uid)

        ///TODO        .orderBy('queueProducts')
        .snapshots();
  }

  Stream<QuerySnapshot> get assets {
    return _assetsCollection.snapshots();
  }

  DocumentReference getDoc(String? aid) {
    return _assetsCollection.doc(aid);
  }

  Future<AssetItemModel> getAssetDoc(String aid) async {
    final DocumentSnapshot doc = await getDoc(aid).get();
    final data = doc.data()! as Map<String, dynamic>;
    return AssetItemModel.fromJson(data);
  }

  Future<void> updateDoc(String? aid, Map<String, dynamic> data) async =>
      _assetsCollection.doc(aid).update(data);

  Future<void> removeDoc(String? aid) async =>
      _assetsCollection.doc(aid).delete();
}
