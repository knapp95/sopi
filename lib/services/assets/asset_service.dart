import 'package:cloud_firestore/cloud_firestore.dart';
import '../authentication_service.dart';

class AssetService {
  final _assetsCollection = FirebaseFirestore.instance.collection('assets');
  static final AssetService _singleton = AssetService._internal();

  factory AssetService() {
    return _singleton;
  }

  AssetService._internal();

  static AssetService get singleton => _singleton;

  Future<List<QueryDocumentSnapshot>> getDocs() async {
    return (await _assetsCollection.get())?.docs;
  }

  Stream<QuerySnapshot> get processingOrderEmployee {
    AuthenticationService.uid;
    return _assetsCollection
        .where('assignedEmployeesIds', arrayContains: AuthenticationService.uid)
        .orderBy('processingProduct')
        .snapshots();
  }

  Stream<QuerySnapshot> get waitingOrdersEmployee {
    return _assetsCollection
        .where('assignedEmployeesIds', arrayContains: AuthenticationService.uid)
        .where('waitingProducts', isNotEqualTo: null)
        .snapshots();
  }

  Future<void> updateDoc(String aid, Map<String, dynamic> data) async =>
      _assetsCollection.doc(aid).update(data);

  Future<void> removeDoc(String aid) async =>
      _assetsCollection.doc(aid).delete();
}
