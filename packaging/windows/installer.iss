; Inno Setup Script - PGYS (Personel ve Görev Yönetim Sistemi)
; Dağıtım ve Kurulum Paketi Tanımlayıcısı

#define MyAppName "Personel ve Görev Yönetim Sistemi"
#define MyAppShortName "PGYS"
#define MyAppVersion "1.0.0"
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
DisableProgramGroupPage=auto

[Languages]
Name: "turkish"; MessagesFile: "compiler:Languages\Turkish.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"
Name: "cleandb"; Description: "Mevcut yerel veritabanını sıfırla (Eski deneme verilerini siler ve sıfır temiz kurulum yapar)"; GroupDescription: "Veritabanı Yapılandırması:"; Flags: unchecked

[InstallDelete]
Type: files; Name: "{userdocs}\pgys.sqlite*"; Tasks: cleandb

[Files]
Source: "{#SourceBuildDir}\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; IconFilename: "{app}\{#MyAppExeName}"
Name: "{group}\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{uninstallexe}"
Name: "{autodesktop}\{#MyAppShortName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon; IconFilename: "{app}\{#MyAppExeName}"

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent
