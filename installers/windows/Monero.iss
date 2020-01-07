; Monero Carbon Chamaeleon GUI Wallet Installer for Windows
; Copyright (c) 2017-2019, The Monero Project
; See LICENSE
#define GuiVersion GetFileVersion("..\..\build\release\bin\monerov-wallet-gui.exe")

[Setup]
AppName=Monerov GUI Wallet
; For InnoSetup this is the property that uniquely identifies the application as such
; Thus it's important to keep this stable over releases
; With a different "AppName" InnoSetup would treat a mere update as a completely new application and thus mess up

AppVersion={#GuiVersion}
VersionInfoVersion={#GuiVersion}
DefaultDirName={pf}\Monerov GUI Wallet
DefaultGroupName=Monerov GUI Wallet
UninstallDisplayIcon={app}\monerov-wallet-gui.exe
PrivilegesRequired=admin
ArchitecturesInstallIn64BitMode=x64
ArchitecturesAllowed=x64
WizardSmallImageFile=WizardSmallImage.bmp
WizardImageFile=FinishImage.bmp
DisableWelcomePage=no
LicenseFile=LICENSE
AppPublisher=The Monerov Developer Community
AppPublisherURL=https://monerov.online
TimeStampsInUTC=yes
CompressionThreads=1

UsedUserAreasWarning=no
; The above directive silences the following compiler warning:
;    Warning: The [Setup] section directive "PrivilegesRequired" is set to "admin" but per-user areas (HKCU,userdocs)
;    are used by the script. Regardless of the version of Windows, if the installation is administrative then you should
;    be careful about making any per-user area changes: such changes may not achieve what you are intending.
; Background info:
; This installer indeed asks for admin rights so the Monero files can be copied to a place where they have at least
; a minimum of protection against changes, e.g. by malware, plus it handles things for the currently logged-in user
; in the registry (GUI wallet per-user options) and for some of the icons. For reasons too complicated to fully explain
; here this does not work as intended if the installing user does not have admin rights and has to provide the password
; of a user that does for installing: The settings of the admin user instead of those of the installing user are changed.
; Short of ripping out that per-user functionality the issue has no suitable solution. Fortunately, this will probably
; play a role in only in few cases as the first standard user in a Windows installation does have admin rights.
; So, for the time being, this installer simply disregards this problem.

[Messages]
SetupWindowTitle=%1 {#GuiVersion} Installer

[Languages]
Name: "en"; MessagesFile: "compiler:Default.isl"
; Without localized versions of special forms, messages etc. of the installer, and without translated ReadMe's
; it probably does not make much sense to offer other install-time languages beside English
; Name: "fr"; MessagesFile: "compiler:Languages\French.isl"
; Name: "it"; MessagesFile: "compiler:Languages\Italian.isl"
; Name: "jp"; MessagesFile: "compiler:Languages\Japanese.isl"
; Name: "nl"; MessagesFile: "compiler:Languages\Dutch.isl"
; Name: "pt"; MessagesFile: "compiler:Languages\Portuguese.isl"


[Files]
; The use of the flag "ignoreversion" for the following entries leads to the following behaviour:
; When updating / upgrading an existing installation ALL existing files are replaced with the files in this
; installer, regardless of file dates, version info within the files, or type of file (textual file or
; .exe/.dll file possibly with version info).
;
; This is far more robust than relying on version info or on file dates (flag "comparetimestamp").
; As of version 0.15.0.0, the Monero .exe files do not carry version info anyway in their .exe headers.
; The only small drawback seems to be somewhat longer update times because each and every file is
; copied again, even if already present with correct file date and identical content.
;
; Note that it would be very dangerous to use "ignoreversion" on files that may be shared with other
; applications somehow. Luckily this is no issue here because ALL files are "private" to Monero.

;Source: {#file AddBackslash(SourcePath) + "ReadMe.htm"}; DestDir: "{app}"; DestName: "ReadMe.htm"; Flags: ignoreversion
Source: "FinishImage.bmp"; Flags: dontcopy

Source: "..\..\build\release\bin\*"; DestDir: "{app}"; Flags: ignoreversion createallsubdirs recursesubdirs

[Tasks]
Name: desktopicon; Description: "Create a &desktop icon"; GroupDescription: "Additional icons:";


[Run]
Filename: "{app}\monerov-wallet-gui.exe"; Description: "Run GUI Wallet now"; Flags: postinstall nowait skipifsilent


[Code]
function InitializeUninstall(): Boolean;
var s: String;
begin
  s := 'Please note: Uninstall will not delete any downloaded blockchain. ';
  s := s + 'If you do not need it anymore you have to delete it manually.';
  s := s + #13#10#13#10 + 'Uninstall will not delete any wallets that you created either.';
  MsgBox(s, mbInformation, MB_OK);
  Result := true;
end;


[Icons]
; Icons in the "Monero GUI Wallet" program group
; Windows will almost always display icons in alphabetical order, per level, so specify the text accordingly
Name: "{group}\GUI Wallet"; Filename: "{app}\monerov-wallet-gui.exe";
Name: "{group}\Uninstall GUI Wallet"; Filename: "{uninstallexe}"

; Desktop icons, optional with the help of the "Task" section
Name: "{commondesktop}\GUI Wallet"; Filename: "{app}\monerov-wallet-gui.exe"; Tasks: desktopicon


[Registry]
; Store any special flags for the daemon in the registry location where the GUI wallet will take it from
; So if the wallet is used to start the daemon instead of the separate icon the wallet will pass the correct flags
; Side effect, mostly positive: The uninstaller will clean the registry
Root: HKCU; Subkey: "Software\monerov-project"; Flags: uninsdeletekeyifempty
Root: HKCU; Subkey: "Software\monerov-project\monerov-core"; Flags: uninsdeletekey

