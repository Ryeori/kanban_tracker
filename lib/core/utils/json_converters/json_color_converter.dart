import 'package:flutter/rendering.dart';

class JsonColorConverter {
  static Color? fromJson(String? colorJson) {
    if (colorJson?.isNotEmpty ?? false) {
      return Color(int.parse(colorJson!, radix: 16));
    }
    return null;
  }

  static String? toJson(Color? color) {
    if (color != null) {
      return color.toString().split('(0x')[1].split(')')[0];
    }
    return null;
  }
}
