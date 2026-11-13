# COACHFIT1 v2: coaches who fit, fill up, grow, have a temper and bond (S452)

v1 (COACHFIT1_MAP_V1_S450.md) scored Depth 5 / Play 5 (Kalli, SQ61): "the choice settles in the first week and then stops being a
choice". v2 takes every point of her 10/10 list. What changed, in one line each:
- The rating counts ONCE: it stays in the coach factor; the fit reads only the PAIR (temper with mood, load, bond, a coach who has taught
  all they can).
- Coaches are assigned by AREA, not by fighter, and lists count SESSIONS: with four boxers the lists bind in week 1.
- Loyalty to one coach costs something: a coach who has taught all they can in an area fits worse there, so the best list moves.
- Growth has a price: a coach who grows asks for more money.
- Every temper is somebody's best hire; the school slows Signature instead of forbidding it; the head coach has a rule; the corner is a
  pick with its number; a quarrel is readable before it happens.

Sources: his order (Q-S294-210 "Yes, that order": fight week, office, coaches, contract tab); OFFICE_BOOKING_S448.md section 4 (Corner
King's pairing, read from their code: their cutman, analyst and personality bonus do nothing - we wire every piece); PROGRESSION_MAP_S448
M6 (approved Q-211); PADPOOL1 (8 club pad nights); Loyalty.gd (R58LOYAL1); Exchanges' shout rule; CoachAreas (five areas, factor
0.5 + rating x 0.7 / 100, alone 0.6); HeadCoach (four backgrounds); COACH_DESIGN_S412 (book, limit, bond).
Rules obeyed: names only in headers; game words; no pronouns for fighters or coaches in rows ("the pads coach", "the fighter"); one pulsing
button a screen; every mechanic wired and shown; no flat "+5% training" perks.

## 1. The idea
Today a coach is one average number and nobody decides who trains whom. After COACHFIT1 the player sets, each week, WHICH coach runs
WHICH area for each fighter. Every assignment has a fit (does this pair work), a load (is this coach over their list), a bond (how long
they have worked together) and a ceiling (has this coach taught all they can here). The answer changes through a season because bonds
grow, coaches hit their ceilings with a fighter, fighters' moods swing and coaches ask for raises.

## 2. The rating counts once
- The coach's AREA RATING keeps today's job and only today's: the coach factor (0.5 + rating x 0.7 / 100) on that session's gains, and M6's
  pads rule for move speed. Nothing else reads it.
- The FIT reads only what is about the pair. ESTIMATE, sized by FITPROBE1.

| Part | Points | Read from |
|---|---|---|
| Temper x the fighter's mood or state (section 5) | -10 to +8 | morale, fatigue, the temper |
| Load (section 3) | 0 at or under the list, -6 at 1 session over, -14 at 2+ over | the week board |
| Bond (section 6) | Stranger -6, Working 0, Trusted +4, Corner +6 | bond step |
| Taught out (section 4) | -4 at Trusted or Corner when the fighter's stat for that area is within 5 of this coach's ceiling | ceiling, stats |
| The session trains the fighter's weakest stat of those it moves | +6 | stats |

- What the fit does (two levers already in the week's maths): GAIN x0.90 at 0, x1.00 at 50, x1.10 at 100 on that session; TIREDNESS
  x1.10 / x1.00 / x0.94.
- Row words: TOP FIT (80+), GOOD (60-79), MIXED (40-59), RISKY (under 40); hover lists the parts with points.
- FITPROBE1 bar without the rating: best list against worst list is still 4 to 8 wins in 100 over a season.

## 3. Assigned by area; lists count sessions
- Each fighter has a coach per AREA: pads (evening), sparring (evening), conditioning mornings (roadwork, intervals, mobility), strength
  mornings (strength, neck), bag mornings (heavy bag, speed bag, slip rope, shadow) - CoachAreas.SESSION's five areas.
- A coach's LIST counts SESSIONS a week (the PADPOOL1 unit): an assistant runs 8 (+2 at that area's rating 80+). The head coach runs 4
  (section 7). The second club coach, when hired, runs 4, conditioning mornings only, and never the corner (Kalli point 11).
- With four boxers training ~5 coached sessions each (20), one assistant (8) and the head coach (4) cover 12: the list binds in week 1.
  Uncoached sessions train ALONE (today's 0.6 factor), shown on the row as "alone".
- So the week is a trade: put the pads coach on the boxer with a bout and the others' pads go alone, or hire.
- Over the list: every session on that coach's list takes the load part, not just the last one added. The board shows "9 of 8".

## 4. Growth, the ceiling, and its price
- Growth: +1 in an area per 10 sessions the coach runs there (M6, approved), up to the coach's ceiling. A night with two fighters on the
  same pads counts ONCE for the coach (Kalli point 10: no double-counting).
- The ceiling shows as a RANGE on the market card from day one ("ceiling 62-74"), exact after 4 weeks of work.
- TAUGHT OUT: when the fighter's stat for that area is within 5 of the coach's ceiling and the bond is Trusted or Corner, the fit takes -4
  in that area ("this coach has taught all they can here"). Moving that area to a fresher coach is then the right move at the right time.
  FITPROBE1 bar: the best list changes at least 3 times a season.
- PRICE: each 5 points a coach gains, the Monday review asks +$50 a week: PAY, or SAY NO (-10 coach mood, and a 1 in 4 chance a rival gym
  makes an offer within 4 weeks, a flag with three answers: match it, promise, let go). The rival offer is AGREED, NOT BUILT: until it is,
  SAY NO costs the -10 mood only, and the flag waits for it.
- Growth stays with the coach; let go and it leaves.

## 5. Tempers: each is somebody's best hire
Every coach has one temper, a word on the card with its one effect. ESTIMATE, FITPROBE1 bar: each temper is the best hire for at least one
of the four bot boxer types.

| Temper | The one thing it changes | Fit part | Best for |
|---|---|---|---|
| Motivator | a loss's mood hit -12 becomes -8 | +8 with a fighter on Low mood (under 40) | a fighter on a bad run |
| Drill sergeant | a sparring night counts 1.25 for move mastery and plan tests, +3 fatigue a night | -10 with Flat or Low mood, +4 with discipline 70+ | a boxer far from a bout |
| Technician | pad learning x1.15 only on moves already Usable (polish, not start) | +4 with coachability 70+ | a boxer with a plan to sharpen |
| Old hand | a fighter back from injury or overreached (fatigue 80+) loses the x0.6 gains and x3 injury risk one week sooner | +4 with a veteran (31+) or one back from injury | a crowded calendar |

Today's two assistants: the pads coach is a Technician, the conditioning coach a Drill sergeant. The market adds a young Motivator (pads)
and an Old hand (sparring, bag).

## 6. Bond
Steps Stranger / Working / Trusted / Corner, one per coach and fighter pair; not loyalty (loyalty is to the club).
- Built: +1 per session together, +6 per bout this coach worked the corner, +10 for a loss survived together. Thresholds 0 / 12 / 60 / 140
  (Kalli point 10: Working after about two weeks of sessions, as the line promises; ESTIMATE, BONDPROBE1).
- Lost: -2 a week apart; -20 when the player moves the fighter off this coach mid-camp; a quarrel (below).
- Does: the fit part above; THE CORNER (section 8); a Corner-step coach leaving costs the fighter -8 mood. ("-5 loyalty" dropped until
  loyalty has an effect, Kalli point 10.) The head coach's bond step IS the "known" level Loyalty reads: one number.
- QUARREL, readable (Kalli point 9): a Drill sergeant with a Flat or Low fighter shows FRICTION on the row. Each week at friction, 1 in 6
  chance of a quarrel (-15 bond, -5 mood); the chance is on hover, with the answer on the row: move the area, or keep going.
- Mood bands used everywhere here: Low under 40, Flat 40-59 (the game's morale words).

## 7. The head coach's rule (decided, Kalli point 7)
The head coach (the player) runs 4 sessions a week, any areas, at rating 60 in the background's area and 45 elsewhere (Ex-pro: pads;
Amateur coach: pads; Strength coach: strength; Old hand: conditioning). The head coach has no growth and no wage. The 0.6 "alone" factor
now means "nobody on this session". CHECK (Claude, before the build): HeadCoach.gd has no rating today; WeekPlan reads CoachAreas.rating_for
- add the head coach as a coach row there, not a special case.

## 8. The corner is a pick (Kalli point 8)
On the bout card, WHO WORKS THE CORNER lists each candidate with the shout number: coachability rule x mood x bond (0.90 / 1.00 / 1.05 /
1.10), floor 0.5. The player still makes every call. An assistant at Corner beating the head coach's own number is the reward a season of
bond buys. The fight screen's Heard / Half heard already shows it landing.

## 9. The school (Kalli point 6)
- Each assistant has a school of 5 to 7 PUNCHES AND COMBINATIONS (moves with mastery today; steps join when StrikeMap arrows get mastery,
  STEPMASTERY1).
- In the school: learning x1.1. Outside it: Signature work at x0.5 of M6's rate (slower, never impossible).
- The head coach's school comes from the background: Ex-pro the pads moves (Jab, Cross, Lead hook, Check hook); Amateur coach Jab, Cross,
  Body hook; Strength coach Body hook, Uppercut; Old hand Jab, Lead hook.

## 10. The decision a week
- MONDAY (Staff app on the office computer; the week board's rows): the table of fighter x area -> coach. Each cell: coach, FIT word,
  load "9 of 8", bond step, FRICTION or TAUGHT OUT when they apply. One action per cell: Swap. The swap shows its price before the click
  (new fit, bond back to Stranger, what stops growing).
- "The coach runs it" (C20, AGREED) fills the best table, never over a list unless there is no choice, and says why in one line.
- The Monday review asks the raises (Pay / Say no) and names growth milestones ("6 pad sessions to 65: second learning slot").
- HIRE / LET GO: market cards show temper, school, ceiling range, list size, wage. Let go costs a week's pay and every bond.
- FIGHT WEEK: the corner pick (section 8).

## 11. Probes, in order (Kalli point 13)
1. FITPROBE1 (Goose): 26-week careers via career_harness, four arms (fits at 50 = today; as written; best table weekly; worst weekly),
   with per-area lists. Bars: best minus worst 4-8 wins in 100 without the rating; no fit part over half the fit; one assistant for four
   boxers costs 2-5; Motivator vs Drill sergeant on a Low fighter differ by 2+; the best table changes 3+ times a season; each temper best
   for one bot type.
2. BONDPROBE1: Stranger vs Corner in close bouts worth 2-4 wins in 100; Working in ~2 weeks, Trusted ~10, Corner ~a season.
3. The four S412 bots (loyal / rotate every block / rotate at the ceiling / one-week farm) with raises and the taught-out rule on: fails if
   one strategy beats the rest by more than 5 points, or the farm beats loyal once costs count.

## 12. Every menu it appears on, and what each is wired to
| Menu | Shows | Wired to |
|---|---|---|
| Week board (Training) | each session row: coach or "alone", FIT word, parts on hover, FRICTION / TAUGHT OUT | CoachFit (new), WeekPlan, PadWeek |
| Office: Staff app | coach cards (areas, growth ticks, ceiling range, temper, school, list "9 of 8", wage); the fighter x area table with Swap; market with Hire | CoachFit, CoachLoad, CoachGrowth (new), StaffRoles |
| Office: Desktop | a list over or a raise asked, in Needs you | OfficeDesk |
| Fighter page, Training | the fighter's coach per area, bond steps and next threshold | CoachFit, Bond (new) |
| Fighter page, moves | "in the pads coach's school x1.1" on a move bar | CoachSchool, MoveTree |
| Learning-slot cards (SLOTS1) | the school reason | LearnSlots |
| Monday review | raises (Pay / Say no), growth milestones, bonds reached, a quarrel | CoachGrowth, Bond, WeekCoach |
| Bout card / fight week | the corner pick with each candidate's number | Bond, AMATEURWEEK1 |
| Fight: shouts | Heard / Half heard, now by bond too | Exchanges, Bond |
| Result page | "The corner: Trusted, 4 of 5 calls heard" | FightWhy, Bond |

## 13. Build order
1. FITPROBE1, BONDPROBE1, the S412 bots (measurements; rules modelled in the probes).
2. Pure rules + tests: CoachFit, CoachLoad (sessions), CoachGrowth (ceiling, taught out, raise), Temper, Bond (with friction), CoachSchool.
   Data: tempers, schools, ceilings on the coaches; the head coach as a coach row.
3. Wiring: WeekPlan/PadWeek read the fit and the per-area coach; the shout reads the bond; MoveMastery reads the school.
4. Screens (Grok Dev, one a task): the week board rows, the Staff app table, the fighter's Training strip, the corner pick.
5. Golden path: hire the young Motivator, set the table, reach Working, hit a list, pay a raise, swap an area at TAUGHT OUT, a bout where
   the chosen corner's number shows on the shouts and the result.

## 14. Needs that are not built yet (said, not hidden)
The rival gym's offer (AGREED, NOT BUILT - SAY NO costs mood only until then); step mastery in the school (STEPMASTERY1); the office
Staff app (OFFICE2); per-area coaches on mornings (this map's step 3).

## 15. Open for him (taste and scope, after the critics)
- The four tempers: the right flavours?
- A raise every 5 points: right pace, or too often?
