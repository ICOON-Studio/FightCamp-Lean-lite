# S310 (operator: "they dont do anything when i click them"): the ops board runs as an S4U task in session 0, so a game it
# starts directly opens on no screen. Each board Play button runs one of these Interactive tasks (schtasks /run, a target in
# AgentComms/launch_targets.json); an Interactive task starts in the logged-on user's own desktop session. Safe to re-run.
$builds = "E:\FightCamp\Lean\Builds"
$exe = Join-Path $builds "FightCamp.exe"
$user = "$env:USERDOMAIN\$env:USERNAME"
$principal = New-ScheduledTaskPrincipal -UserId $user -LogonType Interactive -RunLevel Limited
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -ExecutionTimeLimit (New-TimeSpan -Hours 0) -MultipleInstances IgnoreNew
foreach ($t in @(@("FightCamp Play latest", ""), @("FightCamp Play test film", "-- jump=fight"), @("FightCamp Play test nofilm", "-- jump=fight_nofilm"), @("FightCamp Play test corner", "-- jump=corner"), @("FightCamp Play test injury", "-- jump=injury"), @("FightCamp Play test nationals", "-- jump=nationals"), @("FightCamp Play test pro", "-- jump=pro"), @("FightCamp Play test taperoom", "-- jump=taperoom"), @("FightCamp Play test camp", "-- jump=camp"), @("FightCamp Play test belt", "-- jump=belt"), @("FightCamp Play test men", "-- jump=men"), @("FightCamp Play test men fight", "-- jump=men_fight"), @("FightCamp Play test gameplan", "-- jump=gameplan"), @("FightCamp Play test round3", "-- jump=round3"))) {
    if ($t[1] -eq "") { $action = New-ScheduledTaskAction -Execute $exe -WorkingDirectory $builds }
    else { $action = New-ScheduledTaskAction -Execute $exe -Argument $t[1] -WorkingDirectory $builds }
    Register-ScheduledTask -TaskName $t[0] -Action $action -Principal $principal -Settings $settings -Description "Ops board Play button (S310)" -Force | Out-Null
}
Get-ScheduledTask -TaskName "FightCamp Play*" | ForEach-Object { "{0} | {1} | {2} {3}" -f $_.TaskName, $_.Principal.LogonType, $_.Actions[0].Execute, $_.Actions[0].Arguments }
