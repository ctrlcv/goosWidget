class DdayWidgetData {
  final String id;
  final String title;
  final String targetDate;
  final String backgroundColor;
  final String textColor;

  DdayWidgetData({
    required this.id,
    required this.title,
    required this.targetDate,
    required this.backgroundColor,
    required this.textColor,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'targetDate': targetDate,
      'backgroundColor': backgroundColor,
      'textColor': textColor,
    };
  }

  factory DdayWidgetData.fromJson(Map<String, dynamic> json) {
    return DdayWidgetData(
      id: json['id'] as String,
      title: json['title'] as String,
      targetDate: json['targetDate'] as String,
      backgroundColor: json['backgroundColor'] as String,
      textColor: json['textColor'] as String,
    );
  }

  int getDaysLeft() {
    final target = DateTime.parse(targetDate);
    final now = DateTime.now();
    final difference = target.difference(DateTime(now.year, now.month, now.day)).inDays;
    return difference;
  }

  String getDisplayText() {
    final daysLeft = getDaysLeft();
    if (daysLeft > 0) {
      return 'D-$daysLeft';
    } else if (daysLeft < 0) {
      return 'D+${-daysLeft}';
    } else {
      return 'D-Day';
    }
  }
}
