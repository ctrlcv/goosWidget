class WidgetService {

  static Future<void> updateAllWidgets() async {
    // home_widget 패키지 없이 기본 구현
    // 추후 네이티브 위젯 연동 시 구현 예정
  }

  static Future<void> updateMemoWidgets() async {
    // 네이티브 위젯 업데이트 (추후 구현)
  }

  static Future<void> updateDdayWidgets() async {
    // 네이티브 위젯 업데이트 (추후 구현)
  }

  static Future<void> requestWidgetUpdate() async {
    await updateAllWidgets();
  }

  static Future<bool> isWidgetSupported() async {
    // 현재는 Flutter 앱 기능만 지원
    return false;
  }

  static Future<void> initializeWidgets() async {
    // 위젯 초기화 (현재는 빈 구현)
  }
}