; Inno Setup Script - PGYS (Personel ve Görev Yönetim Sistemi)
; Dağıtım ve Kurulum Paketi Tanımlayıcısı

#define MyAppName "Personel ve Görev Yönetim Sistemi"
#define MyAppShortName "PGYS"
#define MyAppVersion "1.0.4"

#define MyAppPublisher "PGYS"
#define MyAppExeName "PGYS.exe"
#define SourceBuildDir "..\..\build\windows\x64\runner\Release"

[Setup]
AppId={{E58C3B12-9A4B-4E31-8E82-9383A20B78DF}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
DefaultDirName={autopf}\{#MyAppShortName}
DefaultGroupName={#MyAppName}
AllowNoIcons=yes
OutputDir=..\..\dist
OutputBaseFilename=PGYS_Setup_v{#MyAppVersion}
SetupIconFile=..\..\windows\runner\resources\app_icon.ico
Compression=lzma2/max
SolidCompression=yes
WizardStyle=modern
ArchitecturesInstallIn64BitMode=x64compatible
PrivilegesRequired=lowest
PrivilegesRequiredOverridesAllowed=dialog commandline
DisableProgramGroupPage=auto

[Languages]
Name: "turkish"; MessagesFile: "compiler:Languages\Turkish.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"
Name: "installsrv"; Description: "PGYS 7/24 Merkez Sunucu Servisini Kur ve Başlat (Bu bilgisayar Merkez Sunucu olacaksa işaretleyiniz)"; GroupDescription: "Merkez Sunucu Servis Yapılandırması:"; Flags: unchecked
Name: "cleandb"; Description: "Mevcut yerel veritabanını sıfırla (Eski deneme verilerini siler ve sıfır temiz kurulum yapar)"; GroupDescription: "Veritabanı Yapılandırması:"; Flags: unchecked

[InstallDelete]
Type: files; Name: "{userdocs}\pgys.sqlite*"; Tasks: cleandb
Type: files; Name: "{commonappdata}\PGYS\pgys.sqlite*"; Tasks: cleandb

[Files]
Source: "{#SourceBuildDir}\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "..\..\scripts\service_install.bat"; DestDir: "{app}\scripts"; Flags: ignoreversion
Source: "..\..\scripts\service_uninstall.bat"; DestDir: "{app}\scripts"; Flags: ignoreversion

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; IconFilename: "{app}\{#MyAppExeName}"
Name: "{group}\Merkez Sunucu Servisini Başlat (Yönetici)"; Filename: "{app}\scripts\service_install.bat"
Name: "{group}\Merkez Sunucu Servisini Kaldır (Yönetici)"; Filename: "{app}\scripts\service_uninstall.bat"
Name: "{group}\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{uninstallexe}"
Name: "{autodesktop}\{#MyAppShortName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon; IconFilename: "{app}\{#MyAppExeName}"

[Run]
Filename: "{app}\pgys_service.exe"; Parameters: "--install"; Flags: runhidden; Tasks: installsrv; StatusMsg: "Merkez Sunucu 7/24 Arka Plan Servisi kuruluyor ve başlatılıyor..."
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent

[UninstallRun]
Filename: "{app}\pgys_service.exe"; Parameters: "--uninstall"; Flags: runhidden; RunOnceId: "UninstallPGYSService"
