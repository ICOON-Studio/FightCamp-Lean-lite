# COACHFIT1 v1: coaches who fit, fill up, grow, have a temper and bond (S450)

Sources:
- His order, Q-S294-210 "Yes, that order": the fight week, the office computer, then coaches (fit, load, growth, personality, bond), then
  the contract tab.
- The S448 plan (OFFICE_BOOKING_S448.md section 4), read from Corner King's code. Their pairing score is real. Their cutman, matchup
  analyst, personality bonus and per-block assignment do NOTHING in code. Growth is ~75 sessions per hidden step. We take the idea and
  WIRE every piece.
- Built or approved that this map must not contradict:
  - PROGRESSION_MAP_S448 M6 (approved Q-211): pads rating sets every bar's speed; the second learning slot comes from an assistant with
    pads 65+; Signature work = clamp((pads - 55) / 20, 0.25, 1); the four-assistant market; growth +1 per 10 sessions to a ceiling.
  - The club's 8 pad nights a week (AGREED PADPOOL1).
  - Loyalty.gd (R58LOYAL1, built): loyalty and "known" (how well the coach knows the fighter, RPG 3).
  - The shout rule (Exchanges: coachability 0..100 -> a shout lands 0.7..1.0).
  - Coach areas (CoachAreas: pads, bag, conditioning, strength, sparring; `rating` = their average).
- The S412 coach design (COACH_DESIGN_S412.md): his book, his limit, the bond. Its "book" is folded in here as the coach's SCHOOL.
  Its bond steps are kept.
- Rules this map obeys: names only in headers; game words; one pulsing button a screen; every mechanic wired and shown; no "+5% training"
  perks.

## 1. The idea in one paragraph
Today a coach is one average number. After COACHFIT1, WHO trains WHOM is a weekly decision with a price on every row.
- A coach who fits a fighter (the right area, a temper that suits the fighter's mood, room on his list) makes the week count more and
  tire less.
- An overloaded coach makes it count less.
- A coach grows from the sessions he runs, so a cheap one who works with your fighters becomes good.
- A bond grows between a coach and a fighter. On fight night it is the difference between a corner call that lands and one that does not.
- Every number shows on the week board's session row, and every one moves gain, tiredness or the corner.

## 2. Pairing fit (the number on every session row)
Each session (pads, bag, conditioning, strength, sparring) a coach runs for a fighter has a FIT, 0 to 100 from 50. ESTIMATE, sized by
FITPROBE1 (section 9).

| Part | Points | Read from |
|---|---|---|
| His rating in that session's area | +14 at 75+, +7 at 60-74, 0 at 40-59, -12 under 40 | CoachAreas.rating_for |
| The session trains the fighter's weakest of the stats it moves | +8 | the fighter's stats |
| The fighter's mood x his temper (section 5) | -10 to +8 | morale, the coach's temper |
| His load (section 3) | 0 at or under his list, -6 at one over, -16 at two or more over | the week board |
| The bond (section 6) | Stranger -6, Working 0, Trusted +4, Corner +6 | bond step |

What it does (the only two levers, both already in the week's maths):
- GAIN: x0.90 at 0, x1.00 at 50, x1.10 at 100 (linear) on that session's gains.
- TIREDNESS: x1.10 at 0, x1.00 at 50, x0.94 at 100 on that session's fatigue.

Words on the row: TOP FIT (80+), GOOD (60-79), MIXED (40-59), RISKY (under 40). Hover shows each part with its points. That is the
whole explanation, no paragraph.

The head coach (the player) has a fit too. The player's areas come from the HeadCoach background, which is today's rule.

## 3. Load: each coach has a list
- Each assistant takes 2 fighters (+1 at a pads or sparring rating of 80+, the only way past 2). The head coach takes 3.
- The start (four fighters, the head coach plus one assistant) gives 5 places for 4 fighters. The BJJ fighter's mat coach is outside
  this list (BJJ has its own coach).
- Over the list: every fighter on that coach's list takes the load penalty (section 2), not just the last one added. The board shows
  the coach's list as "3 of 2". The fix is a hire, moving a fighter, or accepting it for a fight week.
- The club's 8 pad nights a week are unchanged (PADPOOL1). Load is about WHO runs a fighter's nights, not how many nights there are.

## 4. Growth you can see
- The progression map's rule (M6, RPG 11): +1 in an area per 10 sessions he runs there, up to that coach's ceiling (hidden only until
  the head coach has watched him for 4 weeks; then it is printed).
- Shown: each area bar on his card with a tick at the next point and "7 sessions to 66". The Monday review names a milestone that
  changes something: "6 pad sessions to 65: second learning slots".
- A coach's growth stays with that coach. Let him go and it goes with him (the market's "let go" rule).
- Coaches do not grow in an area they are not running. The choice of who runs what is also who you are growing.

## 5. Personality: four tempers, each changing ONE thing
Every coach has one temper, shown as a word on his card with its one effect. ESTIMATE, sized by FITPROBE1.

| Temper | The one thing it changes | Fit part (section 2) |
|---|---|---|
| Motivator | a fighter's mood after a loss: -12 becomes -8 | +8 with a fighter on low mood (under 40), 0 otherwise |
| Drill sergeant | his sessions' gains x1.05 and their fatigue x1.05 | -10 with a low-mood fighter, +4 with a high-discipline one (70+) |
| Technician | move learning on his pad nights x1.15 (MoveMastery gain) | +4 with a coachable fighter (70+), 0 otherwise |
| Old hand | the fighter recovers 1 more tiredness a rest day | +4 with a veteran (31+) or a fighter back from injury |

The two existing assistants get one each: the pads coach is a Technician and the conditioning coach is a Drill sergeant. The market's
two new assistants are a young Motivator (pads) and an Old hand (footwork, sparring).

## 6. Bond: coach and fighter
Four steps (from COACH_DESIGN_S412): Stranger, Working, Trusted, Corner. One bond per coach and fighter pair. It is NOT loyalty: loyalty
is to the club, bond is to the coach.

- BUILT by:
  - +1 per session together
  - +6 per bout he worked her corner
  - +10 for a loss survived together (the week after a loss, still together)
  - Thresholds 0 / 30 / 80 / 160 (ESTIMATE).
- LOST:
  - -2 a week apart
  - -20 when the player moves the fighter off his list mid-camp
  - a quarrel event (rare, the drill sergeant with a low-mood fighter)
- WHAT IT DOES, and where:
  - Fit (section 2): -6 / 0 / +4 / +6.
  - THE CORNER (fight night): when he works her corner, a shout lands at (the coachability rule) x (0.90 / 1.00 / 1.05 / 1.10) by bond
    step. "Heard" and "Half heard" already show it on the fight screen.
  - Mood: a Corner-step coach leaving costs the fighter -8 mood and -5 loyalty (Loyalty.apply cause "coach_left").
  - "Known" (RPG 3, Loyalty): the head coach's bond step IS the known level the loyalty band reads, so one number, not two.
- The first two weeks with a new coach are Stranger: the fit's -6 is the "slow start" COACH_DESIGN_S412 asked for, priced before the
  click.

## 7. His school (the S412 book, kept small)
Each assistant has a school of 5 to 8 nodes from MoveTree (MOVETREE1, built): the moves he teaches best.
- On a move in his school: learning x1.1 and Signature work at his full rate (M6).
- Outside it: learning x0.9, and he can hold the move (no fade) but not take it past Sharp.
- Schools:
  - the pads coach: Jab, Cross, Lead hook, Check hook, step_in, step_out
  - the conditioning coach: Body hook, tie_up, push_off, cut_off, herd
  - the market's footwork coach: step_back, pivot_out, roll_out, feint, step_out
  - the young pads coach: Jab, Cross, Uppercut, Lead hook, Body hook
- The learning-slot cards (SLOTS1) gain one reason: "In the pads coach's school: x1.1". Where a coach stops, it shows as a line on the
  fighter's move bar.

## 8. The decision a week (what the player does)
- MONDAY (the week board, the Staff app on the office computer): the list of who runs whom. Each row: fighter (portrait, class),
  coach, FIT word + number, load "2 of 2", bond step, and one action: Swap coach.
  - The swap shows its price before the click: the new fit, the bond reset to Stranger, what stops growing.
  - "The coach runs it" fills the best assignment (the C20 control, AGREED): pick by fit, never over load unless no choice, and say why.
- HIRE / LET GO (the Staff app): the market's cards (M6) now show temper, school, list size, growth line and wage. Hire is the one
  button. Let go costs a week's pay and every bond with that coach.
- FIGHT WEEK: who works the corner (the head coach, or the assistant with the best bond); the bond's corner number shows on the bout
  card ("the corner: Trusted, calls land x1.05").

## 9. Probes (before any rule freezes)
- FITPROBE1 (Goose/Qwen, measurement): 26-week careers through the career harness, four arms:
  - all fits held at 50 (today)
  - the fit as written
  - the best assignment every week (the coach runs it)
  - the worst every week
  - Bars:
    - best minus worst is worth 4 to 8 wins in 100 over a season
    - no single part of the fit is more than half of it
    - an overloaded single coach (4 fighters, one assistant) costs 2 to 5
    - a Motivator vs a Drill sergeant on a low-mood fighter differ by at least 2
- BONDPROBE1: the corner multiplier's worth in close fights (Stranger vs Corner) inside 2 to 4 wins in 100 on close bouts; the bond's
  build so a fighter reaches Trusted with one coach in about 12 weeks and Corner in about a season.
- The S412 bots still apply: loyal / rotate every block / rotate at the limit / one-week farm. It fails if one strategy beats the
  rest by more than 5 points across boxer types, or the farm beats loyal once costs count.

## 10. Every menu it appears on, and what each is wired to
| Menu | What it shows | Wired to |
|---|---|---|
| Week board (Training) | each session row: coach, FIT word, number on hover with its parts | CoachFit (new), PadWeek, WeekPlan |
| Office: Staff app (OFFICE screen 5) | each coach: areas with growth ticks, temper, school, list "2 of 2", wage; the who-runs-whom table with Swap; the market's cards with Hire | CoachFit, CoachGrowth (new), StaffRoles, the market data |
| Office: Desktop | the staff strip: list used, an overload in Needs you | OfficeDesk |
| Fighter page, Training | the fighter's coach, fit, bond step and its next threshold | CoachFit, Bond (new) |
| Fighter page, moves | where the coach stops (line on the bar), "in his school x1.1" | the school data, MoveTree |
| Learning-slot cards (SLOTS1) | the school reason | LearnSlots |
| Monday review | growth milestones; bond steps reached; an overload | CoachGrowth, Bond, WeekCoach |
| Bout card / fight week | who works the corner, the bond's corner number | Bond, AMATEURWEEK1 |
| Fight: shouts | Heard / Half heard (already there), now also by bond | Exchanges, Bond |
| Result page | "The corner: Trusted, 4 of 5 calls heard" | FightWhy, Bond |

## 11. Build order
1. FITPROBE1 + BONDPROBE1 (measurements, rules modelled inside the probe).
2. Pure rules with tests: CoachFit (fit and its two levers), CoachLoad, CoachGrowth (the M6 rule plus the visible ceiling), Temper,
   Bond, CoachSchool. Data: tempers and schools on the coaches.
3. Wiring: WeekPlan/PadWeek read the fit; the shout reads the bond; MoveMastery reads the school; Loyalty reads the head coach's bond.
4. Screens (one a task, Grok Dev): the week board rows, the Staff app (office screen 5), the fighter's Training strip.
5. Golden path: hire the young pads coach, assign two fighters, reach Working, swap one, see the fit and the bond move, a fight where
   the corner's bond shows on the shouts and the result.

## 12. Risks
- Too many numbers on a row: one word + one number, the parts only on hover.
- An optimal assignment found once and never touched: the bond's build and growth make the second season's best list different from
  the first. FITPROBE1 reports how often the best list changes in a season (target: at least 3 times).
- Coaches feel like perks: each temper changes one thing the fight or the week reads; no flat % on everything.

## 13. Open for him (taste and scope, after the critics)
- Four tempers: the right flavours, or would he name others?
- The bond lost when a coach leaves: right, or too harsh?
