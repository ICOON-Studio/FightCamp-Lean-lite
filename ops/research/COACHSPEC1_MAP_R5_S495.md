# COACHSPEC1 - coach roles and specialties (design map, S490, round 4 S493)

Status: PROPOSAL, round 4 (S493): section 12 answers the round-3 critic. Round 3 (S492): the rules a critic found broken in round 2 are rewritten and re-probed (section 11 lists
each). Per the S425 rule it reaches the operator's board only after two fresh critics score its depth 7 or more. Nothing here
is built. Screens: `docs/mockups/s490/coach_spec/` (staff_hire, evening_plan; drawn for round 2, section 11 says what they
must change). Balance probes: `probe_coachspec.py` (round 2) and `probe_coachspec_r3.py` (round 3 rules R1-R7, pads over 12
weeks, mobility) in the same folder - pure Python copies of the game's gain and mastery rules; the tables in section 6 are
their output.

## 0. The operator's idea (verbatim, S490)
"have you consider adding specialties on coaches : Head Coach / Program Director: Oversees overall gym operations, sets the
overarching strategy, and integrates different martial arts styles. Striking Coaches: Specialized instructors for Boxing, Muay
Thai, or Kickboxing. Grappling & Ground Coaches: Instructors for Brazilian Jiu-Jitsu (BJJ) (Gi and No-Gi) and Wrestling or
Judo for takedowns and clinch work. MMA / Transition Coaches: ... Strength and Conditioning (S&C) & Fitness Coaches: ...
sometimes supplemented by mobility or yoga instructors"

Scope (CLAUDE.md item 4): boxing + one BJJ athlete now; wrestling later as its own sport; no MMA or Muay Thai now. So this map
designs FOUR roles: head coach (you), boxing coach, BJJ coach, strength and conditioning coach (mobility inside it). Section 8
says how the same table takes the other roles later without a rewrite.

Words: the stat is **Stamina** on every screen (operator S443, Q-S294-195; `Data.LABEL` `Data.gd:14`,
`CoachedMornings.WORDS` `:30`). The coach AREA that rates those mornings is called "conditioning" in code
(`CoachAreas.AREAS`); screens label the meter "Stamina".

## 1. What exists today (code wins)

| Piece | File | What it does today | Wired? |
|---|---|---|---|
| Five coach areas | `scripts/rules/CoachAreas.gd:9-17` | pads, bag, conditioning, strength, sparring; every session maps to one area (roadwork, intervals, mobility -> conditioning; strength, neck -> strength; heavy bag, speed bag, shadow, slip rope -> bag; pads; sparring) | yes: `WeekPlan.coach_for` (`WeekPlan.gd:214-218`) reads the hired coach's rating for the session's area |
| Lift per area | `CoachAreas.gd:63-71` | stat sessions: (0.5 + 0.007 x rating) / 0.6 - 1 against no coach; pads (move learning): rating x 0.40 / 100 | yes |
| No coach | `CoachAreas.gd:7-8` | rating 14.3 = coach factor 0.60 | yes |
| The two hireable coaches | `scripts/state/Data.gd:33-40` | Luke Reid, sessional $450/wk: pads 74, bag 64, sparring 58, conditioning 48, strength 46. Marcus Hale, full-time $1,090/wk: conditioning 90, strength 84, bag 72, sparring 66, pads 58. $1,000 to sign | yes; ONE coach rates EVERY session of every fighter |
| Coach market | `scripts/rules/CoachMarket.gd` | two more (Jamie Price $380, Rosa Mendez $520), at most 2 hired | no (tests only) |
| Head coach = the player | `scripts/rules/HeadCoach.gd` | four backgrounds, one edge each: Old hand (cuts), Ex-pro (1 tell), Amateur coach (exact potential), Strength coach (body mornings x1.10, craft x0.90). Has NO area ratings | yes |
| Coached mornings | `scripts/rules/CoachedMornings.gd:14-20` | a week of coached mornings: you own 4, a sessional coach 2, full-time 3; a coached morning x1.25 (x1.40 on the weak spot), a pair on the same drill x1.15 each | built, NOT wired (tests only) |
| Pad nights in minutes | `WeekPlan.gd:54-57` (75 min a pad night), `PadWeek.gd:38` (240 drill units a night) | a pad night is 75 min of the coach; the agreed training_k board (`docs/mockups/s483/training_k.html`) splits his 75 min between the fighters on that night, by face | 75 min: yes. The split per fighter: AGREED, NOT BUILT (CRITIC_PACK 4.2) |
| Nights laid | `PadWeek.gd:49-54,78-94` | between fights Standard = 3 pad + 1 sparring: sparring Thursday (Tuesday too at two), pads Mon / Wed / Fri first | yes |
| Phase | `WeekPhase.gd:43-58` | an amateur bout 2 weeks out is a BUILD week, never PEAK (S474: no camp); the bout's own week is the FIGHT WEEK | yes |
| Coach fit, coach time | `scripts/rules/CoachFit.gd:33-50` | time units a week (sessional 10, head 4), costs per session, overrun penalty | no (design v8). NOT used by this map any more (section 3.0) |
| Specialty (the hold) | `scripts/rules/Specialty.gd` | the weekly hold that keeps 60+ moves sharp | yes - NOT a coach specialty, despite the name |
| S&C staff job | `scripts/rules/StaffRoles.gd:10,18` | "Strength and conditioning coach, 2 sessions", $100/wk: training injury risk x0.85, a pro camp's bill halved. No effect on gains | yes (`GymSpend.gd:85`) |
| BJJ coach | `scripts/rules/BjjSide.gd:20-22,42-43` | $34 a one-hour class; 3 adult + 2 beginner classes = $170/wk | yes, as a COST line only |
| BJJ learning | `scripts/rules/NoGi.gd:16,19` | 3 classes a week, the syllabus move +3.2 mastery a week, flat: the coach has no quality | yes |
| Mobility | `WeekPlan.gd:40,271-276` | a 20-min morning with no stat; a small Flexibility gain at the coach's rating | yes |
| Move mastery | `MoveMastery.gd:8,62-79` | 2.1 an hour on pads x (1 + 0.40 x pads rating / 100) x (1 - m / cap); Usable at 30, Sharp at 60 | yes |

## 2. The gap the idea fills
1. Roles are hidden. Reid is "a pads coach" and Hale "a conditioning coach" only as numbers; nothing says what each is FOR.
2. One coach rates every session of every fighter: no choice of who coaches whom.
3. The S&C job changes injury risk only. A specialist who does not make anyone fitter is not a specialist.
4. The BJJ coach is a bill, not a person: no quality, the same +3.2 a week whoever teaches.
5. The head coach has an edge but no job in the week. The operator's "oversees ... integrates different martial arts styles"
   is the job nobody does today: deciding who coaches whom.

## 3. The proposal: four roles on the five areas

### 3.0 One time model, the two that already exist (reconciled)
Review round 1 found a third model (CoachFit units) beside two agreed ones. This version uses ONLY the agreed two:
- **Mornings = CoachedMornings** (built, not wired): each week you deal coached mornings - you own 4, a sessional boxing coach
  2, a full-time 3 (`CoachedMornings.gd:19-20`). A coached morning x1.25 (x1.40 on her weak spot); a pair x1.15.
  NEW: the S&C coach owns their DAYS, not a count. On each of their days the Stamina and strength mornings are his GROUP session:
  - **R1 better of the two:** the group morning is rated max(their area, the boxing coach's programme area), so a hire never
    lowers a morning. With the full-time coach (Stamina 90) the S&C coach adds their days and the group bonus, not their rating -
    the hire card says so ("adds days and the group, not rating").
  - **R2 a group needs two:** x1.15 only with 2 to 6 fighters on that morning; one fighter alone trains at x1.00.
  - **R3 one runner, no stacking:** a morning that you or the boxing coach coach on one of their days is run by that coach
    (x1.25, x1.40 on the weak spot) and gets no group bonus. The week board shows the runner's coin; the deal only moves a
    morning off the group where the coached morning adds more.
  A morning nobody coaches runs on the boxing coach's programme: their area rating, x1.00 (today's wired rule, unchanged).
- **Nights = training_k minutes**: a pad night is 75 min of the boxing coach (`WeekPlan.gd:57`), split between the fighters on
  pads that night (the agreed training_k coach row). A sparring night: the coach referees (training_k). NEW (**R4**): you may
  hold one fighter's whole pad night yourself - 75 min at YOUR pads rating. It costs **2 of your 4** (a full evening against a
  morning's attention) and at most **1 a week**; that fighter leaves the coach's split, so the others get the whole 75.
- **Rating = whoever runs it**: every morning and night is rated at the area rating of the person who runs it (CoachAreas, wired).
- CoachFit's time units, its overrun penalty ("fit -8") and "coach time 10 of 10" are dropped from this map. CoachFit's other
  parts (bond, temper) are untouched and still its own design.

### 3.1 Head coach - you (no hire)
- Runs: mornings, pad nights, the corner. NEVER mat classes (you are a boxing coach; the mat is the BJJ coach's). Both screens
  show the same: the head coach card lights sun / moon / stool and greys the mat.
- 4 a week (`CoachedMornings.YOU_OWNED`): each a coached morning; one held pad night costs 2 (R4).
- Areas (P): **40 in every area, 55 in ONE area per background** (Old hand -> bag; Ex-pro -> sparring, which is what the
  corner reads (3.6); Amateur coach -> pads; Strength coach -> strength only, its x1.10 body mornings / x0.90 craft edge kept
  as the background's own edge, like the Old hand's cuts). 40 sits under every area of Reid (lowest: strength 46), so with
  Reid hired the boxing coach always out-rates you except in your edge area. Lift at 40: +30% stat, +16% pads; at 55: +48%
  stat, +22% pads.
- Why you still matter on a morning: attention, not rating. Lucy's Normal Stamina morning: nobody (Reid's programme 48)
  0.150; you coaching it (40, x1.25) 0.175; Reid coaching it (48, x1.25) 0.187 (probe).
- Every "was" baseline on the screens is the better of you and the boxing coach for that area. With Reid and the Old hand that
  is always Reid. With the Strength coach background it would be you (55) on Stamina and strength: the screens then compare
  the S&C candidate against you.
- Today the head coach rates nothing; keeps the four edges unchanged (`HeadCoach.gd`).

### 3.2 Boxing coach (the striking coach) - Reid, Hale, Price, Mendez
- Runs: pad nights (75 min each, split by face), sparring nights (referee), the corner, and their coached mornings (2 sessional,
  3 full-time). Unattended mornings run on their programme at their area rating (today's rule).
- Areas: as in code (`Data.gd:34-39`, `CoachMarket.gd:12-17`). The role badge reads the top area: "Pads" Reid.
- The weekly puzzle: three boxers, a Standard week of 3 pad nights each (`PadWeek.gd:54`), but one coach with 3 x 75 min.
  Worked example (evening_plan, a STAND-IN split): Mon Lucy 45 / Josh 30; Wed Kira 75 (you take Lucy); Fri Josh 45 / Lucy 30.
- Cost: unchanged ($450 sessional is the decided number; $380 / $520 / $1,090 from code).
- **R7 two boxing coaches** (the slots allow 2, `CoachMarket.MAX_HIRED`): each brings 75 min to every pad night (two coaches
  = 150 min a night, so three boxers stop sharing one coach), each brings their coached mornings (2 sessional, 3 full-time),
  and the unattended programme takes the better rating per area. The head boxing coach (the player picks one on the staff
  page) sets the programme's plan; the second holds pads and coaches mornings. Probe: Reid + Price ($830) gives the club's
  moves their first Sharp in week 5 instead of 10 and +17% pad mastery, but only +1.0 stat points - the moves route.

- **R13 class nights cost pads (round 4):** each evening-class night (the +$350 a week the coach already earns, decided
  numbers) takes 30 of that night's 75 pad minutes. The player picks 0, 1 or 2 class nights: money or moves (P).

### 3.3 Strength and conditioning coach (mobility inside it) - NEW as a coach, replaces the flat S&C job
- Runs: MORNINGS ONLY, as group sessions on their days. Never pads, sparring, corner or mat.
- Days: the player picks their days for the whole club on the week board (2 days for the $100 hire; 4 days for the $200 hire (P)).
- Areas (P), re-set by the probe (v1 had 80 / 82): candidate A, 2 days, $100/wk (the code's wage, `StaffRoles.gd:10`):
  **Stamina 66, strength 68** - an accredited S&C coach (UKSCA in the UK; CHECK). Candidate B, 4 days, $200/wk (P):
  **Stamina 60, strength 60** - a gym fitness instructor: lower rated, cheaper per day, more days. The card says which.
- Mobility (round 3 decision, R5): the injury cut stays AUTOMATIC with the hire (risk x0.85, `StaffRoles.gd:18`, today's
  code) and mobility is NOT a weekly choice. Round 2 made the cut need a mobility morning; the probe priced that choice and
  nobody would take it: at the code's 1.3% training injury a week (`InjuryRoll.TRAIN_BASE_10H`), even a x0.6 cut saves
  0.009 stat points a fighter-week (0.021 overreached) against the 0.099 a half-gain morning costs, and 0.5-1.3% of a bout in
  a BUILD week. An option that never wins is cut, not dressed up.
- The pro camp bill halved (code) stays.
- **R12 load (round 4):** a morning the S&C coach runs costs x0.85 of its tiredness (load planned, not just sets), and in a
  fight week the S&C coach plans the taper: tiredness at the first bell -3 (P). This is the real job (Kalli r3 depth 3).

One Normal morning, the women's lightweight (headroom Stamina 0.90, Strength 1.02), probe output:

| Who runs the morning | Rating | Mult | Stamina | Strength |
|---|---|---|---|---|
| Nobody (the sessional coach's programme) | 48 / 46 | x1.00 | 0.150 | 0.168 |
| You (P) | 40 | x1.25 | 0.175 | - |
| The sessional coach coaching it | 48 | x1.25 | 0.187 | - |
| S&C B, group (P) | 60 / 60 | x1.15 | 0.190 | 0.217 |
| S&C A, group (P) | 66 / 68 | x1.15 | 0.198 | 0.230 |
| The full-time coach's programme | 90 / 84 | x1.00 | 0.202 | 0.223 |

Per fighter of the test club (staff_hire "On your fighters"; the sessional coach's programme -> S&C A group):
women's lightweight Stamina 0.150 -> 0.198, Strength 0.168 -> 0.230; women's featherweight 0.187 -> 0.248, 0.206 -> 0.281;
men's welterweight 0.094 -> 0.124, 0.105 -> 0.144 (near the ceiling: the player puts the S&C days where the young ones
train hard).

### 3.4 BJJ coach - the no-gi coach gets a belt
- Runs: the athlete's mat classes (3 a week, `NoGi.gd:16`) plus the club's no-gi classes (BjjSide). Never boxing.
- Belt sets the drill rate (P): brown belt = today's numbers ($34/class, +3.2 a week); black belt $45/class (P), x1.25 (P) =
  +4.0 a week. Weekly bill (5 classes): brown $170 (code), black $225 (P).
- A 30-mastery move owned in 9.4 weeks (brown, code rate) or 7.5 (black, P).
- **R8 promotion follows the IBJJF (Art. 6.1-6.3):** the athlete's belt is signed by the mat coach, never by you (a boxing
  coach). A brown-belt coach can stripe and promote up to PURPLE (6.3, where black belts are scarce); brown and black need a
  black-belt coach; a black belt needs a black belt of 2nd degree or more - a third, dearer candidate or a guest professor for
  a fee (P). So the belt hire is a ceiling on the athlete's career, not only a drill rate. Sources: section 7.
- Gi: out of scope. Wrestling for takedowns: waits for the wrestling sport.

### 3.5 Hiring rules (one budget)
- Slots: you (always), up to 2 boxing coaches (`CoachMarket.MAX_HIRED`), one S&C, one BJJ coach (only with a BJJ athlete).
- Signing fee: $1,000 for a boxing coach (code). S&C and BJJ: a week's pay to let go (`StaffRoles.notice`), no signing fee (P).

### 3.6 The corner (R10, round 4: replaces R6)
- On a club show the club's boxing coach works EVERY corner for the club - bouts run one after another and club mates are never
  matched (England Boxing practice; Kalli's round-3 fault 1). So there is no corner pick: the corner is the head boxing coach,
  or you when none is hired.
- The corner's **sparring** rating (ring reading) adds to a GOOD call's edge and never takes away (fault 2: today's x1.0 is
  the floor): edge x (1 + 0.004 x max(0, sparring - 40)). You 40 -> x1.00 (today), Ex-pro 55 -> 1.06, sessional 58 -> 1.07,
  full-time 66 -> 1.10, the women's-coach candidate 72 -> 1.13. A wrong call is unchanged. Not probed over a bout: it can
  only add, so no club is worse than today; the size is read in the build's probe and shown on the hire card.

### 3.7 Staff over months (R11, round 4: growth CUT)
- Kalli round 3: +1 a quarter is too slow to feel and was never shown. Cut. A coach's ratings are what the hire card says.
- Kept: a boxing coach given no pad night and no coached morning for 4 weeks asks to leave - now WARNED: the week review shows
  "the coach has had no work for 3 weeks" one week before the notice.

## 4. What the player decides each week
1. Which two (or four) days are the S&C coach's, and lining each fighter's Stamina / Strength mornings up with them (their days
   are a teal chip on the day header and a teal tint on every morning they run).
2. Where your 4 go: four coached mornings (x1.25 at your rating), or one fighter's whole pad night (75 min at your pads
   rating, costs 2) and two mornings. 12-week probe (Reid route): the night trades 1.9% of the club's stat points for the
   club's first Sharp move in week 7 instead of 10 - worth it when a move sits under a line before sparring or a bout.
   Evening_plan's Wednesday: you hold her pads 75 min -> uppercut 23.4 -> 30.2, Usable Wed (so Thursday's sparring drills it,
   `PadWeek.gd:384-394`), and the featherweight gets the coach's whole 75 (check hook 12 -> 21.1); costs one coached morning.
   Or your coach holds them 45 min -> 28.0, Usable Fri, and the featherweight gets 30 (-> 15.7). (Uppercut 18.5 and check hook
   12 at the start of the week are STAND-INS; every step after is `MoveMastery.gain`.)
3. On the mat: whether the athlete teaches the beginners (code: saves $68 a week, costs her one class), and which belt of
   coach to pay for - the ceiling on her promotions (3.4).
4. Over months: which role to hire next with one budget - stats (S&C, full-time coach) or moves (a second boxing coach),
   section 6 - and which coach to keep busy (a coach with no work for 4 weeks asks to leave, 3.5).

## 5. Every menu the mechanic appears on (S425 rule)

| Menu | What shows | Wired to | Exists? |
|---|---|---|---|
| Club > People > Staff (hire) | role cards (you, boxing, S&C, BJJ) with what each runs (sun / moon / stool / mat with a word under each), 5 area meters with the area word, the 4 / 2 + 3 a week; S&C candidates with his days, Stamina and Strength meters against today's tick, the injury shield, "adds days and the group, not rating" when the full-time coach out-rates him; per-fighter 12-week totals before -> after (never one morning's %); the hiring routes with $/week, 12-week stat points AND pad mastery + first Sharp week (two columns: stats, moves) | `Data.COACHES` + `CoachMarket.market()` (+ `role`), `StaffRoles` (S&C becomes a coach record with areas and days), `BjjSide` (+ belt), `CoachedMornings.owned`, probe numbers (to become a forecast call) | screen exists (StaffCard); roles NEW. Mockup `staff_hire` |
| Fighter Week (training board) | S&C DAYS row (their chips), COACH row in minutes by face (training_k) with your slice, morning tiles tinted by who runs them + coin, evening tiles with the coin of who holds the pads, the decision box for a night (hold her pads: costs 2 suns), THIS WEEK in totals (stat points, mastery) | `WeekPlan.coach_for` reads the runner of THAT slot (ctx `coach` becomes per-slot); `CoachedMornings.deal`; PadWeek night minutes per fighter (`nights.per` already exists, `PadWeek.gd:332-334`) | board exists (training_k agreed look); roles NEW. Mockup `evening_plan` |
| No-gi athlete page | THE MAT COACH: belt, drill rate a week, classes, "can promote up to: purple" (her ceiling under this coach) | `NoGi.DRILL_GAIN` x belt mult (P), `BjjSide.coach_week`, promotion ceiling by coach belt (R8) | page exists; belt + ceiling NEW |
| Money | coach wages grouped by role in WHERE IT GOES | `StaffRoles.wages`, `GameMoney`, `BjjSide.money` | exists; grouping NEW |
| Week review (Monday) | "Stamina +0.198 on the S&C morning"; "pads: 1 night with you, 2 with your coach"; R14: "You held her pads on Wednesday: the uppercut turned Usable"; R11: "the coach has had no work for 3 weeks" | WeekPlan results by slot, MoveMastery tier change by slot | exists; lines NEW |
| Fight log / result page | R14: "the uppercut from Wednesday's pads landed 3 times" (a move whose band rose on a night YOU held, landed in this bout) | `FightStats` lands by move + the slot record | NEW |
| Fight night corner | the club coach in the corner (face + role) and their ring-reading meter with "+7% on a good call" | `Exchanges.call_edge` x (1 + 0.004 x max(0, sparring - 40)) (R10) | partly; the effect NEW |

## 6. Balance probe (run, not argued)
`python docs/mockups/s490/coach_spec/probe_coachspec.py`: the test club (Lucy, Kira, Josh; `Data.gd`), the base week
(`WeekPhase.gd:26-27`), 12 weeks, headroom re-read every week, coached mornings dealt greedily where they add most, morning
stats only. Club stat points gained in 12 weeks:

| Route | $/wk (coaches) | Stamina | Strength | Speed | All | $ per extra point vs Reid alone |
|---|---|---|---|---|---|---|
| Reid alone | 450 | 14.79 | 13.28 | 3.37 | 31.44 | - |
| Reid + $100 S&C A (66 / 68) | 550 | 16.49 | 14.21 | 3.37 | 34.08 (+2.64) | 454 |
| Reid + $200 S&C B (60 / 60, 4 days) | 650 | 17.10 | 14.04 | 4.09 | 35.23 (+3.79) | 632 |
| Hale | 1,090 | 19.06 | 15.20 | 3.69 | 37.95 (+6.51) | 1,179 |
| v1: Reid + $100 S&C at 80 / 82 | 550 | 17.02 | 14.87 | 3.37 | 35.26 (+3.82) | 314 |
| No coach, you at 40 (first hour) | 0 | 11.13 | 11.73 | 2.15 | 25.02 | - |

Reading: v1's 80 / 82 gave the $100 S&C as many points as the $200 one and 59% of Hale's for 16% of the full-time coach's extra money - the
reviewer was right. At 66 / 68 the ladder is clean: each dearer route buys more points, each at a worse price, and Hale stays
the most points in the club. The full-time coach's other side: pads 58 (+23%) against Reid's 74 (+30%), so the Hale route loses on move
learning - a real trade, shown on staff_hire. With no coach hired, you at 40 give 25.0 against 22.3 if your coached mornings
ran at the no-coach rating (CoachedMornings as designed): +12%, while Reid still adds +26% over that - the first hire stays
needed.

Round 3 (`python docs/mockups/s490/coach_spec/probe_coachspec_r3.py`, rules R1-R3 on; pads: three boxers, pads Mon / Wed /
Fri, one drilled move each from a stand-in 12, `MoveMastery.gain`):

| Route | $/wk | Stat points 12 wk | vs Reid alone | Pad mastery 12 wk | First Sharp move |
|---|---|---|---|---|---|
| Reid alone | 450 | 31.44 | - | 156.8 | week 10 |
| Reid + S&C A | 550 | 34.08 | +2.64 | 156.8 | week 10 |
| Reid + S&C B | 650 | 35.23 | +3.79 | 156.8 | week 10 |
| Reid + Price (two boxing coaches) | 830 | 32.45 | +1.01 | 183.5 | week 5 |
| Hale | 1,090 | 37.95 | +6.51 | 153.9 | week 10 |
| Hale + S&C A | 1,190 | 39.33 | +7.89 | 153.9 | week 10 |
| Hale + S&C B | 1,290 | 40.18 | +8.75 | 153.9 | week 10 |

| Your 4 (Reid route) | Stat points | Pad mastery | First Sharp |
|---|---|---|---|
| Four coached mornings | 31.44 | 156.8 | week 10 |
| One held night (costs 2) + two mornings | 30.85 | 170.4 | week 7 |
| (rejected) held night costing 1 + three mornings | 31.12 | 170.4 | week 7 |

Reading: R1 ends the round-2 fault - with the full-time coach an S&C hire now adds +1.4 (A) or +2.2 (B) instead of lowering
Stamina. The ladder has two axes: stats (S&C, full-time coach) and moves (a second boxing coach: half the weeks to the first
Sharp move for +$380). Your held night at cost 1 lost only 1% of stats for three weeks of moves - near dominant; at cost 2 it
is a trade (-1.9% stats). Pad mastery here saturates (every move reaches Sharp by week 12), so "first Sharp" is the honest
column. Not probed: the corner's call reach over a bout (R6), staff growth (R7), the BJJ ceiling over a career.

## 7. Real-world grounding (marked where not verified)
- England Boxing: about 1,000 affiliated clubs, most run by volunteers; coaches hold England Boxing qualifications (Level 1
  assistant coach, Level 2 coach, Level 3 performance coach) plus DBS and safeguarding. UNVERIFIED this session (from memory).
- A typical amateur club: one head coach (often unpaid, often the founder), 2-5 qualified assistants, a few volunteers. S&C,
  physio and nutrition staff are the norm only at the GB Boxing performance programme (Sheffield, EIS), rarely at a club.
  UNVERIFIED (general knowledge). The game lets a club buy a little of the elite setup: that is the fantasy.
- Pay: sessional club coach GBP 22/h (used in `StaffRoles.gd:4`); S&C GBP 40-60 a session (same line); BJJ instructor GBP 26-27/h
  (`BjjSide.gd:8`, S365 search). A black belt costing ~30% more per class: UNVERIFIED (P). UK mobility / yoga instructors
  GBP 25-50 a class: UNVERIFIED.
- BJJ promotion (R8): the IBJJF graduation system - promotions up to brown signed by an affiliated black-belt professor, a
  black belt only by a black belt with 2+ certified degrees (Art. 6.1-6.2); a brown belt may promote to purple where black
  belts are scarce (6.3). Read 2026-11-15 via ibjjf.com/graduation-system and two summaries (martialartsprofessional.com,
  projectbjj.com) by the round-2 critic; Claude did not open them this session - CHECK before the ceiling ships.
- UKSCA as the UK S&C accrediting body: CHECK (from memory).
- US: USA Boxing certifies coaches by level; most amateur gym coaches are volunteers or paid per session by the fighter; a pro
  trainer takes ~10% of the purse (the game's trainer 10%, CRITIC_PACK 4.13). UNVERIFIED this session.
- $450/wk sessional (decided) = GBP 360 = ~16 h at GBP 22: three evenings and two mornings - matches "2 + 3" on the coach's card.

## 8. Room for later sports (not designed now)
The role table is data: role -> what it may run -> areas. A wrestling coach later = one role row with new areas (takedowns,
clinch) and new session ids; a Muay Thai or kickboxing coach = a striking role with kick / clinch areas; an MMA or transition
coach = a role allowed on BOTH a striking and a grappling area for a fighter who trains both. Gi = a mat area flag. None of
these is added until the operator opens that sport.

## 9. Open questions for the owner (taste and scope only) and risks
Questions:
1. Should the S&C coach become a real coach who makes fighters fitter, or stay the flat injury job it is today?
2. (Round 3: answered by the probe - the injury cut stays automatic; see 3.3.)
3. BJJ coach belts: two candidates (brown at today's price, black dearer and faster), or one coach as today?
4. Role names on screen: sport names ("Boxing coach", "BJJ coach", "S&C coach") or your wider ones ("Striking", "Grappling")?
5. You holding a fighter's pads yourself for a whole night: a choice you want each week, or should nights stay the coach's?
6. Staff who grow and ask to leave (3.7): wanted now, or later with the small living world?

Risks:
- Per-slot coaches change `WeekPlan.coach_for` from one coach to a slot map: every test that passes a single coach rating must
  still pass (a float or one dict keeps meaning "one coach does it all").
- It needs CoachedMornings wired (built, tests only) and the training_k per-fighter split (agreed, not built) first: sequence
  COACHSPEC1 after both, never before.
- The integrate-first rule (S459): roles must not open a new screen before the week board shows them. The hire screen only
  regroups an existing page.
- Head coach rated 40 (P) lifts a no-coach club 12% (section 6). Watch the first month in the next probe.
- Names: rows and buttons say "your coach", "you", faces; names stay in card headers.

## 10. Review round 1 - each item and what was done
Must-fix:
1. "Cardio" -> **Stamina** on both screens (meters, tiles, HER WEEK, fighter rows) and here. The README's old claim that
   "Cardio" came from `CoachedMornings.gd:28-31` was false (those lines say Stamina) and is corrected.
2. Name collision: candidate B "Kerry Walsh" (an opponent in `Data.gd:142,180`) renamed **Gemma Marsden** (grep: no hit).
3. Degenerate head coach: base cut 50 -> **40**, edge 65 -> **55**; 40 is under every Reid area, so every "was" baseline (Reid)
   is the better of the two; 3.1 and the 3.3 table redone.
4. Head coach contradiction: one rule - mornings, pads, corner, NEVER the mat; the grid and the roles strip that disagreed are
   gone; both screens and 3.1 agree.
5. Unwired CoachFit numbers: all removed (section 3.0). Numbers that are designed but not built (CoachedMornings 4 / 2 / x1.15,
   the per-fighter minutes split) now carry a **dashed** underline; dotted stays "new in this proposal"; legend on both screens.
6. "fit -8 this week": gone with CoachFit. The Wednesday box shows the effect in game words: the move bar, Usable day, the
   featherweight's minutes, and a sun pip "-1" (one of your mornings).
7. Wednesday outcome: both picks show uppercut before -> after with the Usable 30 line (23.4 -> 30.2 Usable Wed vs 23.4 -> 28.0
   Usable Fri) and the featherweight's check hook (21.1 vs 15.7), all `MoveMastery.gain`.
8. Nights by the code: pads Mon / Wed / Fri, sparring Thu (`PadWeek.gd:49-54`); BUILD WEEK for her amateur bout 12 days out
   (`WeekPhase.gd:51`, no PEAK for an amateur). Her FIGHT WEEK is Mon 23 - Sat 28 (next week), so this week's tag is BUILD WEEK
   with "Club show Sat 28 · 12 days".
9. Meters: every area meter has its word under it (Pads, Bag, Sparring, Stamina, Strength) on every card; run icons carry a
   word (Mornings, Pads, Corner, Mat); corner redrawn as the corner stool, mat as a tiled mat in perspective.
10. Coins: morning tiles are now TINTED by who runs them (gold you, blue boxing coach, teal S&C, plain = nobody) with a 38 px
    coin carrying the role colour ring and role badge.
To 10:
- Reconciled with CoachedMornings and training_k minutes (3.0); the evening_plan coach row is in minutes by face.
- Tell text cut: the roles legend strip, the WHO RUNS WHAT grid and the explanatory lines are gone ("group mornings: ...",
  "boxing coach or you only ...", "her own mat ...", "the gap between ...", "Drag a coach coin ...", "Hover any number ...").
- The probe ran (section 6) and changed the S&C numbers (80 / 82 -> 66 / 68; B 72 / 70 -> 60 / 60).

## 11. Review round 3 (S492) - each fault a round-2 critic found, and what was done
1. An S&C hire lowered Stamina beside the full-time coach -> R1 better-of rule (3.0); probe: Hale + S&C A +1.38, B +2.23.
2. The x1.15 group bonus without a group -> R2: 2 to 6 fighters on the morning, x1.00 alone.
3. No overlap rule -> R3: one runner per morning; a coached morning on their day gets x1.25, never the group bonus as well.
4. Your held pad night likely dominant and unprobed -> probed over 12 weeks (section 6): at a cost of 1 it was near free;
   R4 makes it cost 2 of your 4, at most 1 a week: a trade of 1.9% of stats for a Sharp move three weeks sooner.
5. The 12-week points left out pads -> the route table and the hire screen carry pad mastery and the first Sharp week.
6. Mobility as priced was useless -> priced again with a x0.6 cut and half the stat kept: still 0.009-0.021 against 0.099.
   Cut as a choice; the injury cut stays automatic with the hire (3.3).
7. The Ex-pro's sparring edge touched nothing; the Strength coach counted twice -> the corner reads sparring (3.6); the
   Strength coach's 55 is strength only (3.1).
8. The corner pick changed nothing -> R6: the corner man's sparring rating scales a good call's edge; one coach per corner
   on a two-boxer card.
9. Two boxing coaches undefined -> R7 (3.2): 75 min each a pad night, mornings add, programme takes the better rating;
   probed as the moves route.
10. BJJ promotion against the IBJJF -> R8 (3.4): the mat coach signs; a brown-belt coach caps the athlete at purple.
11. The hire screen showed one morning's +32% -> 12-week totals per fighter and per club (section 5).
12. Fixed pronouns and "HER WEEK" -> screens say THIS WEEK, "your coach", "the S&C coach", faces on coach rows; names only in
    card headers (owner S448). The round-2 mockups still carry the old labels and the old per-morning %: they are redrawn
    with the build, not before the critics' depth verdict.
Small: candidate B's lower rating has its reason on the card (fitness instructor against an accredited S&C coach); B's Speed
rise in round 2 came from your coached mornings moving off Stamina once their four days took those mornings.

## 12. Review round 4 (S493) - each fault Kalli found in round 3 (depth 6, general 5, play 5), and what was done
Maria scored round 3 depth 7, general 6, play 6; Kalli's lower score sets the work.

General design:
1. The corner pick is false to the sport -> R10 (3.6): the club coach works every corner at a show; no pick.
2. R6 made no-coach corners worse than today -> R10 floors the edge at x1.00: a hire can only add.
3. Fixed "he" for coaches -> they / the coach / role words throughout.
4. Names in rules and rows -> role words (the sessional coach, the full-time coach, the women's lightweight); names stay only
   as candidate names on cards and in the probe's route labels.
5. Power / mobility words -> Strength, Flexibility (the Attrs words).
6. Section order -> 3.5 before 3.6 and 3.7.

Depth:
1. No common currency -> the WINS column below (pack conversions: 5 points better in stats = 72% vs 50%, so about +4.4 wins
   in 100 a point on every stat; a Sharp planned line over Usable = +2.8 wins in 100).
2. No money pressure -> the MEMBERS column below: how many more members pay for the route.
3. The S&C coach ignored load -> R12 (3.3): their mornings cost x0.85 tiredness; they plan the fight-week taper (-3 at the bell).
4. Unprobed rules: R10 cannot make any club worse (floor); R11 growth is cut; the BJJ ceiling is a career rule, read in the
   living-world probe, and stays marked (P).

Play:
- R14: the moment is paid off - the week review and the fight log say which night YOU held made a move, and that it landed.
- R11: the leaving rule warns a week ahead.
- R13: class nights take pad minutes, so the coach's week is money against moves, the trade every real club makes.

Missing (Kalli's list) -> 1 R12, 2 the wins column, 3 R13, 4 R12's taper, 5 the roster break point below.

### The route table with wins and money (from section 6's probe, converted; est.)
Club of three boxers. "Wins" = extra stat points spread over 3 fighters and about 6 fight stats, x 4.4 wins in 100 a point
(linear near an even matchup). "Members" = extra wage / $8.08 a member a week ($35 a month dues).

| Route | $/wk | Extra stat points 12 wk | Wins in 100, each fighter | First Sharp | Members to pay for it |
|---|---|---|---|---|---|
| Sessional coach alone | 450 | - | - | week 10 | - |
| + S&C A | 550 | +2.64 | +0.6 | week 10 | +13 |
| + S&C B | 650 | +3.79 | +0.9 | week 10 | +25 |
| + a second boxing coach | 830 | +1.01 | +0.2, and +2.8 a bout in weeks 5-9 (Sharp 5 weeks sooner) | week 5 | +47 |
| Full-time coach | 1,090 | +6.51 | +1.6 | week 10 | +79 |
| Full-time + S&C B | 1,290 | +8.75 | +2.1 | week 10 | +104 |

Reading: the stats routes buy little per bout but last a career; the moves route buys a lot for the bouts in weeks 5-9 and
nothing after week 10. A club with a bout booked soon takes moves; a club building for nationals takes stats. Money decides
how far up either ladder a club can go: a 30-member club pays for the S&C A hire with 13 more members, not for the full-time
coach. No route is best for every club.

### Roster break point (est.; the build's probe reads it)
One boxing coach holds 75 pad minutes a night. From evening_plan: 75 min moves a drilled line about one band in a night,
45 min about 60% of that. Three boxers at 25 min each: a band in about three nights. Past three boxers on pads the first Sharp
move slips past week 12; the second boxing coach (150 min a night) is the fix, and the hire card says so when a fourth boxer
signs.

I'm writing round 5 as section 13. It'll answer all of John's points and keep everything Dola scored high.

## 13. Round 5 (S494): each point John found in round 4, and what was done

Part 1 of 4. Round 4 scored depth 8 / general 8 / play 7 from Dola and 7 / 6 / 6 from John, so John's list sets the work. Where this section changes an earlier rule, this section replaces it, and the earlier text is void.

Marks: (P) is proposed and untested, CODE is in the game today, ESTIMATE is worked by hand (the probe decides), and CHECK is for Claude to confirm.

**Kept from round 4 (what Dola scored):**
- the two hire routes, more stats or faster moves;
- class nights trading money against pad minutes;
- the mat coach's belt as a ceiling;
- the wins-in-100 figure printed on every choice, where the choice is made. This was Dola's top 10/10 item, and 13.10 lists each place.

### 13.1 Which second coach (replaces R7 in 3.2 and the "two second coaches")
**One hire, not two.** R7's second boxing coach and the code's **Second club coach** staff job become the same slot.
- **What the slot keeps from the staff job (CODE):** +1 roster place, +40 to the member target, and the job's fitness classes.
- **What the slot gains:** area ratings. It becomes a coach record, like the S&C coach in 3.3.
- **Who fills it:** the two `CoachMarket` candidates at their code wages, $380 and $520 (areas per `CoachMarket.gd:12-17`).
- **What happens to the old wage:** the job's flat $280 wage is retired. CHECK what else reads it.

**What the second coach teaches:**
- 75 pad minutes on every pad night, so two coaches give 150 a night;
- 2 coached mornings a week (sessional);
- the programme takes the better rating of the two coaches per area (as in R7);
- the second coach's own class nights, under 13.2's rule.

**What the second coach doesn't do:**
- work the corner (13.8);
- set the programme's plan (the head boxing coach does);
- take the mat.

**Why merge:** the staff job already adds the roster place that brings in the fourth boxer. The roster break point in section 12 says that's exactly when one coach runs out of pad minutes. So one hire is both the fix and its cause, which makes it a single decision.

### 13.2 How class nights split pad minutes (replaces R13)
**Today stays the default.** A boxing coach's week is 3 pad nights at 75 min each plus 2 class nights for +$350 (CODE, decided numbers). The 75 is what's left of the coach's paid hours after those two classes. Nothing is taken away silently.

**The choice, per boxing coach:** 0, 1, 2 or 3 class nights. Each class is $175 (P), which is $350 ÷ 2.

| Class nights | Money a week | Pad minutes a week (one coach) | Where the minutes go |
|---|---|---|---|
| 0 | $0 | 285 | +30 on two pad nights (105 / 105 / 75) |
| 1 | $175 | 255 | +30 on one night (105 / 75 / 75) |
| **2 (default, today)** | **$350** | **225** | 75 / 75 / 75 |
| 3 | $525 | 195 | −30 on one night (75 / 75 / 45) |

**The limits:**
- The player picks which pad night gains or loses the 30.
- A pad night is never over 105 or under 45 minutes.
- Sparring Thursday is never touched.

**Two coaches share one hall (P):**
- The gym runs at most one class a night and at most 3 class nights a week, whoever teaches them.
- So a second coach adds at most one extra class night (+$175) on top of the default two, and that night costs 30 of their own 75.
- Class income can't double. The hall and the members are the limit (13.4).

**The week review** shows "Classes: +$350 · Pads: 225 min". The class pill on the coach card shows "+$175 · −30 pad min" before the click.

### 13.3 Who owns the deal (replaces R3's last sentence)
**The coach deals and the player decides.**
- **Each Monday the coach proposes a week.** That means the coached mornings placed where each adds most (`CoachedMornings.deal`, greedy) and the group sessions on the S&C coach's days.
- **The player can then change anything.** Drag your coin or the boxing coach's coin onto any morning, or off one. A dragged coin belongs to the player, stays there until the player moves it, and wins over the coach's proposal.
- **Each morning has one runner (R3 still holds).** A coached coin on an S&C day takes that morning off the group: x1.25 for that boxer, no x1.15 group bonus. If a group drops to one boxer, the board warns "group x1.00: alone".
- **The board shows the result, not the rule:** each tile is tinted by its runner and shows that runner's coin.

Dola's "assign a coach to a fighter" wish is the same drag, so it needs no extra screen.

Part 2 of 4

### 13.4 Members never exceed the building (replaces the MEMBERS column in section 12)
**The rule (CODE, from the pack):**
- Members drift up to 6 a week toward a target set by reputation, dues, premises and coaches.
- **Members are capped by the premises.** The Unit holds **70**. The figure is in the pack and lives in the premises data (CHECK the file).
- The player can't buy members, and a coach's lift to the target helps the club reach the cap sooner, never pass it.

**What the Unit can pay:**
- At 70 members, dues are 70 × $8.08 = **$566 a week**, which is the most the Unit's dues can ever bring in.
- At the stand-in 38 members, the room left is 32 members, or **$259 a week**, and filling it takes at least 6 weeks at 6 a week.

**The column, corrected (net of each route's own income, against the cap):**

| Route | Wage change | Income it brings | Net a week | Members needed | At the Unit (38 now, 70 max) |
|---|---|---|---|---|---|
| + S&C A | +$100 | none | +$100 | 13 | Fits (51) |
| + S&C B | +$200 | none | +$200 | 25 | Fits (63) |
| + second coach, $380 candidate (13.1) | +$380 | 3rd class night +$175 (13.2); target +40, capped | +$205 | 26 | Fits (64), with almost no room left |
| Full-time instead of sessional | +$640 | none (same number of coaches, same classes) | +$640 | 79 | **Needs a bigger building**: more than the whole Unit |
| Full-time + S&C B | +$840 | none | +$840 | 104 | **Needs a bigger building** |

**Reading:**
- At the Unit, the second coach and the S&C coach compete for the same 32 members of room. A club can afford one comfortably, not both.
- The full-time coach can't be paid from Unit dues at any membership. So hiring that coach and moving premises are one decision.
- The hire card shows the red line "needs a bigger building" and links to premises. The bigger building's capacity is a CHECK.

### 13.5 What extra pad minutes buy, and where the gain stops (replaces "pads saturate" in sections 6 and 12)
**Pads never saturate across a club.** Round 4's probe drilled one move per boxer, so every move hit Sharp and the line went flat. That came from the probe, not the game.

**Under the game's own rule (`MoveMastery.gd:62-79`):**
- Each pad minute adds mastery to the move being drilled: 2.1 an hour × (1 + 0.40 × the pad holder's rating ÷ 100) × (1 − mastery ÷ the move's cap).
- The (1 − mastery ÷ cap) part is the headroom clamp. Each minute buys less as the move nears its cap, and nothing at the cap.

**The lines a move crosses:**
- **Usable at 30:** the move can fire.
- **Sharp at 60:** +2.8 wins in 100 over Usable, from the pack.
- **Signature at 85:** a further +2.7 wins in 100.

**The gain stops in two places only:**
1. **Per move,** at that boxer's cap for that move. The minutes then go to the next move on the coach's pad card.
2. **Per boxer,** when every move in the boxer's plan sits at its cap. There are 6 punches, the book's combinations, the boxer's own combinations and 10 steps, so in a 12- or 24-week window that's rare.

**Stats use the same clamp:** a pace of 1.0 per focused week × headroom. So a better coach gets a boxer to their potential sooner, never higher. Both routes end at the same ceiling, and what a hire buys is speed.

**Corrected reading of the two routes:**
- The moves route keeps paying after week 10: the next move to Usable, then Sharp, then a Signature line.
- It stops only when the boxer runs out of moves below their caps.
- The round-4 line "the stats routes last a career, the moves route stops at week 10" is withdrawn.
- What's left is a difference in kind:
  - **Stats** raise every exchange a little.
  - **Moves** raise the lines the plan uses.
  - **Both** stop at the boxer's potential.

**The re-probe (13.11 item 2)** drills the full pad card over 12 and 24 weeks, toward Signature, and reports Sharp lines and Signature lines per boxer, converted at +2.8 and +2.7 wins in 100.

Part 3 of 4

### 13.6 The held pad night gets a real cost (replaces R4)
John's sum stands. At a cost of 2 coached mornings (about 0.59 stat points, or 0.14 wins in 100), a Sharp line 3 weeks sooner (+2.8 wins in 100 a bout) wins about 20 to 1 whenever a bout falls in the window. So the cost has to be paid in something that matters in wins: the boxer's load and health. Real clubs know this cost. A full hour on the pads with the head coach is the hardest evening of a boxer's week.

**The rule (P):**
1. **It still costs 2 of your 4,** at most once a week.
2. **The held boxer works the whole 75 minutes,** against a usual share of 25–45. That evening counts as a Hard session in the boxer's acute load. The game's load-spike rule applies unchanged (CODE): a ratio of 1.5+ gives 2–4× injury risk.
3. **Never in a FIGHT WEEK.** The taper belongs to the S&C coach (R12), or to the boxing coach when there's no S&C hire. The button is greyed, and hovering it gives the reason.
4. **The decision box shows the boxer's load before and after.** For example, "Load 1.3 → 1.6 · injury risk ×3", shown in red past 1.5. The move gain and its wins figure sit beside it.

**Why it's no longer always right (ESTIMATE):**
- **On a calm week** (load ratio stays under 1.5), it costs only the two mornings. It's the right pick when a move sits just under a line before a bout.
- **On a heavy week** (ratio pushed past 1.5), training injury goes from 1.3% to 2.6–3.9% that week.
  - An injury costs the booked bout. That's about 50 wins in 100 of an even bout, plus the weeks out (CHECK how long a training injury lasts).
  - 2.6% × 50 ≈ **1.3 wins in 100,** and 3.9% × 50 ≈ **2.0,** against the +2.8 it buys.
  - The pick now depends on the boxer's week. The player has to read the load, not just tick the box.
- **The rival choice is real:** hold the night, or keep the boxer's week under the spike and spend the 2 on mornings.
- **It links to the S&C hire:** S&C mornings cost ×0.85 tiredness (R12) and lower the acute load the same way. That makes room to hold a night safely, which is part of what the S&C hire is worth.

**Pass line for the re-probe:**
- Averaged over a season with the pack's bout spacing, the held night's value in wins, net of injury, must sit within ±30% of two coached mornings (R12 included).
- If it's still above, the cost becomes 3. If it's then below, it goes back to 2.

### 13.7 R12 priced in wins (replaces R12's "unpriced")
**What the S&C coach's load work buys (ESTIMATE until the probe):**
- **×0.85 tiredness on the S&C coach's mornings** means 1 ÷ 0.85 = 1.18× as much training before fatigue reaches 80 (overreached: gains ×0.6, injury ×3). That's about one more Hard morning for every six before overreaching.
- **The same ×0.85 lowers acute load** in the spike ratio (CODE rule, unchanged). John's small point is answered here.
- **The taper:** −3 tiredness at the first bell.

**The probe (S427 method):**
- Run 400 bouts a cell, at par and at −3 tiredness, and report wins in 100.
- If the result is under 1 win in 100, raise the taper to −6, or the cut to ×0.75.

**The hire card adds two lines next to the stat totals:**
- "Hard mornings before overreached: 5 → 6";
- "Fresher at the bell: +n wins in 100".

The route table in 13.10 gets a FRESHNESS column filled by the probe. Until then it reads "probe", never a guess.

### 13.8 John's other points
- **The Ex-pro's 55 is dead after the first hire.** Fix: you work the corner as the second second, beside the head boxing coach, who stays chief second.
  - **Effect:** the Ex-pro adds +0.002 a point of sparring over 40 to a good call (55 gives +0.03), on top of the chief second's edge (P).
  - **Other backgrounds** sit at 40 and add nothing, so this is the Ex-pro's own edge.
  - **CHECK** that England Boxing allows a chief second plus one second in an amateur corner.
- **The women's-coach candidate at 72 sparring** has no source in the code, so it's dropped. The corner list is 40 → ×1.00, 55 → ×1.06, 58 → ×1.07, 66 → ×1.10.
- **The guest professor (R8)** is a one-off fee for each black-belt promotion: $450 (P). CHECK real UK grading and seminar fees.
  - Book it one week ahead. The guest takes one class, and the promotion happens that week if the athlete meets the IBJJF minimum time in belt (CHECK).
  - The no-gi page shows "Black belt needs: a 2nd-degree black belt · your mat coach, or a guest ($450)".
- **Who presses Promote (3.4):** you promote the athlete, within the mat coach's ceiling. The coach's belt sets the ceiling, and the button is yours.
- **Section 4.4's cross-reference** now points to 3.7 for the leaving rule.

### 13.9 Names and fixed pronouns out of the body (S448, S412)
Names stay only in card headers. The body uses role and class words: your boxer, the coach, the women's lightweight, the featherweight, the welterweight, the S&C coach, their days.

| Where | Was | Now |
|---|---|---|
| Section 1, coach rows | Candidate names with wages | "the sessional candidate (`Data.gd:34`)", "the full-time candidate (`Data.gd:37`)", "the `CoachMarket` candidates" |
| 3.0 | "his GROUP session" | "their group session" |
| 3.1 | "Lucy's Normal Stamina morning" | "The women's lightweight's Normal Stamina morning" |
| 3.1, 3.2 | "always Reid", "'Pads' Reid" | "always the sessional coach", "the role badge reads the top area: Pads" |
| 3.2 | "Mon Lucy 45 / Josh 30; Wed Kira 75 (you take Lucy); Fri Josh 45 / Lucy 30" | "Mon lightweight 45 / welterweight 30; Wed featherweight 75 (you take the lightweight); Fri welterweight 45 / lightweight 30" |
| 3.2, section 6 | "Reid + Price", "Hale" | "sessional + second coach", "full-time coach" |
| Section 4 | "hold her pads", "costs her one class", "her promotions" | "hold the pads", "costs the athlete one class", "the athlete's promotions" |
| Section 5 | "his days", "out-rates him", "You held her pads", "her ceiling" | "their days", "out-rates them", "You held the pads", "the athlete's ceiling" |
| Section 6 | "Hale stays the most points" | "the full-time coach stays the most points" |

The probe scripts keep their own labels, and no screen reads from them.

Part 4 of 4

### 13.10 The route table as the hire card shows it (replaces section 12's table)
Each route below is compared with the sessional coach alone. Stats are from section 6's probe, converted at 4.4 wins in 100 a point, spread over 3 boxers and 6 stats.

| Route | Net a week (13.4) | Stats: wins in 100, each boxer, 12 wk | Moves: first Sharp | Freshness (R12) | At the Unit |
|---|---|---|---|---|---|
| Sessional alone | — | — | week 10 | — | — |
| + S&C A | +$100 | +0.6 | week 10 | probe | Fits |
| + S&C B | +$200 | +0.9 | week 10 | probe | Fits |
| + second coach | +$205 | +0.2 | **week 5**; keeps paying past week 10 (13.5) | — | Fits, no room left |
| Full-time | +$640 | +1.6 | week 10 (pads 58, slower) | — | Needs a bigger building |
| Full-time + S&C B | +$840 | +2.1 | week 10 | probe | Needs a bigger building |

**Where the wins-in-100 figure is printed, at the choice:**
- each hire candidate's card;
- the class-night pill;
- the held-night decision box, with the load line from 13.6;
- the S&C day chips, as "+n wins in 100 this block".

**Dola's other wishes:**
- **Coach to fighter:** this is the 13.3 drag.
- **R12 visible:** done in 13.7.
- **The leaving warning:** kept (3.7).
- **Visiting coaches, coach traits, short contracts:** not added. They're new content, and this round fixes what's undefined. They go under Later.

### 13.11 Every menu the coach roles appear on (S425; replaces section 5)
| Menu | What shows | Wired to | Exists? |
|---|---|---|---|
| Club > People > Staff | Role cards: you, boxing coach, second coach, S&C coach, mat coach. Each shows what it runs, area meters with their words, the coin count, the class-night pill (+$175 / −30 pad min), the route table (13.10) and the red "needs a bigger building" line | `Data.COACHES`, `CoachMarket` (+ role), `StaffRoles` (the second coach and S&C become coach records), `BjjSide` (+ belt), premises cap | Page exists; roles NEW |
| Fighter Week (training board) | S&C day chips, the coach's minutes by face, tiles tinted by runner, draggable coins (13.3), the held-night box with load before and after (13.6), "group x1.00: alone" warning, THIS WEEK totals | `WeekPlan.coach_for` per slot, `CoachedMornings.deal`, `PadWeek` nights per boxer, load-spike rule | Board exists; roles NEW |
| No-gi athlete page | The mat coach's belt and drill rate, "can promote up to", the guest professor ($450), your Promote button | `NoGi.DRILL_GAIN` × belt, `BjjSide.coach_week`, R8 ceiling | Page exists; belt NEW |
| Premises | The member cap (the Unit: 70), "a full-time coach needs a bigger building" | Premises data, members drift (CODE) | Exists; link NEW |
| Money | Wages grouped by role; class-night income per coach | `StaffRoles.wages`, `GameMoney`, `BjjSide.money` | Exists; grouping NEW |
| Week review | "Classes: +$350 · Pads: 225 min", the S&C morning gains, "You held the pads on Wednesday: the uppercut turned Usable", the no-work warning | `WeekPlan` results by slot, `MoveMastery` tier change | Exists; lines NEW |
| Fight log / result | "The uppercut from Wednesday's pads landed 3 times" | `FightStats` by move + the slot record | NEW |
| Fight-night corner | Chief second (head boxing coach) and, for the Ex-pro, you as second; "+7% on a good call" | `Exchanges.call_edge` × R10 (+ 13.8) | Partly; effect NEW |

### Open questions for the owner (taste and scope)
1. Merge the second boxing coach into the Second club coach job (13.1), or keep them as two hires?
2. Should holding a night carry injury risk (13.6), or would you rather keep the cost in your 4 only (cost 3)?
3. Cap the gym at 3 class nights (13.2), or let a bigger building run more?
4. Guest professor at a flat fee, or only through a hired black-belt coach?

### To reach 10/10
1. Re-run both probes with 13.2, 13.6 and 13.7 on, using a full pad card over 12 and 24 weeks. Fill the FRESHNESS column, and test the held night's season value against the ±30% line.
2. CHECKs:
   - the premises file and the bigger building's cap;
   - the staff job's fitness-class income and what reads its $280;
   - `CoachMarket` areas;
   - training injury length;
   - England Boxing's rule on seconds;
   - UK grading fees;
   - IBJJF time in belt.
3. Redraw `staff_hire` and `evening_plan` with 13.9's words, the drag coins, the load line and the cap line.
4. Send to two fresh critics for the depth-7 gate.

### The 10/10 page (1920×1080, Club > People > Staff)
- **Top bar:** dark shell; the gym name once in the header.
- **Left:** five role cards with portraits, meters and pills.
- **Right:** the hire chart, with stats wins across, moves up and the red cap line.
- **Bottom:** the held-night box, showing "Load 1.3 → 1.6 · injury ×3" beside "+2.8 wins in 100 before Sat 28".
- **Kit:** gold only on the selected hire, green only on Continue. Bebas Neue and IBM Plex Mono, nothing under 12.
