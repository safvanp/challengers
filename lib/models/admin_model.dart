const Id = 'id';
const Name = 'name';
const Password = 'password';

class AdminModel {
  String id;
  String name;
  String password;

  AdminModel({this.id, this.name, this.password});

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map[Id] = id;
    map[Name] = name;
    map[Password] = password;
    return map;
  }

  static AdminModel fromMap(var admin) {
    return AdminModel(
        id: admin[Id], name: admin[Name], password: admin[Password]);
  }
}
