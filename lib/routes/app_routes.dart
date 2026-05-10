import 'package:get/get.dart';

import '../models/task.dart';
import '../screens/add_task_screen.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/task_list_screen.dart';

abstract class AppRoutes {
  static const login = '/login';
  static const home = '/home';
  static const addPenting = '/add-penting';
  static const addBiasa = '/add-biasa';
  static const taskList = '/task-list';
  static const settings = '/settings';

  static final pages = <GetPage<dynamic>>[
    GetPage(name: login, page: () => const LoginScreen()),
    GetPage(name: home, page: () => const HomeScreen()),
    GetPage(
      name: addPenting,
      page: () => const AddTaskScreen(category: TaskCategory.penting),
    ),
    GetPage(
      name: addBiasa,
      page: () => const AddTaskScreen(category: TaskCategory.biasa),
    ),
    GetPage(name: taskList, page: () => const TaskListScreen()),
    GetPage(name: settings, page: () => const SettingsScreen()),
  ];
}
