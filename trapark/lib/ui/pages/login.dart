import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otopark/constants/size_config.dart';
import 'package:otopark/providers/auth_provider.dart';
import 'package:otopark/ui/pages/home_page.dart';
import 'package:otopark/ui/pages/write_plate.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: Get.mediaQuery.size.height * 0.3,
            ),
            GestureDetector(
              onTap: () async {
                await Provider.of<AuthProvider>(context,listen: false).loginOrRegister();
              },
              child: Container(
                height: Get.mediaQuery.size.height * 0.07,
                margin: EdgeInsets.only(top: Get.mediaQuery.size.height * 0.25),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(0, 0),
                      color: Colors.grey.shade300,
                      blurRadius: 10,
                      spreadRadius: 1,
                    )
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Sign In With Google',
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(width: 16),
                    Image.asset(
                      'assets/images/google.png',
                      width: 24,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
