# Agenda Nusantara

> Kelola tugasmu, raih harimu

![Version](https://img.shields.io/badge/version-v1.0.0-blue)
![Platform](https://img.shields.io/badge/platform-Android-green)
![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)

Aplikasi manajemen tugas harian berbasis Flutter dengan penyimpanan lokal SQLite dan visualisasi progres mingguan.

---

## Download

> Link otomatis mengarah ke release terbaru.

| Arsitektur | Ukuran | Download | Cocok untuk |
|------------|--------|----------|-------------|
| ARM64-v8a | ~18 MB | [⬇ Download](https://github.com/edoaurahman/TUK-todolist/releases/latest/download/app-arm64-v8a-release.apk) | Android 5.0+ 64-bit (sebagian besar HP modern) |
| ARM32 (armeabi-v7a) | ~16 MB | [⬇ Download](https://github.com/edoaurahman/TUK-todolist/releases/latest/download/app-armeabi-v7a-release.apk) | Android HP lama / 32-bit |
| x86_64 | ~19 MB | [⬇ Download](https://github.com/edoaurahman/TUK-todolist/releases/latest/download/app-x86_64-release.apk) | Emulator Android (AVD) |

**Tidak tahu arsitektur HP kamu?** Pilih ARM64-v8a — cocok untuk hampir semua HP Android modern (2016 ke atas).

---

## Fitur

- **Autentikasi** — Login dengan username & password lokal
- **Manajemen Tugas** — Buat, tandai selesai, dan hapus tugas
- **Kategori Tugas** — Penting dan Biasa
- **Statistik Dashboard** — Ringkasan tugas selesai vs tertunda
- **Grafik Mingguan** — Bar chart progres 7 hari terakhir
- **Pengaturan** — Ubah kredensial pengguna
- **Bahasa Indonesia** — Antarmuka dan format tanggal sepenuhnya dalam Bahasa Indonesia

---

## Tech Stack

| Komponen | Library |
|----------|---------|
| UI Framework | Flutter |
| State Management | GetX |
| Database Lokal | SQLite (sqflite) |
| Grafik | fl_chart |
| Preferensi | shared_preferences |
| Lokalisasi | intl (id_ID) |

---

## Build dari Source

**Prasyarat:** Flutter SDK, Android SDK

```bash
# Clone repo
git clone https://github.com/edoaurahman/TUK-todolist.git
cd TUK-todolist

# Install dependencies
flutter pub get

# Build APK split per arsitektur (recommended)
flutter build apk --split-per-abi --release

# Output di:
# build/app/outputs/flutter-apk/app-arm64-v8a-release.apk
# build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk
# build/app/outputs/flutter-apk/app-x86_64-release.apk
```
