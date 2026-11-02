# TASK C240b - wire the real Q233 clinch into the room, run the real census (Codex, next free engine/animation seat)

Model: gpt-6-astra, medium. Owner: Codex. Resumes C240 (route_decisions.json "C240": RESUMED, S141).

## Why this exists
C240's own digest (NOT COMPLETE / NOT MERGE-READY, research/C240_DIGEST.md) built the room fixture (hold/break
film, paired-body separation, foul punch) and tested it, but Q233 (the real clinch engine) was not on origin yet, so
C240 drove the room from a SCRIPTED fixture (hard-coded hold_engage at 5s / hold_break at 10s). Q233 merged to master
S141 (`cf984127`): real need-based holds, distance threshold, referee break, penalty ladder, with exact event names
`hold_engage {holder, cause, break_s}`, `hold_break {by, duration_s}`, `inside_work {actor, holder}`,
`foul_on_break {side}`, `hold_warning {side, level, reason}`, `point_deduction {side, points, reason}` logged from
`FightRealtime.gd`. This task connects the two and proves the acceptance C240 could not yet measure.

## Build
1. `FightWorldLiveScreen._pump_to` currently accepts only actions and grapples and drops other events before
   `FightStagePlayer` sees them (C240's own finding - verify still true against today's master first). Add routing
   for Q233's clinch events into the paired-root ownership hook `FightStagePlayer` already exposes for C240's hold
   bindings (do not re-author the binding/playback logic - C240 built it, reuse it). Scope the edit to
   `FightWorldLiveScreen.gd` only; do not touch `FightRealtime.gd` (Q233's owned file) or `FightStagePlayer.gd`'s
   binding tables (C240's owned file) beyond what the routing needs.
2. Re-run `Godot/tools/c240_overlap_census.gd` against >= 10 complete seeded booked bouts (the Q212 booked population,
   same before/after pairing C240 used) with the REAL Q233 events driving the room, not the scripted fixture. Report:
   - torso interpenetration > 2 cm for >= 3 frames, head > 1 cm for >= 1 frame: BEFORE vs AFTER, AFTER must be lower
     by at least half (G147 / C240's own gate - the 30 s scripted excerpt only reached 17->15 of 900 frames, a FAIL).
   - measured clinch rate per round against the Davis et al. 2015 band C240 already cited (2.5/3.2/4.8 across rounds
     1-3, ~5-6 s each; no 12-round pro anchor exists - say so again if still true).
   - KO+TKO 40-55% and thrown 45-56/man-round stay in band (q212 booked census, boxing_clinch ON vs the no_q233 arm
     Q233 already added).
3. A fresh >= 30 s LIVE-ROOM video (game camera, as_game, >= 1280x720, silent) showing a REAL engine-triggered tie-up
   and break (not scripted timestamps) - name the seed and which event fired it in the video receipt.
4. Investigate the C240 digest's open realism-gate 600 s timeout (fight_stage_realism_test.gd) before claiming the
   affected-systems gate green - it was not baseline-attributed. If it reproduces without your change, name that and
   move on; if your change causes it, fix it.

## Acceptance
Same as the original TASK_C240 acceptance block (overlap halved on real bouts, clinch rate in band, KO/thrown bands
held, approved video) - this task is not done until those are REAL measurements, not the scripted-fixture numbers.
Operator video approval remains the merge bar (S138 rule) before any certified_moves.json change.

## Owned files
`Godot/scripts/FightWorldLiveScreen.gd` (the clinch-event routing only - Claude also touches this file for
BroadcastScorebug/K83; coordinate via `git log -p` on it before you start, and keep your diff to the routing lines),
`Godot/tools/c240_overlap_census.gd`, `previews/c240/*`, `research/C240_DIGEST.md` (update, do not
replace the NOT-COMPLETE history - add a new dated section).

## Prior research
Read `research/C240_DIGEST.md` and `research/Q233_DIGEST.md` in full before starting - both are short and
this task is entirely about connecting them. `python Tools/prior_research.py clinch boxing break referee overlap`.

## What would a human do?
Wire the signal the engine already emits into the presentation layer that already knows how to play it, then measure
the real thing instead of trusting the rehearsal.

## Prefab check
None needed - reuses C240's existing clip bindings and Q233's existing event log; no new assets required unless the
real census surfaces a gap the fixture didn't (report it, don't silently author around it).

## Test (tier: engine+room, two files edited/measured)
Parse gate on touched files first. Focused: `c240_boxing_clinch_test.gd`, `q233_boxing_clinch_test.gd`. Affected:
`python Godot/tools/run_tests.py --only fight_world_live,c240,q233,q212,booked --jobs 2` (never serial). Full suite
is nightly only.

## The one trap
`FightWorldLiveScreen.gd` is being edited by two tasks (this one and Claude's K83 scorebug mount) in the same
session - read the file fresh before editing, keep your diff scoped to clinch-event routing, and flag a collision in
your digest rather than guessing the other task's lines away.
