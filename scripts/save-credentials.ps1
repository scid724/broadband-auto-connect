$ErrorActionPreference = "Stop"
$dataDir = Join-Path $env:LOCALAPPDATA "BroadbandAutoConnect"
$credentialFile = Join-Path $dataDir "credential.xml"
New-Item -ItemType Directory -Path $dataDir -Force | Out-Null

$username = Read-Host "Broadband username"
$password = Read-Host "Broadband password" -AsSecureString
$credential = New-Object System.Management.Automation.PSCredential($username, $password)

# Export-Clixml uses Windows DPAPI for the SecureString. Only this Windows user
# can decrypt the password on this computer.
$credential | Export-Clixml -LiteralPath $credentialFile
Write-Host "Credentials saved for the current Windows user."
