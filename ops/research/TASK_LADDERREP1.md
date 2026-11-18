# TASK LADDERREP1 - the season ladder's pure rules: reach, points won/lost, greyed rows, "will they say yes", the clock

Status: OPEN (S515, Claude main line). Discipline: boxing. Model: qwen3-coder (or any seat that runs Godot).
Source: season ladder v6, owner's yes on the board (Q-S294-270: "Yes, build it"). Map: ops/research/DESIGN_LADDER1_V6_DOLA.md
lines 1047-1164 (Part 1, rules R1-R10). Summary: ops/research/APPROVE_LADDER1_V6_S514.md. A PURE module + its test:
Claude wires the screen (Fights > Who do we fight?) and the state after this lands.

## Contract
OWNS: scripts/rules/LadderRep.gd, tests/ladder_rep_test.gd
RED_TEST: tests/ladder_rep_test.gd -> LADDER_REP PASS
REGRESSION: world_ladder_rules_test, rank_line_test
VISUAL: no

## Prior research
`python ops/Tools/prior_research.py ladder rep reach`. Read the map lines above (the rules, word for word), then
scripts/rules/WorldLadderRules.gd and scripts/rules/RankLine.gd (today's ranking, by net wins - do NOT change them; this
module stands beside them). ops/research/GDSCRIPT_TRAPS.md.

## What would a human do?
A club secretary keeps a points table like chess Elo: beating a better boxer pays more, losing to a worse one costs more;
you can challenge a bit above your level, and an idle boxer slowly drops.

## Prefab check
Elo is public maths; no library needed. Write it from the map's formula.

## The job: scripts/rules/LadderRep.gd (extends RefCounted, no preloads, every func static, under 250 lines)
1. `reach_up(rep: int) -> int` = 10 + floor(rep / 5) (R2). `in_reach(my_rep, their_rep) -> bool` (any distance down is
   allowed). `far_below(my_rep, their_rep) -> bool` = they are 20+ below (the WON'T STOP THE CLOCK chip).
2. `expected(my_rep, their_rep) -> float` = 1 / (1 + 10^((their - my) / 25)) (R3).
   `change(my_rep, their_rep, result: String, method: String) -> int`: result "win"/"loss"/"draw"; method "ud"
   (weight 1.0), "split" 0.5, "majority" 0.65, "stop" 1.15 with +2 bonus each way. Win = +round(16*(1-exp)*w),
   loss = -round(16*(1-exp)*w)... use the map's table as the truth: at gap 0 win +8 / loss -8; gap +10 (they are 10
   above) win +11 / loss -5; gap -10 win +5 / loss -11; +20 -> +14/-2; -20 -> +2/-14 (unanimous). Loss magnitude uses
   the expected of the LOSER's side so the table holds. Draw = round(8 * (0.5 - exp)) (never more than a gap-0 win).
   `apply(rep, delta) -> int` clamps to 0..100.
3. `price(my_rep, their_rep) -> Dictionary` (R4): {rep_win, rep_loss, members_win = max(2, min(12, rep_win)),
   members_loss = -1, standing_win = max(1, min(8, rep_win / 2)), standing_loss = -2, ticket = 450,
   morale_win = floor(4 + 6 * (1 - exp)), morale_loss = -12}. No travel line (no venue data: CHECK in the map).
4. `grey(flags: Dictionary) -> Dictionary` (R5) -> {"askable": bool, "status": String} in the map's order: OUT OF REACH,
   BOOKED, RESTING, NATIONALS, NOT SAFE, CLUBMATE, TWICE THIS SEASON, TOO HEAVY, SEASON CAP (18 bouts). Input flags are
   plain booleans/ints the caller computes (out_of_reach, booked, resting, nationals, novice_vs_open, clubmate,
   met_this_season, too_heavy, bouts_this_year). Status words exactly as the map writes them.
5. `yes_score(f: Dictionary) -> Dictionary` (R6) -> {"score": int, "yes": bool, "biggest": String}: base 50; their odds
   +floor((their_expected_pct - 50) / 2); protecting -30 (only when their expected < 60 %); my hot streak -20 when they
   rank 0-8 above; their idle weeks over 6: +3 a week, max +15; last meeting they won +10 / they lost -10; temperament
   careful -10 / normal 0 / bold +10; clamp 5..95; yes = score >= 50; `biggest` = the name of the factor that moved the
   score most (a No always names it). No home/away factor (no venue data). Deterministic: no random anywhere.
6. `clock(free_weeks: int, rep: int) -> int` (R8): the Rep lost to idleness so far = 0 for up to 8 free weeks, then -1
   every 2 weeks after; at rep >= 55 the pro rule: -1 every 4 weeks unbooked. Return a negative int or 0.
A `## why` header names the map lines each func comes from.

## tests/ladder_rep_test.gd (SceneTree, headless)
Every row of the map's R3 table (5 gaps x win/loss), the draw cap, the weights (split < majority < ud < stop), clamp at 0
and 100; reach at rep 0/38/55 = 10/17/21; price at gap 0; every grey status in order (two flags set -> the earlier one
wins); yes_score: a base case, the bounds 5 and 95, each factor moves it the stated amount, the biggest factor named,
the same input twice -> the same answer; clock at 8, 10, 12 weeks and the pro rate. Last line `LADDER_REP PASS` (or FAIL n).

## Rules for this seat
Godot only through godot_slot, headless, `--audio-driver Dummy`, `--log-file E:/FightCamp/tmp/<run>.log`. No screens.
Nothing outside OWNS; never touch scripts/fight3d/.

## The one trap
The map's formula line and its table disagree on the loss side if you use one expected for both; THE TABLE IS THE TRUTH
(gap +10: lose only 5). Test every table row exactly.
