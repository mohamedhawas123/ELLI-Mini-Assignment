import 'package:ellie/app/routes/app_pages.dart';
import 'package:ellie/app/widgets/course_card.dart';
import 'package:ellie/app/widgets/course_list_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/courses_controller.dart';

class CoursesView extends GetView<CoursesController> {
  const CoursesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text('Courses'),
        centerTitle: true,
      ),
      body: GetBuilder<CoursesController>(
        builder: (controller) {
          if (controller.isLoading) {
            return const CourseListSkeleton();
          }
          final courses = controller.courses;

          return Container(
            color: Colors.white,
            height: 1.sh,
            width: 1.sw,
            child: ListView.builder(
              itemCount: courses.length,
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
              itemBuilder: (context, index) {
                final course = courses[index];

                final title = course['name'] ?? '';
                final assignedLesson = course['assignedLesson'];
                final isPending = course['pendingSync'] == true;

                return Padding(
                  padding: EdgeInsets.only(bottom: 10.h),
                  child: CourseCard(
                    title: title,
                    subtitle: assignedLesson != null
                        ? 'Assigned: $assignedLesson'
                        : 'No Assignment',
                    statusText: isPending ? 'Pending Sync' : '',
                    statusColor: isPending
                        ? const Color(0xFFFFECD5)
                        : Colors.transparent,
                    onTap: () async {
                      Get.toNamed(
                        Routes.LESSONS,
                        arguments: {
                          'course_name': title,
                          'course_id': course['id'],
                        },
                      );
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
