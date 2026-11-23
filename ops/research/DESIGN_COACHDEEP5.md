# DESIGN_COACHDEEP5 - deep coaches v5: a catchment ceiling on the members, ties printed, the chemistry sweep below 0.25 (S541)

Task: ops/research/TASK_COACHDEEP5.md. Base: DESIGN_COACHDEEP4.md (every v4 rule stands unless this page changes it), its
result docs/COACHDEEP4_RESULT.md (FAIL 6/10: a, g, h, i), and the owner's 24 answers (ops/research/COACHDEEP_GRILL_S539.md,
binding). The stipend stays $250 a week; owner Q-311 "Bouts pay by rank" stands; v4's rank bands ($450 / $1,000 / $1,200 /
$1,500) and the record line in the departure price stay (f2 and j passed with them). Probe: tools/coachdeep5.gd +
tools/coachdeep5_rules.gd. Result: docs/COACHDEEP5_RESULT.md. Nothing under scripts/ changes until the probe and two critics
pass it.

Prior research (prior_research.py "coach class members catchment"): COACHDEEP1-4 maps and results, GymBills.gd, BoutRules.gd,
StaffRoles.gd, Membership.gd. The work follows COACHDEEP4's verdict (s5): items 1-3 in its order, nothing else touched.

## 1. A catchment ceiling (COACHDEEP4 s5 item 1)

The members target (Membership's, as v4 used it) is:
target = natural_members(reputation now) + the size's add + the class pull (1.5 x paying class share x teaching / 10).
v5 caps it: **target = min(that, CATCHMENT)**, with
**CATCHMENT = natural_members(reputation at the START) + the size's add + 12** (one full class night's worth, CLASS_MEMBERS).

| Club | Town at start (rep 10) | Size's add | One class night | Catchment |
|---|---|---|---|---|
| Small (opens at 30) | 54 | 0 | 12 | **66** |
| Big (opens at 70) | 54 | 30 | 12 | **96** |

Real-world reason: a boxing club draws from a few miles round it - the streets a kid can walk or bus from after school. A
good name and more class nights fill that catchment faster and keep more of it; they do not add people to the town. The
room (StaffRoles: volunteers 30 + 40 a coach) is a coaching limit, not demand, so it stays as the second cap.

DECIDED, and why (the brief's estimate "small ~40-45, big ~85-95" was written from v4's text, not its numbers):
1. The town is read at the START reputation, not today's. v4's own rows show the members ran away with reputation, not with
   the class nights: arms that run NO class night (ALL_REID / ALL_X, 0 classes) ended at 113-117 members in the small club,
   NOHIRE at 110, because reputation climbs from 10 past 100 in two years (+5 a win) and natural_members(100) = 108. A ceiling
   that moves with reputation (catchment = natural(today) + add + 12 = 120 / 150) would cap nothing; the probe runs it as a
   diagnostic (catch=rep) in the trial to show it. Reputation still matters: it is what lifts the target from the opening
   members to the catchment, and the club that loses fights sits below it.
2. "The town's natural members" is the game's own number (Membership.natural_members, BASE 48 + 0.6 a reputation point at
   the standard dues), so the small club's ceiling is 66, not the brief's 40-45 (which took the opening 30 as the town). Using
   the opening members instead would invent a second town number the game does not have. The two sizes stay 30 apart: the
   club-size question (bars h, i) is what the ceiling must bring back, and 66 v 96 keeps it.
3. The ceiling caps the members, not only the target: a won bout's new members (BoutRules.WIN_MEMBERS, +8) also come from
   the town, so a win cannot take the club past the catchment (it can still refill a club below it). CHANGED AFTER THE
   ONE-REP TRIAL, before any sweep or full run (the trial's stop rule): with the target alone capped, the wins' +8 sat on top
   of it - small club 74 at week 104 against 66 (peak 88), big 104 against 96, out of the catchment + 5 band in 94 arms.
   The catch=rep diagnostic (catchment moving with reputation) ended at 109-128 small / 110-150 big: it caps nothing, as s1.1
   says. The trial is rerun with this rule before the sweep.

In the game (after the critics; nothing built before): Membership gains a catchment per club (set by the town at the start,
later by a move or a second site), the Members page shows "your area: 66 people who would box; you have 58".

## 2. The chemistry sweep below 0.25 (COACHDEEP4 s5 item 2) - a written change to bar g's size list, before any run
Bar g's size list becomes **1.0 / 0.6 / 0.4 / 0.25, then 0.15 / 0.10 ONLY if CHEM is best in more than 5 of 10 cells at
0.25**. The verdict runs at the largest size with CHEM best in at most 5 of 10 (bar b must still pass there); if none
qualifies, at the smallest swept size, and bar g fails. A tie (s3) counts as CHEM best when CHEM is one of the tied arms.

## 3. Ties printed (COACHDEEP4 s5 item 3)
Arms whose mean scores are within 0.01 line of the best are TIED; the cell prints them ("CHEM = SMART"). Decided: for the
counts in bars a and g every tied arm counts as best in that cell - the conservative reading, it can only make a and g
harder, never loosen them. The best arm used for every other bar is the first in arm order (as v4), the same plan when tied.

## 4. Bars (written BEFORE any run, not loosened): COACHDEEP4's ten, word for word
- (a) No single assignment rule is the best arm (by score) in more than 6 of the 10 cells.
- (b) Chemistry moves an outcome by a line (cash $1,000, reputation 3, win less loss 0.5, or morale 5; best arm v CHEMOFF,
  paired) in at least 5 of the 10 cells.
- (c) The right coach differs by boxer (ALL_REID v ALL_X per boxer: at least one boxer prefers each coach) in at least 5 cells.
- (d) The best arm beats LAZY by at least one line of score in at least 5 cells.
- (e) Every effect counted in (b), (c), (d), (h), (i) is larger than 2 standard errors (paired); inside 2 errors does not count.
- (f) (f1) a departure is charged only by game items, the probe prints the mean price and its parts; (f2) in at least 8 of 10
  cells the best arm loses no more boxers than LAZY + 0.10 a career.
- (g) CHEM is the best arm in at most 5 of 10 cells with (b) passing; size by the sweep (s2's list), the full run at that
  size is the verdict.
- (h) In the best arm's sampled trade weeks (every 8th; mirror direction when it already runs classes), the class is right
  (> 2 errors) in at least a third AND the boxer is right (< -2 errors) in at least a third.
- (i) Some candidate's best HIRE arm beats the best NOHIRE arm by > 2 errors in one club size and not in the other; and in at
  least one size some hire pays.
- (j) The best plan keeps its ranked boxers: in at least 8 of 10 cells the best arm loses at most 0.10 boxers a career who were
  on the regional table (rank > 0) when they left.
PASS = all ten. Diagnostic target (reported, not a bar): in the 10-rep diagnostic neither the class nor the boxer is right in
more than two thirds of trade weeks.

## 5. Feedback loops
| Loop | Feeds back? | Cap | Checked |
|---|---|---|---|
| Class nights -> members target -> members -> class nights wanted | yes (v4's open loop) | the catchment (s1) | trial: members at week 104 <= catchment + 5, every arm |
| Members -> dues -> cash -> coach hires -> coach evenings -> class nights | yes | the same catchment (dues bounded); hires are fixed per cell in the probe | cash at week 104 printed per arm |
| Wins -> rank -> purse -> keeps the boxer -> more wins | yes | the band top ($1,500 at number 1), the ladder's fixed rivals; she leaves only by the loyalty rule, charged the departure price | ranked_left, pay printed per arm |
| Wins -> reputation -> natural members | yes | the catchment (s1); reputation clamps at 100 in Membership | members printed per arm |
| Chemistry -> learning -> wins -> rank | ONE-WAY in the code: chemistry = traits + a bond that grows with coached weeks (BOND_WEEK, cap 0.25), never with wins. Wins do move morale (trust) and loyalty, which are separate lines | bond cap 0.25, trust 0.7-1.05 | - |
One-rep trial first (mode=full reps=1 hreps=1 at 0.25, catch=start and the catch=rep diagnostic), then the sweep and the 10-rep
diagnostic, then the full run. Stop and fix this map before the full run if any arm's members leave the catchment band or every
cell converges on one best arm.

## 6. Menus (after the critics; nothing built before)
v4's table stands, plus:
| Menu | Shows | Wired to |
|---|---|---|
| Members page / week review | "Your area: 66 people who would box. You have 58." | Membership catchment (new) |
| Week plan (class nights) | the class nights the members fill, and that a further night only fills, never grows, the area | class_share + catchment |
