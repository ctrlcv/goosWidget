import 'package:flutter/material.dart';
import '../models/memo_widget_data.dart';
import '../services/storage_service.dart';
import '../utils/color_utils.dart';
import '../utils/app_colors.dart';

class MemoWidgetScreen extends StatefulWidget {
  final MemoWidgetData? existingWidget;

  const MemoWidgetScreen({super.key, this.existingWidget});

  @override
  State<MemoWidgetScreen> createState() => _MemoWidgetScreenState();
}

class _MemoWidgetScreenState extends State<MemoWidgetScreen> {
  final TextEditingController _contentController = TextEditingController();
  Color _selectedBackgroundColor = AppColors.blue;
  Color _selectedTextColor = AppColors.white;
  double _opacity = 0.8;

  final List<Color> _backgroundColors = AppColors.backgroundColors;
  final List<Color> _textColors = AppColors.textColors;

  @override
  void initState() {
    super.initState();
    if (widget.existingWidget != null) {
      _contentController.text = widget.existingWidget!.content;
      
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
        title: Text(widget.existingWidget != null ? '메모 위젯 편집' : '메모 위젯 만들기'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '메모 내용',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _contentController,
              maxLines: 5,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: '메모 내용을 입력하세요...',
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
              child: Text(
                _contentController.text.isEmpty ? '메모 내용 미리보기' : _contentController.text,
                style: TextStyle(
                  color: _selectedTextColor,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _saveWidget,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
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

  void _saveWidget() async {
    if (_contentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('메모 내용을 입력해주세요.')),
      );
      return;
    }

    // 색상 정보 상세 디버깅
    debugPrint('=== 메모 위젯 저장 전 색상 정보 ===');
    debugPrint('선택된 배경색: $_selectedBackgroundColor');
    debugPrint('배경색 RGB: R=${(_selectedBackgroundColor.r * 255).round()}, G=${(_selectedBackgroundColor.g * 255).round()}, B=${(_selectedBackgroundColor.b * 255).round()}');
    debugPrint('투명도: $_opacity (${(_opacity * 255).round()}/255)');
    debugPrint('선택된 텍스트색: $_selectedTextColor');
    debugPrint('텍스트색 RGB: R=${(_selectedTextColor.r * 255).round()}, G=${(_selectedTextColor.g * 255).round()}, B=${(_selectedTextColor.b * 255).round()}');

    final String backgroundColorHex = ColorUtils.colorToHex(_selectedBackgroundColor, _opacity);
    final String textColorHex = ColorUtils.colorToHexWithoutAlpha(_selectedTextColor);

    debugPrint('변환된 배경색 HEX: $backgroundColorHex');
    debugPrint('변환된 텍스트색 HEX: $textColorHex');
    debugPrint('=== 색상 정보 끝 ===');

    final widget = MemoWidgetData(
      id: this.widget.existingWidget?.id ?? 'memo_${DateTime.now().millisecondsSinceEpoch}',
      content: _contentController.text.trim(),
      backgroundColor: backgroundColorHex,
      textColor: textColorHex,
    );

    if (this.widget.existingWidget != null) {
      await StorageService.updateMemoWidget(widget);
    } else {
      await StorageService.saveMemoWidget(widget);
    }

    if (mounted) {
      Navigator.pop(context, true);
    }
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }
}