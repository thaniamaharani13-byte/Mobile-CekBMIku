Set-Location $PSScriptRoot
if (-not (Get-Command flutter -ErrorAction SilentlyContinue)) {
    Write-Error "Flutter belum tersedia di PATH. Install Flutter SDK dan plugin Flutter/Dart di Android Studio terlebih dahulu."
    exit 1
}
flutter create . --platforms=android
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
flutter pub get
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
Write-Host "Selesai. Buka folder CekBMIKu_Flutter di Android Studio lalu Run." -ForegroundColor Green
