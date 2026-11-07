# TASK_SOUND2 - the sound engineer, round 2: fight sound to 8/10 (Qwen)

Model: Qwen (qwen3-coder). Discipline: boxing. Repo: E:\FightCamp\Lean, on your own worktree and branch. Lean rules: its CLAUDE.md,
no script over 500 lines, Godot headless only (`--headless --audio-driver Dummy`), nothing opens on the operator's screens.

## Contract
OWNS: scripts/audio/, assets/audio/, scripts/fight3d/BeatFire.gd, tests/sound_sync_test.gd
RED_TEST: tests/sound_sync_test.gd -> SOUND_SYNC failures=0
REGRESSION: hit_flash_test, hud_shown_test
VISUAL: no

## Goal (operator S395)
"the fight (short clipped) with sound reviewed ... the sound engineer keep working until it rated 8/10". You own every fight sound.

## Read first
- `ops/research/SOUND_QA_S392.md`: measured sync and mix. This is your fault list.
- `ops/research/TASK_SOUND1.md`: your role and THE EAR RULE. You cannot hear. Nothing is "good" until a listener has rated it.
- `ops/research/SOUND_BENCHMARK_S385.md`: what praised games do.

## Do, in this order
1. **Sound with no punch:** 17 of 125 blocks and misses played a sound after the punch clip had been replaced. Check the punch is
   still running before a block or miss sound fires, as landed punches already do.
2. **Block timing:** `punch_blocked_1` carries 79 ms of near silence before its pat, so every block is heard about 100 ms late.
   Trim the file's lead and correct its `lead_silence`.
3. **Landed and big-shot timing:** bring landed punches inside the bar at 60 fps (heard 50 ms early to 80 ms late of glove contact).
4. **Variety:** all 13 events have one file each, so every jab sounds identical. Add per-play pitch and level variation now, with
   no repeat of the same take twice running. Real extra takes per punch come from Ludo: 3 per punch, stored in the project.
   New takes go on the sound board for the operator's ear and stay unused until he has heard them.
5. **Mix:** our film is -27 LUFS with peaks at -0.3; review video sits near -14. Add a master limiter and bring the mix up, with
   punches clearly above the crowd bed. Measure it on a film's audio track.
6. **New moment:** a big shot now slows the ring to 0.3 for one second (`scripts/fight3d/FightCalls.gd`, on its way to main). Sounds
   do not slow with `Engine.time_scale`, so give that moment its own treatment: a heavier hit, and the crowd ducked under it.

## Done
Each fix has its measured before and after in `assets/audio/SOUND_QA_S395.md`, the same method as S392. Touched tests pass; do not
run the full suite. Open a PR and report what is still unheard. Do not claim any score: the rating comes from a listener.
