import 'package:flutter/material.dart';

import '../models/dday_widget_data.dart';
import '../services/debug_service.dart';
import '../services/storage_service.dart';
import '../utils/app_colors.dart';
import '../utils/color_utils.dart';

class DdayWidgetScreen extends StatefulWidget {
  final DdayWidgetData? existingWidget;

  const DdayWidgetScreen({super.key, this.existingWidget});

  @override
  State<DdayWidgetScreen> createState() => _DdayWidgetScreenState();
}

class _DdayWidgetScreenState extends State<DdayWidgetScreen> {
  final TextEditingController _titleController = TextEditingController();
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 30));
  Color _selectedBackgroundColor = AppColors.red;
  Color _selectedTextColor = AppColors.white;
  double _opacity = 0.8;

  final List<Color> _backgroundColors = AppColors.backgroundColors;
  final List<Color> _textColors = AppColors.textColors;

  @override
  void initState() {
    super.initState();
    if (widget.existingWidget != null) {
      _titleController.text = widget.existingWidget!.title;
      _selectedDate = DateTime.parse(widget.existingWidget!.targetDate);

      try {
        final bgColorHex = widget.existingWidget!.backgroundColor;
        debugPrint('불러온 배경색: $bgColorHex');

        _opacity = ColorUtils.getOpacityFromHex(bgColorHex);
        final parsedBgColor = ColorUtils.getColorWithoutAlpha(bgColorHex);
        final parsedTextColor = ColorUtils.hexToColor(widget.existingWidget!.textColor);

        // 가장 가까운 색상을 찾아서 설정
        _selectedBackgroundColor = AppColors.findClosestColor(parsedBgColor, _backgroundColors);
        _selectedTextColor = AppColors.findClosestColor(parsedTextColor, _textColors);

        debugPrint('파싱된 배경색: $_selectedBackgroundColor, 투명도: $_opacity');
        debugPrint('파싱된 텍스트색: $_selectedTextColor');
      } catch (e) {
        debugPrint('색상 파싱 오류: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existingWidget != null ? 'D-Day 위젯 편집' : 'D-Day 위젯 만들기'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '제목',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'D-Day 제목을 입력하세요...',
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              '목표 날짜',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: _selectDate,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${_selectedDate.year}년 ${_selectedDate.month}월 ${_selectedDate.day}일',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const Icon(Icons.calendar_today),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              '배경색 선택',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              children: _backgroundColors.map((color) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedBackgroundColor = color;
                    });
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: color,
                      border: ColorUtils.colorsAreEqual(_selectedBackgroundColor, color)
                          ? Border.all(color: Colors.black, width: 3)
                          : null,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 30),
            const Text(
              '투명도',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Slider(
              value: _opacity,
              min: 0.0,
              max: 1.0,
              divisions: 10,
              label: '${(_opacity * 100).round()}%',
              onChanged: (value) {
                setState(() {
                  _opacity = value;
                });
              },
            ),
            const SizedBox(height: 30),
            const Text(
              '텍스트 색상',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              children: _textColors.map((color) {
                return Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedTextColor = color;
                      });
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: color,
                        border: _selectedTextColor == color
                            ? Border.all(color: Colors.blue, width: 3)
                            : Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 40),
            const Text(
              '미리보기',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: _selectedBackgroundColor.withValues(alpha: _opacity),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Text(
                    _titleController.text.isEmpty ? 'D-Day 제목' : _titleController.text,
                    style: TextStyle(
                      color: _selectedTextColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    _getPreviewDdayText(),
                    style: TextStyle(
                      color: _selectedTextColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _saveWidget,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: Text(
                  widget.existingWidget != null ? '위젯 수정' : '위젯 생성',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getPreviewDdayText() {
    final now = DateTime.now();
    final difference = _selectedDate.difference(DateTime(now.year, now.month, now.day)).inDays;

    if (difference > 0) {
      return 'D-$difference';
    } else if (difference < 0) {
      return 'D+${-difference}';
    } else {
      return 'D-Day';
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _saveWidget() async {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('제목을 입력해주세요.')),
      );
      return;
    }

    // 저장 전 색상 변환 디버깅
    DebugService.printColorConversion(_selectedBackgroundColor, _opacity, 'D-Day 위젯 배경색');
    DebugService.printColorConversion(_selectedTextColor, 1.0, 'D-Day 위젯 텍스트색');

    final String backgroundColorHex = ColorUtils.colorToHex(_selectedBackgroundColor, _opacity);
    final String textColorHex = ColorUtils.colorToHexWithoutAlpha(_selectedTextColor);

    debugPrint('저장할 배경색 HEX: $backgroundColorHex');
    debugPrint('저장할 텍스트색 HEX: $textColorHex');

    final widget = DdayWidgetData(
      id: this.widget.existingWidget?.id ?? 'dday_${DateTime.now().millisecondsSinceEpoch}',
      title: _titleController.text.trim(),
      targetDate:
          '${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}',
      backgroundColor: backgroundColorHex,
      textColor: textColorHex,
    );

    if (this.widget.existingWidget != null) {
      await StorageService.updateDdayWidget(widget);
    } else {
      await StorageService.saveDdayWidget(widget);
    }

    if (mounted) {
      Navigator.pop(context, true);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }
}
