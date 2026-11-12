# TASK R73DEAL1 - ARENA - the club week's coach hours: pad places, coached mornings, Coach's evenings as pads or a class, and who goes short (one pure module + its test)

Status: OPEN (S440, Claude main). Discipline: boxing (the three boxers' week; Ana's mat is outside this module).
Model: Arena, the strongest code model offered in a NEW chat for this task.
Mechanics: R73 "Coach-hours timetable" (critics 8/7 and 7/5, average 6.75) and R55 "Two fighters, one coach: who gets the pads" (8/8
and 6/5, 6.75), both in ops/research/MECHANICS_BUILD_STATE_S440.md. Source: ops/research/CLUBWEEK_MAP_V41_S432.md section 3.1 (lines
65-78: what is short, all in ONE unit, fighter-sessions) and 3.1a (lines 79-87: Coach's evenings, pads or a second class): READ BOTH
FIRST, they are the spec; section 3.2's last paragraph (lines 100-104: "Coach deals it") and 8 (SHORTWEEK1). The club week map passed two
critics at 7 and 7. Nothing of it is built. THIS task is only the pure rule module: no screen (it waits for the four-fighter start,
FOURSTART1), no wiring into PadWeek or WeekPlan (Claude, later), no loyalty change (the module returns the causes; Loyalty.gd moves the
number).

## Contract
OWNS: scripts/rules/ClubDeal.gd, tests/club_deal_test.gd
RED_TEST: tests/club_deal_test.gd -> CLUB_DEAL failures=0
REGRESSION: dues_wire_test, gym_bills_test, evenings_test, file_limits_test
VISUAL: no
NOT YOURS: every other file (tools/run_tests.sh too). Read, never edit: scripts/rules/DuesLevers.gd (188 lines: CLASS_WEEKLY line 20),
scripts/rules/GymBills.gd (112: runway_weeks 62), scripts/rules/PadWeek.gd (482: today's pad nights, USUAL_PADS 57: read for the
current week, do not copy its timing).

## The week this module deals (input) - decided
`week` = {fighters: [{id, pads: n asked, mornings: [session ids asked, one per morning], loyal: bool, bouts: int, first: bool (a talk's
"give the pad place back": dealt first), short_last_week: bool, fight_week: bool, target_day: int (the season target's date, -1 none)}],
evenings: [3 words, "pads" or "class", Coach's three], own_evening: "pads" or "class", holder: fighter id or "", cash: int, net: int}.
How many each fighter ASKS is computed elsewhere; this module gives the map's asks as constants for that caller: `const ASK := {ordinary:
3, fight_week_extra: 2, trial: 1, film: 2, talk: 1}` (CLUBWEEK 3.1).

## The job: scripts/rules/ClubDeal.gd (pure, static, under 320 lines; preloads DuesLevers and GymBills)
1. Pad places: each Coach evening on "pads" gives 2 pad places; your own evening on "pads" gives 2; all pads = 8. A Loyal holder
   (`can_hold(f)`: loyal and 6 or more bouts) adds 1 more pad place to the pool, worth 0.7 to whoever takes it, and the holder's own
   evening is spent holding (the holder's row reports `holding: true`). `const NTH_VALUE := [1.0, 1.0, 1.0, 0.7, 0.5]`: a boxer's 4th
   and 5th pad place still pay, at 0.7 and 0.5; a 6th is never dealt.
2. Class nights: `class_cash(n) -> int` = n x round(DuesLevers.CLASS_WEEKLY / 3.0) (the map's $117, READ from the code, never typed);
   `class_members_4w(n) -> float` = n x 0.25 (about one new member every 4 weeks a class night is taught, ESTIMATE, MONEYFOUR2).
3. Coached mornings: You 4, Coach 2: 6 slots. One slot covers ONE fighter's session in full (1.0), or TWO fighters asking the SAME
   session at 0.8 each (counted as 2 fighter-sessions covered; automatic, never a choice). Pair same-session asks first.
4. `coach_order(week) -> Array` of fighter ids: Coach's deal order, decided from the map: `first` fighters; then those short last week
   (Coach's own deal leaves nobody short two weeks running, SHORTWEEK1); then fight weeks; then the nearest target_day; then id.
5. `deal(week, order := []) -> Dictionary`: deals pads then mornings in `order` (Coach's when empty), one place at a time round the
   order (never all of one fighter's asks before the next fighter's first). Returns
   {pads: {owned, asked, covered, short}, mornings: {owned: 6, asked, covered, short}, cash: class_cash, members_4w,
    rows: [{id, pads_got, pads_value (sum of NTH_VALUE, the held place at 0.7), mornings_got, mornings_value (1.0 or 0.8 each),
    short: bool (got fewer pads or mornings than asked), holding: bool, causes: Array}]}.
   Counters are in fighter-sessions; pad covered is never more than pad owned. causes: "short" when short, "full_week" when dealt in
   full, "held_pads" for the holder (the Loyalty module's cause names).
6. `coach_evenings(cash, net) -> Array`: "Coach deals it" keeps all three on "pads" unless GymBills.runway_weeks(cash, net) is under
   8, then the first is "class" (map 3.1a LINKS).
7. `words(result) -> String`: "Pad places: 10 asked, 8 covered, 2 short" (the counter's line; no pronoun, no surname).

## The test FIRST: tests/club_deal_test.gd (extends SceneTree, prints `CLUB_DEAL failures=N`, quits with N)
RED ON MAIN: run it on main first: the preload of the missing ClubDeal.gd fails to load. Say so in the PR body. Build a week of three
DIFFERENT boxers (different asks, bouts, targets; never two identical rows). Assert at least:
- all evenings on pads: 8 pad places; two class nights: 4 pad places and cash = 2 x round(DuesLevers.CLASS_WEEKLY / 3.0) (read in the
  test); members_4w 0.5;
- a quiet week (asks 3 + 3 + 4 = 10) on 8 places: covered 8, short 2; covered never exceeds owned on any random week (loop 200 seeded
  weeks with asks 1 to 6 each);
- a 4th and 5th place for one boxer count 0.7 and 0.5 in pads_value; a 6th is never dealt;
- a holder must be loyal with 6+ bouts: a loyal boxer with 5 bouts adds nothing; with 6 the pool is 9, the held place is worth 0.7,
  the holder's row has holding true and the cause "held_pads";
- mornings: two boxers asking the same session share one slot at 0.8 each and count 2 covered; six slots cover at most 12
  fighter-sessions and only when all are paired;
- Coach's order: a `first` boxer is dealt before a fight-week boxer; a boxer short last week is never short again under Coach's
  order when anyone else can be (assert on a week where that is possible);
- round-robin: with 5 places and two boxers asking 4 each, the split is 3 and 2, never 4 and 1;
- coach_evenings: runway 8 weeks keeps three pads; 7 weeks gives one class (cash and net built in the test so GymBills.runway_weeks
  reads them);
- causes: "short" and "full_week" exactly as the rows got; words() names asked, covered and short;
- MUTANTS inside the test: a copy of deal that fills one fighter's asks before the next, and a copy that ignores NTH_VALUE, must each
  FAIL the same asserts; print `MUTANT caught` for each.

## Traps
- GDScript 4: type every Dictionary read; `:=` on a Variant is an error here; `%%` for a literal percent.
- The one trap: the unit. Every counter is FIGHTER-SESSIONS (asked, covered, short), never "nights" or "hours", and covered pads never
  exceed owned (map 3.1). A shared morning is 2 covered, not 1.
- Do not move loyalty or mood here: return the causes only.
- Do NOT delete, skip or weaken any existing test. No .res/.glb/scene loads. Do not touch CI.
- Write the PR body last, from the final run.

## Prior research
`python ops/Tools/prior_research.py coach evenings pad places` -> CLUBWEEK_MAP_V41_S432.md (3.1, 3.1a, 3.2, 8: the spec and its probes),
topics/staff_coaches.md (one coach, several boxers: who gets the pads), topics/money_business.md (class income), R55_PADS_DESIGN_MAP.md
(the older pads design this replaces).

## What would a human do?
A one-coach club on a Tuesday night: the members' class first, then pads for whoever has a fight coming, and somebody waits. A good
coach rotates who waits, and on a thin month teaches a second class for the money.

## Prefab check
None: a small dealing rule over the week's asks. The numbers are the map's and DuesLevers'.

Test command: `godot --headless --audio-driver Dummy --path . --script res://tests/club_deal_test.gd` (on the PC: the plain
`%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe`). Parse first: `--check-only` on both files.
RESULT lines for the PR body: `RESULT: tests/club_deal_test.gd -> CLUB_DEAL failures=0`.
