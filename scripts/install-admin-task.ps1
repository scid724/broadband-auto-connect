[CmdletBinding()]
param(
    [Parameter(Position = 0)]
    [string]$ConnectionName = (-join [char[]](0x5bbd, 0x5e26, 0x8fde, 0x63a5))
)

$ErrorActionPreference = "Stop"
$identity = [Security.Principal.WindowsIdentity]::GetCurrent()
$principalCheck = New-Object Security.Principal.WindowsPrincipal($identity)

if (-not $principalCheck.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    $psExe = Join-Path $env:SystemRoot "System32\WindowsPowerShell\v1.0\powershell.exe"
    $argList = @(
        "-NoProfile",
        "-ExecutionPolicy", "Bypass",
        "-File", $PSCommandPath,
        "-ConnectionName", $ConnectionName
    )
    Start-Process -FilePath $psExe -ArgumentList $argList -Verb RunAs -Wait
    exit 0
}

$credentialFile = Join-Path $env:LOCALAPPDATA "BroadbandAutoConnect\credential.xml"
if (-not (Test-Path -LiteralPath $credentialFile)) {
    throw "Credentials not found. Run save-credentials.cmd first."
}

$scriptPath = Join-Path $PSScriptRoot "broadband-auto-connect.ps1"
$taskName = "Broadband Auto Connect"
$psExe = Join-Path $env:SystemRoot "System32\WindowsPowerShell\v1.0\powershell.exe"
$arguments = '-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File "{0}" -ConnectionName "{1}"' -f $scriptPath, $ConnectionName
$currentUser = $identity.Name

$action = New-ScheduledTaskAction -Execute $psExe -Argument $arguments
$trigger = New-ScheduledTaskTrigger -AtLogOn -User $currentUser
$settings = New-ScheduledTaskSettingsSet `
    -StartWhenAvailable `
    -ExecutionTimeLimit (New-TimeSpan -Minutes 15) `
    -MultipleInstances IgnoreNew
$taskPrincipal = New-ScheduledTaskPrincipal `
    -UserId $currentUser `
    -LogonType Interactive `
    -RunLevel Highest

Register-ScheduledTask `
    -TaskName $taskName `
    -Action $action `
    -Trigger $trigger `
    -Settings $settings `
    -Principal $taskPrincipal `
    -Force | Out-Null

Write-Host "Scheduled task installed: $taskName"
Write-Host "Connection profile: $ConnectionName"