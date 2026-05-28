enum ScheduleRecurrence { weekly, oneOff }

class ScheduleItem {
  final String id;
  final String? courseId; // null = standalone
  final String title;
  final String? location;
  final String time; // "HH:mm" 24h
  final ScheduleRecurrence recurrence;
  final int? dayOfWeek; // 1=Mon ... 7=Sun (when recurrence == weekly)
  final DateTime? date; // when recurrence == oneOff

  ScheduleItem({
    required this.id,
    required this.title,
    required this.time,
    required this.recurrence,
    this.courseId,
    this.location,
    this.dayOfWeek,
    this.date,
  });

  bool get isStandalone => courseId == null;

  Map<String, dynamic> toJson() => {
        'id': id,
        'courseId': courseId,
        'title': title,
        'location': location,
        'time': time,
        'recurrence': recurrence.name,
        'dayOfWeek': dayOfWeek,
        'date': date?.toIso8601String(),
      };

  factory ScheduleItem.fromJson(Map<String, dynamic> json) => ScheduleItem(
        id: json['id'] as String,
        courseId: json['courseId'] as String?,
        title: json['title'] as String,
        location: json['location'] as String?,
        time: json['time'] as String,
        recurrence: ScheduleRecurrence.values.firstWhere(
          (r) => r.name == (json['recurrence'] as String?),
          orElse: () => ScheduleRecurrence.weekly,
        ),
        dayOfWeek: json['dayOfWeek'] as int?,
        date: (json['date'] as String?) != null
            ? DateTime.parse(json['date'] as String)
            : null,
      );

  ScheduleItem copyWith({
    String? id,
    String? courseId,
    String? title,
    String? location,
    String? time,
    ScheduleRecurrence? recurrence,
    int? dayOfWeek,
    DateTime? date,
    bool clearCourseId = false,
    bool clearDayOfWeek = false,
    bool clearDate = false,
    bool clearLocation = false,
  }) {
    return ScheduleItem(
      id: id ?? this.id,
      courseId: clearCourseId ? null : (courseId ?? this.courseId),
      title: title ?? this.title,
      location: clearLocation ? null : (location ?? this.location),
      time: time ?? this.time,
      recurrence: recurrence ?? this.recurrence,
      dayOfWeek: clearDayOfWeek ? null : (dayOfWeek ?? this.dayOfWeek),
      date: clearDate ? null : (date ?? this.date),
    );
  }

  /// Returns true if this item should appear on the dashboard "today" list.
  bool occursOn(DateTime now) {
    switch (recurrence) {
      case ScheduleRecurrence.weekly:
        return dayOfWeek != null && dayOfWeek == now.weekday;
      case ScheduleRecurrence.oneOff:
        if (date == null) return false;
        return date!.year == now.year &&
            date!.month == now.month &&
            date!.day == now.day;
    }
  }
}
