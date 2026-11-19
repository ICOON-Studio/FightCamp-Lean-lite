# COACHFIT_SHEET (critic copy, S530) - the sheet, then the probe's own output

# COACHFIT_SHEET - coach fit as numbers, from the code (S529, COACHSCOPE1 phase 1)

Scope: a numeric sheet written from the code (the earlier prose maps were replaced by this method).
Source of every number: `scripts/rules/CoachFit.gd` (pure, called by nothing in the game yet) and the live levers it
joins. Every number below is asserted by `tests/coach_fit_sheet_test.gd`; change a row = change the test.
Written by Claude from the code, not by a chat seat.

## 0. The verdict up front
Two probes already measured the gain channel on the game's own week (docs/FITPROBE1_RESULT.md, FITPROBE2_RESULT.md,
60 boxers, 26 weeks, paired seeds, control equal to the digit): a TOP fit (82, x1.32 on mornings AND on the drill
nights' weekly rise, tiredness x0.92) gave **+0.95 of a stat in 26 weeks, Sharp 1.5 weeks sooner, +0.08 wins in 100**.
The map promised +3..+5 stat, 2..4 weeks, +4..+8 wins. At the code's numbers coach fit is a label the player cannot feel.
So this sheet does three things: (a) pins every number and cuts what has no lever, (b) joins fit to exactly TWO live
levers (gain, tiredness) and leaves the corner exactly as it is, (c) hands phase 2 ONE question: is there a gain slope
inside the stack cap that makes a TOP fit worth +4..+8 wins in 100? If none, fit stops being a shown number.

## 0b. Phase 2 verdict (S529, Goose COACHFITPROBE2, docs/COACHFITPROBE2_RESULT.md, 60 boxers paired, control exact)
**slope=NONE.** TOP vs AVERAGE wins in 100: k 1.0 +0.08, k 1.5 +1.12, k 2.0 +1.83, k 3.0 +1.83 (the 1.6 cap binds from
k 2.0); Sharp sooner +1.5 / +1.7 / +4.8 / +4.8 weeks. **tired=fail** (fit 80 ahead 6.6 energy, wanted 8..12; fit 35 down
6.6 by round 3, wanted 15..20). So, as section 0 decided beforehand: coach fit is NOT a shown number. It becomes a hover
reason on the coached-morning tile ("suits her: learns a little faster") and the coach card; no fit grid, no fit words
on the roster. Questions 2-4 (choice, mode, bond) are not run. Phase 3 critics judge THIS verdict + the hover design.

## 1. The fit number: fit = clamp(50 + temper + bond + taught + focus, 10, 90)
| Row | Value | Code | When |
|---|---|---|---|
| Neutral | 50 | CoachFit.NEUTRAL | fit 50 = today's game to the digit (gain x1.00, tiredness x1.00) |
| Temper: Motivator | +6 | TEMPER_SUITS | boxer's mood Flat or Low |
| Temper: Technician | +6 / -8 | TEMPER_SUITS / TEMPER_CLASH | coachability >= 70 / < 30 |
| Temper: Steady | **0** (was +2) | temper_part | always: the safe coach, never a clash, never a lift |
| Mode right / wrong | +4 / -4 | MODE_RIGHT / MODE_WRONG | Lift on Flat/Low; Teach when < half her cards known; Polish when more |
| Temper part held | -12..+10 | temper_part clamp | |
| Bond: Stranger / Working / Trusted / Corner | -4 / 0 / +6 / +12 | BOND_STEPS (from 0 / 8 / 45 / 110) | Stranger's -4 counts on evenings only |
| Taught out | -6 | TAUGHT_OUT | the ability is within 5 of the coach's ceiling (not yet at it) |
| Above the ceiling | gain x0.5 | ceiling_mult | at or past the ceiling |
| Ceiling: morning / evening | floor(55 + 0.35 x area) / area | morning_ceiling / evening_ceiling | pads 74 -> 80 / 74 |
| Focus morning | +10 / -3 | FOCUS_MORNING / FOCUS_OTHER_MORNING | the morning trains her week's focus / another stat |
| Words | TOP FIT 75+, GOOD 58+, MIXED 40+, RISKY | WORDS | |

**Reach, measured over every input the game has (test `_test_reach`): fit runs 28..82.** FIT_MIN 10 / FIT_MAX 90 are
only reachable through the time penalty, which this sheet cuts (section 6). So gain spans x0.78..x1.32 and tiredness
x1.055..x0.92 in play.

## 2. Worked examples (each one asserted)
| # | Who | fit | gain | tiredness | word |
|---|---|---|---|---|---|
| E1 | Steady coach, Working bond, plain morning | 50 | x1.00 | x1.00 | MIXED |
| E2 | Steady coach, Stranger, morning (Stranger costs evenings only) | 50 | x1.00 | x1.00 | MIXED |
| E3 | Technician teaching a coachable (75) boxer who knows 30% of her cards, Trusted, focus morning | 76 | x1.26 | x0.935 | TOP FIT |
| E4 | Motivator lifting a Flat boxer, Corner bond, focus morning | 82 | x1.32 | x0.92 | TOP FIT |
| E5 | Technician polishing an uncoachable (25) novice, Stranger, evening | 34 | x0.84 | x1.04 | RISKY |
| E6 | E5, and taught out (mastery 60, ceiling 63) | 28 | x0.78 | x1.055 | RISKY |
| E7 | Motivator "lifting" a Steady boxer: nothing to lift | 50 | x1.00 | x1.00 | MIXED |

## 3. Tiredness: tired_mult = clamp(1.125 - 0.0025 x fit, 0.92, 1.08)
1.00 at fit 50, 0.9375 at 75, 1.0375 at 35; held at 0.92 / 1.08. It multiplies the LOAD a session adds
(WeekPlan.day: load / LOAD_PER_FATIGUE), never the night's recovery or the carried fatigue. Live context: a boxer at 80
fatigue is overreached and trains at x0.6 (WeekPlan.OVERREACHED, TIRED_GAIN) - that is where x0.92 can matter.

## 4. The stack: one cap, never below today
`CoachFit.capped(gain_mult, today)` where today = what that gain already gets with no fit (coached morning
CoachedMornings x1.25 / x1.15 / x1.4 x camp protocol x1.1 / 1.2 / 1.35 on the camp stat).
Result = min(today x gain_mult, max(1.6, today)).
- TOP fit, plain morning: x1.32. TOP fit on a 1-to-1 morning (1.25 x 1.32 = 1.65): held at x1.6.
- Weak-spot 1-to-1 in a Hard camp is x1.89 TODAY (1.4 x 1.35, live, uncapped): a TOP fit adds nothing past it, a neutral
  fit leaves it alone (x1.89), a RISKY fit still costs (x0.84 -> x1.5876).
- Why: the old cap min(g x camp, 1.6) would have cut a live x1.89 to x1.6 the day fit is wired, for a neutral coach -
  wiring fit must never change the game at fit 50.

## 5. The four channels, each joined to ONE lever
| Channel | Lever (live code) | Fit does | Never |
|---|---|---|---|
| Gain | WeekPlan.day: `gain *= CoachedMornings.day_mult(...)` (mornings) and the drill nights' weekly rise (DrillWeek / PadWeek) | MULTIPLIES, through capped() above, on sessions the coach takes (coached mornings, pads, sparring) | never replaces TrainingPreview.coach_factor (the coach's SKILL 0.5 + r x 0.7); fit is the MATCH |
| Tiredness | WeekPlan.day load | MULTIPLIES by tired_mult | never the recovery (fatigue_keep) |
| Word taken in (corner) | Exchanges.uptake(coachability) x FighterProfile.trust(mood) - 75 coachability, Flat = 0.925 x 0.85 = 0.786 | **NOTHING.** Stays today's | the owner's Q-S294-86 ruling: "her morale is the trust score, no new meter". Low stays 0.7, not a hard zero |
| Correction (habit fix) | HabitFix.cost(habit, fix, hold = uptake x trust) | **NOTHING.** Stays today's | |

So no double count: fit lives in the week; the corner lives in the fight. Coach time is ClubDeal's (S519).

## 6. Cut (no lever, no cost or no choice)
- CoachFit's coach-time budget (COACH_TIME, COST, over, time_penalty, can_take, next_week_time): ClubDeal (S519) already
  deals the coach's hours (ASK, MORNING_SLOTS, 1-to-1 vs shared). Two budgets for one coach = the double count. Cut at
  build; `fit()` stops reading "over".
- Steady's free +2 (now 0, done S529): a temper that is +2 for everyone is not a choice.
- Film on the fit grid (COST film 0): FilmSeats owns film nights.
- SHIELD and the "Steady Hand" mode: not in the code; stay out.
- Mode as a PLAYER control: the right mode is fully decided by the card (mood; cards known over or under half). A control
  with one right answer the game already knows is a tax, not a choice. At build the coach plays the right mode himself
  and the card SAYS which ("Teaching: she knows 3 of 10 cards"); MODE_WRONG only bites when the player forces a coach
  onto a boxer of the wrong kind. Probe question 3 checks this.

## 7. The choices that stay (each must have a different best case - probe question 2)
1. Which coach takes which boxer (temper vs her coachability and mood): Technician +6/-8, Motivator +6 only while she is
   Flat/Low, Steady 0 safe. Mood moves week to week, so the best coach moves.
2. Keep a pairing to grow the bond (Working 0 -> Trusted +6 -> Corner +12) or switch for temper now and start at Stranger.
3. Mornings on her focus (+10) or on another stat (-3).
OPEN (needs a number, probe sizes it): **bond growth has no rule in the code.** Candidate: +1 bond a coached session
together, +5 a bout he works her corner (Working -> Trusted ~6 weeks at 6 sessions; Corner ~16 weeks with bouts).

## 8. Phase 2 - COACHFITPROBE2 (Qwen, on this sheet; copy of tools/fit_probe2.gd)
Population: fit_probe2's 60 boxers, paired seeds, AVERAGE fit 50 / TOP fit 82 / CONTROL untouched.
1. SLOPE: sweep gain_mult = 1 + k x (fit - 50) / 100 for k in 1.0 (today), 1.5, 2.0, 3.0, through capped() section 4.
   Print per k: focus stat gain in 26 weeks, weeks to Sharp, wins in 100 (TRAINBALANCE). Pass: some k gives +4..+8 wins
   and Sharp 2..4 weeks sooner with the 1.6 cap holding. None -> the finding is "fit cannot be felt inside the cap":
   it becomes a hover reason, not a shown number.
2. CHOICE: two coaches (Technician 75 pads, Motivator 70 pads) x four boxers (coachability 25 / 75, mood Steady / Flat)
   over a season with mood moving: each coach is the better pick in 30..70% of boxer-weeks.
3. MODE: the coach's own mode pick vs the best hand pick over the season: equal (then the mode control is cut, section 6).
4. BOND: +1 a session, +5 a corner: weeks to Trusted 5..8, to Corner 14..20.
5. TIREDNESS: two identical four-round bouts after a camp week at fit 80 vs 35: energy at the bell differs 8..12 (80
   ahead) and 35 is 15..20 down by round three. If not, change the constant, not the pass line.

## 9. Where it shows (build, after phase 3) - each wired, each with its action
| Menu | Shows | Press |
|---|---|---|
| Training, morning tile | "Coach fit GOOD x1.13" beside the coached-morning tag | the tile's coach swap |
| People, coach card | temper, the bond step and weeks to the next | assign to a boxer |
| Roster row (hover) | her fit word with each coach | assign |
| Week review | "Trusted reached" / "taught out: 2 weeks to the ceiling" | open the coach card |
Only after probe question 1 passes; otherwise the hover reason on the morning tile only.

## 10. Phase 3
Two fresh critics on THIS sheet + the probe output (never a prose map), 7+/7+ -> his board with `ask --attach` -> build:
fit into WeekPlan.day + the drill nights behind GameSwitches, tests red first, golden path walks one coached week.

## 11. The hover design (S530, Claude, after slope=NONE) - what is built, what is cut
Decided from section 0b: fit is felt in TRAINING (+27% focus-stat gain in 26 weeks at TOP, Sharp 1.5 weeks sooner) but not
in WINS (+0.08 in 100). So it is shown where training is shown, as a reason, never as a number or a grid.

**Built (each behind GameSwitches, GAME_ON):**
| # | What | Rule | Where it shows (file) | What the player does with it |
|---|---|---|---|---|
| H1 | Fit on coached mornings | gain x gain_mult(fit) at k 1.0 (today's code, x0.78..x1.32) through capped() s4 | the morning's gain number already on the tile moves (TrainGrid._morning `gl`) | nothing new to press: the number is the truth |
| H2 | The reason line | one line added to the coached tag's hover (`tag["long"]`, TrainGrid line ~165), only when the word is TOP FIT or RISKY (MIXED/GOOD = silent) | Training, morning tile hover | swap the coach on that morning, or move her focus |
| H3 | Taught out | ceiling_mult: at or past the coach's ceiling the gain halves (x0.5); within 5 of it, fit -6 | hover line "Taught out: the coach's Pads ceiling here is 80 - past it she learns at half speed"; week review line once, the week she reaches it | raise the area (morning_ceiling = 55 + 0.35 x area) or hire the better coach |
| H4 | Bond | +1 a coached morning together, +5 a bout he works her corner; steps at 8 / 45 / 110 (s1) | coach card: "Trusted with Mara (+6)" and "Corner bond in ~N weeks" | keep the pairing or switch |

Reason line words (game words, no numbers but the stat):
- TOP FIT: "Suits her: <why> - learns faster." <why> = the biggest positive part: "lifts a flat boxer" (Motivator),
  "she takes teaching" (Technician, coachability 70+), "her focus this week", "Corner bond".
- RISKY: "Poor fit: <why> - learns slower." <why> = the biggest negative part: "she will not take teaching"
  (Technician, coachability < 30), "taught out", "a stranger to her" (evenings).
- Never both; never on a morning the coach does not take.

**Cut (no felt effect, nothing to choose):**
- Tiredness channel (s3): failed its own pass line (6.6 energy, wanted 8..12 / 15..20). Raising the constant to pass would
  make a hidden number decide bouts - the opposite of a hover reason. tired_mult stays in CoachFit.gd, not wired.
- Fit word on the roster row and the "Coach fit GOOD x1.13" tag (s9): a number with no felt payoff.
- Mode control (s6) and the coach-time budget (s6): as decided.

**Tests at build (red first):** coach_fit_wire_test - fit 50 = today's WeekPlan.day gain to the digit on every morning
kind; TOP raises a plain coached morning by x1.32, a 1-to-1 one held at x1.6; the hover carries the reason only at
TOP FIT / RISKY; past the ceiling the gain halves; bond +1 a coached morning. Golden path walks one coached week and reads
the line. File budget: TrainGrid.gd is 282 lines (+~12); the reason text lives in CoachFit.reason(p) (pure, +~25).

**Question for the critics (beside depth and general):** with the fight effect at +0.08 wins, is H1-H4 enough of a choice
to keep, or should coach fit be cut whole and the coach's SKILL (TrainingPreview.coach_factor) carry coaching alone?


---
# Appendix: docs/COACHFITPROBE2_RESULT.md (verbatim)

# COACHFITPROBE2 Result

Probe run: 2026-11-19T17:26:24. S529 COACHFIT_SHEET phase 2.

## Question

Can a coach fit be felt inside the cap?

## Method

- SLOPE: `1.0 + k * (fit - 50) / 100.0` for k in [1.0, 1.5, 2.0, 3.0], through `CoachFit.capped()`.
- TIREDNESS: camp week at tired_mult(80) vs tired_mult(35), then 4-round bout.

## Measured

```text
COACHFITPROBE2 (S529 COACHFIT_SHEET phase 2): can a coach fit be felt inside the cap?
TOP fit 82: CoachFit.gain_mult(82)=1.320 (must equal 1.32: yes). Probe gain at fit 82 for k in [1.0, 1.5, 2.0, 3.0]: [1.32, 1.48, 1.64, 1.96].
fit 50: gain_mult=1.000 tired_mult=1.000 (both must be 1.000: yes). tired_mult(80)=0.925 tired_mult(35)=1.038.
Population: 60 boxers, seeds 6100..6159. Part 1: 26 weeks. Part 2: 40 bouts a boxer per arm.
Pilot: 294 ms/run, 48.2 ms/bout -> projected 19.0 min (budget 90 min).
--- k=1.0 ---
CONTROL determinism: match
  AVERAGE k=1.0 Sharp=7.77 gain=+3.530 eve+=0.00 capped=0
  TOP k=1.0 Sharp=6.23 gain=+4.483 eve+=40.53 capped=0
  CONTROL k=1.0 Sharp=7.77 gain=+3.530 eve+=0.00 capped=0
CONTROL: match
TRAINBALANCE AVERAGE wins=724/2400 = 30.17 in 100
TRAINBALANCE TOP wins=726/2400 = 30.25 in 100
k=1.0: Sharp +1.53 weeks (OUT) | wins +0.08 in 100 (OUT)
--- k=1.5 ---
CONTROL determinism: match
  AVERAGE k=1.5 Sharp=7.77 gain=+3.530 eve+=0.00 capped=0
  TOP k=1.5 Sharp=6.12 gain=+4.932 eve+=56.88 capped=0
  CONTROL k=1.5 Sharp=7.77 gain=+3.530 eve+=0.00 capped=0
CONTROL: match
TRAINBALANCE AVERAGE wins=724/2400 = 30.17 in 100
TRAINBALANCE TOP wins=751/2400 = 31.29 in 100
k=1.5: Sharp +1.65 weeks (OUT) | wins +1.12 in 100 (OUT)
--- k=2.0 ---
CONTROL determinism: match
  AVERAGE k=2.0 Sharp=7.77 gain=+3.530 eve+=0.00 capped=0
  TOP k=2.0 Sharp=3.00 gain=+5.257 eve+=48.98 capped=2682
  CONTROL k=2.0 Sharp=7.77 gain=+3.530 eve+=0.00 capped=0
CONTROL: match
TRAINBALANCE AVERAGE wins=724/2400 = 30.17 in 100
TRAINBALANCE TOP wins=768/2400 = 32.00 in 100
k=2.0: Sharp +4.77 weeks (OUT) | wins +1.83 in 100 (OUT)
--- k=3.0 ---
CONTROL determinism: match
  AVERAGE k=3.0 Sharp=7.77 gain=+3.530 eve+=0.00 capped=0
  TOP k=3.0 Sharp=3.00 gain=+5.257 eve+=48.98 capped=2682
  CONTROL k=3.0 Sharp=7.77 gain=+3.530 eve+=0.00 capped=0
CONTROL: match
TRAINBALANCE AVERAGE wins=724/2400 = 30.17 in 100
TRAINBALANCE TOP wins=768/2400 = 32.00 in 100
k=3.0: Sharp +4.77 weeks (OUT) | wins +1.83 in 100 (OUT)
COACHFITPROBE2 slope=NONE
--- TIREDNESS ---
  boxer 0: fat_start=40.2 | fit80 fat_end=68.6 last_bell=68.2 r3=68.2 | fit35 fat_end=70.4 last_bell=64.6 r3=64.6 | ahead=3.6 r3_down=3.6
  boxer 1: fat_start=41.1 | fit80 fat_end=67.7 last_bell=69.9 r3=69.9 | fit35 fat_end=70.2 last_bell=64.8 r3=64.8 | ahead=5.1 r3_down=5.1
  boxer 2: fat_start=44.3 | fit80 fat_end=65.1 last_bell=74.7 r3=74.7 | fit35 fat_end=69.9 last_bell=65.2 r3=65.2 | ahead=9.5 r3_down=9.5
TIREDNESS n=20: ahead=6.6 (8..12: OUT) r3_down=6.6 (15..20: OUT)
COACHFITPROBE2 tired=fail ahead=6.6 r3_down=6.6
```

## Verdict

- **COACHFITPROBE2 slope=NONE**
- **COACHFITPROBE2 tired=fail ahead=6.6 r3_down=6.6**

Elapsed: 953 s.
