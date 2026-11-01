# S310: the ops board's Play buttons (E:\FightCamp\Game\AgentComms\launch_targets.json) start the build through Explorer,
# which drops command-line arguments - a shortcut keeps them. One .lnk per test jump (scripts/ui/TestJump.gd), beside the
# exe in Builds/. Run by tools/export.sh; safe to run again.
$builds = Join-Path (Split-Path -Parent $PSScriptRoot) "Builds"
$exe = Join-Path $builds "FightCamp.exe"
$shell = New-Object -ComObject WScript.Shell
foreach ($j in @(@("Test fight with film", "jump=fight"), @("Test fight without film", "jump=fight_nofilm"), @("Test corner minute", "jump=corner"), @("Test injury", "jump=injury"), @("Test nationals", "jump=nationals"), @("Test ground moves", "jump=grapple"), @("Test tape room", "jump=taperoom"))) {
    $lnk = $shell.CreateShortcut((Join-Path $builds ($j[0] + ".lnk")))
    $lnk.TargetPath = $exe
    $lnk.Arguments = "-- " + $j[1]
    $lnk.WorkingDirectory = $builds
    $lnk.Save()
}
