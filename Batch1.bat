REM Allow registry editing by disabling Group Policy setting
echo Allowing registry editing...
powershell -Command "Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System' -Name 'DisableRegistryTools' -Value 0"
echo Registry editing has been enabled.

REM Change power settings to prevent the computer from turning off, sleeping, hibernating, or shutting down its screen
echo Changing power settings to never turn off, sleep, hibernate, or shut down the screen...

REM Set the power scheme to high performance
powercfg -setactive SCHEME_MIN

REM Turn off monitor after: Never
powercfg -change monitor-timeout-ac 0
powercfg -change monitor-timeout-dc 0

REM Put the computer to sleep: Never
powercfg -change standby-timeout-ac 0
powercfg -change standby-timeout-dc 0

REM Hibernate after: Never
powercfg -change hibernate-timeout-ac 0
powercfg -change hibernate-timeout-dc 0

REM Disable hybrid sleep
powercfg -setacvalueindex SCHEME_CURRENT SUB_SLEEP STANDBYIDLE 0
powercfg -setdcvalueindex SCHEME_CURRENT SUB_SLEEP STANDBYIDLE 0

REM Turn off hard disk after: Never
powercfg -change disk-timeout-ac 0
powercfg -change disk-timeout-dc 0

echo Power settings have been updated successfully.

REM Move the Start Menu from the center to the left on Windows 11 and disable Task View, Widgets, and Chat
echo Moving Start Menu to the left and disabling Task View, Widgets, and Chat...

REM Define the registry path for Start Menu alignment
set "RegPath=HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"

REM Set the Start Menu alignment to the left (0 for left, 1 for center)
reg add "%RegPath%" /v "TaskbarAl" /t REG_DWORD /d 0 /f

REM Disable Task View button
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowTaskViewButton" /t REG_DWORD /d 0 /f

REM Disable Widgets
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarDa" /t REG_DWORD /d 0 /f

REM Disable Chat
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarMn" /t REG_DWORD /d 0 /f

REM Restart Explorer to apply changes
taskkill /f /im explorer.exe
start explorer.exe

echo Start Menu has been moved to the left.
echo Task View, Widgets, and Chat have been disabled.

REM Set the time zone to GMT+3 Istanbul and regional format to English (Europe)
echo Setting time zone to GMT+3 (Istanbul) and regional format to English (Europe)...

REM Set the time zone to GMT+3 Istanbul
tzutil /s "GTB Standard Time"

REM Define registry path for regional format settings
set "RegPath=HKCU\Control Panel\International"

REM Set regional format to English (Europe)
reg add "%RegPath%" /v "LocaleName" /t REG_SZ /d "en-150" /f

REM Set other related regional format settings
reg add "%RegPath%" /v "Locale" /t REG_SZ /d "00000809" /f
reg add "%RegPath%" /v "sLanguage" /t REG_SZ /d "ENU" /f
reg add "%RegPath%" /v "sCountry" /t REG_SZ /d "150" /f
reg add "%RegPath%" /v "sShortDate" /t REG_SZ /d "dd/MM/yyyy" /f
reg add "%RegPath%" /v "sLongDate" /t REG_SZ /d "dddd, d MMMM yyyy" /f
reg add "%RegPath%" /v "sTimeFormat" /t REG_SZ /d "HH:mm:ss" /f
reg add "%RegPath%" /v "iCalendarType" /t REG_DWORD /d "1" /f

echo Time zone has been set to GMT+3 (Istanbul).
echo Regional format has been set to English (Europe).

REM Enable "This PC" and "User's Files" icons on the desktop
echo Enabling "This PC" and "User's Files" icons on the desktop...

REM Define the registry path for desktop icons
set "RegPath=HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel"

REM Enable "This PC" icon
reg add "%RegPath%" /v "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" /t REG_DWORD /d 0 /f

REM Enable "User's Files" icon
reg add "%RegPath%" /v "{59031a47-3f72-44a7-89c5-5595fe6b30ee}" /t REG_DWORD /d 0 /f

REM Refresh the desktop to apply changes
ie4uinit.exe -show

echo "This PC" and "User's Files" icons have been enabled on the desktop.

REM Install and update Windows Package Manager (winget)
echo Installing and updating Windows Package Manager (winget)...
powershell -NoProfile -ExecutionPolicy Bypass -Command "&([ScriptBlock]::Create((irm https://github.com/asheroto/winget-install/releases/latest/download/winget-install.ps1))) -Force"

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "Write-Output 'Downloading the latest version of WinGet from GitHub...'; " ^
    "$url = 'https://github.com/microsoft/winget-cli/releases/download/v1.6.3482/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle'; " ^
    "$output = 'Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle'; " ^
    "Invoke-WebRequest -Uri $url -OutFile $output; " ^
    "Write-Output 'Installing the latest version of WinGet...'; " ^
    "Add-AppxPackage -Path $output; " ^
    "Write-Output 'WinGet has been successfully updated.'"


REM Install and/or update Required Applications
echo Installing and/or updating Required Applications...

winget settings --enable InstallerHashOverride

winget install --id=TeamViewer.TeamViewer --ignore-security-hash --accept-package-agreements --accept-source-agreements

winget install Adobe.Acrobat.Reader.64-bit --accept-package-agreements --accept-source-agreements

winget install --id=Google.Chrome --ignore-security-hash --accept-package-agreements --accept-source-agreements

winget install --id=RARLab.WinRAR --ignore-security-hash --accept-package-agreements --accept-source-agreements

winget install 9WZDNCRFJBH4 --ignore-security-hash --accept-package-agreements --accept-source-agreements

winget install 9NR5B8GVVM13 --ignore-security-hash --accept-package-agreements --accept-source-agreements

pause