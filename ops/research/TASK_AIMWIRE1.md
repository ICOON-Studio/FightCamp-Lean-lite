# TASK AIMWIRE1 - QWEN (qwen3-coder) - the aim buttons: rib targets that never appear, a body bonus that never fires, and what a fight's tiredness does to a year

Model: qwen3-coder
Discipline: boxing (the demo).

## The operator's words (S429, S430)
"hits never go to the ribs ?" and, on the Pace and Aim buttons: "do these affect anything , they take effect immediately or how they work ?"

## Contract
OWNS: scripts/state/LiveRound.gd (only the two places named below), tests/aim_wire_test.gd (new), tools/fight_toll_probe.gd (new), docs/AIMWIRE1_RESULT.md (new)
RED_TEST: tests/aim_wire_test.gd -> AIM_WIRE failures=0   (it must print failures > 0 on today's main first: prove it red, paste both runs)
REGRESSION: pace_aim_test, exchanges_test, corner_bar_test, golden_path_test, balance_harness_test
VISUAL: no
Run one test: `python ops/Tools/godot_slot.py run --who qwen -- "%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe" --headless --audio-driver Dummy --path . --script res://tests/<name>.gd`
Parse first (a parse error hangs a headless test): the same command with `--check-only --script res://<file>`.

## What is wrong today (read on main, S430)
`scripts/rules/PaceAim.gd` is right and tested; the live round does not feed it:
1. RIB TARGETS NEVER APPEAR. `LiveRound.preview` (about line 171) builds the aim buttons with
   `PaceAim.offers({"head": bool(lv["opp_hurt"])})`, and `LiveRound.exchange` (about line 218) passes
   `var opp_hurt := {"head": bool(lv["opp_hurt"])}`. Nothing ever sets `left_ribs` or `right_ribs`, so "Left ribs" and
   "Right ribs" can never be offered, their +4 edge and x1.3 damage can never fire.
2. THE BODY BONUS NEVER FIRES. Line about 256: `PaceAim.edge(pace, aim, opp_hurt, {})`. The last argument is the
   opponent's burn ({"core": x, "legs": y}); passed empty, so "body aim against an opponent whose core or legs are at 50
   or more" (+3) never applies.

## The job
A. Find where the opponent's hurt places and burn already live during a live round, on the path the GAME runs (not a
   guess): the 3D view keeps a body map (`scripts/rules/BodyMap.gd`, places left_ribs / right_ribs, HURT at 55) and a
   burn track (`scripts/rules/BodyTrack.gd`, `scripts/rules/BoutBurn.gd`); the words-mode round has `lv["body"]` (body
   shots landed each way) and the opponent's energy. Decide ONE source that exists in BOTH a watched round and a round in
   words, and say which and why in the result page. If no such source exists for the ribs, derive it in the rules from
   the body shots landed on the opponent this bout (state the rule and the number; a side is hurt when it has taken N).
B. Feed both into `LiveRound.preview` and `LiveRound.exchange` so the two rules above can fire. Change nothing in
   `PaceAim.gd`'s numbers. `LiveRound.gd` is 469 lines: stay under 500 (move a helper to a new small file if needed).
C. `tests/aim_wire_test.gd`: on the game path (build a bout the way `tests/pace_aim_test.gd` / `tests/exchanges_test.gd`
   do, two DIFFERENT fighters), prove (1) after enough body work on one side the aim list offers that side's ribs,
   (2) aiming there then wins the edge PaceAim promises, (3) body aim against a burned opponent gets the +3, (4) a fresh
   opponent gets none of it. Red on main first.
D. MEASURE what the change does to balance: `tools/exchange_balance.gd` (the existing harness, 400 bouts a plan) before
   and after, for "own game", "body all fight", "head all fight" and "body then the hurt ribs". Report the win shares.
   If "body then ribs" beats every other plan by more than 5 wins in 100, say so and propose the smaller number: do not
   tune it yourself.
E. SECOND MEASUREMENT, no game file changed: `tools/fight_toll_probe.gd`. S430 added a rule: a fight now leaves
   tiredness (`scripts/rules/Aftermath.gd` `toll`: 45 on a full tank, +0.5 for each point of tank missing at the final
   bell, +10 for a stoppage loss, never under what the boxer walked in with, at most 95), booked in
   `scripts/state/AfterFight.gd` `book`. Play 52-week careers the way `tools/money_four_probe.gd` does (same sensible
   player, four fighters, one stipend), 10 careers a cell, same seeds: cell TODAY (the rule as it is) and cell OFF (set
   `f["week_fatigue"]` back to its pre-fight value right after each fight, inside the probe only). Report medians: real
   bouts a year (count ticket-cut ledger lines; do NOT add w + l, the four arrive with 18 bouts already boxed), win share,
   training injuries, days spent over 80 tiredness, mean tiredness on fight day. One sentence: does the rule change what
   the sensible player's year looks like, and is a boxer ever sent into the next bout still tired from the last?

## Result page (docs/AIMWIRE1_RESULT.md)
The source chosen in A and why; the red and green runs of the test; the two balance tables; the toll table; what you could
not measure. Name the population in every table. Check your own sums against the ledger before you write them.

## Prior research
- `python ops/Tools/prior_research.py aim ribs body pace` before you start.
- `docs/AMATEURPROBE1_RESULT.md` (the S430 correction block: how a bout count went 18 too high) and
  `docs/MONEYFOUR1_RESULT.md`.
- S323 balance check in `PaceAim.gd`'s header (save -4 / +6 came from 400 bouts a plan).

## What would a human do?
A corner that sees the other boxer wince on one side sends every body shot there, and goes downstairs harder once the legs
have gone. The game already has both rules written; this task only connects the wires and measures that neither becomes
the one right answer.

## Prefab check
Nothing to fetch: every rule and harness named here is in the repo.

## The one trap
A test that builds its own hurt map in memory and never goes through `LiveRound` proves nothing (that is exactly how the
rule stayed dead: `pace_aim_test` is green while the game never calls it with ribs). The test must drive
`LiveRound.preview` and `LiveRound.exchange`.

End the PR body with `RESULT: tests/aim_wire_test.gd -> AIM_WIRE failures=0` and
`RESULT: tools/fight_toll_probe.gd -> FIGHT_TOLL careers=20 (measure only)`.
