import 'package:flutter/material.dart';

TextStyle textStyle(BuildContext context, FontWeight textType, double textSize,
    Color textColor) {
  return TextStyle(
    fontSize: MediaQuery.of(context).size.width * textSize,
    fontWeight: textType,
    color: textColor,
    wordSpacing: 0.0,
    letterSpacing: 0.0,
  );
}

Widget pawImage(BuildContext context, double widthF, double heightF) {
  double width = MediaQuery.of(context).size.width * widthF;
  double height = MediaQuery.of(context).size.height * heightF;

  // Ensure height is proportional and constrained
  height = height > 150 ? 150 : height; 

  return Image.asset(
    'assets/images/loginPaw.png',
    fit: BoxFit.contain,
    width: width,
    height: height,
    alignment: Alignment.center,
  );
}
