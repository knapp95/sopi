import 'package:cloud_firestore/cloud_firestore.dart';

class SettingsService {
  final _settingsCollection = FirebaseFirestore.instance.collection('settings');
  static final SettingsService _singleton = SettingsService._internal();

  factory SettingsService() {
    return _singleton;
  }

  SettingsService._internal();

  static SettingsService get singleton => _singleton;

  DocumentReference getDoc(String? id) {
    return _settingsCollection.doc(id);
  }

  Future<void> updateDoc(String? id, Map<String, dynamic> data) async =>
      _settingsCollection.doc(id).update(data);
}
