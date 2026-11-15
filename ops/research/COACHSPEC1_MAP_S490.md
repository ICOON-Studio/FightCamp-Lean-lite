# COACHSPEC1 - coach roles and specialties (design map, S490, review round 1)

Status: PROPOSAL, round 2 after a fresh reviewer scored v1 6/10 (every must-fix applied, see section 10). Per the S425 rule it
reaches the operator's board only after two fresh critics score its depth 7 or more. Nothing here is built. Screens:
`docs/mockups/s490/coach_spec/` (staff_hire, evening_plan). Balance probe: `docs/mockups/s490/coach_spec/probe_coachspec.py`
(pure Python copy of the game's gain and mastery rules; run it, the table in section 6 is its output).

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
| Mobility | `WeekPlan.gd:40,271-276` | a 20-min morning with no stat; a small conditioning attribute gain at the coach's rating | yes |
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
  NEW: the S&C coach owns his DAYS, not a count: on each of his days every fighter on a Stamina or strength morning is coached
  as a group at x1.15 (the existing SHARED value) and rated at his area. A morning nobody coaches runs on the boxing coach's
  programme: his area rating, x1.00 (today's wired rule, unchanged).
- **Nights = training_k minutes**: a pad night is 75 min of the boxing coach (`WeekPlan.gd:57`), split between the fighters on
  pads that night (the agreed training_k coach row). A sparring night: the coach referees (training_k). NEW: you may take one
  fighter's whole pad night yourself - 75 min at YOUR pads rating - and it uses one of your 4 (the 4 are "a coached morning or
  a pad night").
- **Rating = whoever runs it**: every morning and night is rated at the area rating of the person who runs it (CoachAreas, wired).
- CoachFit's time units, its overrun penalty ("fit -8") and "coach time 10 of 10" are dropped from this map. CoachFit's other
  parts (bond, temper) are untouched and still its own design.

### 3.1 Head coach - you (no hire)
- Runs: mornings, pad nights, the corner. NEVER mat classes (you are a boxing coach; the mat is the BJJ coach's). Both screens
  show the same: the head coach card lights sun / moon / stool and greys the mat.
- 4 a week (`CoachedMornings.YOU_OWNED`): each a coached morning or one fighter's pad night.
- Areas (P): **40 in every area, 55 in the edge's area** (Old hand -> bag; Ex-pro -> sparring; Amateur coach -> pads;
  Strength coach -> conditioning AND strength). 40 sits under every area of Reid (lowest: strength 46), so with Reid hired the
  boxing coach always out-rates you except in your edge area. Lift at 40: +30% stat, +16% pads; at 55: +48% stat, +22% pads.
- Why you still matter on a morning: attention, not rating. Lucy's Normal Stamina morning: nobody (Reid's programme 48)
  0.150; you coaching it (40, x1.25) 0.175; Reid coaching it (48, x1.25) 0.187 (probe).
- Every "was" baseline on the screens is the better of you and the boxing coach for that area. With Reid and the Old hand that
  is always Reid. With the Strength coach background it would be you (55) on Stamina and strength: the screens then compare
  the S&C candidate against you.
- Today the head coach rates nothing; keeps the four edges unchanged (`HeadCoach.gd`).

### 3.2 Boxing coach (the striking coach) - Reid, Hale, Price, Mendez
- Runs: pad nights (75 min each, split by face), sparring nights (referee), the corner, and his coached mornings (2 sessional,
  3 full-time). Unattended mornings run on his programme at his area rating (today's rule).
- Areas: as in code (`Data.gd:34-39`, `CoachMarket.gd:12-17`). The role badge reads the top area: "Pads" Reid.
- The weekly puzzle: three boxers, a Standard week of 3 pad nights each (`PadWeek.gd:54`), but one coach with 3 x 75 min.
  Worked example (evening_plan, a STAND-IN split): Mon Lucy 45 / Josh 30; Wed Kira 75 (you take Lucy); Fri Josh 45 / Lucy 30.
- Cost: unchanged ($450 sessional is the decided number; $380 / $520 / $1,090 from code).

### 3.3 Strength and conditioning coach (mobility inside it) - NEW as a coach, replaces the flat S&C job
- Runs: MORNINGS ONLY, as group sessions on his days. Never pads, sparring, corner or mat.
- Days: the player picks his days for the whole club on the week board (2 days for the $100 hire; 4 days for the $200 hire (P)).
- Areas (P), re-set by the probe (v1 had 80 / 82): candidate A, 2 days, $100/wk (the code's wage, `StaffRoles.gd:10`):
  **Stamina 66, strength 68**. Candidate B, 4 days, $200/wk (P): **Stamina 60, strength 60**.
- Mobility (P): the existing injury cut (risk x0.85, `StaffRoles.gd:18`) applies to a fighter ONLY in a week with one mobility
  morning on one of his days. Today the cut is automatic. A morning that gains no stat buys 15% less injury risk.
- The pro camp bill halved (code) stays.

One Normal morning, Lucy (headroom Stamina 0.90, Power 1.02), probe output:

| Who runs the morning | Rating | Mult | Stamina | Strength (Power) |
|---|---|---|---|---|
| Nobody (Reid's programme) | 48 / 46 | x1.00 | 0.150 | 0.168 |
| You (P) | 40 | x1.25 | 0.175 | - |
| Reid coaching it | 48 | x1.25 | 0.187 | - |
| S&C B, group (P) | 60 / 60 | x1.15 | 0.190 | 0.217 |
| S&C A, group (P) | 66 / 68 | x1.15 | 0.198 | 0.230 |
| Hale's programme | 90 / 84 | x1.00 | 0.202 | 0.223 |

Per fighter of the test club (staff_hire "On your fighters"; Reid's programme -> S&C A group):
women's lightweight Stamina 0.150 -> 0.198, Power 0.168 -> 0.230; women's featherweight 0.187 -> 0.248, 0.206 -> 0.281;
men's welterweight 0.094 -> 0.124, 0.105 -> 0.144 (he is near his potential: the player puts the S&C days where the young ones
train hard).

### 3.4 BJJ coach - the no-gi coach gets a belt
- Runs: the athlete's mat classes (3 a week, `NoGi.gd:16`) plus the club's no-gi classes (BjjSide). Never boxing.
- Belt sets the drill rate (P): brown belt = today's numbers ($34/class, +3.2 a week); black belt $45/class (P), x1.25 (P) =
  +4.0 a week. Weekly bill (5 classes): brown $170 (code), black $225 (P).
- A 30-mastery move owned in 9.4 weeks (brown, code rate) or 7.5 (black, P). The belt promotion stays the professor's call (you).
- Gi: out of scope. Wrestling for takedowns: waits for the wrestling sport.

### 3.5 Hiring rules (one budget)
- Slots: you (always), up to 2 boxing coaches (`CoachMarket.MAX_HIRED`), one S&C, one BJJ coach (only with a BJJ athlete).
- Signing fee: $1,000 for a boxing coach (code). S&C and BJJ: a week's pay to let go (`StaffRoles.notice`), no signing fee (P).

## 4. What the player decides each week
1. Which two (or four) days are the S&C coach's, and lining each fighter's Stamina / strength mornings up with them (his days
   are a teal chip on the day header and a teal tint on every morning he runs).
2. Where your 4 go: a coached morning (x1.25 at your rating) or one fighter's whole pad night (75 min at your pads rating).
   Evening_plan's Wednesday: you hold her pads 75 min -> uppercut 23.4 -> 30.2, Usable Wed (so Thursday's sparring drills it,
   `PadWeek.gd:384-394`), and the featherweight gets the coach's whole 75 (check hook 12 -> 21.1); costs one coached morning.
   Or your coach holds them 45 min -> 28.0, Usable Fri, and the featherweight gets 30 (-> 15.7). (Uppercut 18.5 and check hook
   12 at the start of the week are STAND-INS; every step after is `MoveMastery.gain`.)
3. Whether a fighter spends a morning on his day on mobility to keep the injury cut (P) or on a stat (Sat: -0.230 Power).
4. On the mat: whether the athlete teaches the beginners (code: saves $68 a week, costs her one class).
5. Over months: which role to hire next with one budget (section 6).

## 5. Every menu the mechanic appears on (S425 rule)

| Menu | What shows | Wired to | Exists? |
|---|---|---|---|
| Club > People > Staff (hire) | role cards (you, boxing, S&C, BJJ) with what each runs (sun / moon / stool / mat with a word under each), 5 area meters with the area word, the 4 / 2 + 3 a week; S&C candidates with his days, Stamina and Strength meters against today's tick, the injury shield; per-fighter before -> after; the four hiring routes with $/week, pads lift and 12-week club points | `Data.COACHES` + `CoachMarket.market()` (+ `role`), `StaffRoles` (S&C becomes a coach record with areas and days), `BjjSide` (+ belt), `CoachedMornings.owned`, probe numbers (to become a forecast call) | screen exists (StaffCard); roles NEW. Mockup `staff_hire` |
| Fighter Week (training board) | S&C DAYS row (his chips), COACH row in minutes by face (training_k) with your slice, morning tiles tinted by who runs them + coin, evening tiles with the coin of who holds the pads, the decision box for a night, HER WEEK roles vs today | `WeekPlan.coach_for` reads the runner of THAT slot (ctx `coach` becomes per-slot); `CoachedMornings.deal`; PadWeek night minutes per fighter (`nights.per` already exists, `PadWeek.gd:332-334`) | board exists (training_k agreed look); roles NEW. Mockup `evening_plan` |
| No-gi athlete page | THE MAT COACH: belt, drill rate a week, classes | `NoGi.DRILL_GAIN` x belt mult (P), `BjjSide.coach_week` | page exists; belt NEW |
| Money | coach wages grouped by role in WHERE IT GOES | `StaffRoles.wages`, `GameMoney`, `BjjSide.money` | exists; grouping NEW |
| Week review (Monday) | "Stamina +0.198 on the S&C morning"; "pads: 1 night with you, 2 with your coach" | WeekPlan results by slot | exists; lines NEW |
| Fight night corner | the boxing coach or you in the corner (portrait + role) | corner pick | partly |

## 6. Balance probe (run, not argued)
`python docs/mockups/s490/coach_spec/probe_coachspec.py`: the test club (Lucy, Kira, Josh; `Data.gd`), the base week
(`WeekPhase.gd:26-27`), 12 weeks, headroom re-read every week, coached mornings dealt greedily where they add most, morning
stats only. Club stat points gained in 12 weeks:

| Route | $/wk (coaches) | Stamina | Power | Speed | All | $ per extra point vs Reid alone |
|---|---|---|---|---|---|---|
| Reid alone | 450 | 14.79 | 13.28 | 3.37 | 31.44 | - |
| Reid + $100 S&C A (66 / 68) | 550 | 16.49 | 14.21 | 3.37 | 34.08 (+2.64) | 454 |
| Reid + $200 S&C B (60 / 60, 4 days) | 650 | 17.10 | 14.04 | 4.09 | 35.23 (+3.79) | 632 |
| Hale | 1,090 | 19.06 | 15.20 | 3.69 | 37.95 (+6.51) | 1,179 |
| v1: Reid + $100 S&C at 80 / 82 | 550 | 17.02 | 14.87 | 3.37 | 35.26 (+3.82) | 314 |
| No coach, you at 40 (first hour) | 0 | 11.13 | 11.73 | 2.15 | 25.02 | - |

Reading: v1's 80 / 82 gave the $100 S&C as many points as the $200 one and 59% of Hale's for 16% of his extra money - the
reviewer was right. At 66 / 68 the ladder is clean: each dearer route buys more points, each at a worse price, and Hale stays
the most points in the club. Hale's other side: his pads 58 (+23%) against Reid's 74 (+30%), so the Hale route loses on move
learning - a real trade, shown on staff_hire. With no coach hired, you at 40 give 25.0 against 22.3 if your coached mornings
ran at the no-coach rating (CoachedMornings as designed): +12%, while Reid still adds +26% over that - the first hire stays
needed. Not probed yet: the mobility cut's injury effect, pads mastery over 12 weeks per route, the BJJ belt.

## 7. Real-world grounding (marked where not verified)
- England Boxing: about 1,000 affiliated clubs, most run by volunteers; coaches hold England Boxing qualifications (Level 1
  assistant coach, Level 2 coach, Level 3 performance coach) plus DBS and safeguarding. UNVERIFIED this session (from memory).
- A typical amateur club: one head coach (often unpaid, often the founder), 2-5 qualified assistants, a few volunteers. S&C,
  physio and nutrition staff are the norm only at the GB Boxing performance programme (Sheffield, EIS), rarely at a club.
  UNVERIFIED (general knowledge). The game lets a club buy a little of the elite setup: that is the fantasy.
- Pay: sessional club coach GBP 22/h (used in `StaffRoles.gd:4`); S&C GBP 40-60 a session (same line); BJJ instructor GBP 26-27/h
  (`BjjSide.gd:8`, S365 search). A black belt costing ~30% more per class: UNVERIFIED (P). UK mobility / yoga instructors
  GBP 25-50 a class: UNVERIFIED.
- US: USA Boxing certifies coaches by level; most amateur gym coaches are volunteers or paid per session by the fighter; a pro
  trainer takes ~10% of the purse (the game's trainer 10%, CRITIC_PACK 4.13). UNVERIFIED this session.
- $450/wk sessional (decided) = GBP 360 = ~16 h at GBP 22: three evenings and two mornings - matches "2 + 3" on his card.

## 8. Room for later sports (not designed now)
The role table is data: role -> what it may run -> areas. A wrestling coach later = one role row with new areas (takedowns,
clinch) and new session ids; a Muay Thai or kickboxing coach = a striking role with kick / clinch areas; an MMA or transition
coach = a role allowed on BOTH a striking and a grappling area for a fighter who trains both. Gi = a mat area flag. None of
these is added until the operator opens that sport.

## 9. Open questions for the owner (taste and scope only) and risks
Questions:
1. Should the S&C coach become a real coach who makes fighters fitter, or stay the flat injury job it is today?
2. Mobility: should the injury cut need a mobility morning on his day (a weekly choice), or stay automatic?
3. BJJ coach belts: two candidates (brown at today's price, black dearer and faster), or one coach as today?
4. Role names on screen: sport names ("Boxing coach", "BJJ coach", "S&C coach") or your wider ones ("Striking", "Grappling")?
5. You holding a fighter's pads yourself for a whole night: a choice you want each week, or should nights stay the coach's?

Risks:
- Per-slot coaches change `WeekPlan.coach_for` from one coach to a slot map: every test that passes a single coach rating must
  still pass (a float or one dict keeps meaning "one coach does it all").
- It needs CoachedMornings wired (built, tests only) and the training_k per-fighter split (agreed, not built) first: sequence
  COACHSPEC1 after both, never before.
- The integrate-first rule (S459): roles must not open a new screen before the week board shows them. The hire screen only
  regroups an existing page.
- Head coach rated 40 (P) lifts a no-coach club 12% (section 6). Watch the first month in the next probe.
- Names: rows and buttons say "your coach", "you", faces; names stay in card headers.

## 10. Review round 1 (fresh reviewer, 6/10) - each item and what was done
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
