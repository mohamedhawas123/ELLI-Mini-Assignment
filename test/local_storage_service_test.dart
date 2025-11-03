import 'package:ellie/app/models/assignment_model.dart';
import 'package:ellie/app/services/local_storage_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_test/hive_test.dart';

void main() {
  setUp(() async {
    await setUpTestHive();
    await Hive.openBox('assignmentsBox');
  });

  tearDown(() async {
    await tearDownTestHive();
  });

  test('Saving pending assignment offline should store it in Hive', () async {
    // Arrange
    final assignment = Assignment(
      courseId: 11,
      lessonId: 2,
      isPendingSync: true,
    );

    // Act
    await LocalStorageService.savePendingAssignment(assignment);

    // Assert
    final box = Hive.box('assignmentsBox');
    final saved = box.get(assignment.courseId);

    expect(saved, isNotNull);
    expect(saved['course_id'], equals(11));
    expect(saved['lesson_id'], equals(2));
    expect(saved['isPendingSync'], isTrue);
  });
}
