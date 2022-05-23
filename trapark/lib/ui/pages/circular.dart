import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:otopark/constants/size_config.dart';

class CircularPage extends StatelessWidget {
  const CircularPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Lottie.asset('assets/images/loading.json',height: screenHeight*0.3),
      ),
    );
  }
}
