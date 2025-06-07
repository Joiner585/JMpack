[Setup]
OutputBaseFilename=launchJMPack
SetupIconFile=JMPack.ico
VersionInfoCompany=Joiner
VersionInfoCopyright=Joiner
VersionInfoDescription=launchJMPack
VersionInfoProductName=launchJMPack
VersionInfoProductTextVersion=1.0
VersionInfoProductVersion=1.0
VersionInfoTextVersion=
VersionInfoVersion=1.0
CreateAppDir=no
Compression=lzma2/ultra
SolidCompression=yes
DisableStartupPrompt=yes
DisableWelcomePage=yes
DisableProgramGroupPage=yes
DisableDirPage=yes
DisableReadyMemo=yes
DisableReadyPage=yes
DisableFinishedPage=yes
Uninstallable=no
AppName=''
AppVersion=''
[Code]
var
ResultCode: Integer;
function InitializeSetup: Boolean;
Begin
Exec(ExpandConstant('{src}\jmpack 3.5.1\AutoIt3.exe" JMPACK.a3x"'), '', '', SW_SHOW, ewNoWait, ResultCode)
exit;
end;

[Languages]
Name: "default"; MessagesFile: "compiler:Default.isl"


