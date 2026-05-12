import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/task_controller.dart';
import '../models/task.dart';
import '../routes/app_routes.dart';
import '../theme/app_theme.dart';

class TaskListScreen extends GetView<TaskController> {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Tugas')),
      body: Obx(() {
        if (controller.tasks.isEmpty) {
          return const Center(
            child: Text(
              'Belum ada tugas.\nTambahkan dari Beranda.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSubtle),
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: controller.refreshAll,
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: controller.tasks.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (ctx, i) {
              final t = controller.tasks[i];
              return _TaskTile(
                task: t,
                onToggle: () => controller.toggleDone(t),
                onDelete: () => _confirmDelete(t),
              );
            },
          ),
        );
      }),
    );
  }

  Future<void> _confirmDelete(Task t) async {
    final ok = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Hapus tugas?'),
        content: Text('"${t.title}" akan dihapus permanen.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            style: TextButton.styleFrom(foregroundColor: AppColors.penting),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (ok == true && t.id != null) {
      await Get.find<TaskController>().remove(t.id!);
    }
  }
}

class _TaskTile extends StatelessWidget {
  final Task task;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  const _TaskTile({
    required this.task,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isPenting = task.category == TaskCategory.penting;
    final accent = isPenting ? AppColors.penting : AppColors.biasa;
    final dateLabel = DateFormat('dd MMM yyyy', 'id_ID').format(task.dueDate);
    final categoryLabel = isPenting ? 'Penting' : 'Biasa';
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onToggle,
        onLongPress: onDelete,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              _Checkbox(checked: task.done, color: accent, onTap: onToggle),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: task.done
                            ? AppColors.textSubtle
                            : AppColors.textPrimary,
                        decoration: task.done
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$dateLabel · $categoryLabel',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSubtle,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => Get.toNamed(AppRoutes.taskDetail, arguments: task),
                child: Icon(Icons.play_arrow_rounded, color: accent, size: 28),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Checkbox extends StatelessWidget {
  final bool checked;
  final Color color;
  final VoidCallback onTap;
  const _Checkbox({
    required this.checked,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          color: checked ? color : Colors.transparent,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: checked ? color : Colors.grey.shade400,
            width: 1.5,
          ),
        ),
        child: checked
            ? const Icon(Icons.check, size: 16, color: Colors.white)
            : null,
      ),
    );
  }
}
