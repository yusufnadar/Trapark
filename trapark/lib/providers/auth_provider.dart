import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:otopark/constants/local_storage.dart';
import 'package:otopark/models/user.dart';
import 'package:otopark/services/auth_service.dart';
import 'package:otopark/services/user_service.dart';
import 'package:otopark/ui/pages/home_page.dart';
import 'package:otopark/ui/pages/write_plate.dart';

class AuthProvider extends ChangeNotifier {
  UserModel user = UserModel();
  AuthService authService = AuthService();
  UserService userService = UserService();

  Future loginOrRegister() async{
   try{
     User user = await authService.loginOrRegister();
     this.user = (await userService.readUser(user.uid,user.email))!;
     notifyListeners();
     if(this.user.id != null){
       if(this.user.plate != null){
         GetStorage().write(userToken, this.user.id);
         return Get.to(() => const HomePage());
       }else{
         return Get.to(() => WritePlate());
       }
     }else{
       Get.snackbar('Hata', 'Bir hata oluştu');
     }
   }catch(e){
     Get.snackbar('Hata', e.toString(),duration: const Duration(seconds: 3));
   }
  }

}
