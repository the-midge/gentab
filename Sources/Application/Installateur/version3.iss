; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#define MyAppName "Gentab"
#define MyAppVersion "0.9"
#define MyAppExeName "MyProg.exe"

[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{9898A299-B436-4AB9-800A-EBA416760FA4}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
;AppVerName={#MyAppName} {#MyAppVersion}
DefaultDirName={pf}\{#MyAppName}
DisableDirPage=yes
DisableProgramGroupPage=yes
OutputDir=D:\GenTab\Sources\Application\Installateur
OutputBaseFilename=setup
Compression=lzma
SolidCompression=yes

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: "C:\Program Files (x86)\Inno Setup 5\Examples\MyProg.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "D:\GenTab\Sources\Application\GenTab\dos.png"; DestDir: "{app}"; Flags: ignoreversion
Source: "D:\GenTab\Sources\Application\GenTab\dos_final.png"; DestDir: "{app}"; Flags: ignoreversion
Source: "D:\GenTab\Sources\Application\GenTab\guitar.jpeg"; DestDir: "{app}"; Flags: ignoreversion
Source: "D:\GenTab\Sources\Application\GenTab\Guitar-icon.png"; DestDir: "{app}"; Flags: ignoreversion
Source: "D:\GenTab\Sources\Application\GenTab\poeme.txt"; DestDir: "{app}"; Flags: ignoreversion
Source: "D:\GenTab\Sources\Application\GenTab\projetTampon.aup"; DestDir: "{app}"; Flags: ignoreversion
Source: "D:\GenTab\Sources\Application\GenTab\quatro.png"; DestDir: "{app}"; Flags: ignoreversion
Source: "D:\GenTab\Sources\Application\GenTab\quatro_final.png"; DestDir: "{app}"; Flags: ignoreversion
Source: "D:\GenTab\Sources\Application\GenTab\ressource.qrc"; DestDir: "{app}"; Flags: ignoreversion
Source: "D:\GenTab\Sources\Application\GenTab\tres.png"; DestDir: "{app}"; Flags: ignoreversion
Source: "D:\GenTab\Sources\Application\GenTab\tres_final.png"; DestDir: "{app}"; Flags: ignoreversion
Source: "D:\GenTab\Sources\Application\GenTab\uno.png"; DestDir: "{app}"; Flags: ignoreversion
Source: "D:\GenTab\Sources\Application\GenTab\uno_3.png"; DestDir: "{app}"; Flags: ignoreversion
Source: "D:\GenTab\Sources\Application\GenTab\uno_final.png"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Program Files\GenTab\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "D:\GenTab\Sources\Application\build-GenTab-Desktop_Qt_5_5_1_MinGW_32bit-Release\release\libgcc_s_dw2-1.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "D:\GenTab\Sources\Application\build-GenTab-Desktop_Qt_5_5_1_MinGW_32bit-Release\release\libstdc++-6.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "D:\GenTab\Sources\Application\build-GenTab-Desktop_Qt_5_5_1_MinGW_32bit-Release\release\libwinpthread-1.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "D:\GenTab\Sources\Application\build-GenTab-Desktop_Qt_5_5_1_MinGW_32bit-Release\release\main.o"; DestDir: "{app}"; Flags: ignoreversion
Source: "D:\GenTab\Sources\Application\build-GenTab-Desktop_Qt_5_5_1_MinGW_32bit-Release\release\MainWindow.o"; DestDir: "{app}"; Flags: ignoreversion
Source: "D:\GenTab\Sources\Application\build-GenTab-Desktop_Qt_5_5_1_MinGW_32bit-Release\release\moc_MainWindow.cpp"; DestDir: "{app}"; Flags: ignoreversion
Source: "D:\GenTab\Sources\Application\build-GenTab-Desktop_Qt_5_5_1_MinGW_32bit-Release\release\moc_MainWindow.o"; DestDir: "{app}"; Flags: ignoreversion
Source: "D:\GenTab\Sources\Application\build-GenTab-Desktop_Qt_5_5_1_MinGW_32bit-Release\release\Parameters.o"; DestDir: "{app}"; Flags: ignoreversion
Source: "D:\GenTab\Sources\Application\build-GenTab-Desktop_Qt_5_5_1_MinGW_32bit-Release\release\qrc_ressource.cpp"; DestDir: "{app}"; Flags: ignoreversion
Source: "D:\GenTab\Sources\Application\build-GenTab-Desktop_Qt_5_5_1_MinGW_32bit-Release\release\qrc_ressource.o"; DestDir: "{app}"; Flags: ignoreversion
Source: "D:\GenTab\Sources\Application\build-GenTab-Desktop_Qt_5_5_1_MinGW_32bit-Release\release\Qt5Core.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "D:\GenTab\Sources\Application\build-GenTab-Desktop_Qt_5_5_1_MinGW_32bit-Release\release\Qt5Gui.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "D:\GenTab\Sources\Application\build-GenTab-Desktop_Qt_5_5_1_MinGW_32bit-Release\release\Qt5Widgets.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "D:\GenTab\Sources\Application\build-GenTab-Desktop_Qt_5_5_1_MinGW_32bit-Release\release\platforms\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Icons]
Name: "{commonprograms}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{commondesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent

