class Assignment {
  final int courseId;
  final int lessonId;
  bool isPendingSync;

  Assignment({
    required this.courseId,
    required this.lessonId,
    this.isPendingSync = false,
  });

  Map<String, dynamic> toJson() => {
    "course_id": courseId,
    "lesson_id": lessonId,
  };

  factory Assignment.fromJson(Map<String, dynamic> json) {
    return Assignment(
      courseId: json['course_id'],
      lessonId: json['lesson_id'],
      isPendingSync: json['isPendingSync'] ?? false,
    );
  }
}
