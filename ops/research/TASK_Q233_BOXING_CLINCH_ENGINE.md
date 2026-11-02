# TASK Q233 - the boxing clinch in the ENGINE: who ties up and why, the referee, warnings and deductions (Qwen engine seat)
Model: deepseek-v4-pro (engine). Owner: Qwen (the next free Token Plan seat - the Q226 seat when Q226c lands). Worktree
E:/FightCamp/wt/Q233, branch qwen/q233-boxing-clinch (from master).
Operator 2026-10-02 (S139), verbatim: "keep working on this and maybe put a threshold when the distance is too close to
clinch ?" and "do a proper intergration of the clinch, who initates it, why , what are the penalties etc".
READ FIRST - the design, every number and source: `research/S139_CLINCH_DESIGN.md` (sections 1-6). It is the spec.

## Start from the work already done (never merged)
- `fb58fb93` Q174: the need-based hold model in FightRealtime.gd (HOLD_ENGAGE_BASE / FATIGUE / DAMAGE / OUTWORKED
  factors, HOLD_DURATION_TICKS, `_run_hold`, `hold_engage` / `hold_break`, its own RNG stream SEED_HOLD) -
  `git show fb58fb93 -- Godot/scripts/FightRealtime.gd`; digest `research/Q174_DIGEST.md`.
- `ca6aaf3a` + `69fb0764` Q175: the `boxing_hold` option (OFF by default, OFF byte-identical), the BELL-BREAK fix
  (boxing hold 6.78 s -> 5.02 s, inside K38's 4-7 s band), `tools/q175_measure_hold.gd`; digest `Q175_DIGEST.md`.
Re-apply those diffs onto TODAY's FightRealtime.gd (the file moved on since 09-25 - apply by hand where hunks fail;
never take the old whole file). Then build the rest of the design on top.

## Build (S139_CLINCH_DESIGN.md s1-s5)
1. Initiation = need (hurt, tired, smothered) + the operator's DISTANCE threshold (gap < CLINCH_GAP_M for >
   CLINCH_DWELL_S -> the man with the higher need ties up) + tactics (personality: "dirty"/veteran holds more and may
   hit on the break; plan: out-boxer holds when smothered, pressure fighter works inside; protecting a lead late) +
   the CORNER ORDER (two new orders in the corner-instruction list: "tie_up_when_hurt", "work_inside").
2. Inside: no head shots; short body shots at a low rate by the free man; holder recovers stamina, the leaned-on man
   pays stamina (constants named, PROXY-labelled, bounded).
3. The break: referee STOP-BREAK after a drawn 2-8 s (mean ~5 s, Q175's bell-break fix), or a man breaks free; both
   step back to range. A chance (personality-driven, small) of a punch on the break = a FOUL.
4. Penalties (ABC via J14): per man per round count holds + held seconds; soft warning -> hard warning -> 1-point
   deduction (discretionary) for excessive holding; warning -> deduction for hitting on the break. A deduction comes
   off THAT round on all three cards (RoundScoring / the judges' read). DQ: not in this task.
5. Scoring/judges: clinch time scores nothing; a heavy holder loses a little on effective aggression/ring generalship.
6. Log events the room and HUD read (keep names exact, other agents consume them): `hold_engage` {holder, cause},
   `hold_break` {by: referee|free}, `hold_warning` {side, kind: holding|on_break, level: soft|hard},
   `point_deduction` {side, points, round, reason}, `foul_on_break` {side}. Round stats: clinches, clinch_s per man.
7. Switch: one key in DEMO_SWITCHES (game ON, tests OFF); OFF byte-identical (no state key, no draw) - C230/Q226 pattern.

## Acceptance (S139_CLINCH_DESIGN.md s6 - print achieved beside wanted)
Booked census (`tools/q212_booked_census.gd -- weeks=40 as_game`, plus a no_q233 control arm, own save folders, >= 120
boxing bouts each): holds 2.5-4.8 a round rising R1->late rounds; 4-6 s mean each; ~10% of round time; KO+TKO 40-55%
and thrown 45-56 per man-round unchanged in band; warnings present in bouts with a heavy holder; deductions in < 10% of
bouts; the OFF arm identical to master. Two DIFFERENT fighters in every fixture (stats, style, personality).

## Owned files
`Godot/scripts/FightRealtime.gd` (hold/clinch/referee/penalty code only - NEVER read whole: `sed -n` windows; anchors:
R92 clinch ~905, `_grapple_clinch` ~6175, the corner order handling `grep -n "corner_order\|instruction" FightRealtime.gd`),
the judges' deduction hook (`grep -n "deduct" Godot/scripts/RoundScoring.gd Godot/scripts/JudgePanel.gd`), the corner-order
list (`grep -rn "corner_order" Godot/scripts/*.gd | head`), `Godot/tests/q233_boxing_clinch_test.gd`,
`Godot/tools/q212_booked_census.gd` (the no_q233 arm only), `research/Q233_DIGEST.md`. NOT the room/animation
(Codex C240 builds the clinch film on your events) and NOT the HUD (Claude's BroadcastScorebug.gd shows your events).

## Prior research
`python Tools/prior_research.py clinch holding referee deduction boxing`: S139_CLINCH_DESIGN.md, K38, Q174, Q175, J14
(the referee - warnings, deductions, hit on the break), J38 (the break), J1 (10-point must), topics/clinch.md.

## What would a human do?
A sports-sim designer: make the hold a consequence of state (hurt/tired/trapped) and of the man's style, give the
referee a simple escalation ladder, make penalties rare but real, and check the whole fight still lands in its bands.

## Prefab check
None needed: engine logic on our own state; every number comes from the research files named above.

## Test (tier: engine edited)
Parse gate; NEW `q233_boxing_clinch_test.gd`: (a) a fresh even man almost never holds, a hurt/tired/smothered man holds
far more (show the ratio); (b) gap under the threshold for longer than the dwell -> a hold; above it -> none; (c) the
break ends every hold within the drawn bound; (d) excessive holding escalates soft -> hard -> deduction and the round's
cards drop one point; (e) MMA and kickboxing hashes unchanged (control arm). Break one rule and watch it fail (say so).
Then `python Godot/tools/run_tests.py --jobs 2 --only fight_realtime,boxing_output,fight_strike_whole,judge,round_scoring`.
Watchdog GREEN before each heavy run (if RED wait 2 min and re-check; never kill a process you did not start). Look at
any image with your file tool only - never open a viewer.

## The one trap
`fb58fb93`/`ca6aaf3a` were written against the 09-25 FightRealtime - constants and functions have moved and the stamina
model changed (C226 ST1). Re-measure; do not trust the old digest's numbers.

## Finish
git add by explicit path, commit, git push -u origin qwen/q233-boxing-clinch. Never edit HANDOFF.md. Do not stop at written.
