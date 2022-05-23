import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otopark/constants/size_config.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Function()? onTap;
  final MaterialColor? color;
  final String? icon;

  const CustomButton(
      {Key? key, required this.text, this.onTap, this.color, this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, //()=>Get.to(()=>WritePlate()),
      child: Container(
        alignment: Alignment.center,
        height: screenHeight * 0.075,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 0),
              color: Colors.grey.shade300,
              blurRadius: 10,
              spreadRadius: 1,
            )
          ],
        ),
        child: icon != null
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    text,
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(width: 16),
                  Image.asset(
                    icon!,
                    width: 24,
                  )
                ],
              )
            : Text(
                text,
                style: const TextStyle(fontSize: 18),
              ),
      ),
    );
  }
}
