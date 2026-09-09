[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$ConnectionName
)

$ErrorActionPreference = "Stop"
$identity = [Security.Principal.WindowsIdentity]::GetCurrent()
$principalCheck = New-Object Security.Principal.WindowsPrincipal($identity)
if (-not $principalCheck.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    throw "Run this installer as administrator."
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
