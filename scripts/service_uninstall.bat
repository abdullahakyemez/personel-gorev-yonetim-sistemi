@echo off
chcp 65001 >nul
echo ========================================================
echo PGYS Merkez Sunucu Windows Servisi Kaldırma
echo ========================================================
echo.

:: Yönetici yetkisi kontrolü
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [UYARI] Bu betik Windows Görev Zamanlayıcısından servisi
    echo kaldırmak için Yönetici olarak çalıştırılmalıdır.
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
    pause
    exit /b 1
)

"%EXE_PATH%" --uninstall

echo.
pause
