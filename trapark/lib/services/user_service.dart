import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart';
import 'package:otopark/constants/local_storage.dart';
import 'package:otopark/models/user.dart';

class UserService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<UserModel?> readUser(id, email) async {
    var source = await firestore.collection('users').doc(id).get();
    print('id $id');
    if (source.data() != null) {
      return UserModel.fromDoc(source);
    } else {
      return saveUser(email, id);
    }
  }

  Future<UserModel?> getUser(id) async {
    var source = await firestore.collection('users').doc(id).get();
    if (source.data() != null) {
      return UserModel.fromDoc(source);
    } else {
      return null;
    }
  }

  Future<UserModel?> saveUser(String? email, String? id) async {
    await firestore.collection('users').doc(id).set({
      'email': email,
      'id': id,
    });
    return readUser(id, email);
  }

  Future updateUser(String plate,id) async{
    await firestore.collection('users').doc(id).update({
      'plate':plate
    });
    return true;
  }
}
