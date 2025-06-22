import 'package:flutter/material.dart';
import '../models/memo_widget_data.dart';
import '../models/dday_widget_data.dart';
import '../services/storage_service.dart';
import '../services/debug_service.dart';
import '../utils/color_utils.dart';
import 'memo_widget_screen.dart';
import 'dday_widget_screen.dart';

class WidgetManagementScreen extends StatefulWidget {
  const WidgetManagementScreen({super.key});

  @override
  State<WidgetManagementScreen> createState() => _WidgetManagementScreenState();
}

class _WidgetManagementScreenState extends State<WidgetManagementScreen> {
  List<MemoWidgetData> _memoWidgets = [];
  List<DdayWidgetData> _ddayWidgets = [];

  @override
  void initState() {
    super.initState();
    _loadWidgets();
  }

  Future<void> _loadWidgets() async {
    final memoWidgets = await StorageService.getMemoWidgets();
    final ddayWidgets = await StorageService.getDdayWidgets();
    
    await DebugService.printStoredWidgets();
    
    setState(() {
      _memoWidgets = memoWidgets;
      _ddayWidgets = ddayWidgets;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('내 위젯 관리'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _memoWidgets.isEmpty && _ddayWidgets.isEmpty
          ? const Center(
              child: Text(
                '생성된 위젯이 없습니다.\n메인 화면에서 위젯을 생성해보세요!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (_memoWidgets.isNotEmpty) ...[
                  const Text(
                    '📝 메모 위젯',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  ..._memoWidgets.map((widget) => _buildMemoWidgetCard(widget)),
                  const SizedBox(height: 20),
                ],
                if (_ddayWidgets.isNotEmpty) ...[
                  const Text(
                    '📅 D-Day 위젯',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  ..._ddayWidgets.map((widget) => _buildDdayWidgetCard(widget)),
                ],
              ],
            ),
    );
  }

  Widget _buildMemoWidgetCard(MemoWidgetData widget) {
    Color backgroundColor;
    Color textColor;
    
    try {
      final bgColorHex = widget.backgroundColor;
      debugPrint('메모 위젯 배경색: $bgColorHex');
      backgroundColor = ColorUtils.hexToColor(bgColorHex);
      textColor = ColorUtils.hexToColor(widget.textColor);
    } catch (e) {
      backgroundColor = Colors.grey;
      textColor = Colors.black;
      debugPrint('색상 파싱 오류: $e');
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Text(
              widget.content,
              style: TextStyle(
                color: textColor,
                fontSize: 16,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton.icon(
                  onPressed: () => _editMemoWidget(widget),
                  icon: const Icon(Icons.edit, size: 18),
                  label: const Text('편집'),
                ),
                TextButton.icon(
                  onPressed: () => _deleteMemoWidget(widget.id),
                  icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                  label: const Text('삭제', style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDdayWidgetCard(DdayWidgetData widget) {
    Color backgroundColor;
    Color textColor;
    
    try {
      final bgColorHex = widget.backgroundColor;
      debugPrint('D-Day 위젯 배경색: $bgColorHex');
      backgroundColor = ColorUtils.hexToColor(bgColorHex);
      textColor = ColorUtils.hexToColor(widget.textColor);
    } catch (e) {
      backgroundColor = Colors.grey;
      textColor = Colors.black;
      debugPrint('색상 파싱 오류: $e');
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Column(
              children: [
                Text(
                  widget.title,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  widget.getDisplayText(),
                  style: TextStyle(
                    color: textColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton.icon(
                  onPressed: () => _editDdayWidget(widget),
                  icon: const Icon(Icons.edit, size: 18),
                  label: const Text('편집'),
                ),
                TextButton.icon(
                  onPressed: () => _deleteDdayWidget(widget.id),
                  icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                  label: const Text('삭제', style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _editMemoWidget(MemoWidgetData widget) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MemoWidgetScreen(existingWidget: widget),
      ),
    );
    
    if (result == true) {
      _loadWidgets();
    }
  }

  void _editDdayWidget(DdayWidgetData widget) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DdayWidgetScreen(existingWidget: widget),
      ),
    );
    
    if (result == true) {
      _loadWidgets();
    }
  }

  void _deleteMemoWidget(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('위젯 삭제'),
        content: const Text('이 메모 위젯을 삭제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('삭제', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await StorageService.deleteMemoWidget(id);
      _loadWidgets();
    }
  }

  void _deleteDdayWidget(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('위젯 삭제'),
        content: const Text('이 D-Day 위젯을 삭제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('삭제', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await StorageService.deleteDdayWidget(id);
      _loadWidgets();
    }
  }
}