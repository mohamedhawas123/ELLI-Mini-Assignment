import 'dart:async';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../../offline/hive_boxes.dart';
import '../../../services/assignment_service.dart';
import '../../../models/assignment_model.dart';

class CoursesController extends GetxController {
  bool isOnline = false;
  bool isLoading = true;

  late StreamSubscription<List<ConnectivityResult>> _connectivitySub;

  //static courses
  final List<Map<String, dynamic>> courses = [
    {"id": 11, "name": "Math Grade 5"},
    {"id": 12, "name": "English Grade 5"},
    {"id": 13, "name": "Science Grade 5"},
    {"id": 14, "name": "History Grade 5"},
  ];

  @override
  void onInit() {
    super.onInit();
    isLoading = true;
    update();
    _initConnectivityListener();
    _applyPendingFromHive();
    _applyAssignmentsFromApi();
  }

  void _initConnectivityListener() {
    final connectivity = Connectivity();

    // Initial check
    connectivity.checkConnectivity().then((results) async {
      isOnline = _isAnyOnline(results);
      if (isOnline) {
        await syncPendingAssignments();
      }
      update();
    });

    _connectivitySub = connectivity.onConnectivityChanged.listen((
      results,
    ) async {
      final wasOnline = isOnline;
      isOnline = _isAnyOnline(results);
      update();

      if (!wasOnline && isOnline) {
        await syncPendingAssignments();
      }
    });
  }

  bool _isAnyOnline(List<ConnectivityResult> results) {
    if (results.isEmpty) return false;
    return results.any(
      (r) =>
          r == ConnectivityResult.wifi ||
          r == ConnectivityResult.mobile ||
          r == ConnectivityResult.ethernet ||
          r == ConnectivityResult.vpn,
    );
  }

  void _applyPendingFromHive() {
    final box = Hive.box(HiveBoxes.assignments);

    for (var i = 0; i < courses.length; i++) {
      final courseId = courses[i]['id'] as int;
      if (box.containsKey(courseId)) {
        courses[i]['pendingSync'] = true;
        final item = Map<String, dynamic>.from(box.get(courseId));
        final lessonId = item['lesson_id'] as int?;
        if (lessonId != null) {
          courses[i]['assignedLesson'] = _lessonNameFromId(lessonId);
        }
      } else {
        courses[i].remove('pendingSync');
      }
    }

    update();
  }

  Future<void> _applyAssignmentsFromApi() async {
    final data = await AssignmentService.fetchAssignments();
    if (data.isEmpty) return;

    for (final record in data) {
      final courseId = record['course_id'];
      final lessonId = record['lesson_id'];
      final idx = courses.indexWhere((c) => c['id'] == courseId);

      if (idx != -1) {
        courses[idx]['assignedLesson'] = _lessonNameFromId(lessonId);
        courses[idx]['pendingSync'] = false;
      }
    }
    isLoading = false;

    update();
  }

  Future<void> syncPendingAssignments() async {
    final box = Hive.box(HiveBoxes.assignments);
    if (box.isEmpty) return;

    print('Syncing pending assignments...');

    final keys = box.keys.toList();
    for (final key in keys) {
      final data = Map<String, dynamic>.from(box.get(key));
      final courseId = data['course_id'] as int;
      final lessonId = data['lesson_id'] as int;

      final assignment = Assignment(courseId: courseId, lessonId: lessonId);
      final success = await AssignmentService.assignBlock(assignment);

      if (success) {
        await box.delete(key);

        final idx = courses.indexWhere((c) => c['id'] == courseId);
        if (idx != -1) {
          courses[idx]['assignedLesson'] = _lessonNameFromId(lessonId);
          courses[idx]['pendingSync'] = false;
        }
      }
    }

    update();
  }

  String _lessonNameFromId(int lessonId) => 'Lesson $lessonId';

  void updateCourseAssignment(
    int courseId,
    String lessonTitle,
    bool isPending,
  ) {
    final index = courses.indexWhere((c) => c['id'] == courseId);
    if (index != -1) {
      courses[index]['assignedLesson'] = lessonTitle;
      courses[index]['pendingSync'] = isPending;
      update();
    }
  }

  @override
  void onClose() {
    _connectivitySub.cancel();
    super.onClose();
  }
}
