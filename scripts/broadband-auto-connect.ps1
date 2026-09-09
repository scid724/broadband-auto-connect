[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$ConnectionName,
    [int]$RetryIntervalSeconds = 2,
    [int]$MaxRetryMinutes = 10
)

$ErrorActionPreference = "SilentlyContinue"
$dataDir = Join-Path $env:LOCALAPPDATA "BroadbandAutoConnect"
$logFile = Join-Path $dataDir "connect.log"
$credentialFile = Join-Path $dataDir "credential.xml"
New-Item -ItemType Directory -Path $dataDir -Force | Out-Null

function Write-Log([string]$Message) {
    Add-Content -LiteralPath $logFile -Value (
        "{0} {1}" -f (Get-Date -Format "yyyy-MM-dd HH:mm:ss.fff"), $Message
    ) -Encoding UTF8
}

function Test-Connected {
    $status = & "$env:SystemRoot\System32\rasdial.exe" 2>&1 | Out-String
    return ($status -match [regex]::Escape($ConnectionName))
}

if (-not (Test-Path -LiteralPath $credentialFile)) {
    Write-Log "Credential file not found"
    exit 2
}

$credential = Import-Clixml -LiteralPath $credentialFile
$networkCredential = New-Object System.Net.NetworkCredential(
    $credential.UserName,
    $credential.Password
)

if (Test-Connected) {
    exit 0
}

$deadline = (Get-Date).AddMinutes($MaxRetryMinutes)
while ((Get-Date) -lt $deadline) {
    Write-Log "Dialing"
    & "$env:SystemRoot\System32\rasdial.exe" `
        $ConnectionName `
        $networkCredential.UserName `
        $networkCredential.Password 2>&1 | Out-Null

    if (Test-Connected) {
        Write-Log "Connection succeeded"
        exit 0
    }

    Start-Sleep -Seconds $RetryIntervalSeconds
}

Write-Log "Retry limit reached"
exit 1
