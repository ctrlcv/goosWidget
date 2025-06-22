class MemoWidgetData {
  final String id;
  final String content;
  final String backgroundColor;
  final String textColor;

  MemoWidgetData({
    required this.id,
    required this.content,
    required this.backgroundColor,
    required this.textColor,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'backgroundColor': backgroundColor,
      'textColor': textColor,
    };
  }

  factory MemoWidgetData.fromJson(Map<String, dynamic> json) {
    return MemoWidgetData(
      id: json['id'] as String,
      content: json['content'] as String,
      backgroundColor: json['backgroundColor'] as String,
      textColor: json['textColor'] as String,
    );
  }
}