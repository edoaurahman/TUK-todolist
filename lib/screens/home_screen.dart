import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/auth_controller.dart';
import '../controllers/task_controller.dart';
import '../routes/app_routes.dart';
import '../theme/app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();
    final task = Get.find<TaskController>();
    final today = DateFormat(
      'EEEE, d MMM yyyy',
      'id_ID',
    ).format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Beranda'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: auth.logout,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: task.refreshAll,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Obx(
              () => Text(
                'Halo, ${auth.username.value.isEmpty ? 'User' : auth.username.value}! 👋',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(today, style: const TextStyle(color: AppColors.textSubtle)),
            const SizedBox(height: 16),
            Obx(
              () => Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      label: 'TUGAS SELESAI',
                      value: task.doneCount.value,
                      color: AppColors.biasa,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      label: 'BELUM SELESAI',
                      value: task.pendingCount.value,
                      color: AppColors.penting,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const _ChartCard(),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.15,
              children: [
                _MenuButton(
                  icon: Icons.add_rounded,
                  label: 'Tambah Tugas Penting',
                  color: AppColors.penting,
                  onTap: () => Get.toNamed(AppRoutes.addPenting),
                ),
                _MenuButton(
                  icon: Icons.add_rounded,
                  label: 'Tambah Tugas Biasa',
                  color: AppColors.biasa,
                  onTap: () => Get.toNamed(AppRoutes.addBiasa),
                ),
                _MenuButton(
                  icon: Icons.list_alt_rounded,
                  label: 'Daftar Tugas',
                  color: AppColors.primary,
                  onTap: () => Get.toNamed(AppRoutes.taskList),
                ),
                _MenuButton(
                  icon: Icons.settings_rounded,
                  label: 'Pengaturan',
                  color: const Color(0xFF607080),
                  onTap: () => Get.toNamed(AppRoutes.settings),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final int value;
  final Color color;
  const _StatCard({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textSubtle,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$value',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _MenuButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: Colors.white, size: 22),
              ),
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChartCard extends StatelessWidget {
  const _ChartCard();

  @override
  Widget build(BuildContext context) {
    final task = Get.find<TaskController>();
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'TUGAS SELESAI / HARI',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textSubtle,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 160,
            child: Obx(() {
              final now = DateTime.now();
              final days = List.generate(
                7,
                (i) => DateTime(now.year, now.month, now.day - (6 - i)),
              );
              final fmt = DateFormat('yyyy-MM-dd');
              final labelFmt = DateFormat('E', 'id_ID');
              final data = days
                  .map((d) => task.perDay[fmt.format(d)] ?? 0)
                  .toList();
              final maxY = (data.fold<int>(
                0,
                (a, b) => a > b ? a : b,
              )).toDouble();
              return BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: maxY < 1 ? 4 : maxY + 1,
                  borderData: FlBorderData(show: false),
                  gridData: const FlGridData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 28,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          if (value == meta.max) {
                            return const SizedBox.shrink();
                          }
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textSubtle,
                            ),
                          );
                        },
                      ),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 24,
                        getTitlesWidget: (value, meta) {
                          final i = value.toInt();
                          if (i < 0 || i >= days.length) {
                            return const SizedBox.shrink();
                          }
                          return Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              labelFmt.format(days[i]),
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.textSubtle,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  barGroups: [
                    for (var i = 0; i < data.length; i++)
                      BarChartGroupData(
                        x: i,
                        barRods: [
                          BarChartRodData(
                            toY: data[i].toDouble(),
                            color: AppColors.primary,
                            width: 16,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(4),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
