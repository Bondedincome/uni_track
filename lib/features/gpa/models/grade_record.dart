class GradeRecord {
  final String courseId;
  final String gradeLetter; // e.g., 'A', 'B+', 'C'
  final double gradePoints; // e.g., 4.0, 3.3, 2.0
  final int credits;

  GradeRecord({
    required this.courseId,
    required this.gradeLetter,
    required this.gradePoints,
    required this.credits,
  });

  Map<String, dynamic> toJson() => {
    'courseId': courseId,
    'gradeLetter': gradeLetter,
    'gradePoints': gradePoints,
    'credits': credits,
  };

  factory GradeRecord.fromJson(Map<String, dynamic> json) => GradeRecord(
    courseId: json['courseId'],
    gradeLetter: json['gradeLetter'],
    gradePoints: json['gradePoints'],
    credits: json['credits'],
  );
}
