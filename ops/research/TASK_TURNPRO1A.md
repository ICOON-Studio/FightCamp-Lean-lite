# TASK TURNPRO1A - turning pro, the pure rules: who calls, the two promoters' terms, one ask with a counter, the money apart

Status: OPEN (S522, Claude main). Discipline: boxing. Model: Goose (cloud), default. Pure rule module + its test only.
Source: the owner approved the design (Q-S294-227 "Yes, both", build after the fight week - the fight week is built).
The map: `ops/research/DESIGN_TURNPRO1_V2_REVISE_KALLI_KALLI.md` sections 1-2 (read them whole; this brief is the build
cut). Today the game has ONE call (scripts/state/Roster.gd check_pro / turn_pro / decline_pro, lines ~180-305: Bow Lane
first, Harrow & Finch at 0.9x after a decline) and the debut maths in scripts/rules/ProDebut.gd. This task writes the
rules the v2 map adds, as a pure module; Claude wires them into Roster and the offer screen afterwards.

## Contract
OWNS: scripts/rules/ProCall.gd, tests/pro_call_test.gd
RED_TEST: tests/pro_call_test.gd -> PRO_CALL failures=0
REGRESSION: pro_debut_test
VISUAL: no

## Prior research
`python ops/Tools/prior_research.py turning pro promoter debut purse`. Read the map sections 1.1-2.1, ProDebut.gd (49
lines: tickets_sold, night, sheet - REUSE it by preload, never copy its numbers), Roster.gd lines 30-50 (PRO_* constants:
PRO_PURSE 1500, PRO_PURSE_STEP 500, PRO_PURSE_TOP 3000, GYM_SHARE = ProDebut.MANAGER + TRAINER = 0.25, PRO_DEBUT_WEEKS 4,
PRO_OPP_GAP 1.0, PRO_SECOND_TERMS 0.9) and scripts/rules/AskBout.gd (the ask pattern: every answer shown before it is
pressed, never a random no). ops/research/GDSCRIPT_TRAPS.md first.

## What would a human do?
A promoter's matchmaker prices a debut from the tickets the boxer will sell: a ticket house gambles on the gate, a
guarantee house pays a flat purse. The coach gets one request before signing, and the promoter says yes, no, or "this
instead" - the coach sees each answer before asking.

## Prefab check
None: our own rules on our own numbers.

## The job - scripts/rules/ProCall.gd (extends RefCounted, static funcs, no class_name, no state script preloaded; only
## ProDebut.gd may be preloaded). Plain Dictionaries in and out. Game text never says he, she, her or him; names only
## in headers, so no function puts a person's name in a line.
Every number below that the map tags ESTIMATE is a named const with `## ESTIMATE` on its line.
1. `PROMOTERS` - two rows keyed "bow" and "hf" (map 1.3): name ("Bow Lane Promotions" / "Harrow & Finch Boxing"), purse
   (1500 / 1800 guaranteed), step (500 / 400), top (3000 / 3000), break_even tickets (60 = ProDebut.BREAK_EVEN / 70),
   boxer share past break-even (0.5 = ProDebut.HER_SHARE / 0.3), under_break_even (bow: purse - 25 a ticket short,
   floor 500; hf: none), debut_weeks (4 / 6), opp_gap (1.0 / 1.5), guaranteed (false / true).
2. `who_calls(forecast: int) -> Array` (map 1.2): forecast = tickets the boxer would sell (ProDebut.tickets_sold).
   forecast >= bow break_even + 15 -> ["bow"]; forecast <= bow break_even - 15 -> ["hf"]; else ["bow", "hf"] (both, the
   same week, side by side). BAND := 15 (ESTIMATE).
3. `terms(key: String, declines: int, title_since_decline: bool) -> Dictionary`: the row's money at 0.9x
   (Roster PRO_SECOND_TERMS, pass it in as an argument or mirror it as SECOND_TERMS with a comment naming Roster) after a
   decline unless a title came since (map 1.2). Returns {key, name, purse, step, top, break_even, share, debut_weeks,
   opp_gap, guaranteed, factor}.
4. `debut_purse(t: Dictionary, sold: int) -> int`: hf = purse; bow = purse, minus 25 a ticket under break_even, floor 500
   (map 1.3; SHORT_TICKET := 25, PURSE_FLOOR := 500, both ESTIMATE).
5. `money(t: Dictionary, sold: int, costs: int, gym_share: float, stipend_paid: bool) -> Dictionary` (map section 2):
   gym_at_signing = round(debut_purse * gym_share) - costs (the gym's cut is taken from the purse AND from the ticket
   share past break-even, as ProDebut.night already does: gym_at_signing also adds round(ticket_share * gym_share));
   weekly_after = (250 if stipend_paid else 0) - 75 (the lost amateur cut, LOST_CUT_A_WEEK := 75 ESTIMATE; the 250 is the
   stipend: take it as an argument `stipend: int`, default 250); boxer = debut_purse + ticket_share - the gym's part of
   both; by_debut = gym_at_signing + weekly_after * debut_weeks; even_week = the first week >= 1 where gym_at_signing +
   weekly_after * week >= 0, or -1 when weekly_after <= 0. ticket_share = (sold - break_even, at least 0) x
   ProDebut.TICKET_PRICE x share. Keys: {purse, ticket_share, gym_at_signing, weekly_after, by_debut, even_week, boxer}.
6. `pays_back_line(m: Dictionary) -> String`: even_week > 0 -> "The gym is about even %d weeks after signing."; else
   "The gym gets its money back once your boxer is ranked."
7. `ASKS` and `ask_answers(t: Dictionary, forecast: int, runway_weeks: int) -> Array` (map 1.4): one entry per ask
   {kind, label, answer: "take"|"counter"|"wont", words, after (the terms as they would be)}:
   - "later": +2 weeks for purse -150, or +4 for -300 - two entries "later2" and "later4"; always "take".
   - "softer": opp_gap +0.5 and "tune_ups": 2 (the next 2 pro offers tune-up only); always "take".
   - "split": share +0.10 and opp_gap -0.5 (the opponent 0.5 HIGHER) when forecast >= break_even + 20; counter +0.05,
     opponent unchanged, when 5..19 over; else "wont" with the reason in plain words.
   - "price": bow only: ticket price 40 not 50, +15 tickets (`price`, `extra_tickets` in after); hf -> "wont".
   - "costs": hf only: the promoter pays the signing costs and takes costs + 100 from the purse (+200 when
     runway_weeks < 8, the counter); bow -> "wont".
   Every number here is ESTIMATE.
8. `apply_ask(t: Dictionary, entry: Dictionary, take_counter: bool) -> Dictionary`: the terms after that one ask
   ("wont" returns t unchanged). One ask per offer is the caller's rule; this function does not count.
9. `morale(ambition: String, stay: bool, before_nationals: bool) -> int` (map 1.5): ambition "pro": +5 turning pro,
   -5 staying; "title": -5 turning pro only when before_nationals, else 0; anything else 0. And
   `ambition_kind(words: String) -> String`: the signing card's words (scripts/rules/Recruit.gd ambition: "A regional
   title within a year" -> "title"; any text containing "pro" -> "pro"; else "other").
10. `AGE_STOP := 32` (ESTIMATE) and `age_line(age: int) -> String`: "" under 29; 29-31 -> "Age %d: first calls stop at
    32."; 32+ -> "First calls have stopped at 32." And `calls_open(age: int) -> bool` (age < AGE_STOP).
11. `WINDOW_DAYS := 14` (ESTIMATE): the offer stands this long; `expires(day: int) -> int` = day + WINDOW_DAYS.

## tests/pro_call_test.gd (extends SceneTree, prints `PRO_CALL failures=<n>`, quits 1 on any failure)
- The map's worked cases, section 2 (70 members, 7 wins, no title -> ProDebut.tickets_sold; Bow Lane: costs 1245):
  case A bow, stipend paid: gym_at_signing -870 +- the ticket share rounding, weekly_after +175, even_week 5;
  case B bow, no stipend: weekly_after -75, even_week -1, and the line "once your boxer is ranked";
  case C hf at 54 tickets, stipend paid: purse 1800, gym_at_signing 450 - 1245 = -795, by_debut over 6 weeks +255.
  Write the expected numbers from the map, not from your code; if the map's own arithmetic disagrees with its rules,
  say which in the PR body and test the rule.
- who_calls at 75 / 60 / 45 tickets -> ["bow"], ["bow","hf"], ["hf"]; the 0.9x after a decline and the title reset.
- Each ask's three answers on the band edges (split at 79 / 65 / 64 tickets over break-even 60: take / counter / wont);
  price and costs refused by the other house with a reason; apply_ask keeps t unchanged on "wont".
- morale on all rows, age_line at 28 / 29 / 32, expires.
- No line any function returns contains " he ", " she ", " her ", " him " (lower-cased, spaces around).
- Mutants: break the band (15 -> 0) and the floor (500 -> 0) and show the test goes red (run them by hand, say so in the PR).

## Rules for this seat
Godot 4.7.2 headless only, `--audio-driver Dummy`. Nothing outside OWNS; do not touch Roster.gd, ProDebut.gd or any
screen. Scripts under 500 lines. PR body: `RESULT: tests/pro_call_test.gd -> PRO_CALL failures=0`.

## The one trap
ProDebut.night already splits the ticket share between the boxer and the gym (gym = share x 0.25). Do not take the
gym's 25% twice, and do not hard-code 60 / 50 / 0.5 when ProDebut has them.
