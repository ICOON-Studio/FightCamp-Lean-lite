# TASK SOUND1R2 - QWEN (sound engineer) - round 1 rework (S386, Claude's collect review)

Model: qwen3-coder. Discipline: boxing (the demo). The full contract stays ops/research/TASK_SOUND1.md - read it first.
Start from your branch qwen/sound1 (a54bd8d2) in worktree E:/FightCamp/wt/LEAN_SOUND1. Push to qwen/sound1.

## Why round 1 was not collected
1. Ludo IS installed: `C:/Users/user/AppData/Roaming/npm/ludo` (your shell's PATH missed it). Round 1 shipped 91
   ffmpeg-synthetic placeholders instead of Ludo sounds. The brief asks for Ludo sounds; synthetic tones never go in
   assets/audio. Delete every synthetic file you added and make the round-1 events with Ludo (TASK_SOUND1: 8 variants per
   punch layer, per-event loudness classes, budget 200 credits; spend the least that covers every event once first).
2. sounds.json lost all 13 round-0 Ludo rows (punch_jab_head_1 ... ui_click_1; the files are still on disk). The operator is
   judging exactly those 13 now (board question Q-S294-99). Put every row back as it was on main (heard/verdict untouched),
   and keep them in their events' `files` pools.
3. assets/audio/crowd/crowd_arena_loop_1.ogg (Ludo, round 0) was OVERWRITTEN. Restore it from origin/main
   (`git checkout origin/main -- assets/audio/crowd/crowd_arena_loop_1.ogg`); a new crowd loop is crowd_arena_loop_2.ogg.
   Rule (TASK_SOUND1): never overwrite a file a row names; a redo is a NEW file <event>_<n+1>.ogg.
4. Keep the code (SoundBank.gd, Sfx.gd, FightSfx.gd, FlipCard/UI hooks, sound_bank_test.gd, FIGHT_HOOKS.md) - it is fine.

## Operator's ear on round 0 (C234, 2026-11-05: "1,3,4,6,7,8,9,10 are ok , rest trash")
KEEP as they are: punch_jab_head_1, punch_body_1, punch_blocked_1, punch_big_1, bell_round_start_1, bell_round_end_1,
crowd_arena_loop_1, crowd_roar_1. Use these as the reference for what he likes.
REDO with Ludo, a NEW file each (<event>_2.ogg, rows heard:false), and take the _1 file out of its event's `files` pool, leaving
the file and its row on disk: punch_power_head, punch_miss, knockdown_fall, footwork_canvas, ui_click. Do these five FIRST.
sounds.json on main now carries heard/verdict for all 13: keep those values.

## Done when
- `git diff origin/main...HEAD -- assets/audio` shows NO modified or deleted file (only added ones); every main row is in sounds.json.
- No file in sounds.json has source "ffmpeg synthetic".
- `godot --headless --audio-driver Dummy --path . --script res://tests/sound_bank_test.gd` passes (no SCRIPT ERROR).
- The sound board (tools/sound_board.py) rebuilt; every new row "heard": false.
- Your last message: `RESULT: tests/sound_bank_test.gd -> <pass line>`, credits spent, the list of new files.

## Contract
OWNS: scripts/audio/, assets/audio/, docs/audio/, tests/sound_bank_test.gd, tools/audio_prep.py, tools/sound_board.py,
tools/audio_ear.py, tools/build_sounds_json.py, tools/gen_round1_audio.py, scripts/ui/UI.gd:275-288, scripts/ui/FlipCard.gd:188-198
RED_TEST: tests/sound_bank_test.gd -> PASS sound_bank_test
REGRESSION: golden_path_test, card_flip_test, drill_card_test
VISUAL: no (sound; the operator's ear judges on the sound board, never auto-merged without his keep)
