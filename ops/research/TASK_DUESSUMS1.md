# TASK DUESSUMS1 - QWEN (qwen3-coder) - dues: the sums that give each price a club where it wins (pure module + a 5-year sim, MEASURE ONLY)

Status: OPEN (S431, Claude main). Discipline: boxing. Model: qwen3-coder.
Source: the operator approved the dues mechanism (board Q-S294-176: "ok for the mechanism but the design needs better
presentation") and asked in S430 whether it is "implemented ... accross all menus properly". The menus are DUESWIRE1. THIS task
is the numbers: with today's rules Premium has the best 5-year total in 9 of 9 clubs, so the choice has one right answer.
Nothing here is wired into the game: a new pure module and its test only. Claude picks the numbers from your table, then asks him.

## The fault today (measured S424, branch claude/duesband1, tests/dues_bands_sim_test.gd)
Bands in scripts/rules/Membership.gd DUES: cheap $25 (draw 1.15, intake 0.50), standard $35 (1.0, 0.35), premium $45
(0.85, 0.20). Over 5 years premium wins every case (reputation 10 / 40 / 80 x member cap 40 / 60 / 120). Two reasons:
(1) once the gym is full the cap binds, so cheap's extra members never arrive and cheap is only a price cut;
(2) a home-grown boxer was worth only half a stipend ($6,500).

## What real cheap clubs live on (John, ops/research/J_CHEAP_CLUB_MONEY_S424_BRIEF_JOHN.md: read its last table)
Dues cover only 18 to 67 in 100 of a cheap English club's income. The rest: grants (Movement Fund median about $12,345 an
award, at most $18,750 in 12 months; Awards for All funds about 1 application in 3), home shows ($1,004 to $14,336 net a
year), donations ($3,454 to $5,418), and coaches who are volunteers (no wages at 3 of 3 clubs). Budget gyms lose members
faster: about 5.6 in 100 a month against 2.8 at a club.

## Contract
OWNS: scripts/rules/DuesLevers.gd, tests/dues_levers_test.gd
RED_TEST: tests/dues_levers_test.gd -> DUES_LEVERS failures=0
REGRESSION: membership_test, membership_why_test
VISUAL: no

## The job
1. `scripts/rules/DuesLevers.gd` (new, pure, static funcs only, no preload but `res://scripts/rules/Membership.gd`, under 200
   lines). It holds the CANDIDATE levers as data and the sums as functions. Every lever is per band and per year, in game
   dollars, expected values (no RNG):
   - GRANT: `grant_year(band, chance, payout, youth_open)` = chance x payout for cheap; half the chance for standard; 0 for
     premium. Candidates: chance 0.20 / 0.33 / 0.50, payout 8000 / 12345 / 18750.
   - VOLUNTEER: `volunteer_saving_year(band, share)` = share x 450 x 52 (the sessional coach costs $450 a week) for cheap;
     half the share for standard; 0 for premium. Candidates: share 0.0 / 0.25 / 0.50.
   - SHOW: `show_year(home_grown_boxers, per_boxer)` = min(1000 + per_boxer x boxers, 14336). Candidates: per_boxer
     1000 / 2000 / 3000. Boxers = the band's expected home-grown boxers so far (intake_chance x intakes passed, two a year).
   - CHURN: `premium_draw(reputation, low_rep_draw)` = the draw premium really gets: `low_rep_draw` at reputation 0 rising
     in a straight line to 1.0 at reputation 100. Candidates: low_rep_draw 0.85 (today) / 0.75 / 0.65.
   - `five_year_total(reputation, cap, band, levers: Dictionary) -> Dictionary` {dues, grant, volunteer, show, boxers,
     total}: weekly `Membership.settle_week(members, reputation, cap, band, draw_mult)` from 40 members for 260 weeks (for
     premium pass draw_mult = premium_draw(...) / Membership.draw("premium", reputation)), plus the yearly levers, plus
     6500 x boxers (the home-grown boxer's value, unchanged).
2. `tests/dues_levers_test.gd` (new, extends SceneTree, the shape of tests/membership_test.gd):
   a) CONTROL, proves the bar can read worse: all levers at zero and low_rep_draw 0.85 must give premium the top total in
      9 of 9 cases (reputation 10, 40, 80 x cap 40, 60, 120). Print the table. If it does not, stop and say so.
   b) THE SEARCH: every combination of the candidates above (3 x 3 x 3 x 3 x 3 = 243 sets). For each set count the wins per
      band over the 9 cases. A set is GOOD when: every band wins at least 2 cases and none more than 5; cheap wins the case
      reputation 10 / cap 120 (a new club with room); premium wins reputation 80 / cap 40 (a famous full gym); and the
      best band's total is never more than 25 in 100 above the worst band's in any case (no band is a trap).
      Print: how many of the 243 are GOOD, and the 10 GOOD sets closest to the real-world middle (chance 0.33, payout
      12345, share 0.25, per_boxer 2000, low_rep_draw 0.75), each with its 9-case winner table.
   c) Checks: (a) holds; at least one GOOD set exists; each lever function returns 0 for premium where the rule says so;
      totals are sums of their parts. Last line `DUES_LEVERS checks=%d failures=%d`, quit 1 on a failure.
   d) Add `const PICK := {...}` in DuesLevers.gd = the GOOD set nearest the real-world middle, and print its full 9-case
      table (every band's dues, grant, volunteer, show, boxers, total, the winner).
3. Do NOT widen a candidate list, change a bar or add a lever to make a GOOD set appear. If none of the 243 is GOOD, the
   test fails on that check: print which bar fails most often and by how much. That is a result, not a failure of yours.
4. Do not edit Membership.gd, HomeJuniors.gd or any screen. Nothing in the game calls DuesLevers yet.

## Prior research
ops/research/J_CHEAP_CLUB_MONEY_S424_BRIEF_JOHN.md (real cheap clubs' money), ops/research/DUES_DESIGN_MAP_S423.md (the
design and its S424 correction), ops/research/DUES_CHOICE_S422.md, scripts/rules/Membership.gd (settle_week, draw,
intake_chance), ops/research/GDSCRIPT_TRAPS.md (read before writing GDScript).

## What would a human do?
A club treasurer puts three prices side by side for five years and adds what each kind of club can really collect beyond
dues: a grant, volunteers, a home show; then looks for the club each price suits.

## Prefab check
None: our own rules and our own numbers.

## Rules
Godot only through `python ops/Tools/godot_slot.py run --who qwen -- <godot.exe> --headless --audio-driver Dummy --path . --script <script>`
on the PC (in the cloud: the plain headless command). Parse first with `--check-only --script res://<file>`. No file over
500 lines. Never "he" or "she" in text. Write no check that can only pass: (a) is the proof the bars can go red.

## Result lines (PR body)
RESULT: tests/dues_levers_test.gd -> DUES_LEVERS checks=N failures=0
RESULT: tests/membership_test.gd -> MEMBERSHIP checks=N failures=0
Also paste in the PR body: the control table, the count of GOOD sets, and PICK's 9-case table.
