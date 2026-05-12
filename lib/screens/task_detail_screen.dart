import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../models/task.dart';
import '../theme/app_theme.dart';

class TaskDetailScreen extends StatelessWidget {
  const TaskDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final task = Get.arguments as Task;
    final isPenting = task.category == TaskCategory.penting;
    final accent = isPenting ? AppColors.penting : AppColors.biasa;
    final dateLabel = DateFormat('dd MMMM yyyy', 'id_ID').format(task.dueDate);
    final categoryLabel = isPenting ? 'Penting' : 'Biasa';

    return Scaffold(
      appBar: AppBar(title: const Text('Detail Tugas')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _Badge(
                  label: task.done ? 'Selesai' : 'Belum Selesai',
                  color: task.done ? AppColors.biasa : AppColors.textSubtle,
                ),
                const SizedBox(width: 8),
                _Badge(label: categoryLabel, color: accent),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              task.title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: AppColors.textSubtle),
                const SizedBox(width: 6),
                Text(
                  dateLabel,
                  style: const TextStyle(fontSize: 14, color: AppColors.textSubtle),
                ),
              ],
            ),
            if (task.done && task.completedAt != null) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.check_circle, size: 16, color: AppColors.biasa),
                  const SizedBox(width: 6),
                  Text(
                    'Selesai ${DateFormat('dd MMM yyyy', 'id_ID').format(task.completedAt!)}',
                    style: const TextStyle(fontSize: 14, color: AppColors.biasa),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 24),
            const Text(
              'DESKRIPSI',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textSubtle,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Text(
                task.description.isEmpty ? 'Tidak ada deskripsi.' : task.description,
                style: TextStyle(
                  fontSize: 15,
                  color: task.description.isEmpty ? AppColors.textSubtle : AppColors.textPrimary,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;
  const _Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
