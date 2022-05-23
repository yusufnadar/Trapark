import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:otopark/constants/local_storage.dart';
import 'package:otopark/constants/size_config.dart';
import 'package:otopark/providers/user_provider.dart';
import 'package:otopark/ui/pages/home_page.dart';
import 'package:otopark/ui/pages/login.dart';
import 'package:otopark/ui/pages/write_plate.dart';
import 'package:provider/provider.dart';

class Landing extends StatefulWidget {
  const Landing({Key? key}) : super(key: key);

  @override
  State<Landing> createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ScreenUtil().init(context);
    Provider.of<UserProvider>(context,listen: false).getUser();
  }

  @override
  Widget build(BuildContext context) {
    if (GetStorage().read(userToken) != null) {
      return Consumer<UserProvider>(
        builder: (BuildContext context, value, Widget? child) {
          if(value.user.plate != null){
            return const HomePage();
          }else{
            return WritePlate();
          }
        },
      );
    } else {
      return const Login();
    }
  }
}
