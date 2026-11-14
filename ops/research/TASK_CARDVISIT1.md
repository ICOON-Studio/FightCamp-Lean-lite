# TASK CARDVISIT1 - which cards does a played bout ever reach, and which plan lines can ever fire there? (probe, no screen)

Status: OPEN (S464, Claude main). Discipline: boxing. Model: qwen3-coder (Qwen), default.

## Why now
TREEVALUE1 (Claude rerun S464, tools/treevalue_probe.gd, docs/TREEVALUE1_RESULT.md) found 7 move-tree nodes (step_in, step_out,
roll_out, feint, cut_off, herd, push_off) that read EXACTLY the same win count at bar 0 and bar 70 - the bout never consults
them. The cause traced so far: an arrow fires only on its own card (StrikeMap row "from") at its "when" (PlanBoard.pick,
scripts/rules/PlanBoard.gd:74), and the card a 30 s exchange is fought on comes from PlanFight.GAME_CARD[sit]
(scripts/rules/PlanFight.gd:22, read at scripts/state/LiveRound.gd:262) and then PlanFight.where_next (line ~150, the move's
"to" when won, LOST_CARD when lost). "range" is fought on "long" while step_in starts from "outside", so a planned
"step_in when range" can never fire. We need the full table: per card, how often bouts reach it; per (move, when) pair from
PlanFight.ANSWERS, how often that pair could fire.

## What to build (tools/cardvisit_probe.gd; start from tools/treevalue_probe.gd on main - it parses and runs)
1. Same fighters (60 generated, seeds 7100-7159, _make_fighter), the same four opponents, the same CALIBRATED ratings step
   (copy the CALIBRATE block), 2 bouts per fighter per opponent, all step/defence bars at 45, BASE plan = treevalue's PLAN.
2. After every exchange record lv["at"] and the situation `sit` the bout used. Do NOT edit scripts/: read them from the
   match dict the bout already keeps (m["rounds"] / the exchange records - find where LiveRound stores each exchange's
   "at" and "sit"; if they are not stored, re-derive them in the probe by calling PlanFight.GAME_CARD / where_next exactly as
   LiveRound does, and say so in the result).
3. Print a table: card x situation counts (share of all exchanges), per opponent style.
4. For every move in PlanFight.ANSWERS (each situation's best and ok lists, base ids), print `REACH <move> <sit> <share>` =
   the share of exchanges whose card == StrikeMap.move(move)["from"] AND whose sit == that situation. Mark NEVER at 0.
5. CONTROL: the same seeds twice give identical tables; and a mutant arm that forces lv["at"] = "outside" on every exchange
   (a local copy of the loop, never in scripts/) must show step_in REACH > 0 (the instrument can read a reach).
6. Write docs/CARDVISIT1_RESULT.md FROM THE RUN (the probe's own _write_result_doc), never typed by hand.

## Pass lines (print each with yes/no)
- every card in StrikeMap ("outside", "long", "mid", "inside", "clinch", "own_ropes", "opp_ropes", "corner") reached >= 1 in 100
- every ANSWERS "best" pair REACH >= 1 in 100 (list those that fail)
Final line: `CARDVISIT never_cards=<list|none> never_best=<n> pairs=<list>`.

## Contract
OWNS: tools/cardvisit_probe.gd, docs/CARDVISIT1_RESULT.md
RED_TEST: tools/cardvisit_probe.gd -> CARDVISIT never_cards=
REGRESSION: plan_bout_test, fire_level_test
VISUAL: no
NOT YOURS: every file in scripts/ and tests/ (read-only). Report a card no bout reaches; never change a rule.
Runs only through `python ops/Tools/godot_slot.py run --who cardvisit1 -- <godot> --headless --audio-driver Dummy --path . --script res://tools/cardvisit_probe.gd`.
Under 500 lines. PR body: `RESULT: tools/cardvisit_probe.gd -> CARDVISIT never_cards=<...> never_best=<n> ...`.

## Prior research
docs/TREEVALUE1_RESULT.md, docs/NODEREAD1_RESULT.md, tools/treevalue_probe.gd, tools/noderead_probe.gd; scripts/rules/PlanFight.gd,
PlanBoard.gd, StrikeMap.gd, scripts/state/LiveRound.gd:240-280, LiveRoundAfter.gd:44 (read-only). S450 lesson: a probe that
reads the same in both arms is void - that is why the mutant arm must move a number.

## What would a human do?
A coach watches tape and counts where the fight is fought: if a fighter is never at range, a range plan is wasted paper.

## Prefab check
None: the probe reuses the game's bout.

## The one trap
Typing the result page or inventing columns the probe never writes (NODEREAD1, KNOWBOTS1 did). Claude reruns on the same seeds
and diffs the page.

## Static check (Claude S464, before the run): best answers whose own card differs from the card the situation starts on
press (mid): pivot_out(own_ropes), roll_out(inside), 1-1(long) | range (long): step_in(outside), 1-1-2(outside), 3b-3(mid) |
counter (long): feint(outside), 1-1-2(outside) | loadup (mid): roll_out, tie_up (inside), 1-1(long) | tiring (inside): 1-2-3-2,
1-2-3, cut_off (long), 3b-3(mid), herd(opp_ropes) | hurt (opp_ropes): 1-6-3, 3b-3 (mid), 1-2-3-2, cut_off (long) |
she_tired (inside): step_back(mid), step_out, 1-1 (long) | she_hurt (own_ropes): tie_up, roll_out (inside), step_out(long).
The card chains between exchanges (where_next), so some of these are still reached - the run says which, and how often.
"outside" is entered only through step_out / feint (their "to"), so step_in, feint and 1-1-2 may be unreachable in practice.
