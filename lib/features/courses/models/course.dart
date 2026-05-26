import 'package:flutter/material.dart';

class Course {
  final String id;
  final String code;
  final String name;
  final String instructor;
  final int credits;
  final Color color;
  final double progress; // 0.0 to 1.0

  Course({
    required this.id,
    required this.code,
    required this.name,
    required this.instructor,
    required this.credits,
    required this.color,
    this.progress = 0.0,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'code': code,
    'name': name,
    'instructor': instructor,
    'credits': credits,
    'color': color.toARGB32(),
    'progress': progress,
  };

  factory Course.fromJson(Map<String, dynamic> json) => Course(
    id: json['id'],
    code: json['code'],
    name: json['name'],
    instructor: json['instructor'],
    credits: json['credits'],
    color: Color(json['color']),
    progress: json['progress'] ?? 0.0,
  );
}
