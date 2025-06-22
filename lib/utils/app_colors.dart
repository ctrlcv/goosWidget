import 'package:flutter/material.dart';

class AppColors {
  // 정확한 색상 값을 미리 정의
  static const Color red = Color(0xFFFF0000);
  static const Color blue = Color(0xFF0000FF);
  static const Color green = Color(0xFF00FF00);
  static const Color yellow = Color(0xFFFFFF00);
  static const Color purple = Color(0xFF800080);
  static const Color orange = Color(0xFFFFA500);
  static const Color grey = Color(0xFF808080);
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);

  static const List<Color> backgroundColors = [
    red,
    blue,
    green,
    yellow,
    purple,
    orange,
    grey,
    black,
  ];

  static const List<Color> textColors = [
    black,
    white,
    grey,
  ];
  
  static Color findClosestColor(Color targetColor, List<Color> colorList) {
    Color closestColor = colorList.first;
    double minDistance = double.infinity;
    
    for (Color color in colorList) {
      double distance = _colorDistance(targetColor, color);
      if (distance < minDistance) {
        minDistance = distance;
        closestColor = color;
      }
    }
    
    return closestColor;
  }
  
  static double _colorDistance(Color c1, Color c2) {
    final r1 = c1.r * 255;
    final g1 = c1.g * 255;
    final b1 = c1.b * 255;
    final r2 = c2.r * 255;
    final g2 = c2.g * 255;
    final b2 = c2.b * 255;
    
    return ((r1 - r2) * (r1 - r2)) +
           ((g1 - g2) * (g1 - g2)) +
           ((b1 - b2) * (b1 - b2));
  }
}