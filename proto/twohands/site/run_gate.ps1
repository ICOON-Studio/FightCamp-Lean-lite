# Starts the Puncher's chance test-link gate (server.js) on this PC, port 8798 (S565, TASK_TESTLINK1).
# The owner's login for /owner/log is read from Tailscale itself, so no email address is written in the repo.
# The Tailscale address is added once, by hand:  tailscale serve --bg --https=8443 http://127.0.0.1:8798
# and taken away with:                            tailscale serve --https=8443 off
$ts = "C:\Program Files\Tailscale\tailscale.exe"
try {
    $st = & $ts status --json | ConvertFrom-Json
    $me = $st.User.PSObject.Properties[[string]$st.Self.UserID].Value.LoginName
    if ($me) { $env:OWNER_LOGIN = $me }
} catch { Write-Host "Tailscale did not answer: /owner/log stays shut." }
if (-not $env:PORT) { $env:PORT = "8798" }
node (Join-Path $PSScriptRoot "server.js")
