import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  var id;
  var email;
  var plate;

  UserModel({this.id, this.email, this.plate});

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'],
        email: json['email'],
        plate: json['plate'],
      );

  factory UserModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> source) =>
      UserModel.fromJson(source.data()!);
}
