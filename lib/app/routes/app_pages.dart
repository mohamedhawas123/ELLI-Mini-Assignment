import 'package:get/get.dart';

import '../modules/courses/bindings/courses_binding.dart';
import '../modules/courses/views/courses_view.dart';

import '../modules/lessons/bindings/lessons_binding.dart';
import '../modules/lessons/views/lessons_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.COURSES;

  static final routes = [
    GetPage(
      name: _Paths.COURSES,
      page: () => const CoursesView(),
      binding: CoursesBinding(),
    ),
    GetPage(
      name: _Paths.LESSONS,
      page: () => const LessonsView(),
      binding: LessonsBinding(),
    ),
  ];
}
