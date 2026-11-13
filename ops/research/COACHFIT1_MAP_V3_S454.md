# COACHFIT1 v3: coaches who fit, fill up, grow, have a temper and bond (S454)

v2 (COACHFIT1_MAP_V2_S452.md) scored Depth 8 / Play 8 (Dola, COACHFIT_CRITIC_S452_DOLA.md, raw transcript) and Depth 6 / Play 5 (Maria,
COACHFIT_CRITIC_S452_BRIEF_MARIA.md). v1 scored 5/5 (Kalli) and 6/6 (John). v3 takes Maria's whole 10/10 list and Dola's mechanics list.
Maria's core finding: "the weekly gain differences are too small to feel" - TOP FIT against RISKY moved about 0.04 of a stat point a
week. v3's core change: every fit difference is printed on the week in stat points and is big enough to see (0.5+ a week on a focused
area), coaches have a weekly energy, and each temper is a weekly lever, not only a hire.

| The critics found | v3 changes the MECHANIC |
|---|---|
| Maria 1: fit spread x0.90-1.10 is invisible on the week | Gain x0.80 to x1.20, tiredness x0.85 to x1.15; every row prints its predicted gain in stat points; FITPROBE1 bar: TOP FIT vs RISKY >= 0.5 a week on a focused area (section 2) |
| Maria (logic): "4 boxers x 5 coached sessions" does not match a 10-12 session week | A COACHED SESSION is defined: evenings (pads, sparring, film) and Hard mornings. Light and Normal mornings train alone (0.6) unless assigned. Four fighters need ~16-22 coached sessions against 12 (section 3) |
| Maria 3: "over list" was a flat penalty forever | COACH ENERGY: 10 a week; a session 1, a Hard session 1.5, a corner night 3; a deficit shrinks next week's list by that much. Over the list is a two-week trade (section 3) |
| Maria 4: taught-out arrived late, sprung on the player | Graded: -2 at Working when the stat is within 10 of the ceiling, -4 within 6, -6 within 3; the row says "taught out in about 3 weeks" (section 4) |
| Maria 5: the temper was a hire-time choice | Each temper has a WEEKLY MODE, one toggle per coach per week, its effect printed on the rows (section 5) |
| Maria (logic) + 6: "coach mood" does not exist in the code | Dropped. SAY NO to a raise = "working to rule": that coach's list -1 session for 4 weeks, on the card (section 4) |
| Maria (logic) + 9: "Old hand" already names a head-coach background (HeadCoach.gd 29) | The temper is renamed STEADY HAND and is about the calendar, not injuries: with a bout inside 14 days, tiredness x0.85 on every session that coach runs (section 5) |
| Maria 7: only one pair could ever reach Corner | Bond thresholds 0 / 8 / 35 / 90; apart decay -1 a week (was -2) (section 6) |
| Maria 8 + Dola: the corner pick needs its difference shown | Each candidate shows expected calls heard ("about 4 of 6") and the win-chance swing from BONDPROBE1 (section 8) |
| Maria 10: fighters have asks; tie them to coaches | A fighter at Trusted asks for that coach on the pads before a bout: hear it (+5 mood) or overrule it (-5) (section 6) |
| Maria (logic): Swap mid fight week; Pay with cash under $0 | Swap in a fight week is allowed and shows the -20 bond price; Pay is greyed under $0 cash with "not enough cash" (section 10) |
| Maria (options): Copy last week, lock a cell, list-full warning before Monday | All three on the Staff table / desktop (section 10, 12) |
| Dola 2: which sessions push a coach over | Hover "9 of 8" lists the sessions, the newest first (section 10) |
| Dola 3: temporary vs permanent swap | Swap THIS WEEK ONLY (bond pauses, fit -2 that week) or FOR GOOD (bond starts at Stranger) (section 10) |
| Dola 4 + 10: the school list and growth progress on the card | The market and staff cards list every move in the school and "62 -> 65 in 14 sessions" (section 12) |
| Dola 5: market filters | Filter by area, temper, ceiling, wage (section 12) |
| Dola 9: no one-line summary per fighter | Each fighter row on the table starts with the week's predicted gain in the fighter's focus stat and "best swap: +0.4" (section 10) |
| Maria (logic): pro-night cutman in the corner pick | The corner pick lists the head second only; the cutman stays its own StaffRoles job ($150 a pro night) and is shown beside it, not chosen from the same list (section 8) |
| Maria (logic): roster places | The map's numbers assume the Bigger unit (5 places) or a second club coach; with the starting Unit (3 places) the table has three rows and the list binds less, said on the Staff app (section 3) |

Sources as v2 (his order Q-S294-210; OFFICE_BOOKING_S448 s4; PROGRESSION_MAP_S448 M6, approved Q-211; PADPOOL1; Loyalty.gd; Exchanges'
shout rule; CoachAreas factor 0.5 + rating x 0.7 / 100, alone 0.6; HeadCoach.gd four backgrounds; COACH_DESIGN_S412) plus StaffRoles
(cutman $150 a pro night), BoutRead.gd 228 (coachability from personality), CornerJobs.gd 99 (discipline from personality).
Rules obeyed: names only in headers; game words; "the pads coach", "the fighter" in rows; one pulsing button a screen; every mechanic
wired and shown; no flat "+5% training" perks. ESTIMATE = a number this map sets that a probe sizes.

## 1. The idea
Today a coach is one average number and nobody decides who trains whom. After COACHFIT1 the player sets each week WHICH coach runs WHICH
area for each fighter, and sees on every row what that pair will add this week in stat points. The answer changes through a season:
bonds grow, coaches near their ceiling with a fighter, a coach's energy runs short in a busy camp, raises are asked, fighters ask for
their coach, and the calendar makes one temper worth more than another.

## 2. The rating counts once; the fit is the pair, and it is visible
- The coach's AREA RATING keeps today's job only: the coach factor (0.5 + rating x 0.7 / 100) on that session's gains, and M6's pads rule
  for move speed.
- The FIT (0-100) reads only the pair. ESTIMATE, sized by FITPROBE1.

| Part | Points | Read from |
|---|---|---|
| Temper and its mode x the fighter's state (section 5) | -10 to +8 | morale (FighterProfile), fatigue, the calendar |
| Load: the coach's energy (section 3) | 0 in budget, -6 at 1 over, -14 at 2+ over | the week board |
| Bond (section 6) | Stranger -6, Working 0, Trusted +4, Corner +6 | bond step |
| Taught out, graded (section 4) | -2 / -4 / -6 | ceiling, stats |
| The session trains the fighter's weakest stat of those it moves | +6 | stats |

- What the fit does: GAIN x0.80 at 0, x1.00 at 50, x1.20 at 100; TIREDNESS x1.15 / x1.00 / x0.85.
- Every row prints the session's PREDICTED GAIN in stat points ("+0.26 Power, TOP FIT"); hover lists the fit parts with points.
- Row words: TOP FIT (80+), GOOD (60-79), MIXED (40-59), RISKY (under 40).
- FITPROBE1 bars: TOP FIT vs RISKY on a focused area >= 0.5 stat points a week (a fighter with 3 coached sessions in that area);
  best list vs worst list 4-8 wins in 100 over a season, without the rating; no single part more than half of the fit.

## 3. Assigned by area; coached sessions; coach energy
- Each fighter has a coach per AREA: pads (evening), sparring (evening), conditioning mornings (roadwork, intervals, mobility), strength
  mornings (strength, neck), bag mornings (heavy bag, speed bag, slip rope, shadow) - CoachAreas.SESSION's five areas.
- A COACHED SESSION is an evening (pads, sparring, film) or a HARD morning. Light and Normal mornings train alone (0.6) unless the player
  assigns a coach to that morning (then it is coached and costs energy). Four boxers on a normal week: 3 pad nights + 1 sparring night +
  1-2 Hard mornings each = 16-22 coached sessions.
- COACH ENERGY (ESTIMATE): 10 a week. A session costs 1, a Hard session 1.5, a corner night 3. An assistant's LIST (what fits in 10) is
  8 normal sessions with room for a corner night; +2 energy at that area's rating 80+. The head coach has 5 energy (4 sessions + the
  office). The second club coach, when hired, has 5, conditioning mornings only, never the corner.
- OVER BUDGET: every session on that coach's list takes the load part, and next week's energy is 10 minus the deficit ("tired: 8 next
  week"). Over budget is a two-week trade: this week's bout against next week's camp.
- Uncoached sessions train ALONE (0.6), shown on the row as "alone".
- Roster places: the starting Unit holds 3 fighters, so the table has 3 rows and binds less; with the Bigger unit (5) or a second club
  coach the four-fighter numbers above apply. The Staff app says which.

## 4. Growth, the ceiling, and its price
- Growth: +1 in an area per 10 sessions the coach runs there (M6), up to the ceiling. A night with two fighters on the same pads counts
  once for the coach.
- The ceiling shows as a RANGE on the card from day one ("ceiling 62-74"), exact after 4 weeks of work. The card prints growth progress:
  "62 -> 63 in 4 sessions".
- TAUGHT OUT, graded and announced: from Working, when the fighter's stat for that area is within 10 of the coach's ceiling the fit takes
  -2, within 6 -4, within 3 -6. The row says "taught out in about N weeks" from the fighter's current gain rate. Moving that area to a
  fresher coach is a planned move, not a surprise. FITPROBE1 bar: the best table changes at least 5 times a season.
- PRICE: each 5 points a coach gains, the Monday review asks +$50 a week: PAY (greyed under $0 cash: "not enough cash"), or SAY NO =
  WORKING TO RULE: that coach's energy -1 for 4 weeks, shown on the card. The rival gym's offer (AGREED, NOT BUILT) adds to SAY NO later;
  until it is built nothing on screen mentions it.
- Growth stays with the coach; let go and it leaves. Growth milestones are announced as gains ("the pads coach reached 65: the
  Technician's polish now reaches Sharp moves").

## 5. Tempers, each with a weekly mode
Every coach has one temper (a word on the card) and two MODES; the player sets the mode once a week (default: the first). ESTIMATE,
FITPROBE1 bar: each temper is the best hire for at least one of the four bot boxer types, and each mode is the better one in at least one
week of a season for that coach.

| Temper | Mode A (default) | Mode B | Fit part |
|---|---|---|---|
| Motivator | LIFT: a loss's mood hit -12 becomes -8; +3 mood a week for Flat fighters on the list | DRILL: no mood effect, gains x1.05 | +8 with a fighter on Low mood (under 40) |
| Drill sergeant | PUSH: sparring counts 1.25 for move mastery and plan tests, +3 fatigue a night | EASE: no mastery bonus, fatigue as normal, no friction roll | -10 with Flat or Low mood in PUSH, +4 with discipline 70+ |
| Technician | POLISH: pad learning x1.15 on moves already Usable (Sharp too from rating 65) | TEACH: x1.10 on moves under 30 | +4 with coachability 70+ |
| Steady hand | TAPER: with a bout inside 14 days, tiredness x0.85 on every session this coach runs | BUILD: no bout soon, gains x1.05 on conditioning | +4 with a fighter who has a bout inside 14 days |

Discipline and coachability are read from the fighter's `personality` (CornerJobs.gd 99, BoutRead.gd 228). Today's two assistants: the
pads coach is a Technician, the conditioning coach a Drill sergeant. The market adds a young Motivator (pads) and a Steady hand (sparring,
bag). The mode toggle sits on the coach card and on the table header for that coach; each row shows the mode's effect.

## 6. Bond
Steps Stranger / Working / Trusted / Corner, one per coach and fighter pair (not loyalty to the club).
- Built: +1 per session together, +6 per bout this coach worked the corner, +10 for a loss survived together. Thresholds 0 / 8 / 35 / 90
  (ESTIMATE, BONDPROBE1: Working after ~1.5 weeks, Trusted ~6 weeks, Corner ~half a season; two or three pairs reach Trusted in a season).
- Lost: -1 a week apart; -20 when moved FOR GOOD mid-camp (a THIS WEEK ONLY swap pauses it); a quarrel.
- Does: the fit part; THE CORNER (section 8); a Corner-step coach leaving costs the fighter -8 mood. The head coach's bond step IS the
  "known" level Loyalty reads.
- FIGHTER'S ASK: at Trusted, before a bout the fighter asks for that coach on the pads. HEAR IT (+5 mood, the area moves to that coach for
  the camp) or OVERRULE (-5 mood). Uses the existing asks mechanic (Q-S294-209 order: after AMATEURWEEK1).
- QUARREL, readable: a Drill sergeant in PUSH with a Flat or Low fighter shows FRICTION on the row; each week at friction, 1 in 6 chance of
  a quarrel (-15 bond, -5 mood); the answer is on the row: switch to EASE, move the area, or keep going.

## 7. The head coach's rule
The head coach (the player) has 5 energy, any areas, rating 60 in the background's area and 45 elsewhere (Ex-pro: pads; Amateur coach:
pads; Strength coach: strength; Old hand: conditioning). No growth, no wage, no temper modes. CHECK before the build: HeadCoach.gd has no
rating today; add the head coach as a coach row in CoachAreas.rating_for, not a special case.

## 8. The corner is a pick, with its difference shown
On the bout card, WHO WORKS THE CORNER lists each candidate as a card (name in the card's header) with its shout number: coachability rule
x mood x bond (0.90 / 1.00 / 1.05 / 1.10), floor 0.5, and what it means: "about 4 of 6 calls heard" and the win-chance swing against the
head coach from BONDPROBE1. The corner night costs that coach 3 energy. On a pro night the cutman stays a separate StaffRoles job, shown
beside the pick. The fight screen's Heard / Half heard shows it landing; the result page says what an unheard call cost.

## 9. The school
Each assistant has a school of 5 to 7 punches and combinations, listed in full on the card. In the school: learning x1.1. Outside: Signature
work at x0.5 of M6's rate. Step arrows join when they get mastery (STEPMASTERY1). The head coach's school comes from the background (Ex-pro
Jab, Cross, Lead hook, Check hook; Amateur coach Jab, Cross, Body hook; Strength coach Body hook, Uppercut; Old hand Jab, Lead hook).

## 10. The decision a week (Monday, Staff app; and the week board)
- THE TABLE: fighter rows x five area columns. Each row starts with the fighter's predicted focus-stat gain this week and "best swap:
  +0.4". Each cell: coach portrait, FIT word with a bar, predicted gain in points, bond pips, and FRICTION / TAUGHT OUT IN 3 WKS / ALONE.
- SWAP: the popover lists each coach with the new fit, gain, energy cost and bond effect, and two buttons: THIS WEEK ONLY (bond pauses, fit
  -2 this week) or FOR GOOD (bond starts at Stranger). Allowed in a fight week, with its price shown.
- Hover "9 of 8" (energy over) lists the sessions on that list, newest first.
- COACH RUNS IT (C20, AGREED) fills the table, never over budget unless there is no choice, says why in one line, and skips LOCKED cells.
- COPY LAST WEEK; a LOCK on any cell.
- The Monday review: raises (Pay / Say no), growth milestones as gains, bonds reached, a quarrel, a fighter's ask.
- The office desktop's Needs you: "the pads coach's energy runs short next week" BEFORE Monday, from the booked calendar.
- FIGHT WEEK: the corner pick (section 8).

## 11. Probes, in order
1. FITPROBE1 (Goose): 26-week careers via career_harness, four arms (fit at 50 = today; as written; best table weekly; worst weekly), per-
   area coaches, energy and modes on. Bars: TOP FIT vs RISKY >= 0.5 stat points a week on a focused area; best minus worst 4-8 wins in 100;
   no fit part over half the fit; one assistant for four boxers costs 2-5; the best table changes 5+ times a season; each temper best for one
   bot type; each mode best in at least one week.
2. BONDPROBE1: Stranger vs Corner in close bouts worth 2-4 wins in 100; thresholds land at ~1.5 / ~6 / ~13 weeks.
3. The four S412 bots (loyal / rotate every block / rotate when taught out / one-week farm) with raises, energy and graded taught-out: fails
   if one beats the rest by more than 5 points, or the farm beats loyal once costs count.

## 12. Every menu it appears on, and what each is wired to
| Menu | Shows | Wired to |
|---|---|---|
| Week board (Training) | each coached session: coach or "alone", FIT word, predicted gain, parts on hover, FRICTION / TAUGHT OUT IN N WKS | CoachFit (new), WeekPlan, PadWeek |
| Office: Staff app, coaches | cards: areas, growth "62 -> 63 in 4 sessions", ceiling range, temper + MODE toggle, full school list, energy pips "9 of 10", wage, raise | CoachFit, CoachEnergy (new), CoachGrowth (new), StaffRoles |
| Office: Staff app, table | fighter x area cells, row summaries, Swap (this week / for good), Lock, Copy last week, Coach runs it | CoachFit, CoachEnergy, Bond |
| Office: Staff app, market | cards with school list, temper, ceiling range, energy, wage; filters area / temper / ceiling / wage; Hire | StaffRoles, CoachSchool |
| Office: Desktop | energy short next week; a raise asked; a fighter's ask | OfficeDesk |
| Fighter page, Training | the fighter's coach per area, bond steps and next threshold | CoachFit, Bond (new) |
| Fighter page, moves | "in the pads coach's school x1.1" on a move bar | CoachSchool, MoveTree |
| Learning-slot cards (SLOTS1) | the school reason | LearnSlots |
| Monday review | raises (Pay / Say no -> working to rule), growth as gains, bonds reached, quarrel, the fighter's ask | CoachGrowth, Bond, WeekCoach |
| Bout card / fight week | the corner pick: calls heard and the win swing per candidate; cutman beside it on pro nights | Bond, CoachEnergy, AMATEURWEEK1 |
| Fight: shouts | Heard / Half heard, by bond too | Exchanges, Bond |
| Result page | "The corner: Trusted, 4 of 5 calls heard; the unheard call cost about 3 in 100" | FightWhy, Bond |

## 13. Build order
1. FITPROBE1, BONDPROBE1, the S412 bots (rules modelled in the probes).
2. Pure rules + tests: CoachFit, CoachEnergy, CoachGrowth (ceiling, graded taught out, raise, working to rule), Temper (with modes), Bond
   (friction, asks), CoachSchool. Data: tempers, modes, schools, ceilings; the head coach as a coach row.
3. Wiring: WeekPlan/PadWeek read the fit, energy and per-area coach; the shout reads the bond; MoveMastery reads the school.
4. Screens (Grok Dev, one a task): week board rows, Staff app table + cards + market, the fighter's Training strip, the corner pick.
5. Golden path: hire the young Motivator, set the table, see a TOP FIT row's gain beat a RISKY one, go over budget and pay it next week,
   reach Working, say no to a raise (working to rule), swap an area when TAUGHT OUT IN 1 WK shows, hear a fighter's ask, a bout where the
   chosen corner's calls show on the shouts and the result.

## 14. Needs that are not built yet (said, not hidden)
The rival gym's offer (AGREED, NOT BUILT; not shown until built); step mastery in the school (STEPMASTERY1); the office Staff app
(OFFICE2); the asks mechanic for coaches (after AMATEURWEEK1); per-area coaches on mornings (step 3).

## 15. Open for him (taste and scope, after the critics)
- The four tempers and their modes: the right flavours?
- A raise every 5 points: right pace?
