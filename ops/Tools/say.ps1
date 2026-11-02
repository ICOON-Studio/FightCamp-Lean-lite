param(
    [Parameter(Mandatory = $true)][string]$Text,
    [string]$Voice = "",
    [double]$Rate = -1
)
# Speaks one narration line on the operator's speakers. Local only - nothing leaves the PC.
# Uses the Windows OneCore engine (Windows.Media.SpeechSynthesis), which reaches the newer
# voices (Mark) that the old System.Speech engine cannot. Must run in the foreground
# shell - a hidden Start-Process child was inaudible (S81).
# The operator's pick (voice + speaking rate 0.5-3.0) is remembered in say_prefs.txt.
$prefs = Join-Path $env:LOCALAPPDATA "FightCamp_say_prefs.txt"
$saved = @{ voice = "Mark"; rate = "1.1" }
if (Test-Path $prefs) {
    Get-Content $prefs | ForEach-Object { $k, $v = $_ -split "=", 2; if ($v) { $saved[$k] = $v } }
}
if ($Voice -ne "") { $saved.voice = $Voice }
if ($Rate -gt 0) { $saved.rate = "$Rate" }
"voice=$($saved.voice)", "rate=$($saved.rate)" | Set-Content -Encoding utf8 $prefs

Add-Type -AssemblyName System.Runtime.WindowsRuntime
$null = [Windows.Media.SpeechSynthesis.SpeechSynthesizer, Windows.Media.SpeechSynthesis, ContentType = WindowsRuntime]
$null = [Windows.Storage.Streams.DataReader, Windows.Storage.Streams, ContentType = WindowsRuntime]
$asTask = ([System.WindowsRuntimeSystemExtensions].GetMethods() | Where-Object {
    $_.Name -eq 'AsTask' -and $_.GetParameters().Count -eq 1 -and $_.GetParameters()[0].ParameterType.Name -eq 'IAsyncOperation`1' })[0]
function Await($op, [Type]$type) {
    $task = $asTask.MakeGenericMethod($type).Invoke($null, @($op))
    $task.Wait() | Out-Null
    $task.Result
}
$synth = New-Object Windows.Media.SpeechSynthesis.SpeechSynthesizer
$pick = [Windows.Media.SpeechSynthesis.SpeechSynthesizer]::AllVoices | Where-Object { $_.DisplayName -match $saved.voice } | Select-Object -First 1
if ($pick) { $synth.Voice = $pick }
$synth.Options.SpeakingRate = [double]$saved.rate
$stream = Await ($synth.SynthesizeTextToStreamAsync($Text)) ([Windows.Media.SpeechSynthesis.SpeechSynthesisStream])
$reader = New-Object Windows.Storage.Streams.DataReader($stream.GetInputStreamAt(0))
$size = [uint32]$stream.Size
$null = Await ($reader.LoadAsync($size)) ([uint32])
$bytes = New-Object byte[] $size
$reader.ReadBytes($bytes)
$wav = Join-Path $env:TEMP "claude_say.wav"
[System.IO.File]::WriteAllBytes($wav, $bytes)
(New-Object System.Media.SoundPlayer $wav).PlaySync()
