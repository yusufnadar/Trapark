import 'package:flutter/material.dart';
import 'package:otopark/constants/size_config.dart';
import 'package:otopark/providers/auth_provider.dart';
import 'package:otopark/providers/user_provider.dart';
import 'package:otopark/ui/widgets/custom/custom_button.dart';
import 'package:otopark/ui/widgets/custom/custom_input.dart';
import 'package:provider/provider.dart';

class WritePlate extends StatelessWidget {
  WritePlate({Key? key}) : super(key: key);

  final plateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final _authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomInput(
                hintText: 'Plaka',
                controller: plateController,
                onChanged: (value){},
                focusNode: null,
              ),
              SizedBox(height: screenHeight * 0.03),
              CustomButton(
                text: 'Devam Et',
                icon: 'assets/images/right.png',
                onTap: (){
                  Provider.of<UserProvider>(context,listen: false).updateUser(plateController.text,_authProvider.user.id);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
