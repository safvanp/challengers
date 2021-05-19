import 'package:flutter/material.dart';
import 'package:challengers/models/const.dart';

class UserModel {
  String id;
  String name;
  String age;
  String contact;
  String blood;
  String email;
  String location;

  UserModel(
      {this.id,
      @required this.name,
      this.age,
      this.contact,
      this.blood,
      this.email,
      this.location});

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map[Id] = id;
    map[Name] = name;
    map[Age] = age;
    map[Contact] = contact;
    map[Bloodgroup] = blood;
    map[Email] = email;
    map[Location] = location;
    return map;
  }

  static UserModel fromMap(var user) {
    return UserModel(
        id: user[Id],
        name: user[Name],
        age: user[Age],
        contact: user[Contact],
        blood: user[Bloodgroup],
        email: user[Email],
        location: user[Location]);
  }
}
