# Social Media App (Laravel + Flutter)

Aplikasi media sosial yang dibuat menggunakan **Laravel** sebagai Backend (REST API) dan **Flutter** sebagai Frontend (Mobile App).

## Fitur utama:
- Autentikasi (Login, Register, Logout) menggunakan Laravel Sanctum.
- CRUD Postingan (Upload Teks & Gambar).
- Edit Profil Pengguna.
- Penyimpanan sesi lokal dan manajemen state.

## Struktur Folder

- `social_media_api/` : Kode API Backend (Laravel 10+).
  
- `Flutter-Social-Media-App_login upgrade-main/` : Kode Aplikasi Mobile (Flutter).

## Panduan Instalasi & Menjalankan Backend (Laravel)
### Requirements
Pastikan komputer sudah terinstal:
- PHP (versi 8.1 atau lebih baru)
- Composer
- MySQL (via XAMPP, Laragon, atau Docker)

### Langkah 1: Masuk ke Folder Backend
Buka terminal dan arahkan ke direktori backend:
```
cd social_media_api
```

### Langkah 2: Install Dependensi
Unduh semua pustaka PHP yang dibutuhkan:
```
composer install
```

### Langkah 3: Konfigurasi Environment (.env)
Salin file contoh konfigurasi dan buat file .env baru:
```
copy .env.example .env
```
Buka file .env tersebut dengan text editor, lalu sesuaikan konfigurasi database:
```
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=social_media_app
DB_USERNAME=root
DB_PASSWORD=
```
(Pastikan telah membuat database kosong bernama social_media_app di phpMyAdmin atau MySQL).

### Langkah 4: Generate Key & Migrasi Database
Jalankan perintah berikut untuk mengisi tabel database (Users, Posts, Sessions):
```
php artisan key:generate
php artisan migrate
```
Catatan: Migrasi wajib dijalankan karena aplikasi menggunakan SESSION_DRIVER=database.

### Langkah 5: Jalankan Server
Untuk menghubungkan dengan Emulator Android atau HP Fisik, jangan hanya menggunakan php artisan serve biasa. Gunakan perintah ini agar host terbuka:
```
php artisan serve --host=0.0.0.0 --port=8000
```

### Panduan Frontend (Flutter)
1. Masuk ke folder frontend:
   ```
   cd Flutter-Social-Media-App_login upgrade-main
   ```
   
2. Install paket flutter:
   ```
   flutter pub get
   ```
   
3. PENTING: Cek file lib/pages/home_page.dart (dan file API lainnya). Pastikan apiUrl sesuai dengan IP komputer Anda:
   - Emulator Android: Gunakan http://10.0.2.2:8000
     
   - HP Fisik / iOS: Gunakan IP LAN Laptop (contoh: http://192.168.1.x:8000)
     
4. Jalankan aplikasi:
   ```
   flutter run
   ```
