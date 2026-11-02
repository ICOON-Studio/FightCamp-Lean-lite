# TASK FIGHTLINK2B - drilled punches get thrown more (select_mult), camp sharpness proven, windup traced

Model: Arena (cloud, FightCamp-lite). Discipline: BOXING (demo).

## Why (operator S274: "should not those be in the fight engine ?" - yes: FIGHTLINK step 2 was approved S248 "Go")
FIGHTLINK2 (S250, bd50b9fb) wired a punch's mastery into the bout's recovery / power / stamina / telegraph
(FightRealtime ~1876-1890 builds `state[side].mm_eff[technique]` from `rules/MoveMastery.effects`; the telegraph is read at
~6663-6665). Two of MoveMastery's outputs are read by NOTHING (Claude S274, grep): `select_mult` (a drilled punch is chosen
more often) and `windup` (`_raw_windup`, time before the punch lands). S251 also measured camp sharpness's "+10% execution
speed" (operator Q-S249-2) as not moving the bout; code now sits at ~6258 (`bw_rec`) and ~6666 - never re-measured.

## What to do
1. SELECT_MULT INTO PUNCH CHOICE. Find where the bout builds the technique `weights` for `FightMoves.select`
   (Godot/scripts/FightMoves.gd:512; the caller is in FightRealtime.gd - 10,231 lines, use `grep -n` + `sed -n` windows, never
   read it whole) and multiply each technique's weight by that side's `mm_eff[technique].select_mult` when `state.move_mastery`
   is set. Rules: NO new RNG draw (FightMoves header: one roll, joint walk); a technique with no mastery entry or at USABLE 45
   is exactly 1.0 (today's bout byte-identical); boxing only; respect ROLE_PRIORITY two-stage selection (apply the mult in
   stage 2, inside the chosen role, so the plan's primary/secondary ratio is not diluted).
2. CAMP SHARPNESS - MEASURE, THEN FIX IF INERT. A/B over >= 200 seeded boxing bouts (two DIFFERENT fighters, stats differ,
   population named in the output): readiness 0 vs 1 (the athlete field the code reads - `gameplan_readiness` / `bw_rec`). Report
   punches thrown per minute, landed %, slip %. If the difference is within noise, trace what gates the throw rate
   (S251 note: FightMoves.throw_share inputs) and apply the +10% there, red test first.
3. WINDUP - TRACE ONLY. Report whether the engine has any per-throw time quantity windup should scale (a reaction/slip window,
   the counter window, the next-decision delay). If one exists and is not already scaled by `telegraph` (do not count the same
   effect twice), propose the exact line and expected effect in the PR body; do NOT build a new phase.

## Tests (pure sim, no LFS - runs in CI)
- NEW `Godot/tests/mastery_select_wire_test.gd`: a fighter with jab mastery 90 vs the same fighter at 45 (everything else
  equal - a CONTROL arm: the only difference is mastery) over N seeded bouts throws the jab more often by a bounded margin
  (>= 5 % relative, no exact count); at 45 the choice stream is byte-identical to master (determinism tripwire). RED on master.
- `fight_sharp_edge_test`: add the A/B of part 2 if it changes code; else report the numbers only.
- Regression: mastery_wire_test, move_mastery_test, fightlink_wire_test, bout_wear_wire_test.
Parse gate: `python Godot/tools/check_scripts.py <touched .gd>`. PR body: `RESULT: tests/mastery_select_wire_test.gd -> <pass line>`.

## Owned files
Godot/scripts/FightRealtime.gd (the weights call site only), Godot/scripts/FightMoves.gd (only if the mult must enter select),
Godot/tests/mastery_select_wire_test.gd (new), Godot/tests/fight_sharp_edge_test.gd.

## Prior research
S250_DIGEST.md (FIGHTLINK2 + "Not wired yet: windup, select_mult, weekly decay"), S251_DIGEST.md (sharpness measured inert),
rules/MoveMastery.gd (the numbers - Ludo r116), FIGHTLINK verdicts on the board (Q-S249-2/3).

## What would a human do?
A boxing coach: "the punch he drilled all week is the one he reaches for under pressure" - the same man, more of that punch.

## Prefab check
n/a.

## The one trap
Never add a second random draw or change the plan's role ratio - every seeded bout without mastery must stay byte-identical.

## Contract
OWNS: Godot/tests/mastery_select_wire_test.gd, Godot/scripts/FightRealtime.gd
RED_TEST: Godot/tests/mastery_select_wire_test.gd -> MASTERY_SELECT failures=0
REGRESSION: mastery_wire_test
VISUAL: no
