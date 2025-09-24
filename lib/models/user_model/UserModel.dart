class UserModel {
  late String id;
  late String fullname;
  late String email;
  UserModel({required this.id, required this.fullname, required this.email});

  //object to map
  UserModel.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];

    this.fullname = map['fullname'];
    this.email = map['email'];
  }
  //object to map
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['id'] = this.id;
    map['fullname'] = this.fullname;
    map['email'] = this.email;
    return map;
  }
}
