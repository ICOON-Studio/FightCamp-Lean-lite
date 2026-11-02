@echo off
REM cline_set_key.cmd - the OPERATOR double-clicks this with his OpenRouter key on the clipboard.
REM S148: Claude's npm install of Cline lives in Claude's shell sandbox (memory project_shell_sandbox_split), so the
REM operator's window cannot run `cline auth`. Instead the key goes into ONE file in his user folder; Tools\cline_task.cmd
REM reads it at launch and hands it to Cline (-k). Claude never reads, prints or types the key.
echo Saving the OpenRouter key from your clipboard...
powershell -NoProfile -Command "$k = (Get-Clipboard | Out-String).Trim(); if (-not $k.StartsWith('sk-or-')) { Write-Host 'NOT SAVED: the clipboard does not hold an OpenRouter key (it starts with sk-or-). Copy the key and run this again.'; exit 1 }; $d = Join-Path $env:USERPROFILE '.fightcamp'; New-Item -ItemType Directory -Force -Path $d | Out-Null; $f = Join-Path $d 'openrouter_key.txt'; Set-Content -Path $f -Value $k -NoNewline -Encoding ascii; if ((Get-Content $f -Raw) -eq $k) { Set-Clipboard -Value ' '; Write-Host 'DONE - key saved, clipboard cleared. Tell Claude: done' } else { Write-Host 'NOT SAVED: could not write the key file.' }"
pause
