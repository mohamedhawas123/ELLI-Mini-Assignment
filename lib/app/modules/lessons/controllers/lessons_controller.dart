import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../../../offline/hive_boxes.dart';
import '../../../models/assignment_model.dart';
import '../../../services/assignment_service.dart';
import '../../courses/controllers/courses_controller.dart';

class LessonsController extends GetxController {
  String? selectedLesson;

  final List<Map<String, String>> lessons = [
    {"title": "Lesson 1", "subtitle": "08:00 to 08:45"},
    {"title": "Lesson 2", "subtitle": "09:00 to 09:45"},
    {"title": "Lesson 3", "subtitle": "10:00 to 10:45"},
  ];

  void selectLesson(String title) {
    selectedLesson = title;
    update();
  }

  bool get isLessonSelected => selectedLesson != null;

  Future<void> assignLessonToCourse(int courseId) async {
    if (selectedLesson == null) return;

    final coursesController = Get.find<CoursesController>();
    final isOnline = coursesController.isOnline;

    final lessonId = _lessonIdFromTitle(selectedLesson!);
    final assignment = Assignment(courseId: courseId, lessonId: lessonId);

    if (isOnline) {
      final success = await AssignmentService.assignBlock(assignment);
      if (success) {
        print("Synced to server for course $courseId - lesson $lessonId");
        final box = Hive.box(HiveBoxes.assignments);
        if (box.containsKey(courseId)) {
          await box.delete(courseId); // cleanup if it was pending before
        }

        coursesController.updateCourseAssignment(
          courseId,
          selectedLesson!,
          false,
        );
      } else {
        await _savePending(assignment);
        coursesController.updateCourseAssignment(
          courseId,
          selectedLesson!,
          true,
        );
      }
    } else {
      await _savePending(assignment);
      coursesController.updateCourseAssignment(courseId, selectedLesson!, true);
    }

    Get.back();
  }

  Future<void> _savePending(Assignment assignment) async {
    final box = Hive.box(HiveBoxes.assignments);
    await box.put(assignment.courseId, {
      "course_id": assignment.courseId,
      "lesson_id": assignment.lessonId,
      "isPendingSync": true,
    });
    print("Saved locally as pending: ${assignment.courseId}");
  }

  int _lessonIdFromTitle(String title) {
    final parts = title.split(' ');
    if (parts.length >= 2) {
      final id = int.tryParse(parts[1]);
      if (id != null) return id;
    }
    return 0;
  }
}
