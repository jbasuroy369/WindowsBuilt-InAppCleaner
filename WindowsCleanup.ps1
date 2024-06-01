<#
.SYNOPSIS
  <ScriptName: WindowsCleanup>
.DESCRIPTION
  <The script removes built-in windows app during device provisioning>
.OUTPUTS
  <Log file stored in C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\win32-WindowsCleanup.log>
.NOTES
  Version:        1.2
  Author:         Joymalya Basu Roy, Wojciech Maciejewski
  Creation Date:  22-03-2021
  Updated to 1.1: 22.06.2021 - correcting typo from "Microsft.windowscommunicationsapps" -> "Microsoft.windowscommunicationsapps" 
  Updated to 1.2: 19.12.2021 - adding Teams chat icon for Windows 11
#>


# If running as a 32-bit process on an x64 system, re-launch as a 64-bit process

if ("$env:PROCESSOR_ARCHITEW6432" -ne "ARM64")
{
    if (Test-Path "$($env:WINDIR)\SysNative\WindowsPowerShell\v1.0\powershell.exe")
    {
        & "$($env:WINDIR)\SysNative\WindowsPowerShell\v1.0\powershell.exe" -ExecutionPolicy bypass -NoProfile -File "$PSCommandPath"
        Exit $lastexitcode
    }
}
    
# Logging Preparation

$AppName = "WindowsCleanup"
$Log_FileName = "win32-$AppName.log"
$Log_Path = "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\"
$TestPath = "$Log_Path\$Log_Filename"
$BreakingLine="- - "*10
$SubBreakingLine=". . "*10
$SectionLine="* * "*10

If(!(Test-Path $TestPath))
{
New-Item -Path $Log_Path -Name $Log_FileName -ItemType "File" -Force
}

function Write-Log {
    [CmdletBinding()]
    param(
        [Parameter()]
        [string]$Message
    )
$timestamp = Get-Date -Format "dddd MM/dd/yyyy HH:mm:ss"
Add-Content -Path $TestPath -Value "$timestamp : $Message"
}

# Start logging [Same file will be used for IME detection]

Write-Log "Begin processing app removal..."
Write-Log $SectionLine

# STEP: Remove built-in Windows packages

Write-Log "Start - Remove built-in Windows packages"
Write-Log $SubBreakingLine


$builtinappstoremove = @(
"Microsoft.windowscommunicationsapps"
"Microsoft.Windows.Photos"
"Microsoft.SkypeApp"
"Microsoft.XboxSpeechToTextOverlay"
"Microsoft.XboxGamingOverlay"
"Microsoft.XboxGameOverlay"
"Microsoft.WindowsFeedbackHub"
"Microsoft.Wallet"
"Microsoft.StorePurchaseApp"
"Microsoft.MicrosoftEdge"
"Microsoft.MicrosoftEdge.Stable"
"Microsoft.People"
"Microsoft.MicrosoftStickyNotes"
"Microsoft.MicrosoftSolitaireCollection"
"Microsoft.MicrosoftOfficeHub"
"Microsoft.Microsoft3DViewer"
"Microsoft.Getstarted"
"Microsoft.GetHelp"
"Microsoft.BingWeather"
"Microsoft.ZuneVideo"
"Microsoft.XboxApp"
"Microsoft.Office.OneNote"
"Microsoft.WindowsAlarms"
"Microsoft.WindowsSoundRecorder"
"Microsoft.ZuneMusic"
"Microsoft.YourPhone"
"Microsoft.WindowsMaps"
"Microsoft.MicrosoftEdgeDevToolsClient"
"Microsoft.EdgeDevtoolsPlugin"
"Microsoft.Print3D"
"MicrosoftTeams"
"Microsoft.Xbox.TCUI"
"Microsoft.XboxGameOverlay"
"Microsoft.XboxIdentityProvider"
"Microsoft.XboxSpeechToTextOverlay"
)

foreach ($app in $builtinappstoremove) {
    Write-Log "Attempting to remove $app"
    Get-AppxPackage -Name $app -AllUsers | Remove-AppxPackage -AllUsers
    Get-AppXProvisionedPackage -Online | Where {$_.DisplayName -eq "$app"} | Remove-AppxProvisionedPackage -Online
    Write-Log "Removed $app"
    Write-Log $SubBreakingLine
}

Write-Log "END - All specified built-in apps were removed succesfully"
Write-Log $BreakingLine
