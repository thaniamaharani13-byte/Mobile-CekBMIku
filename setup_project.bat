@echo off
setlocal
cd /d "%~dp0"
where flutter >nul 2>nul
if errorlevel 1 (
  echo [ERROR] Flutter belum tersedia di PATH.
  echo Install Flutter SDK dan plugin Flutter/Dart di Android Studio terlebih dahulu.
  pause
  exit /b 1
)

echo Membuat/melengkapi platform Android dengan Flutter SDK lokal...
flutter create . --platforms=android
if errorlevel 1 goto :fail

echo Mengambil dependency...
flutter pub get
if errorlevel 1 goto :fail

echo.
echo SELESAI. Sekarang buka folder ini di Android Studio lalu Run.
pause
exit /b 0

:fail
echo.
echo Setup gagal. Baca pesan error di atas.
pause
exit /b 1
