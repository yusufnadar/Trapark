import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:otopark/constants/local_storage.dart';
import 'package:otopark/models/user.dart';
import 'package:otopark/services/user_service.dart';
import 'package:otopark/ui/pages/home_page.dart';

class UserProvider extends ChangeNotifier{

  UserModel user = UserModel();
  UserService userService = UserService();

  Future<UserModel?> getUser()async{
    try{
      var existUser = await userService.getUser(GetStorage().read(userToken));
      if(existUser != null){
        user = existUser;
        notifyListeners();
        return user;
      }
    }catch(e){
      Get.snackbar('Hata', e.toString(),duration: const Duration(seconds: 2));
    }
  }

  Future updateUser(String plate,id) async{
    try{
      var result = await userService.updateUser(plate,id);
      if(result){
        user.plate = plate;
        GetStorage().write(userToken, id);
        Get.to(()=>HomePage());
      }
    }catch(e){
      Get.snackbar('Hata', e.toString(),duration: const Duration(seconds: 2));
    }
  }
}