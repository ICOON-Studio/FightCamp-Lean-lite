# TASK Q208 - QWEN - BACK CONTROL: HOOKS IN TO THE TAP OR THE ESCAPE (S113)
Owner: qwen (qwen3-coder, medium, `--yolo`). Assigned 2026-09-27 (S113). Branch `qwen/q208-back-control` from
`origin/master` (carries Q206 fence pin + Q207 one down, merged 1a71240a), own worktree. Claude merges.

## Why
The MMA ground engine has a `back` seat (`FightRealtime.gd` `_grapple_ground` :6073, back entry :6419, submission
window for mount/back :6321, `_finish_submission` :6548) but it was never calibrated: how long a man holds the back, how
he loses it, how often the rear-naked choke ends the fight. G142 (`research/G142_BACK_CONTROL.md`, 70 lines -
read it whole, §6 and the acceptance bands are the spec) gives a per-second competing-risks table from real UFC data.
Q206 also owed `fight_fence_pin_test` and never delivered it; it is part of this task.

## What would a human do?
A BJJ coach who corners MMA fighters: on the back with hooks in, the top man hand-fights for the neck, punches to open
it, and locks the choke; the bottom man fights the hands, scoots to the fence to stand, or turns into guard. The ref
stands them up only when nothing happens on the fence. A FightMetric coder counts each visit from hooks-in to its end
and codes the exit. Build the seat the way the coach describes it and measure it the way the coder counts it.

## Prefab check
None usable: this retunes our own engine. G142 names the datasets (UFCStats finish strings, Sportradar
`backControlTime` - commercial, docs public, NOT to be scraped here). No Godot plugin models MMA ground seats.

## Build
1. A two-stage back seat inside the existing `back` ground seat - NOT a new stance. Stage A (control) and Stage B (RNC
   locked), one draw per second of competing risks from G142 §6 exactly (the rates are per SECOND; the engine ticks
   faster - convert once, name the constants, cite G142). Stage B `rnc_fail` returns to Stage A; a failed attempt is
   not an exit. Other choke uses Stage B with finish 0.050.
2. Flags on Stage A from G142 §6: body triangle, fence (use Q206's fence seat / `_near_wall`), upright; weight-class
   multipliers from the HW-LHW / WSW-FLW rows. Punches landed in Stage A raise that second's `rnc_lock` x1.15 each
   (cap x1.8).
3. Every exit logs `{"type": "back_end", "to": <exit>, "t_s": ...}`; entry logs `{"type": "back", "via": ...}`.
   Exits map onto existing seats: esc_guard -> guard (bottom), esc_top -> top reversal, esc_stand -> standing,
   to_mount -> mount, ref_stand -> standing reset, RNC/other choke finish -> `_finish_submission`, GnP TKO -> the
   existing stoppage path. Grep every consumer that switches on the seat and make sure nothing silently resets.
4. Census tool `Godot/tools/q208_back_census.gd`: visits from real MMA bouts, THREE DIFFERENT populations (grappler vs
   striker, wrestler vs BJJ, two strikers with different grapple stats - never identical fighters, both legal for MMA
   and able to do everything). Name each population in the output. Print achieved beside wanted for EVERY band in
   G142's acceptance list. Also a forced-seat mode (start the pair on the back) so the visit-level bands get 1k+ visits.
5. `Godot/tests/fight_back_control_test.gd` (20+ MMA seeds: a back visit enters Stage A, reaches Stage B, exits by at
   least four different routes, never resets silently; boxing: zero back events) and `Godot/tests/fight_fence_pin_test.gd`
   (Q206's owed test: a pair driven to the fence enters the fence seat, drifts off by the Q206 rules).

## Acceptance (G142 bands - report hit/miss for each; a miss -> retune a lambda, never add a state)
Median visit 14-24 s; RNC finish 18-26% of visits; to guard 18-30%; stand/shed 15-28%; to mount 5-12%; ref stand
2-7%; RNC finish given attempt 32-50%; locked RNC -> finish 7-11 s. Fight level ~0.35 back visits per MMA fight.

## Gate (tier: script edited)
Check the PC first: `powershell -NoProfile -ExecutionPolicy Bypass -File Tools\pc_watchdog.ps1 -Once` - exit 1 means
stop and say so. Parse gate on every touched `.gd`: `python Godot/tools/check_scripts.py <files>`. Then
`python Godot/tools/run_tests.py --jobs 2 --only fight_realtime,fight_knockdown_count,fight_stoppage_read,grapple,fight_scoring,fight_one_down,fight_back_control,fight_fence_pin`
no worse than master at branch point (master's reds in that subset: fight_scoring, grapple_naming_contract). A pin your
change moves: list it with old/new and Claude re-pins. RUN THE WHOLE SUBSET - Q207 skipped fight_realtime. Never the
full suite.

## Owned files
`Godot/scripts/FightRealtime.gd` (6,915 lines - NEVER open it whole; anchors: `_grapple_ground` :6073, submission
window :6321, back entry :6419, `_finish_submission` :6548, `_move_seat` :5945, `_near_wall` :5763, constants :640-660;
use `sed -n` windows), `Godot/scripts/GrappleSeat.gd` if a constant is needed (small, read whole),
`Godot/tools/q208_*.gd`, the two new tests, `research/Q208_DIGEST.md`.

## Deliver
Commit and push AS YOU GO. Digest with the census table (population named, achieved beside wanted) first, then
`python Tools/agent_comms.py send --from qwen --to claude --topic Q208 --body "..."`. Do NOT edit HANDOFF.md,
CURRENT_STATUS.md or HANDOFF_ARCHIVE.md (logs). All research is open: root `RESEARCH_INDEX.md`.
**Trap:** G142's rates are PER SECOND and the RNC share is PER VISIT, while the engine's current submission odds are per
TICK and per window (`SUBMISSION_OPEN_TICKS` :654). Replace the back seat's old submission roll with Stage B - do not
stack Stage B on top of it, or the RNC rate doubles and every band reads high.
