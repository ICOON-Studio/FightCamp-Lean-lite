# COACHDEEP9 - coaches v9: v8 plus the three changes its probe named, the same seven bars, and a STOP RULE (S544)

Kind: design + probe. Model: claude-opus-5-5 (console tab). Commit only your paths (`git commit -m "..." -- <files>`), do
not push. Godot only through `python ops/Tools/godot_slot.py run --who COACHDEEP9 -- <cmd>` (headless, Dummy audio), ONE
run at a time, output to a file, wait on its done line (a killed waiter leaves Godot running: check by PID). Before each
run: `powershell -NoProfile -ExecutionPolicy Bypass -File ops\Tools\pc_watchdog.ps1 -Once`; RED = wait; the owner's game
(ArcheAge) in the top list with memory AMBER = wait. Other workers share the Godot queue.
Estimate: 1.5-2 hours (the probe exists: v8's full run took 29 minutes). Run the FULL size (100 careers a cell per arm)
before any verdict.

## Why
Coaches v7 is the owner's design (`ops/research/COACH_INTERVIEW_S542.md`, 17 answers). v7 failed 4 of 7 (bars 1, 3, 5);
v8 (`docs/COACHDEEP8_RESULT.md`, read sections 1, 3, 4, 7) fixed bar 5 and failed 4 of 7 again (bars 1, 2, 3). Two of the
three failures are not the design: bar 1 is one card priced against the owner's own rule (Q17 "wages scale with
ratings"), bar 2 is the probe's careful line punishing itself. Bar 3 is the design: two of the three forced moments have
one answer best in 8 of 10 cells in BOTH versions. This is the last round on numbers. Map: copy
`ops/research/DESIGN_COACHDEEP8.md` to `DESIGN_COACHDEEP9.md`, changes marked "v9:"; bars s10 unchanged and committed
before any run. Probe: copies of v8's files (`tools/coachdeep9.gd`, `tools/coachdeep9_rules.gd`, `tools/coachdeep9_sum.py`;
v8's stay untouched). Nothing under scripts/ or tests/ changes.

## The three changes (v8 result, section 7; nothing else moves)
1. ONE WAGE RULE FOR EVERY CARD (bar 1; grill Q17). A coach's wage band comes from the ratings that pay (teaching and
   pads first), by one written formula applied to all five cards. The best class teacher in the town is never the
   cheapest card. Write the formula on the map, print each card's wage before and after, and say which cards moved.
   Do NOT hand-tune a single card: if the formula leaves L cheapest and best, say so and change the formula's weights,
   not L.
2. THE CAREFUL LINE READS WHO WOULD CARRY THE WARNING (bar 2; map s12, a change to the probe's bot, not to the game).
   It allows a style push from the coach who coaches most of the club's boxers (refusing costs every one of them a
   season) and refuses only a coach with few boxers. Say plainly in the result that this is the bot's policy: the rule
   a player could say in one sentence.
3. A STANDING WARNING DRAINS LOYALTY (bar 3; interview 15 "two warnings", interview 3). While a warning stands, the
   warned person loses about 1 loyalty a week until it fades (26 weeks) or a second warning comes. So the answer to a
   falling-out or a push depends on WHO sits lower against the leaving line (25): the pop-up shows both people's
   loyalty and how many weeks each would last. Start size -1 a week, an ESTIMATE to tune inside 0.5-2; the cap: a
   warning alone never takes anyone under the line in fewer than 8 weeks (the player must have time to act).

## THE STOP RULE (written before the run; the coordinator applies it, you report against it)
- PASS 7 of 7 -> write `ops/research/CRITIC_COACHDEEP9_BRIEF.md` (opens with `ops/research/CRITIC_PACK.md` and
  `ops/research/CRITIC_ACCESS.md`; the game, the rules and the probe's numbers, never our opinion or an earlier score;
  DEPTH and PLAY out of 10, the bar is 8 on both; missing and useless options; the list to reach 10; the critic's 10/10
  as a 1920x1080 HTML page), queue it for kalli and dola (`python ops/Tools/seat_queue.py add --seat <seat> --brief
  research/CRITIC_COACHDEEP9_BRIEF.md`), and say a code-checked critic is owed.
- Bar 3 FAILS AGAIN on the falling-out or on the style push -> that moment is NOT a player decision. Do not propose a
  v10. In the result, write "THE CUT" for each failing moment: what the game does by itself instead (the answer that
  was best in most cells, as a rule), what the player still sees (one news line), and re-score bars 1, 2, 4, 5, 6, 7
  with that moment played by the rule in every arm (a second full run: `cut=fallout`, `cut=push` or both). Report both
  tables. A coach game with the hire, the trial week, the raise and the corner pick, each a real call, is the target;
  a forced moment with one right answer is not worth a pop-up.
- Bar 1 or 2 fails again -> the one number or policy line that fails, and stop. No tuning beyond the ranges above.

## Feedback loops
- Warning -> loyalty down -> nearer the line -> the person leaves -> the club is weaker -> more losses -> more moments.
  Cap: -1 a week, never under the line inside 8 weeks, one push a boxer a season, months with two moments stay 0
  (v8 bar 7). Print people lost per career, cost on and off (v8's control arms), and STOP if the careless line loses
  over 3 people a career in any cell or the careful line over 1.
- Loyalty drain -> the answer follows loyalty -> the same person is backed every time -> the other one always carries
  the warning -> leaves. Print, per cell, how often each person is the one warned; STOP if one person carries over 80%
  of a career's warnings in more than half the cells.
- The wage formula -> wages up -> cash down -> the cheapest card best again. Print cash at the end per arm; bar 7's
  range holds (no arm under -$40k).
- Everything v8 capped stays capped (members at the catchment, name fees, bond, chemistry).
- ONE-REP TRIAL FIRST, printed in full: STOP and fix the map if every cell picks the same hire, if a moment's answers
  differ by under 0.5 lines in every cell (the change did nothing), or if a bar v8 passed fails in the trial.

## Carry into the result (for the build, unchanged from v8 section 6)
The game's win read ignores the corner coach (`BoutRead.chance`: the coach argument is dropped when the boxer has a plan;
`_call` is `auto_corner`). The corner pick's build step must wire it. Repeat the four points in your result.

## Prior research
`docs/COACHDEEP8_RESULT.md`, `docs/COACHDEEP7_RESULT.md`, `ops/research/COACH_INTERVIEW_S542.md` (the owner's 17 answers:
every change must sit inside them - quote the answer each change stands on), `ops/research/DESIGN_COACHDEEP8.md`,
`ops/research/topics/` page on staff if `python ops/Tools/prior_research.py coach wage loyalty warning` lists one.

## What would a human do?
A gym owner backs whoever the club can least afford to lose, and knows who that is before the row starts: the head
coach with one foot out of the door is backed; the prospect who is already unhappy is backed. If the game cannot show
who is closer to leaving, there is nothing to weigh.

## Prefab check
None (our own modules; v8's probe files are the starting code).

## Contract
OWNS: ops/research/DESIGN_COACHDEEP9.md, tools/coachdeep9.gd, tools/coachdeep9_rules.gd, tools/coachdeep9_sum.py, docs/COACHDEEP9_RESULT.md, ops/research/CRITIC_COACHDEEP9_BRIEF.md
RED_TEST: tools/coachdeep9.gd
REGRESSION: none
VISUAL: none

Do not ask questions: decide, and write what you decided in the result.
