import 'package:hive/hive.dart';
import '../models/assignment_model.dart';
import '../offline/hive_boxes.dart';

class LocalStorageService {
  static Future<void> init() async {
    await Hive.openBox('assignmentsBox');
  }

  static Future<void> savePendingAssignment(Assignment assignment) async {
    final box = Hive.box(HiveBoxes.assignments);
    await box.put(assignment.courseId, {
      "course_id": assignment.courseId,
      "lesson_id": assignment.lessonId,
      "isPendingSync": true,
    });
    print(" Saved pending assignment locally: ${assignment.courseId}");
  }

  static List<Assignment> getPendingAssignments() {
    final box = Hive.box(HiveBoxes.assignments);
    return box.values
        .map((item) => Assignment.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  static Future<void> markSynced(int courseId) async {
    final box = Hive.box(HiveBoxes.assignments);
    final item = box.get(courseId);
    if (item != null) {
      item['isPendingSync'] = false;
      await box.put(courseId, item);
      print(" Marked course $courseId as synced");
    }
  }
}
