import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/memo_widget_data.dart';
import '../models/dday_widget_data.dart';
import 'widget_service.dart';

class StorageService {
  static const String _memoWidgetsKey = 'memo_widgets';
  static const String _ddayWidgetsKey = 'dday_widgets';

  static Future<List<MemoWidgetData>> getMemoWidgets() async {
    final prefs = await SharedPreferences.getInstance();
    final String? widgetsJson = prefs.getString(_memoWidgetsKey);
    
    if (widgetsJson == null) return [];
    
    final List<dynamic> widgetsList = json.decode(widgetsJson);
    return widgetsList.map((json) => MemoWidgetData.fromJson(json)).toList();
  }

  static Future<void> saveMemoWidget(MemoWidgetData widget) async {
    final widgets = await getMemoWidgets();
    widgets.add(widget);
    
    final prefs = await SharedPreferences.getInstance();
    final String widgetsJson = json.encode(widgets.map((w) => w.toJson()).toList());
    await prefs.setString(_memoWidgetsKey, widgetsJson);
    
    // 네이티브 위젯 업데이트
    await WidgetService.updateMemoWidgets();
  }

  static Future<void> updateMemoWidget(MemoWidgetData widget) async {
    final widgets = await getMemoWidgets();
    final index = widgets.indexWhere((w) => w.id == widget.id);
    
    if (index != -1) {
      widgets[index] = widget;
      
      final prefs = await SharedPreferences.getInstance();
      final String widgetsJson = json.encode(widgets.map((w) => w.toJson()).toList());
      await prefs.setString(_memoWidgetsKey, widgetsJson);
      
      // 네이티브 위젯 업데이트
      await WidgetService.updateMemoWidgets();
    }
  }

  static Future<void> deleteMemoWidget(String id) async {
    final widgets = await getMemoWidgets();
    widgets.removeWhere((w) => w.id == id);
    
    final prefs = await SharedPreferences.getInstance();
    final String widgetsJson = json.encode(widgets.map((w) => w.toJson()).toList());
    await prefs.setString(_memoWidgetsKey, widgetsJson);
    
    // 네이티브 위젯 업데이트
    await WidgetService.updateMemoWidgets();
  }

  static Future<List<DdayWidgetData>> getDdayWidgets() async {
    final prefs = await SharedPreferences.getInstance();
    final String? widgetsJson = prefs.getString(_ddayWidgetsKey);
    
    if (widgetsJson == null) return [];
    
    final List<dynamic> widgetsList = json.decode(widgetsJson);
    return widgetsList.map((json) => DdayWidgetData.fromJson(json)).toList();
  }

  static Future<void> saveDdayWidget(DdayWidgetData widget) async {
    final widgets = await getDdayWidgets();
    widgets.add(widget);
    
    final prefs = await SharedPreferences.getInstance();
    final String widgetsJson = json.encode(widgets.map((w) => w.toJson()).toList());
    await prefs.setString(_ddayWidgetsKey, widgetsJson);
    
    // 네이티브 위젯 업데이트
    await WidgetService.updateDdayWidgets();
  }

  static Future<void> updateDdayWidget(DdayWidgetData widget) async {
    final widgets = await getDdayWidgets();
    final index = widgets.indexWhere((w) => w.id == widget.id);
    
    if (index != -1) {
      widgets[index] = widget;
      
      final prefs = await SharedPreferences.getInstance();
      final String widgetsJson = json.encode(widgets.map((w) => w.toJson()).toList());
      await prefs.setString(_ddayWidgetsKey, widgetsJson);
      
      // 네이티브 위젯 업데이트
      await WidgetService.updateDdayWidgets();
    }
  }

  static Future<void> deleteDdayWidget(String id) async {
    final widgets = await getDdayWidgets();
    widgets.removeWhere((w) => w.id == id);
    
    final prefs = await SharedPreferences.getInstance();
    final String widgetsJson = json.encode(widgets.map((w) => w.toJson()).toList());
    await prefs.setString(_ddayWidgetsKey, widgetsJson);
    
    // 네이티브 위젯 업데이트
    await WidgetService.updateDdayWidgets();
  }
}