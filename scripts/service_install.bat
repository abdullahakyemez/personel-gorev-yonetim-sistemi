@echo off
chcp 65001 >nul
echo ========================================================
echo PGYS Merkez Sunucu Windows Servisi Kurulumu
echo ========================================================
echo.

:: Yönetici yetkisi kontrolü
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [UYARI] Bu betik Windows Görev Zamanlayıcısına sistem servisi
    echo eklemek için Yönetici olarak çalıştırılmalıdır.
    echo Lütfen bu dosyaya sağ tıklayıp "Yönetici olarak çalıştır" seçeneğini kullanın.
    echo.
    pause
    exit /b 1
)

set "EXE_PATH=%~dp0..\build\cli\bundle\bin\pgys_service.exe"

if not exist "%EXE_PATH%" (
    set "EXE_PATH=%~dp0pgys_service.exe"
)

if not exist "%EXE_PATH%" (
    echo [HATA] pgys_service.exe bulunamadı!
    echo Lütfen dosyanın mevcut olduğunu kontrol edin.
    pause
    exit /b 1
)

echo Çalıştırılacak servis dosyası: %EXE_PATH%
"%EXE_PATH%" --install

echo.
echo Servis durumu kontrol ediliyor:
"%EXE_PATH%" --status

echo.
pause
