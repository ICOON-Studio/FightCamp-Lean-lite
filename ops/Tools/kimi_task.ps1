# kimi_task.ps1 - the ONE permitted way Claude launches Kimi Code on a task (S122, 2026-09-29).
#
#   powershell -NoProfile -ExecutionPolicy Bypass -File Tools\kimi_task.ps1 <prompt-file> <workspace-dir> [out-file]
#
# Kimi Code CLI 2.1.1 lives on C:\Tools\kimi-code (S139: moved off the failing D:) (installed from code.kimi.ai, checksum-verified).
# It runs on the operator's PAY-PER-USE Moonshot Open Platform key (provider "moonshot-api", model
# kimi-k2.7-code, set as default_model in %USERPROFILE%\.kimi-code\config.toml). The Kimi Code SUBSCRIPTION
# is NOT active (403), so never switch the model to kimi-code/*.
#
# WHY -p AND NOT --auto: `-p` runs one prompt non-interactively and it DOES use its shell/edit tools on its
# own (verified S122: it ran git and python unasked). `--auto` cannot be combined with `-p`.
#
# The desktop app (Kimi Work) is NOT scriptable: it quits (code 1) when started with any remote-debugging
# flag - a deliberate, obfuscated check. Do not try to get around it.
#
# Runs at IDLE priority (operator 2026-09-25). READ THE OUT FILE, it is the evidence.
param(
    [Parameter(Mandatory = $true)][string]$PromptFile,
    [Parameter(Mandatory = $true)][string]$Workspace,
    [string]$OutFile = "$env:TEMP\kimi_task_last.txt"
)
$ErrorActionPreference = 'Stop'
$kimi = 'C:\Tools\kimi-code\bin\kimi.exe'
if (-not (Test-Path $kimi)) { Write-Error "kimi not found at $kimi"; exit 2 }
if (-not (Test-Path $PromptFile)) { Write-Error "prompt file not found: $PromptFile"; exit 2 }
if (-not (Test-Path $Workspace)) { Write-Error "workspace not found: $Workspace"; exit 2 }
$full = (Resolve-Path -LiteralPath $PromptFile).Path
# One short line on the command line (no quoting traps); the brief itself stays in the file.
$line = "Read the file $full with your file tool and do exactly what it says, start to finish, without asking questions."
$psi = New-Object System.Diagnostics.ProcessStartInfo
$psi.FileName = $kimi
$psi.Arguments = '-p "' + $line + '"'
$psi.WorkingDirectory = $Workspace
$psi.UseShellExecute = $false
$psi.RedirectStandardOutput = $true
$psi.RedirectStandardError = $true
$p = [System.Diagnostics.Process]::Start($psi)
try { $p.PriorityClass = [System.Diagnostics.ProcessPriorityClass]::Idle } catch {}
$stdout = $p.StandardOutput.ReadToEndAsync()
$stderr = $p.StandardError.ReadToEndAsync()
$p.WaitForExit()
("=== kimi_task " + (Get-Date -Format s) + " rc=" + $p.ExitCode + " ws=" + $Workspace + "`n" + $stdout.Result + "`n--- stderr ---`n" + $stderr.Result) | Out-File -FilePath $OutFile -Encoding utf8
exit $p.ExitCode
