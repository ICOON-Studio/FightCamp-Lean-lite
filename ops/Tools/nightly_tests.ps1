# S402 (operator: "full test should go once a day around 5 am and then you review and act on it"): the one full test run of the day.
# Started by the scheduled task "FightCamp Nightly Tests" at 05:00. Writes ops/AgentComms/nightly/latest.txt; a Claude scheduled task reviews it.
# Waits up to an hour for a PC that is not RED. -DryRun checks the wiring and runs no tests.
param([switch]$DryRun)
$root = 'E:\FightCamp\Lean'
$dir = Join-Path $root 'ops\AgentComms\nightly'
New-Item -ItemType Directory -Force $dir | Out-Null
$latest = Join-Path $dir 'latest.txt'
$date = Get-Date -Format 'yyyy-MM-dd'
$log = Join-Path $dir "suite_$date.log"
Set-Location $root
$head = (& git -C $root log -1 --format='%h %s') -join ' '
for ($i = 0; $i -lt 12; $i++) {
    & powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $root 'ops\Tools\pc_watchdog.ps1') -Once | Out-Null
    if ($LASTEXITCODE -ne 1) { break }
    if ($DryRun) { break }
    Start-Sleep -Seconds 300
}
if ($LASTEXITCODE -eq 1 -and -not $DryRun) {
    "FULL TESTS $date SKIPPED: PC RED for an hour. Commit: $head" | Out-File -Encoding utf8 $latest
    exit 0
}
if ($DryRun) { "FULL TESTS $date DRY RUN OK. Commit: $head" | Out-File -Encoding utf8 $latest; exit 0 }
$env:JOBS = '4'
$start = Get-Date
& 'C:\Program Files\Git\usr\bin\sh.exe' tools/run_tests.sh *> $log
$lines = Get-Content $log
$pass = @($lines | Where-Object { $_ -like 'PASS *' }).Count
$fail = @($lines | Where-Object { $_ -like 'FAIL *' })
$mins = [int]((Get-Date) - $start).TotalMinutes
@("FULL TESTS $date pass=$pass fail=$($fail.Count) minutes=$mins commit: $head", "log: $log") + $fail | Out-File -Encoding utf8 $latest
