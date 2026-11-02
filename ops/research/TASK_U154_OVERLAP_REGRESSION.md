# TASK_U154 - the overlap regression: bisect it, then fix the mechanism so no-teleport AND the overlap budget both hold (Cursor, full branch)

Model: Composer, medium, `-p --force --trust`. Owner: cursor. Assigned S63, 2026-09-24.
Operator split 2026-09-24: agents own the engine and motion lane; Claude integrates.

## Why
`tools/u145_transition_probe.gd -- arms=A stills=off`, seed 94301, now reads the longest >3 cm
overlap run at **0.200 s boxing / 0.150 s MMA** (522 / 426 overlap frames). S62 measured **0.100 /
0.083 s** on the same probe and the budget is 0.10 s. Bodies overlapping was the operator's worst
on-screen verdict. S63 PROVED it is not S63: a control arm with S63's three engine files reverted gives
the identical 522 / 0.200 and 426 / 0.150. **Prime suspect: your own U150 part 2** -
`overlap_sep_credit_engine_gap` (ON) skips the room's SECOND hip push in `_correct_refused_overlap`
(`FightWorldLiveScreen.gd`, grep the flag) to fix `fight_room_no_teleport`; that push was also closing
overlap.

## Part 1 - bisect
Run the probe with the room option `overlap_sep_credit_engine_gap: false` (find how u145 passes room
options; add an arg if it cannot). If boxing returns to ~0.100 s, that is the cause. Otherwise bisect
the room/engine commits between S62's digest commit (`git log --oneline -- research/S62_DIGEST.md`)
and 952762dd. The probe is WINDOWED (~10 min a run): launch through
`powershell -NoProfile -ExecutionPolicy Bypass -File Tools\godot_hidden.ps1 --path Godot --resolution 1280x720 --script tools/u145_transition_probe.gd -- arms=A stills=off`.
**It REWRITES `research/U145_DIGEST.md` on every run** - `git checkout HEAD -- research/U145_DIGEST.md` after each one; never commit it.

## Part 2 - fix the mechanism, not the number
Both must hold at once: no double hip write in one frame (the teleport U150 fixed) AND overlap runs
<= 0.10 s. E.g. let the ONE remaining push close faster, or credit only the part of the engine gap that
is actually present this frame. If they genuinely cannot both hold, keep no-teleport (a jump reads worse
than 0.1 s of overlap), say so, and report the smallest overlap you reached. Print all arms side by side.

## Owned files
`Godot/scripts/FightWorldLiveScreen.gd` (the overlap/refusal functions only - grep
`_correct_refused_overlap`, `_refuse_overlap_on_placed`, `_overlap_sep`), `Godot/tools/u145_transition_probe.gd`
(an option arg only), `research/U154_DIGEST.md` (new). FightWorldLiveScreen.gd is 3,400+ lines -
never open it whole; grep, then `sed -n` windows.

## Gate (tier: a script edited)
Parse gate; u145 arm A seed 94301: longest overlap <= 0.10 s boxing AND MMA, jumps <= boxing 5 / MMA 8;
`python Godot/tools/run_tests.py --only fight_room_no_teleport,fight_world,fight_separation,grapple`.
No full suite (Claude's). Branch `cursor/u154-overlap`, worktree off `origin/master`; `--headless --import`
once on a "TitleHonours" error. One `agent_comms.py send` per part. Do NOT edit HANDOFF.md.
Trap: two honest runs that disagree mean a flag you did not set - print every room option the probe used.
