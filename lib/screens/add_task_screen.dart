import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/task_controller.dart';
import '../models/task.dart';
import '../theme/app_theme.dart';

class AddTaskScreen extends StatefulWidget {
  final TaskCategory category;
  const AddTaskScreen({super.key, required this.category});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  DateTime _due = DateTime.now();
  bool _saving = false;

  bool get _isPenting => widget.category == TaskCategory.penting;
  Color get _accent => _isPenting ? AppColors.penting : AppColors.biasa;
  String get _title =>
      _isPenting ? 'Tambah Tugas Penting' : 'Tambah Tugas Biasa';
  String get _badge => _isPenting ? 'PENTING' : 'BIASA';

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _due,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: ColorScheme.light(primary: _accent),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _due = picked);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    await Get.find<TaskController>().addTask(
      title: _titleCtrl.text,
      description: _descCtrl.text,
      dueDate: _due,
      category: widget.category,
    );
    if (mounted) setState(() => _saving = false);
    Get.back();
    Get.snackbar(
      'Tersimpan',
      'Tugas berhasil disimpan',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: _accent.withValues(alpha: 0.12),
      colorText: _accent,
      duration: const Duration(seconds: 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateLabel = DateFormat('dd MMM yyyy', 'id_ID').format(_due);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _accent,
        title: Text(_title),
        leading: const BackButton(),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  _badge,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: _accent,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
            const _Label('TANGGAL JATUH TEMPO'),
            InkWell(
              onTap: _pickDate,
              borderRadius: BorderRadius.circular(10),
              child: InputDecorator(
                decoration: const InputDecoration(),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today_rounded,
                        size: 18, color: AppColors.textSubtle),
                    const SizedBox(width: 10),
                    Text(dateLabel,
                        style: const TextStyle(
                            color: AppColors.textPrimary, fontSize: 15)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            const _Label('JUDUL TUGAS'),
            TextFormField(
              controller: _titleCtrl,
              decoration: InputDecoration(
                hintText:
                    _isPenting ? 'Contoh: Submit laporan' : 'Contoh: Beli buah',
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Judul wajib diisi' : null,
            ),
            const SizedBox(height: 14),
            const _Label('DESKRIPSI'),
            TextFormField(
              controller: _descCtrl,
              maxLines: 4,
              decoration: const InputDecoration(hintText: 'Jelaskan tugas...'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: _accent),
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('SIMPAN'),
            ),
          ],
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.textSubtle,
          letterSpacing: 1,
        ),
      ),
    );
  }
}
