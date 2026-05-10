import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../routes/app_routes.dart';
import '../services/auth_service.dart';

class AuthController extends GetxController {
  final AuthService _service = AuthService();

  final username = ''.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _service.ensureSeeded().then((_) async {
      username.value = await _service.getUsername();
    });
  }

  Future<void> login(String u, String p) async {
    isLoading.value = true;
    final ok = await _service.login(u.trim(), p);
    isLoading.value = false;
    if (ok) {
      username.value = u.trim();
      Get.offAllNamed(AppRoutes.home);
    } else {
      Get.snackbar(
        'Login Gagal',
        'Username atau password salah',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
    }
  }

  Future<bool> changePassword(String current, String next) =>
      _service.changePassword(current, next);

  void logout() {
    Get.offAllNamed(AppRoutes.login);
  }
}
