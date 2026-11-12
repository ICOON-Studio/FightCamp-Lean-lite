# TASK R26TOWEL1 - QWEN (qwen3-coder) - THE TOWEL: when the card comes in the corner minute, the risk it shows, and what each answer costs (one pure module + its test)

Status: OPEN (S440, Claude main). Discipline: boxing. Model: qwen3-coder.
Mechanic: R26 "Corner minute: three fixes, time for two" (critics 8/9 and 7/8, average 8.0, ops/research/MECHANICS_BUILD_STATE_S440.md);
the towel was the RPG critic's ask (docs/mockups/s432/critics/rpg3_clubcoach_review.md). Source: ops/research/FIGHT_LINK_MAP_S432.md
M13 THE TOWEL (lines 377-396: READ IT FIRST, it is the spec), its numbers (section 9, lines 495-497) and CORE_LOOP_MAP_S432.md C11
(one card, its reasons). The fight-link map passed two critics at 7 and 7. THIS task is only the pure rule module: no screen, no wiring
into the corner minute (CornerJobsRow / BoutNight are Claude's, later), no probe (TOWEL1 is a separate job).

## Contract
OWNS: scripts/rules/Towel.gd, tests/towel_test.gd
RED_TEST: tests/towel_test.gd -> TOWEL failures=0
REGRESSION: knockdowns_test, injury_roll_test, body_map_test, corner_jobs_test, file_limits_test
VISUAL: no
NOT YOURS: every other file (tools/run_tests.sh too). Read, never edit: scripts/rules/Knockdowns.gd (138 lines: round_counts 20-74,
puncher_chance 121-138, MARGIN_FACTOR line 10), scripts/rules/BodyMap.gd (205: HURT / CRITICAL / DOCTOR lines 7-10, band() 124),
scripts/rules/InjuryRoll.gd (204: KO_DAYS 12, KO_SECOND_WINDOW 13, KO_SECOND_DAYS 14), scripts/rules/Attrs.gd (408: STOP_DROP 40,
wear_stoppage 133), scripts/rules/PaceAim.gd (190: PACES line 5), scripts/rules/BoutRules.gd (337: CORNER keys line 69).

## The job: scripts/rules/Towel.gd (pure, static, under 260 lines; preloads Knockdowns, BodyMap, InjuryRoll, Attrs)
Our fighter is always side "a" in Knockdowns' terms.
1. `const LINES := {"careful": 0.12, "normal": 0.20, "brave": 0.33}` (the map's ESTIMATES; a comment names TOWEL1 as their probe) and
   `const LINE_WORDS` ("Careful", "Normal", "Brave"). `const PULL_DAYS := 14`, `const PULL_MORALE := -4`.
2. `risk(state, n := 200, seed := 1) -> Dictionary` {stop, stop_safe, lose, lose_safe}: the chance our fighter is stopped next round,
   as Box safe would make it, and the chance of losing the round each way. `state` = {sides: {a: {power, chin, heart, stop_mult},
   b: {...}}, damage: {a, b}, counts: {a, b}, p_lose: float, p_lose_safe: float, margins: {close, clear, dominant} (shares, sum 1)}.
   Run `n` seeded trials (one RandomNumberGenerator seeded with `seed`, shared in order): draw lose with p_lose; on a loss draw the
   margin from `margins` and call Knockdowns.round_counts(margin, "a", sides, damage, counts, rng) and read "stopped"; on a win call
   Knockdowns.puncher_chance("a", sides, damage, counts, rng) and read "stopped". BOX SAFE runs the same with p_lose_safe and every
   margin one band lower (`softer(margin)`: dominant -> clear -> close, close stays close). Never re-implement Knockdowns' maths.
3. `softer(margin) -> String` as above.
4. `reasons(state, line, risk_now) -> Array` of {id, words}: "count" (state.counts_last_round > 0: a count in the round just gone),
   "head" (state.head_v at or under BodyMap.CRITICAL: head damage past the critical band), "eye" (state.eye_closing true: the R28 cutman
   case; this module only reads the flag), "line" (risk_now.stop at or over LINES[line]). Empty = no card.
5. `comes(state, line, risk_now) -> bool`: reasons not empty. `coach_pulls(risk_now, line) -> bool`: when Coach corners, Coach pulls at
   the line by itself (stop at or over LINES[line]).
6. `answer(kind, ctx) -> Dictionary`: the lasting price of each answer, NOT applied (the caller applies it). ctx = {band: loyalty band
   word, day, last_stop_day (-1 when none)}:
   - "pull": {result: "retired", next_round: false, wear: false, injury_roll: false, days_out: PULL_DAYS, morale: PULL_MORALE,
     loyalty: +2 for band Settled / Loyal / Trusts you, -6 for Wavering and Leaving (the map names Settled-and-up and Wavering; Leaving
     is below Wavering and takes its -6: say so in the PR body), mark: "pulled me out"};
   - "one_more": {next_round: true, if_stopped: {wear: true, durability_drop: Attrs.STOP_DROP, days_out: InjuryRoll.KO_SECOND_DAYS when
     last_stop_day >= 0 and day - last_stop_day <= InjuryRoll.KO_SECOND_WINDOW, else InjuryRoll.KO_DAYS}, if_won_bout: {mark: "sent me
     out"}};
   - "box_safe": {next_round: true, pace: "save", call: "hands", gloves_high: true, margin: "softer"}.
   Read every number from its constant; never type 30, 90 or 2.
7. `words(risk_now, line) -> String`: "Stopped next round: 14 in 100 (Box safe: 6 in 100). Your line: 20." (rounded in 100s).

## The test FIRST: tests/towel_test.gd (extends SceneTree, prints `TOWEL failures=N`, quits with N)
RED ON MAIN: run it on main first: the preload of the missing Towel.gd fails to load. Say so in the PR body. Assert at least:
- risk() equals a loop written IN THE TEST over Knockdowns.round_counts / puncher_chance with the same seed and the same draw order
  (exact equality of the four shares), for two DIFFERENT sides built from the game's own fighters (two Data.PROSPECTS rows, deep
  copies: power and chin from each one's `stats`, heart from each one's `personality`);
- with the same seed, stop_safe <= stop (Box safe never raises the risk) on three different damage levels; risk rises with damage;
- softer: dominant -> clear -> close -> close;
- reasons: each of the four appears alone when only its condition holds (head at BodyMap.CRITICAL reads, at CRITICAL + 1 does not; the
  line at exactly LINES[line] reads); comes() false with none; coach_pulls true at the line, false just under it;
- answer("pull") has wear false and days_out 14; loyalty +2 for "Settled" and "Loyal", -6 for "Wavering" and "Leaving";
- answer("one_more") days_out equals InjuryRoll.KO_DAYS with no stop before, InjuryRoll.KO_SECOND_DAYS with a stop 60 days ago, and
  KO_DAYS again with a stop KO_SECOND_WINDOW + 1 days ago; durability_drop equals Attrs.STOP_DROP (all read in the test);
- words() holds both numbers and the line, and no pronoun;
- MUTANTS inside the test: a copy of softer that goes the wrong way and a copy of the line check with `>` in place of `>=` must each
  FAIL the same asserts; print `MUTANT caught` for each.

## Traps
- ops/research/GDSCRIPT_TRAPS.md first (typed Dictionary reads, no `:=` on a Variant, `%%` for a literal percent).
- The one trap: every trial starts from the SAME state (the round to come, not the one a previous trial played): never carry a
  trial's returned damage or counts into the next, and keep one rng whose draws happen in a fixed order (lose, margin, Knockdowns'
  own draws). The test's loop must do exactly what yours does, or the exact-equality assert cannot hold.
- Do not fit LINES to the risk you see: 0.12 / 0.20 / 0.33 are the map's numbers; TOWEL1 moves them later.
- Words: "Coach", never a surname; no pronoun in a built string. Do NOT delete or weaken any existing test.
- Write the PR body last, from the final run.

## Prior research
`python ops/Tools/prior_research.py towel` -> FIGHT_LINK_MAP_S432.md (M13, the spec), J55_THE_CORNER_BETWEEN_ROUNDS.md (what a corner may
do in the minute), topics/knockdowns_stoppage.md (the count and referee numbers behind Knockdowns.gd), CORE_LOOP_MAP_S432.md C11.

## What would a human do?
The corner's hardest call: after a count, with the eye going, the coach asks how likely the next round ends it, whether the fight is
still winnable, and what a stoppage would cost the boxer's future, then pulls out, sends out, or says "hands up, survive it".

## Prefab check
None: the risk is the game's own Knockdowns run many times; the prices are the game's own constants.

Test command: `"%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe" --headless --audio-driver Dummy --path . --script res://tests/towel_test.gd`
(the plain win64 exe, never the console one). Parse first: `--check-only` on both files.
RESULT lines for the PR body: `RESULT: tests/towel_test.gd -> TOWEL failures=0`.
