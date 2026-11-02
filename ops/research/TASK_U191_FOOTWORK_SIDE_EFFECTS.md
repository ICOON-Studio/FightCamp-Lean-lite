# TASK U191 - CURSOR - WHAT FOOTWORK ECONOMY BROKE ON THE WAY (S99)
Owner: cursor. Assigned 2026-09-27 (S99). Model: Cursor default (auto), medium. Branch `cursor/u191-footwork-side-effects`
from `origin/master`, own worktree. Claude merges; never merge master in. **Launch after U190 lands (two-agent cap).**

## Why
Q183 turned `footwork_economy` ON for every ruleset (less circling, shorter retreats, a burst limiter). Q201
(`Q201_DIGEST.md`, branch qwen/q201-footwork-evidence) ran the ten tests it turned red with the flag OFF and ON. Claude's
ruling (S99): these five are DEFECTS, not stale values. Each is a physical or behavioural fault the footwork change exposed:

| test | check | OFF | ON |
|---|---|---|---|
| fight_between_exchanges | S4E6-3 clash mean (band 1.0-2.8 s) | 1.64 s | 3.01 s |
| fight_defence_model | feint + model preempt bites | 24 | 0 |
| fight_contact_stop | a landed low kick keeps contact | 9 | 0 |
| fight_grapple_seam | every film that started played out | 17/17 | 16/17, 24 suspended |
| fight_room_walkout | MMA fighter Y stays at mounted height | 0 dev | 2.5 cm |

(`fight_separation` is Qwen's Q202. Do not touch the separation code.)

## What would a human do?
An engine programmer takes each red check, finds the one tick where ON and OFF first differ for that quantity, and asks
which footwork rule caused it. Two examples: a clash is held longer because the retreat is halved, so nobody leaves the
exchange. A feint is never read because the model needs approach/retreat cycles that no longer happen. Then they fix the
RULE (or the interaction), keeping Q183's own headline numbers (m/min, burst/hold p50, landed/min - `Q183_DIGEST.md`)
inside their CIs. Changing a test band is not a fix unless a real study says the band is wrong. If so, quote it.

## Do
1. For each row, reproduce ON and OFF (`footwork_economy: false` in the test's begin options, locally, reverted after).
2. Fix it in the engine: one named constant or rule per fix, each with a comment naming this task.
3. Re-run Q183's census on 10 seeds before and after; print both.

## Gate (a CEILING)
Turn as many of the five green as can be done honestly. Say which stayed red and why. Q183's headline numbers stay
inside their old CIs.
`python Godot/tools/run_tests.py --jobs 2 --only fight_between,fight_defence,fight_contact,fight_grapple_seam,fight_room_walkout,fight_realtime,fight_footwork`
must be no worse than master, apart from the rows you turned green. Parse gate on every touched .gd. Never the full suite.

## Owned files
`Godot/scripts/FightRealtime.gd` (~6,300 lines - never open it whole; grep `footwork_economy`, `clash`, `feint`, then
read `sed -n` windows), `Godot/scripts/FightFootwork.gd` (read it whole if it is under 600 lines), `Godot/tools/u191_*.gd`,
`research/U191_DIGEST.md`. Tests are read-only unless a cited study proves a band wrong.

## Deliver
Commit explicit paths (list them in the message), push the branch, and write `U191_DIGEST.md` with an OFF/ON/after
table. Then run `python Tools/agent_comms.py send --from cursor --to claude --topic U191 --body "<rows green, Q183 headlines>"`.
Do NOT edit HANDOFF.md. All research is open: RESEARCH_INDEX.md.
**Trap:** turning footwork_economy off for a ruleset makes the tests pass and throws away Q183. That is not allowed.

## REWORK (S102, 2026-09-27) - SENT BACK
Claude bisected U191 ALONE on master c1080a37 (diff 5149a535..9710e193, digests excluded) against the same master with
nothing applied. U191 adds THREE reds that base does not have:
- `fight_realtime_test`: "the doctor actually stops a fight over a championship distance (0 of 3)"
- `fight_realtime_test`: "a hurt man is told to protect his head (0)"
- `fight_defence_movement_test`: "RULE R19 defensive_movement_rate | GATED S4e (2) | FAIL"
(The 7 judo seed pins failing on both arms were stale and are re-pinned on master in S102 - not yours.)
Q203 was merged in S102 and touches `FightDefenceModel.gd` too: **rebase on origin/master first**, then make those three
rows green without losing your U191 rows or turning footwork_economy off. Same gate as above plus
`python Godot/tools/run_tests.py --jobs 2 --only fight_realtime,fight_defence_movement,fight_defence_model` - no red that
master does not have. Push to `cursor/u191-footwork-side-effects`, mail with `--topic U191`.
