import 'package:flutter/material.dart';
import 'storage_service.dart';
import '../utils/color_utils.dart';

class DebugService {
  static Future<void> printStoredWidgets() async {
    final memoWidgets = await StorageService.getMemoWidgets();
    final ddayWidgets = await StorageService.getDdayWidgets();
    
    debugPrint('=== 저장된 메모 위젯 ===');
    for (var widget in memoWidgets) {
      debugPrint('ID: ${widget.id}');
      debugPrint('Content: ${widget.content}');
      debugPrint('Background HEX: ${widget.backgroundColor}');
      debugPrint('Text Color HEX: ${widget.textColor}');
      
      // 색상 파싱 테스트
      try {
        final bgColor = ColorUtils.hexToColor(widget.backgroundColor);
        final opacity = ColorUtils.getOpacityFromHex(widget.backgroundColor);
        final colorWithoutAlpha = ColorUtils.getColorWithoutAlpha(widget.backgroundColor);
        final textColor = ColorUtils.hexToColor(widget.textColor);
        
        debugPrint('파싱된 배경색: $bgColor (투명도: $opacity)');
        debugPrint('알파 제거 배경색: $colorWithoutAlpha');
        debugPrint('파싱된 텍스트색: $textColor');
      } catch (e) {
        debugPrint('색상 파싱 오류: $e');
      }
      debugPrint('---');
    }
    
    debugPrint('=== 저장된 D-Day 위젯 ===');
    for (var widget in ddayWidgets) {
      debugPrint('ID: ${widget.id}');
      debugPrint('Title: ${widget.title}');
      debugPrint('Background HEX: ${widget.backgroundColor}');
      debugPrint('Text Color HEX: ${widget.textColor}');
      
      // 색상 파싱 테스트
      try {
        final bgColor = ColorUtils.hexToColor(widget.backgroundColor);
        final opacity = ColorUtils.getOpacityFromHex(widget.backgroundColor);
        final colorWithoutAlpha = ColorUtils.getColorWithoutAlpha(widget.backgroundColor);
        final textColor = ColorUtils.hexToColor(widget.textColor);
        
        debugPrint('파싱된 배경색: $bgColor (투명도: $opacity)');
        debugPrint('알파 제거 배경색: $colorWithoutAlpha');
        debugPrint('파싱된 텍스트색: $textColor');
      } catch (e) {
        debugPrint('색상 파싱 오류: $e');
      }
      debugPrint('---');
    }
  }
  
  static void printColorConversion(Color color, double opacity, String label) {
    final hexWithAlpha = ColorUtils.colorToHex(color, opacity);
    final hexWithoutAlpha = ColorUtils.colorToHexWithoutAlpha(color);
    
    debugPrint('=== $label 색상 변환 테스트 ===');
    debugPrint('원본 색상: $color');
    debugPrint('투명도: $opacity');
    debugPrint('알파 포함 HEX: $hexWithAlpha');
    debugPrint('알파 제외 HEX: $hexWithoutAlpha');
    
    // 역변환 테스트
    final parsedColor = ColorUtils.hexToColor(hexWithAlpha);
    final parsedOpacity = ColorUtils.getOpacityFromHex(hexWithAlpha);
    final parsedColorWithoutAlpha = ColorUtils.getColorWithoutAlpha(hexWithAlpha);
    
    debugPrint('역변환 색상: $parsedColor');
    debugPrint('역변환 투명도: $parsedOpacity');
    debugPrint('역변환 알파제거 색상: $parsedColorWithoutAlpha');
    debugPrint('---');
  }
}