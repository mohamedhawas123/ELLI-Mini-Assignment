import 'dart:convert';
import 'package:dio/dio.dart';
import '../models/assignment_model.dart';

class AssignmentService {
  static const String baseUrl =
      "https://6908d0ca2d902d0651b1cf89.mockapi.io/assignments";
  static const String token = "mock_token_123";

  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {"Content-Type": "application/json"},
    ),
  );

  static Future<List<Map<String, dynamic>>> fetchAssignments() async {
    try {
      final res = await _dio.get('');
      if (res.statusCode == 200) {
        final data = res.data;
        if (data is List) {
          return List<Map<String, dynamic>>.from(data);
        }
      }
      print(" Fetch failed: ${res.statusCode}");
      return [];
    } on DioException catch (e) {
      print(" Dio error fetching assignments: ${e.message}");
      return [];
    } catch (e) {
      print(" Unknown error fetching assignments: $e");
      return [];
    }
  }

  static Future<bool> assignBlock(Assignment assignment) async {
    try {
      final response = await _dio.post(
        '',
        data: jsonEncode({
          "token": token,
          "course_id": assignment.courseId,
          "lesson_id": assignment.lessonId,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        print(" Synced to MockAPI: ${response.data}");
        return true;
      } else {
        print(" Sync failed: ${response.statusCode}");
        return false;
      }
    } on DioException catch (e) {
      print(" Dio error syncing: ${e.message}");
      return false;
    } catch (e) {
      print(" Unknown error syncing: $e");
      return false;
    }
  }
}
