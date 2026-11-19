# COACHFIT_SHEET - coach fit as numbers, from the code (S529, COACHSCOPE1 phase 1)

Scope: ops/research/COACHFIT_SCOPE_S528.md (CLAUDE.md item 8: nine map rounds, Arena 5/4, the METHOD was wrong).
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
inside the stack cap that makes a TOP fit worth +4..+8 wins in 100? If none, fit stops being a shown number (Arena 10/10
item 5: "make the fight effect felt or stop showing it").

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
1.00 at fit 50, 0.9375 at 75, 1.0375 at 35; held at 0.92 / 1.08 (Arena item 3). It multiplies the LOAD a session adds
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
   ahead) and 35 is 15..20 down by round three (Arena item 3). If not, change the constant, not the pass line.

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
