# TASK R29JUDGES1 - ARENA - THE JUDGES: three cards scored like judges, each with a lean, 10-8 for a count, a running card and one reason (one pure module + its test)

Status: OPEN (S440, Claude main). Discipline: boxing. Model: Arena, the strongest code model offered in a NEW chat for this task.
Mechanic: R29 "Scorecards after each round" (critics 6/7 and 5/7, average 6.25) and it feeds R30 "the Why screen" (7.25), both in
ops/research/MECHANICS_BUILD_STATE_S440.md; the critics asked for it again in ops/research/RESULT_PAGE_CRITICS_S439.md. Source:
ops/research/FIGHT_LINK_MAP_S432.md M2 THE JUDGES (lines 200-226: READ IT FIRST, it is the spec) and section 9's Judges row. The map
passed two critics at 7 and 7. Today the cards come from rounds won only (scripts/rules/BoutRules.gd scorecards 244 and cards_of 259):
no judge sees ring control, a count or a big shot. THIS task is only the pure rule module: no wiring into BoutNight (Claude, later),
no Officials rule (who you know), no probe (JUDGES1 is a separate job that will set the weights).

## Contract
OWNS: scripts/rules/Judges.gd, tests/judges_test.gd
RED_TEST: tests/judges_test.gd -> JUDGES failures=0
REGRESSION: bout_rules_test, fight_stats_test, file_limits_test
VISUAL: no
NOT YOURS: every other file (tools/run_tests.sh too). Read, never edit: scripts/state/LiveRound.gd (456 lines: the exchange record is
built at lines 345-372; perks 222-310, "counter_sense" at 308), scripts/rules/Duels.gd (488: LONG 0, POCKET 1, INSIDE 2 at lines 9-12:
a higher place is closer), scripts/rules/BoutRules.gd (337: scorecards 244, cards_of 259), scripts/rules/Exchanges.gd (372: round_of
317).

## What one exchange record holds (LiveRound, side "a" = our fighter, "b" = the opponent)
won (bool, for a), margin, landed [a, b], setup ("landed" when a's set-up landed), read (Dictionary; result "landed" when a's Read
landed), perks (Array; "counter_sense" = a's counter landed), after {hurt: [a, b]} (hurt after this exchange), place (int, Duels),
wa / wb (the place each side wanted), pace. Build these by hand in the test; never load a scene.
A ROUND passed to this module is {exs: [records], counts: [a, b] (standing counts suffered this round), pace: [a, b] (pace dial 0-100,
for professional WORK)}.

## The job: scripts/rules/Judges.gd (pure, static, under 300 lines, zero preloads; numbers it needs from Duels are named consts with a
comment pointing at Duels)
1. `const PARTS := ["clean", "big", "ring", "initiative", "work"]`; `const AMATEUR_LEANS := ["clean", "ring", "initiative"]`;
   `const PRO_LEANS := ["clean", "ring", "work"]`; `const WEIGHTS` (the map's ESTIMATES, a comment names JUDGES1): clean 1 a landed
   punch; big 2 for each big shot; ring 1 an exchange; initiative 1 a forward exchange won; work = pace gap / 10 to the busier side;
   `const LEAN_MULT := 2.0` (the lean doubles its part).
2. `parts(round) -> Dictionary` {clean: [a, b], big: [a, b], ring: [a, b], initiative: [a, b], work: [a, b]}:
   - clean: the sum of landed;
   - big: for a: each exchange with setup "landed", read result "landed", "counter_sense" in perks, or after.hurt[1] turning true
     (false in the exchange before); for b: after.hurt[0] turning true;
   - ring: an exchange where a won AND place == wa gives a 1; where a lost AND place == wb gives b 1;
   - initiative: an exchange whose place is closer than the exchange before (the first compares with Duels LONG) is a FORWARD exchange;
     it goes to the side whose want was that place and who won it;
   - work: (pace a - pace b) / 10 to the busier side, 0 to the other.
3. `panel(seed, pro: bool) -> Array` of 3 lean words, each judge drawn independently from its set with one RandomNumberGenerator seeded
   with `seed` (repeats allowed: a panel can be two ring judges).
4. `score_round(parts, lean, counts, pro, names) -> Dictionary` {a, b, reason}: each side's total = sum of its parts (initiative only
   amateur, work only pro) with the lean's part x LEAN_MULT; the higher total gets 10 and the other 9; a LEVEL total goes to the side
   ahead on the lean's part, then on clean, then to the side that won the last exchange. Counts: each count suffered takes one more
   point off that side on EVERY card (one count 10-8, two 10-7; counts on both sides cancel one for one). `reason` names the part
   that decided this card's round in plain words with the two names ("Ring: Priya kept the pocket"; "Clean: Lucy landed 9 to 6";
   "Count: Lucy took a count").
5. `cards(rounds, leans, pro, names) -> Dictionary` {cards: [[a, b], [a, b], [a, b]], by_round: [[{a, b, reason} x3], ...],
   running: [[[a, b] x3] after round 1, after round 2, ...], verdict: "unanimous" / "split" / "majority" / "draw", winner: "a"/"b"/""}.
6. `card_reason(c, judge) -> String`: the ONE reason for a judge's card (the round reason that moved most points their way), for the
   result page's three cards.

## The test FIRST: tests/judges_test.gd (extends SceneTree, prints `JUDGES failures=N`, quits with N)
RED ON MAIN: run it on main first: the preload of the missing Judges.gd fails to load. Say so in the PR body. Hand-build rounds (every
round different; never two identical rounds compared). Assert at least:
- a round where a lands more and nothing else differs gives 10-9 to a on all three cards whatever the leans;
- a close round where b out-landed a by 1 but a kept the place it wanted and won 4 of 6 goes to a on a "ring" card and to b on a
  "clean" card (the lean decides, as the map says);
- one count on a: 10-8 to b on every card even when a won the parts; two counts 10-7; one count each: 10-9 by the parts;
- a level total goes to the lean's side; forward exchanges count only when won by the side that wanted the closer place;
- big shots: a landed set-up, a landed Read, counter_sense and a fresh hurt each add WEIGHTS.big; a hurt that was already true the
  exchange before adds nothing;
- panel: the same seed gives the same three; an amateur panel never holds "work", a pro panel never "initiative";
- cards over three rounds: running totals add up round by round; a 2-1 fight with one close round can read "split" with mixed leans and
  "unanimous" with three clean leans; every reason holds a name and no pronoun;
- MUTANTS inside the test: a copy of score_round that forgets LEAN_MULT and a copy that ignores counts must each FAIL the same asserts;
  print `MUTANT caught` for each.

## Traps
- GDScript 4: type every Dictionary read; `:=` on a Variant is an error here; `%%` for a literal percent.
- The one trap: the judges must stay a READ of the exchanges, never a second fight model: no randomness inside scoring (only the
  panel draw), no number taken from outside the round you were given.
- A test that only your own function can pass is not a test: each expected card is summed in the test from the records you built.
- Do NOT delete, skip or weaken any existing test. No .res/.glb/scene loads (the public mirror has no LFS assets). Do not touch CI.
- Write the PR body last, from the final run.

## Prior research
`python ops/Tools/prior_research.py judges scorecard` -> topics/scoring_results.md (10-point must, 10-8s, and the open defect that the
three judges never disagree), J1_ORGANIZATION_RULES_AND_JUDGES.md (amateur criteria: quality blows, domination, competitiveness;
professional: clean punching, ring generalship, effective aggression), FIGHT_LINK_MAP_S432.md M2 (the spec).

## What would a human do?
A judge scores each round on its own: who landed the cleaner punches, who controlled the ring, who took the fight to the other; a
standing count is a 10-8. Judges weigh those differently, which is why close fights split. A coach who knows the judges boxes for them.

## Prefab check
None: arithmetic over the exchange records. BoutRules.cards_of shows the house style for a verdict from rounds.

Test command: `godot --headless --audio-driver Dummy --path . --script res://tests/judges_test.gd` (on the PC: the plain
`%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe`). Parse first: `--check-only` on both files.
RESULT lines for the PR body: `RESULT: tests/judges_test.gd -> JUDGES failures=0`.
