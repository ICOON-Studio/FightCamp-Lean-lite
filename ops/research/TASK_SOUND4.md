# TASK_SOUND4 - the sound engineer, round 4: the missing sounds, made in Ludo (Qwen)

Model: Qwen (qwen3-coder). Discipline: boxing. Repo: E:\FightCamp\Lean, on your own worktree and branch. Lean rules: its CLAUDE.md,
no script over 500 lines, Godot headless only (`--headless --audio-driver Dummy`), nothing opens on the operator's screens.

## Contract
OWNS: assets/audio/raw/, assets/audio/ui/, assets/audio/crowd/, assets/audio/fight/, assets/audio/gym/, assets/audio/voice/, assets/audio/sounds.json, assets/audio/SOUND_QA_S447.md
RED_TEST: tests/sound_bank_test.gd -> SOUND_BANK failures=0
REGRESSION: sound_bank_test, file_limits_test
VISUAL: no
NOT YOURS: every script. Nothing new is WIRED into the game in this task: every new sound stays "heard": false and unused until
the operator keeps it on the sound board (THE EAR RULE). Wiring is the next task, after his ear.

## Why (operator S447)
He is downloading the punch, crowd-cheer and camera-flash items from ProductionCrate himself (its free download limit stops the
rest). His words: "yes brief qwen to make the rest in ludo". These are the rest. Ludo is paid until about 2026-12-11, then paused
three months: make everything in this one task.

## Make, in Ludo (`ludo audio`, his Pro plan: sound-effect 2 credits, ambiance 2, speech-preset 1), 3 takes of each unless noted
1. Menu: a soft wooden click, a confirm click (a little brighter), a back/cancel click (lower). Short (< 0.15 s), dry.
2. Miss: a quiet air whoosh of a glove past a head (0.2-0.35 s). It plays only on a full power punch that misses (SOUND3 rule).
3. Block: a glove smacking into a glove guard (leather on leather, short, no body thud) - 4 takes.
4. Crowd, small club hall (150-400 people, NOT a stadium): a gasp after a big shot, an "oooh" after a near miss, scattered boos,
   polite applause between rounds, a short cheer for the home fighter. Ambiance tool for anything over 3 s.
5. Referee count: a man's voice, "one" to "ten" and "box!", each word its own file (speech preset; a calm, firm referee).
6. Camera shutters: a press-photographer burst (3-5 shots) and a single shot, for the ringside flashes.
7. Gym: a heavy-bag thud (body hook into a 45 kg bag), a speed-bag rattle loop (4 s), a skipping rope tapping loop (4 s).
Prompts in plain physical words (what hits what, the room, the length). No music, no "epic", no game-trailer words.

## Then
- Originals kept in assets/audio/raw/ (Ludo's ".mp3" files are WAV - keep the real extension).
- `python tools/audio_prep.py` -> 48 kHz Ogg, mono one-shots, levelled + limited, each entry in assets/audio/sounds.json with
  `"heard": false` and a `"source": "ludo S447 <prompt>"` line.
- `python tools/sound_board.py` -> the board page + the numbered reel; post it with
  `python ops/Tools/review_add.py --stage S447 --rating "unheard" --title "Sound round 4: the missing sounds (Ludo)" <files>`.
- assets/audio/SOUND_QA_S447.md: per sound its prompt, length, peak and loudness numbers (the prep tool's), which take you would
  play first and why IN NUMBERS. Never call a sound good, punchy or AAA: you cannot hear it, and neither can Claude.

## Prior research
Memory rule S385 (THE EAR RULE, the pipeline: tools/audio_prep.py, tools/sound_board.py); ops/research/TASK_SOUND3.md (the miss
rule, the room by attendance); ops/research/PRODUCTIONCRATE_S446.md (what he downloads himself - do not duplicate those);
assets/audio/SOUND_QA_S395.md.
## What would a human do?
A sound designer records or generates a few takes of each, levels them the same, and lets the director pick by ear.
## Prefab check
ProductionCrate covers punches, big crowds and flashes (the operator downloads them); Ludo makes the rest, licence-clean.

Test command: `python ops/Tools/godot_slot.py run --who SOUND4 -- "$LOCALAPPDATA/Programs/Godot/Godot_v4.7.2-stable_win64.exe"
--headless --audio-driver Dummy --path . --script res://tests/sound_bank_test.gd`
RESULT line for the PR body: `RESULT: tests/sound_bank_test.gd -> SOUND_BANK failures=0`.
