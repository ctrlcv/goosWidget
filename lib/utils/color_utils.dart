import 'package:flutter/material.dart';

class ColorUtils {
  static bool colorsAreEqual(Color color1, Color color2) {
    return (color1.r * 255).round() == (color2.r * 255).round() &&
           (color1.g * 255).round() == (color2.g * 255).round() &&
           (color1.b * 255).round() == (color2.b * 255).round();
  }
  static String colorToHex(Color color, double opacity) {
    final int alpha = (opacity * 255).round();
    final int red = (color.r * 255).round();
    final int green = (color.g * 255).round();
    final int blue = (color.b * 255).round();
    
    return '#${alpha.toRadixString(16).padLeft(2, '0')}${red.toRadixString(16).padLeft(2, '0')}${green.toRadixString(16).padLeft(2, '0')}${blue.toRadixString(16).padLeft(2, '0')}';
  }
  
  static String colorToHexWithoutAlpha(Color color) {
    final int red = (color.r * 255).round();
    final int green = (color.g * 255).round();
    final int blue = (color.b * 255).round();
    
    return '#${red.toRadixString(16).padLeft(2, '0')}${green.toRadixString(16).padLeft(2, '0')}${blue.toRadixString(16).padLeft(2, '0')}';
  }
  
  static Color hexToColor(String hex) {
    hex = hex.replaceAll('#', '');
    
    if (hex.length == 8) {
      // AARRGGBB 형식
      return Color(int.parse('0x$hex'));
    } else if (hex.length == 6) {
      // RRGGBB 형식
      return Color(int.parse('0xFF$hex'));
    } else {
      return Colors.grey;
    }
  }
  
  static double getOpacityFromHex(String hex) {
    hex = hex.replaceAll('#', '');
    
    if (hex.length == 8) {
      final alpha = int.parse(hex.substring(0, 2), radix: 16);
      return alpha / 255.0;
    }
    
    return 1.0;
  }
  
  static Color getColorWithoutAlpha(String hex) {
    hex = hex.replaceAll('#', '');
    
    if (hex.length == 8) {
      // AARRGGBB에서 RRGGBB만 추출
      return Color(int.parse('0xFF${hex.substring(2)}'));
    } else if (hex.length == 6) {
      return Color(int.parse('0xFF$hex'));
    } else {
      return Colors.grey;
    }
  }
}