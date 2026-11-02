# TASK Q207 - ENGINE AGENT (QWEN OR CURSOR) - ONE DOWN / ONE UP: THE SECONDS AFTER AN MMA KNOCKDOWN (S104)
Owner: whichever engine agent frees first (Qwen: qwen3-coder medium `--yolo`; Cursor: Composer medium). Assigned
2026-09-27 (S104). Branch `<agent>/q207-one-down-one-up` from the branch that carries Q205+Q206 once merged to master
(if not yet merged at launch: from `origin/qwen/q206-fence-pin`), own worktree. Claude merges.

## Why
In MMA today a recovered knockdown does nothing: `_go_down` (`FightRealtime.gd:2447`) either stops the bout (KO roll
lost / three-knockdown rule) or calls `_start_count`, which returns at once because MMA carries no `knockdown_count`
(`:2495`). The man is simply standing again on the next tick - the damage stays, the moment does not. G140
(`research/G140_ONE_DOWN_ONE_UP.md`, read §1, §3, §7 - it is 102 lines, read it whole) measures what really
happens: a knockdown ends the fight within 10 s about 38% of the time, a fight with a KD finishes by KO/TKO 63.5%, the
median stop is ~6 s, and the standing man chooses FOLLOW / HOVER / RESET.

## What would a human do?
The standing man reads how hurt the other is and his own game: a wrestler dives on top (FOLLOW), a kickboxer stands
over him punching down (HOVER) or waves him up (RESET). The downed man shells, stands, wall-walks the cage, grabs a leg
or upkicks. The referee hovers at arm's length, watching for intelligent defence; a man who only covers while shots
stack is stopped, one who improves position is let go on. A FightMetric coder logs the KD, the seconds to the stop or
to the recovery, and where it ended (standing, top, stopped).

## Prefab check
None: this is our own engine's state machine. G140's Prefab check found no public dataset that tags the aftermath
(UFCStats/Sportradar give KD counts only); the rates are G140 §7's J rates calibrated to S timings. Instrument: extend
`Godot/tools/q205_mma_state_time_census.gd` (as Q206 did) - do not write a second census.

## Do
1. BASELINE on the branch point: run the census and record per MMA bout: KDs, share of KD'd bouts ending KO/TKO, and
   for each KD the seconds until the bout stops or the man is back in a normal state. Name the populations (Q205's
   three matchups, never identical fighters, legal for MMA).
2. Add `ONE_DOWN_ONE_UP` as a new grapple STANCE value `"one_down"` (it is not a ground seat: no hips claimed, no guard -
   G140 §7), entered from `_go_down` when the man recovered AND the ruleset has no `knockdown_count` AND the option
   `one_down_one_up` is on (default ON for MMA only). Boxing, kickboxing and judo must stay BYTE-IDENTICAL: print log
   hashes on 4 seeds each before and after. Spar mode (`state["spar"] != ""`) keeps today's behaviour.
   Also enter it with LOW danger from a stuffed shot / failed takedown where the existing code already puts a man on
   the floor, only if that path exists cleanly; otherwise leave low-danger entries for a later task and say so.
3. On entry pick the standing man's policy once (may flip once): FOLLOW / HOVER / RESET, priors 0.55/0.25/0.20, shifted
   by his style (grappling edge -> FOLLOW ~0.7; striker -> HOVER+RESET ~0.6). Use the existing per-tick draw stream -
   no draw inside an `if` that changes the draw count for other rulesets.
4. Per-tick exits converted from G140 §7's per-second table (t = 0-3 s / 4-10 s / >10 s columns), high danger:
   referee stoppage -> `_stop(..., METHOD_TKO)` (`:2775`); follow-down settles -> `_move_seat` to `"ground"` with the
   standing man on top (see the takedown call at `:5374` for the shape); downed man stands / wall-walks -> `"standing"`
   (fence clinch if Q206's fence seat is present and he is near the cage); leg grab -> ground with either on top, or
   standing; upkick -> standing. HOVER applies strikes to the downed man each second (use the existing strike/impact
   path so damage and scoring stay honest); RESET exits to standing in 1-3 s. A downed man with head condition better
   than the flash threshold shades toward standing; a worn head shades toward stoppage. A second KD in the round raises
   the stoppage rate (G140 §3). Force a branch by ~15 s.
5. Log every entry and exit (`{"type": "one_down", ...}`, `{"type": "one_down_end", "to": ..., "t_s": ...}`) so the
   census and the presenter can read it. Grep every consumer that switches on `stance` (`BroadcastRead.gd`, the
   presenter, scoring, `FightStoppageRead`) and make sure the new value is handled or falls through safely.
6. MEASURE with the extended census. v1 ACCEPTANCE (G140 §7, all bands - say which you hit and which you missed):
   ~35-40% of KD sequences over by 10 s; ~50-55% over by the end of the round; median time-to-stop 5-7 s; survivors
   exit to STANDING or GROUND_TOP, never a silent reset; bouts with >=1 KD end KO/TKO toward 63.5% (report the number,
   it is a direction not a gate). MMA leg share must stay inside 12-18% (`fight_realtime_test`).

## Gate (tier: script edited)
Parse gate on every touched `.gd`: `python Godot/tools/check_scripts.py <files>`. Then
`python Godot/tools/run_tests.py --jobs 2 --only fight_realtime,fight_knockdown_count,fight_stoppage_read,grapple,fight_scoring,fight_one_down`
no worse than the branch point, except pins your change moves (list each with old/new; Claude re-pins). Never the full
suite. Check the PC first: `powershell -NoProfile -ExecutionPolicy Bypass -File Tools\pc_watchdog.ps1 -Once` - exit 1
means stop and say so.

## Owned files
`Godot/scripts/FightRealtime.gd` (6,466 lines - NEVER open it whole; anchors: `_go_down` :2447, `_recovery_chance`
:2565, `_start_count` :2491, `_stop` :2775, knockdown caller :4486, ground seat move :5374, stance switches :4958/5041;
use `sed -n` windows), `Godot/scripts/FightGrappleSeat.gd` if a constant is needed, `Godot/tools/q205_*.gd` (extend),
`Godot/tools/q207_*.gd`, `research/Q207_DIGEST.md`, a new `Godot/tests/fight_one_down_test.gd` (MMA over 20+
seeds: a KD enters `one_down`, it exits by at least three different routes, it never lasts past the forced branch;
boxing: zero `one_down` events and the count still runs).

## Deliver
Commit and push AS YOU GO. Digest with before/after census first, then
`python Tools/agent_comms.py send --from <agent> --to claude --topic Q207 --body "..."`. Do NOT edit HANDOFF.md,
CURRENT_STATUS.md or HANDOFF_ARCHIVE.md (logs). All research is open: root `RESEARCH_INDEX.md`.
**Trap:** the count machine and this state must never both run - `_start_count` returning early for MMA is the seam;
branch there, not after. And the round bell: a man in `one_down` at the bell is saved by it in MMA (no count to hold
the clock) - end the state at the bell, do not reuse `_hold_the_bell`.
