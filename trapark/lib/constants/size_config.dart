import 'package:flutter/cupertino.dart';

late double screenWidth;
late double screenHeight;

class ScreenUtil {

  init(context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
  }
}
