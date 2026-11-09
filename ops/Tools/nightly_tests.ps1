# S402 (operator: "full test should go once a day around 5 am and then you review and act on it"): the one full test run of the day.
# Started by the scheduled task "FightCamp Nightly Tests" at 05:00. Writes ops/AgentComms/nightly/latest.txt; a Claude scheduled task reviews it.
# Waits up to an hour for a PC that is not RED.
# -DryRun runs the whole script path with a stand-in for Godot (no test, no heat) and prints how many tests it reached; latest.txt is left alone.
param([switch]$DryRun)
$root = 'E:\FightCamp\Lean'
$dir = Join-Path $root 'ops\AgentComms\nightly'
New-Item -ItemType Directory -Force $dir | Out-Null
$latest = Join-Path $dir 'latest.txt'
$date = Get-Date -Format 'yyyy-MM-dd'
$log = Join-Path $dir "suite_$date.log"
Set-Location $root
$head = (& git -C $root log -1 --format='%h %s') -join ' '
# S408: a scheduled task's PATH has Git\cmd only, so run_tests.sh died on dirname / mktemp / xargs and "pass=0 fail=0" was every morning's result.
$gitBin = 'C:\Program Files\Git\usr\bin'
$env:PATH = "$gitBin;$env:PATH"
$env:JOBS = '4'
if ($DryRun) {
    $env:GODOT_EXE = Join-Path $gitBin 'true.exe'
    $log = Join-Path $env:TEMP 'fightcamp_nightly_dry.log'
    & (Join-Path $gitBin 'sh.exe') tools/run_tests.sh *> $log
    $n = @(Get-Content $log | Where-Object { $_ -like 'PASS *' }).Count
    "DRY RUN reached $n tests (log: $log)"
    if ($n -eq 0) { exit 1 }
    exit 0
}
for ($i = 0; $i -lt 12; $i++) {
    & powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $root 'ops\Tools\pc_watchdog.ps1') -Once | Out-Null
    if ($LASTEXITCODE -ne 1) { break }
    Start-Sleep -Seconds 300
}
if ($LASTEXITCODE -eq 1) {
    "FULL TESTS $date SKIPPED: PC RED for an hour. Commit: $head" | Out-File -Encoding utf8 $latest
    exit 0
}
$start = Get-Date
& (Join-Path $gitBin 'sh.exe') tools/run_tests.sh *> $log
$lines = Get-Content $log
$pass = @($lines | Where-Object { $_ -like 'PASS *' }).Count
$fail = @($lines | Where-Object { $_ -like 'FAIL *' })
$mins = [int]((Get-Date) - $start).TotalMinutes
if ($pass + $fail.Count -eq 0) {
    @("FULL TESTS $date BROKEN: no test ran (pass=0 fail=0, $mins minutes), read the log. Commit: $head", "log: $log") + @($lines | Select-Object -First 8) | Out-File -Encoding utf8 $latest
    exit 1
}
@("FULL TESTS $date pass=$pass fail=$($fail.Count) minutes=$mins commit: $head", "log: $log") + $fail | Out-File -Encoding utf8 $latest
