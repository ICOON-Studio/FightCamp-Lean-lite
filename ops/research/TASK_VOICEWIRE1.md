# TASK VOICEWIRE1 - QWEN (qwen3-coder), the sound engineer - the cast's voices made this month and wired into fight night

Status: OPEN (S437, Claude main). Discipline: boxing. Model: qwen3-coder.
Source: the operator picked the cast by ear (docs/audio/VOICE_CAST_S434.md: "keep 1, 3", "keep 2b, 4c, 6b ,5b"). S437:
his Ludo subscription runs one more month and is then PAUSED for three ("sub is paid normally for a month, after that
it is paused"), so every voice line the game needs is generated NOW, with the same voice and delivery note as the cast
table. Budget: at most 140 Ludo credits in this task (a line is 1 credit, `ludo audio speech-preset`; 1,083 on the
account). Print the credits spent.

## Contract
OWNS: scripts/audio/VoiceLines.gd, scripts/audio/FightVoice.gd, tests/voice_lines_test.gd, assets/audio/voice, assets/audio/sounds.json, tools/voice_make.py, docs/audio/VOICEWIRE1_RESULT.md, scripts/fight3d/FightIntro.gd, scripts/fight3d/CornerMinute.gd
RED_TEST: tests/voice_lines_test.gd -> VOICE_LINES failures=0
REGRESSION: sound_bank_test, sound_sync_test, intro_style_test, file_limits_test, no_pronoun_test
VISUAL: no
NOT YOURS: scripts/audio/Sfx.gd and SoundBank.gd (read them; use them as they are), the cast (do not change a voice or
its delivery note), any text the screen shows.

## What exists (read these first)
- docs/audio/VOICE_CAST_S434.md: role -> Ludo voice -> delivery note, and the six kept sample files under
  assets/audio/raw/tts_s434.
- scripts/audio/Sfx.gd: `Sfx.play(id, opts)` (false when the id has no kept file), buses include "Voice" (-6 dB),
  `played` counts plays (tests read it). scripts/audio/SoundBank.gd reads assets/audio/sounds.json: `events` (what the
  game plays) and `files` (each asset: prompt, source, credits, loudness numbers, heard, verdict).
- THE EAR RULE: a sound is "unheard" until the operator keeps it on the sound board. A new file enters sounds.json with
  "heard": false and no verdict, exactly like the S385 files did; SoundBank already refuses to play an unkept file. Do
  not mark anything heard or kept yourself.
- Where the words are shown today: scripts/fight3d/FightIntro.gd `cue_name_red` / `cue_name_blue` (ui.say of
  ctx["intros"]), `cue_seconds_out`; scripts/fight3d/CornerMinute.gd LINES (line 35: the between-rounds advice per
  call id) and its `ui.say` of `_lines`; scripts/rules/Exchanges.gd CALLS (the corner calls during a round).

## The job
1. scripts/audio/VoiceLines.gd (pure, no preloads): the table of every spoken line: id, role (announcer / shout_m /
   shout_f / between / guide), text (at most 250 characters), and the event id it plays as ("voice_<id>").
   Lines, all WITHOUT a fighter's name (names are generated; a voice cannot say them):
   - announcer (Roger): the opening ("Ladies and gentlemen..."), "In the red corner!", "In the blue corner!",
     "Seconds out!", and six results: winner by decision / by stoppage / by knockout, each for the red and the blue
     corner, plus "A draw!". 3 takes of each of the two corner calls, 1 of the rest.
   - between rounds (Brian): one line for EVERY key of CornerMinute.LINES, the same words the screen shows.
   - corner shouts during a round: one short shout (under 8 words) for EVERY key of Exchanges.CALLS, once in the male
     voice (Callum) and once in the female voice (Sarah).
   - guide (Bill): the first-week tips the guide already shows (grep "guide" under scripts/ui and assets/data; take
     at most 12, the ones a new player meets first).
   `VoiceLines.for_call(call_id, coach_female) -> String` (event id or ""), `between(call_id)`, `announce(what, corner)`.
2. tests/voice_lines_test.gd FIRST, red: every CornerMinute.LINES key and every Exchanges.CALLS key has its line(s);
   no text over 250 characters; no line holds a digit or a name from scripts/rules data name lists; every event id in
   VoiceLines exists in sounds.json `events` on bus "Voice" after step 3; ids unique. Print `VOICE_LINES failures=<n>`.
3. tools/voice_make.py: for each VoiceLines row without a file, run
   `ludo audio speech-preset --text <text> --voice-preset-id <voice> --delivery-note "<note from the cast table>"
   --out <tmp>` (check `ludo audio speech-preset --help` for the exact flag names), convert to mono 48 kHz ogg with
   `ludo toolbox audio convert`, read its numbers with `ludo toolbox audio info`, store it under
   assets/audio/voice/<role>/<id>_<take>.ogg and add the `files` row (prompt = the text, source, credits, made, the
   loudness numbers, "heard": false) and the `events` row (bus "Voice", kind "voice", priority 3, no pitch spread).
   The script is re-runnable: a line that has its file is skipped; it stops before passing the 140 credit budget and
   prints what is left unmade. `ludo account show` before and after; both numbers go in the result file.
4. scripts/audio/FightVoice.gd (small): `intro(cue, corner)`, `between(call_id)`, `shout(call_id, coach_female)`; each
   is one `Sfx.play` of the VoiceLines event, nothing else. Wire: FightIntro's three cues and the result announcement
   where the fight ends (find where the result is first shown; one call), CornerMinute where `ui.say` shows a LINES
   line, and the place a corner call is made in a round (grep where Exchanges.CALLS ids reach the fight view). The
   words on screen stay as they are; the voice is on top.
5. Post every new file to the sound board for his ear (ops/Tools: grep "sound board" / review_add for audio; the
   S385 files were posted the same way) in ONE batch per role. docs/audio/VOICEWIRE1_RESULT.md: lines made per role,
   credits before / after, what is not made and why, the test's last line.

## Traps
- ops/research/GDSCRIPT_TRAPS.md first. Tests run with `--audio-driver Dummy`: assert on `Sfx.played` and on
  sounds.json, never on hearing.
- Headless tests are the OFF control arm, but nothing here needs a switch: an unkept file simply does not play.
- A failed or refused Ludo job is refunded; do not retry one line more than twice. Never `--no-wait` 50 jobs at once
  (the account runs 2 at a time).
- Never copy a voice file to anywhere outside assets/audio/voice. Nothing opens on a monitor; no audio is played aloud.

## Prior research
docs/audio/VOICE_CAST_S434.md, assets/audio/SOUND_QA_S395.md, the `ludo` skill (~/.claude/skills/ludo), memory note
"Qwen = SOUND ENGINEER + the ear rule (S385)".

## What would a human do?
A boxing broadcast has one ring announcer for both corners and the result, and a corner you can hear: short shouts in
the round, calm words on the stool. The sound engineer records the whole script in one studio day with the same voices.

## Prefab check
The voices are Ludo's catalog voices (his Pro plan covers game use); no other library applies.

Every Godot job through the queue: `python ops/Tools/godot_slot.py run --who qwen -- <godot.exe> --headless
--audio-driver Dummy --path . --script res://tests/voice_lines_test.gd` (the plain win64 exe). Parse first:
`--check-only` on each touched script. Under 500 lines a script.
RESULT lines for the PR body: `RESULT: tests/voice_lines_test.gd -> VOICE_LINES failures=0`.
