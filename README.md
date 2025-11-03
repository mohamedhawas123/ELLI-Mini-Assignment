Bell Schedule Selector (ELLI Mini Assignment)

A Flutter feature that lets admins assign predefined lesson blocks to courses, with full offline capability using Hive and auto-sync when back online.

Folder Structure

lib/
 └── app/
     ├── models/              # Data models (e.g. Assignment)
     ├── modules/
     │   ├── courses/         # Course list + controller
     │   └── lessons/         # Lesson block selector + controller
     ├── offline/             # Hive box constants
     ├── routes/              # App routing setup (GetX)
     ├── services/            # API & LocalStorage services
     └── widgets/             # Shared UI components (CourseCard, LessonCard)
test/
 └── local_storage_service_test.dart   # Unit test for offline Hive storage


Architecture Choices

Pattern:
	•	GetX for state management, dependency injection, and navigation
	•	Service layer for separating logic:
	•	AssignmentService → handles remote API (MockAPI.io)
	•	LocalStorageService → handles local Hive operations
	•	Offline-first architecture:
	•	When offline, saves assignments to Hive
	•	When internet is restored, controller automatically syncs them to server
	•	Modular design:
Each screen has its own controller and view under app/modules/.

Libraries Used

get
hive / hive_flutter
hive_test
dio
connectivity_plus
flutter_screenutil
font_awesome_flutter
path_provider

How to Simulate Offline / Online Behavior


Unit Test

File: test/local_storage_service_test.dart
Tests that pending assignments are stored locally in Hive when offline.

How to Simulate Offline

1.	Open the app on a mobile device or emulator.
2.	Go to the Courses screen and open any course.
3.	Turn off Wi-Fi or mobile data (to simulate offline mode).
4.	Assign a lesson block — it will be saved locally as Pending Sync.
5.	Go back to the Courses list — you’ll see the status badge “Pending Sync.”
6.	Turn Wi-Fi or mobile data back on.
7.	The app will automatically detect the connection and sync the pending assignment to the server.

Simulation Flow

1.App loads → Courses fetched and pending assignments checked in Hive.
2.	If internet is off → assigned lessons are marked “Pending Sync”.
3.	Once online → all Hive records automatically sync and UI updates to “Synced”.