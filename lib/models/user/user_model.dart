import 'package:firebase_database/firebase_database.dart';
class UserModel {
  String uid;
  String typeAccount;


  static void test() {
    //FirebaseDatabase.instance.('users').document().setData({ 'userid':
    print('test1');
    final FirebaseDatabase database = FirebaseDatabase.instance;
    print('test1');
    database.reference().child('messages').set('test');
    print('test2');
    database.reference().child('counter').once().then((DataSnapshot snapshot) {
    print('Connected to second database and read ${snapshot.value}');
    });
  }

}
