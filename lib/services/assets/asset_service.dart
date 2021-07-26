import 'package:cloud_firestore/cloud_firestore.dart';

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

  DocumentReference getDoc(String? pid) {
    return _assetsCollection.doc(pid);
  }

  Future<void> updateDoc(String? aid, Map<String, dynamic> data) async =>
      _assetsCollection.doc(aid).update(data);


  Future<void> removeDoc(String? aid) async =>
      _assetsCollection.doc(aid).delete();


}
