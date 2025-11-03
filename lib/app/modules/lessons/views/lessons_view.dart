import 'package:ellie/app/widgets/lesson_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/lessons_controller.dart';

class LessonsView extends GetView<LessonsController> {
  const LessonsView({super.key});

  @override
  Widget build(BuildContext context) {
    final courseName = Get.arguments['course_name'];

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Container(
          margin: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Select Lesson Block",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              Text(courseName ?? "", style: TextStyle(fontSize: 12.sp)),
            ],
          ),
        ),
      ),
      body: GetBuilder<LessonsController>(
        builder: (controller) {
          return Container(
            color: Colors.white,
            height: 1.sh,
            width: 1.sw,
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: controller.lessons.length,
                    padding: EdgeInsets.all(10.r),
                    itemBuilder: (context, index) {
                      final lesson = controller.lessons[index];
                      final isSelected =
                          controller.selectedLesson == lesson['title'];

                      return Padding(
                        padding: EdgeInsets.only(bottom: 10.h),
                        child: LessonCard(
                          title: lesson['title'] ?? '',
                          subtitle: lesson['subtitle'] ?? '',
                          isSelected: isSelected,
                          onTap: () {
                            controller.selectLesson(lesson['title'] ?? '');
                          },
                        ),
                      );
                    },
                  ),
                ),

                GestureDetector(
                  onTap: controller.isLessonSelected
                      ? () async {
                          final selected = controller.selectedLesson!;
                          final courseId = Get.arguments['course_id'];

                          await controller.assignLessonToCourse(courseId);
                          Get.back();
                        }
                      : null, // disable if no selection
                  child: Container(
                    padding: EdgeInsets.all(12.r),
                    margin: EdgeInsets.symmetric(
                      vertical: 15.h,
                      horizontal: 10.w,
                    ),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: controller.isLessonSelected
                          ? const Color(0xFF1C75D2)
                          : Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Center(
                      child: Text(
                        "Assign Block",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
