
class UserModel {
  String uid;
  String typeAccount;

  Map<String, dynamic> toJson() => {
    'typeAccount' : this.typeAccount,
  };



}
