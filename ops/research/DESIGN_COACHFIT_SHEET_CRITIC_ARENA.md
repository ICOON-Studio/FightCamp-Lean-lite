# COACHFIT_SHEET, judged - fresh critic (S530, COACHCRITIC10A, Arena)

SCORE depth=4 general=6

A fresh sports-management lens on the coach fit sheet: the mechanic, its numbers checked against the code, its choices,
and the answer to its own last question (keep the hover of section 11, or cut coach fit whole).

**In one line:** the arithmetic is right - I could not break a single row - but the sheet cuts the channel that changes a
decision (tiredness) and keeps the one that changes a rounding step (stat gain), asks the player to choose something no
screen lets her choose (which coach for which boxer), and hides its biggest coaching multiplier behind a hover that is
silent for the two middle words. Keep the hover, cut the fit's vocabulary and its unreachable parts, and re-measure the
two probes it rests on before anything is wired.

## What I read

Code, all read in full: `scripts/rules/CoachFit.gd` (216 lines), `scripts/rules/WeekPlan.gd` (389),
`scripts/rules/CoachedMornings.gd` (224), `scripts/ui/TrainGrid.gd` (282). Read around them, where a joined number is
decided: `scripts/rules/BoutRules.gd` (PROTOCOLS, tank_parts, FRESH_FATIGUE), `scripts/rules/TrainingPreview.gd`
(coach_factor, headroom), `scripts/rules/InjuryRoll.gd` (fatigue_mult, load_mult), `scripts/rules/PeakCamp.gd`,
`scripts/rules/ClubDeal.gd` (ASK, MORNING_SLOTS), `scripts/state/ClubWeek.gd` (the coached-morning tag and the
injury multiplier on the Training row), `scripts/state/Sim.gd` (step_day, week_peak), `scripts/rules/ReviewReveal.gd`
(what a week can light), `scripts/rules/FightWeek.gd` (REST_UP_TIRED_TO), `scripts/rules/FighterProfile.gd` (TRUST),
`scripts/rules/FighterGoal.gd`, `scripts/rules/Recruit.gd`, `scripts/rules/TraitLine.gd` (the other meaning of "temper").
Tests: `tests/coach_fit_sheet_test.gd`, `tests/coach_fit_test.gd`. Docs: the brief and its appendix
(`docs/COACHFITPROBE2_RESULT.md`). Probe source: `tools/fit_probe2.gd` (header and method). Worked from the code, not
run: no Godot was started. No other critic's answer was read.

## What holds

Every row of the sheet's number tables, recomputed by hand from the code. This is the strongest part of the sheet and it
deserves saying plainly: seven worked examples, a reach sweep, a stack of four cases, and the corner's untouched numbers
all come out exactly.

| Sheet says | Code | Verdict |
|---|---|---|
| Neutral 50; the game to the digit at 50 | `NEUTRAL`, `gain_mult(50)=1.0`, `tired_mult(50)=1.0` | right |
| Motivator +6 while Flat/Low; Technician +6 at coachability 70+, -8 under 30; Steady 0 | `temper_part` | right |
| Bond -4 / 0 / +6 / +12 from 0 / 8 / 45 / 110; a Stranger costs evenings only | `BOND_STEPS`, `STRANGER_EVENINGS_ONLY` | right |
| Taught out -6 within 5 of the ceiling; at the ceiling the gain halves | `TAUGHT_OUT_WITHIN`, `ceiling_mult` | right |
| Morning ceiling 55 + 0.35 x area, evening = area; pads 74 gives 80 / 74 | `morning_ceiling`, `evening_ceiling` | right |
| Focus morning +10, another stat -3, mornings only | `FOCUS_MORNING`, `FOCUS_OTHER_MORNING` | right |
| Words at 75 / 58 / 40 | `WORDS` | right |
| Reach 28..82 | 50+6+4+12+0+10 = 82; 50-8-4-4-6 = 28 | right |
| Gain 0.78..1.32, tiredness 1.055..0.92 | `gain_mult`, `tired_mult` | right |
| Stack: x1.32 plain, x1.6 held on a 1-to-1, x1.89 today on a Hard weak spot, x1.5876 for a risky fit | `capped`, `CoachedMornings.SOLO/SOLO_WEAK`, `BoutRules.PROTOCOLS[3].focus` | right |
| Worked examples 1-7: 50, 50, 76, 82, 34, 28, 50 | `fit()` | all seven exact |
| Corner untouched: coachability 75 takes 0.925, Flat 0.85 gives 0.786 | `Exchanges.uptake`, `TRUST` | right |
| Hover lands on the morning tile's gain label and the coached tag | `TrainGrid.gd` lines 149-158 (`gl`) and 160-165 (`tag["long"]`) | right |
| "Called by nothing in the game yet" | only the two tests preload `CoachFit` | right |
| File budget: 282 lines + ~12 | `TrainGrid.gd` is 282 lines | right |

So: no arithmetic error found. The problems are not sums, they are choices.

## Where the sheet is wrong

1. **The tiredness channel was measured on a quantity the game caps, then cut for failing.** The probe asked for 8..12
   points of energy at the bell and got 6.6, and the sheet cut the channel. But the game's own tank rule saturates before
   the probe could ever see a difference: `BoutRules.tank_parts` takes `clamp((fatigue - 50) x 2, 0, 20)`, so every
   fight-night reading past fatigue 60 takes the same 20 off, and both probe arms were past it (68.6 and 70.4). A fight
   week set to rest up additionally resets the at-bell tiredness to 30 (`FightWeek.REST_UP_TIRED_TO`), which erases the
   gap for any player who does the obvious thing. The pass line was unwinnable by construction.
   Meanwhile the load the channel actually moves is read in three live places the probe never looked at: the overreached
   line (80; past it a morning trains at x0.6, `WeekPlan.TIRED_GAIN`), the week's peak on the injury roll
   (`InjuryRoll.fatigue_mult`: x1 to 72, x2 at 76, x3 at 80 - already shown on the Training row as an injury multiplier in
   `ClubWeek`), and the peak-camp award (`PeakCamp`: the peak must stay under 80 to earn +1 on every stat for that
   fight). `WeekPlan`'s own note puts a Hard camp's peak at 77.4 and six hard mornings at about 83. A 6.6-point fatigue
   gap sits exactly on those lines. The channel with the most to say was the one cut, and the cut rests on looking at the
   wrong screen.
2. **The wins arm has no dose control, so "+0.08 in 100" cannot carry the verdict it carries.** The probe ran 40 bouts a
   boxer on a fixed opponent set with the arm winning 30 per cent, and no run that hands the harness a *known* boost. The
   game's own published curve is about 5 points of stats for 72 per cent wins, i.e. a few win points per stat point; a
   known +5 in the focus stat must show roughly +20-27 before the harness can pass or fail anything, and an even-odds arm
   (50 per cent) is where a one-point training edge is legible at all. A 30-per-cent long shot is the worst place to look
   for one stat point. Until that control exists, "slope=NONE" is a result about one parameterisation (1 + k(fit-50)/100
   through a 1.6 cap, where k 2.0 and k 3.0 are identical by construction) and one harness, not about the mechanic.
3. **The probe scaled a different lever from the one the sheet wires.** `tools/fit_probe2.gd` multiplies the day's
   *focus* gain; section 5 and H1 wire the *coached* morning (`CoachedMornings.day_mult`, the x1.25 / x1.15 / x1.4 the
   deal hands out, which goes on whichever ability the deal picked, not on the week's focus). Those are different sets of
   mornings, and the fit already pays +10 for training the focus - so the probe's number double counts a choice the week
   already pays for, and the +27 per cent headline is not the number the built lever will produce. Re-run on the wired
   path before it goes in a hover.
4. **The cap is asymmetric and anti-correlated with the player's skill.** `capped(gain, today)` holds at
   `max(1.6, today)`. On a well-built week (a weak-spot 1-to-1 in a Hard camp, x1.89 today) a TOP fit changes nothing at
   all, while a risky fit still bites (x1.5876, about 16 per cent off) and a poor one on a 1-to-1 morning loses. The fit
   can only ever hurt the best weeks. Whatever else is decided, the slope must not be a ratchet that punishes only.
5. **The biggest coaching number in the game is the one being hidden.** The fit spans x0.78..x1.32 - 69 per cent between
   its playable floor and its top - while the coach's visible *skill* (`TrainingPreview.coach_factor`) spans x0.906 to
   x1.018 for the two assistants' 58 and 74 ratings, about 12 per cent. The coach card shows the small one and the sheet
   hides the big one, then hides it a second time by rule: a reason line only at TOP FIT or RISKY, silent for GOOD and
   MIXED. Two boxers on the same coach whose gains differ by 13 per cent would look identical on screen. That is exactly
   the "unnecessary information" problem the owner's rule is about, one step sideways: information that changes the
   number but is not on screen is not clarity, it is a hidden die.
6. **At the resolution the player reads, the payoff is a rounding step.** A stat morning is
   `1.0 x quality x condition x coach_factor x headroom x 0.2 x intensity`; with a coach at 0.906 and the headroom clamp's
   floor (0.10) that is about 0.018 of a stat, and the tile prints two decimals. A x1.32 fit moves 0.018 to 0.024 - under
   the tile's own last digit - and the week review lights only the biggest stat that ticked a **whole** point
   (`ReviewReveal`). The probe's 0.95 of a stat in 26 weeks is under one whole point in half a year. Early in a career
   (headroom 0.4) the hover is at least visible on the tile; the fit goes quiet exactly as the boxer gets good.
7. **The sheet's first choice does not exist in the game.** "Which coach takes which boxer" needs a per-boxer
   assignment; the club has no such control. `ClubDeal` deals the coach's hours automatically (ASK, MORNING_SLOTS = 6),
   `CoachedMornings.week_deal` picks the days and who shares, the People page hires *one* assistant (sessional or
   full-time), and the pack's "Coach runs it / I run it per fighter" is agreed but not built. With one assistant there is
   nothing to choose per boxer: the fit's main decision is a one-off hire already made on price and rating.
8. **The words collide, and two inputs have no producer.** The game uses "temper" for the boxer's short fuse
   (`Recruit.gd`: "Short fuse"; `TraitLine`, `PushBack`, `CornerJobs`, every personality block) - the sheet uses it for
   the coach's manner. The game already has loyalty as the bond (`FighterGoal.gd`: "loyalty is the bond") - the sheet
   adds a second bond with no growth rule. `cards_known_share`, which the mode's +4/-4 needs, exists only inside
   `CoachFit.gd` and its tests; nothing in the game computes it. "Focus" is never defined for the +10/-3: the camp's
   stat, the goal's stat and the plan's focus are three different things in the code. One word per concept is an owner
   rule; this breaks it twice and invents a third word for a value nobody produces.
9. **Small inaccuracies inside otherwise exact tables.** The mode is not symmetric: a motivator has a right mode (lift,
   while she is Flat or Low) and never a wrong one, so "-4" is a technician-only number. At exactly half her cards both
   teach and polish read as wrong (`share > 0.5` / `share < 0.5`), so the sheet's "over or under half" leaves a dead
   centre where the right mode does not exist. `FIT_MIN` 10 and `FIT_MAX` 90 are unreachable (the real reach is 28..82),
   so the clamp is decoration and a clamp test proves nothing. Section 7 grows bond "+1 a coached session"; section 11
   H4 grows it "+1 a coached morning" - two rules in one document, and the second is the one the build list carries.
10. **Two strings would break the game's own rules.** H4's coach-card line uses a boxer's name outside a header; the
    pack's rule is names in headers only. And the taught-out hover would print the coach's ceiling ("80") - a number that
    appears nowhere in the game (the card shows the area rating, 74, not the derived 80), so it is a new unexplained
    number in a tooltip.
11. **What the cut list leaves behind.** If the coach-time budget, the time penalty, the mode control and the word ladder
    go, then `COACH_TIME`, `COST`, `week_cost`, `over`, `can_take`, `next_week_time`, `MODE_RIGHT/WRONG`, `STEADY_ALWAYS`,
    `PEN_MID/PEN_HIGH` and `WORDS` are all dead - roughly a third of a 216-line module nothing calls. Section 6 cuts them
    from the design but not from the file, and the test still asserts them.

## The sheet's last question: keep the hover, or cut coach fit whole?

**Keep it - as a hover, and only the reduced version.** Not because the payoff is impressive (it is not: 0.08 in 100,
and a rounding step in the week) but because of what it costs to *not* have it: the coached-morning tag already prints
x1.25 / x1.15 / x1.4 on the tile (`TrainGrid` line 160), it is the only visible coaching number in the training screen,
and once the fit is wired that tag becomes a number the player cannot explain without a reason line. An unexplained
multiplier of up to a third, on the screen the game's core loop runs on, is worse than no multiplier.

But kept as written, the hover repeats the fault it is meant to fix: it is silent for the two middle words, it carries a
scale the player cannot move, and it explains a lever the probe did not measure. So keep the hover with five changes:

- **One input the player moves:** the coach's manner against her coachability and her mood. That is the only part of
  the number a screen can change. Drop the mode (no data source, and the game would know the answer anyway), drop the
  bond (no rule, and loyalty is already the bond), drop the focus part (+10 for the focus is a second payment on a choice
  the week already pays).
- **The reason on every coached morning where the fit is not neutral**, one sentence, direction always, never a word and
  never a multiplier: "suits her: she takes teaching" / "does not suit her: she will not take teaching".
- **No ladder.** Delete TOP FIT / GOOD / MIXED / RISKY from the hover path; a four-word scale whose middle two words are
  silent is a scale the player cannot learn.
- **The ceiling stays as its own rule, not as a fit part.** Past the coach's Pads ceiling the gain halves; that is a
  cliff with an action (raise the area, or hire the better pad man) and it needs no fit vocabulary at all.
- **A kill switch, written down now:** if the repaired tiredness probe (item 1) and the repaired wins probe (item 2) both
  come back empty, cut coach fit whole and let the coach's skill carry coaching. Cut-whole is a fine outcome; it is just
  not the right one to reach by measuring the wrong screen.

Why not cut it whole today, as section 0b's pre-commitment implies? Because the pre-commitment was made against a probe
that (a) tested a saturating quantity in the ring rather than the live fatigue line in the week, and (b) measured wins in
a 30-per-cent harness with no dose control. A verdict is only as good as its probe. Repair the probe first; then the
pre-commitment means something.

Play (not on the scored line): 3 out of 10. As a hover there is no anticipation, nothing to come back for and no felt
reward; as a wired number it is one bar-step a season. The one thing that could make it felt week to week is the fatigue
line - easing one hard morning so a camp peaks under 80 and earns the gold peak-camp line is a decision the player
already makes and already cares about.

## Options: missing, useless, and what each changes

The sheet's own choices, judged one at a time.

**Real, keep**
- *Mornings on her focus (+10 fit) or on another stat (-3).* Changes the fit by 13 points, i.e. about 13 per cent of one
  morning's gain. Real but small, and it exists only as a side-effect of dragging a session onto a day; there is no
  control called "focus". Keep, and say which stat counts as her focus (the camp's, else the goal's).
- *Which coach takes which boxer.* The right shape - a manner against a boxer's coachability and her mood, with the best
  manner moving as her mood moves. Keep, **and build the control it needs** (see missing, below). Without the control it
  is not an option, it is a fact.
- *Keep the pairing to grow the bond, or switch and start at a Stranger.* The only real trade-off in the design (temper
  now against +6 or +12 later) - and it is the only one that interacts with a scarce thing, the coach's hours, once two
  boxers are in camp and the sessions are shared. Keep it, but only after it has a rule (see missing).

**Useless, cut - and the sheet is right about all four**
- *Mode as a player control (lift / teach / polish).* A control with one right answer the card already knows is a tax.
  Also unbuildable today: `cards_known_share` has no producer anywhere in the game.
- *The coach-time budget.* `ClubDeal` owns the coach's hours; two budgets for one coach is a double count. Correct cut -
  then delete the ~40 lines, the four functions and the constants, and the test that asserts them.
- *The "Coach fit GOOD x1.13" tag and the fit word on the roster row.* A number with no felt payoff. Correct cut.
- *Steady's free +2, now 0.* Correct: a manner that is +2 (or 0) for everyone is not a choice. Note the consequence -
  with Steady at 0 it becomes the default coach for everyone who is neither coachable nor flat, which is most boxers on
  most weeks. That is fine only if the other two manners are few and cheap to meet.

**Missing - with what each would change**
- *A per-boxer assignment control.* Nothing exists: the deal is automatic and one assistant is hired. Add an assign
  press on the coach card ("take her mornings") and a "which coach" line in the day's coach cell. This is the one item
  that turns the mechanic from a fact into a choice; without it, depth cannot go above 5 however good the numbers are.
- *The manner on the hire card.* The hire decision (sessional or full-time) is made on cost and rating today, and the
  manner - the thing that decides the fit - is not on the card. Add one line: "suits: boxers who take teaching" /
  "suits: a flat boxer". This changes who the player hires, i.e. the only coaching decision that is made once and lasts.
- *A press on the hover.* Every hover in this game carries an action, and both sheet hovers are read-only. "See the
  coaches" from the tile, "Give her the pads" from the ceiling line. A reason with no press is a caption.
- *An option when the ceiling is reached.* Past the coach's ceiling the gain halves and the sheet's answer is a hover
  telling the player to raise the area or hire better - three screens away, in People. Either put the press there or make
  the ceiling a reason to bring in a second coach for that one area (the club already hires by the job).
- *A "steady her first" answer.* The motivator's +6 exists only while she is Flat or Low, and a Flat boxer takes 0.85 of
  the corner's word (`TRUST`). So the design pays the player for a state the rest of the game punishes, and rewards the
  perverse move (keep her just under 50 morale to keep the lift). The missing option is the ordering: the hover should say
  "flat: a rest week would do more than a lift", and the rest week is already on the week screen. Without it, the
  motivator is an incentive to neglect morale.
- *A cost, or a scarcity.* With the coach-time budget cut, the fit is free: no slot, no hour, no money. Every good
  mechanic in this game costs something. The cheapest honest cost is to let the coach's scarce slots be dealt by fit (he
  takes the morning that suits him, and the second boxer's deal visibly gets worse) - which is also the R55 two-in-camp
  rule the pack already flags as missing.
- *A definition of "focus".* The +10/-3 needs one stat to be "her focus" this week. The code has three candidates (the
  camp's stat, the goal's stat, the plan's focus). Name it, or the number is unfalsifiable.

## To reach 10/10

Most important first. Each is specific enough to build; the first two are probes, because two of the sheet's five cuts
rest on measurements that do not measure what the design uses.

1. **Re-run the tiredness probe on the fatigue line, not the ring.** Same 60 boxers and paired seeds; a Standard and a
   Hard camp week at `tired_mult(82)` and `tired_mult(50)`; report, per week and per arm: the week's peak fatigue
   (`Sim` week_peak), the number of mornings that started past 80 (training at x0.6), `InjuryRoll.fatigue_mult(peak)`
   (x1 to 72, x2 at 76, x3 at 80), and whether `PeakCamp.met` came out true (peak under 80, +1 on every stat for that
   fight). Pass: a TOP fit keeps a Hard camp under 80 in at least half the weeks where a neutral coach crosses it, or
   moves the injury multiplier by 1.25x or more. Do NOT re-use the energy-at-the-bell pass line: `tank_parts` clamps the
   tiredness term at 20 from fatigue 60 up, so past that point the ring cannot show any gap at all.
2. **Add a dose control to the wins harness before believing +0.08.** In the same arena, same seeds, same opponents, run
   three arms: untouched, +5 on the focus stat, +0.95 on the focus stat. Expect about +20-27 wins in 100 for the +5 arm
   (the pack's own curve). If +5 does not move the harness, the harness cannot judge a training edge and the whole
   "fit cannot be felt in wins" conclusion has to be withdrawn, not used to cut. Also run the even-odds arm: a
   30-per-cent long shot is the worst place to find one stat point.
3. **Re-run the slope on the lever the sheet actually wires.** H1 multiplies the *coached* morning
   (`CoachedMornings.day_mult`), not the focus morning the probe scaled. Sweep again on the coached mornings and on the
   drill nights, and keep the evening arm in the report: with `FireLevel` on, a line fires 1 use in 2 at Usable and 3 in 4
   at Sharp, which is the only fight-facing number the fit could ever own (+2.8 wins in 100 between tiers). "Sharp 1.5
   weeks sooner" is the fit's one interesting result and it belongs in the sheet's first paragraph, not the last.
4. **Make the cap symmetric or drop it.** Today `max(1.6, today)` lets a TOP fit do nothing on a x1.89 morning while a
   risky fit still takes 16 per cent off it. A fit that can only punish the player's best week is a trap. Either let the
   fit lift past 1.6 when it is the fit that is lifting (and keep the cap against compounding), or hold today's product
   as a floor *and* a ceiling for both directions and say so out loud.
5. **Cut the fit down to one input and then show it everywhere it moves.** Keep the manner against coachability and mood;
   delete mode, bond, focus and the taught-out -6 from the number. Then: a reason line on every coached morning where the
   fit is not neutral (not only at the two extremes), no word ladder, no multiplier in the string, and a press on it that
   goes to the coach card. A hidden x0.92..x1.10 is defensible; a hidden x0.78..x1.32 that stays silent for its middle
   words is not.
6. **Build the assignment control, or accept that the mechanic is a fact.** Add "take her mornings" on the coach card and
   a coach line in the day's coach cell; with two assistants the deal becomes a decision (who gets the 1-to-1s, who
   shares), and fit gets the thing it currently lacks - a cost, because the coach's slots are scarce when two boxers are
   in camp. This is also where the R55 two-in-camp tension finally lands.
7. **Give the ceiling its own rule, outside the fit.** `morning_ceiling(area) = 55 + 0.35 x area` and the x0.5 past it;
   show it once in the week review the week she reaches it ("learns at half speed on the pads: the ceiling here is
   <his> - raise the area or hire the better pad man"), with a press, and no number the game shows nowhere else. This is
   the single most actionable thing in the whole sheet and it does not need the fit to exist.
8. **Fix the words and the inputs before any of it is wired.** Rename the coach's "temper" to a manner (Motivator,
   Teacher, Steady hand) so the boxer's Temper keeps its meaning; drop the second bond, or define bond = loyalty plus
   coached sessions and say which; delete `cards_known_share` unless something produces it; define "focus". One word per
   concept is not a style note in this game, it is the reason the four mastery tiers work.
9. **Clean the cut out of the file, and make the tests assert what is left.** Delete `COACH_TIME`, `COST`, `week_cost`,
   `over`, `can_take`, `next_week_time`, `time_penalty` and `PEN_*`, `MODE_*`, `STEADY_ALWAYS`, and the two unreachable
   clamp ends (make the clamp 28 and 82 so a failure means something). Update `coach_fit_sheet_test` to the numbers that
   survive; a test that asserts a dead constant is a test that will argue with the next change.
10. **Write the two probe outcomes into the sheet as a gate.** "Repairs 1-3 pass -> wire and show under item 5; any of
    them fail -> cut coach fit whole, keep the ceiling rule of item 7, and put the manner on the hire card as a shape
    only (no number)." A pre-commitment made after the probe is a pre-commitment worth having.

## What 10/10 looks like as one 1920x1080 page

(A page, described - the task's one-file contract means the HTML is not shipped here.)

Warm tan plaster wall, cream paper, one aluminium frame. Top bar as everywhere else: back and forward, the club's name,
the date, the cash, CONTINUE.

Left, the week: seven columns, magnets. One morning tile is circled in marker - Thursday's pads, the one the coach takes.
On it, the tag "Coached 1-to-1: Power (x1.25)" and, under it, the stat gain as it will land: +0.07 Power. On hover, one
Kalam line, handwritten, no numbers but the stat: *"Suits her - she takes teaching."* Next to it a small paper clip with
one press: **See the coaches**.

Right, the coach card, pinned: the coach's face, the area bars (pads 74, conditioning 58), one line of manner -
**Teacher** - and below it, in marker, the three boxers he could take mornings for, each with her coachability as a word
("takes teaching" / "will not take teaching") and the two and a half weeks the bond needs to reach Trusted. One button on
each: **Take her mornings**. The boxer he is already taking is ticked, and the cost is visible where the cost is: the
other boxer's shared mornings grey out beside it.

Bottom, the fatigue line, drawn as a chalk line with the overreached mark at 80 and the peak camp mark just under it: this
week's peak sits at 74, in green, so the gold peak-camp card is in reach; move one Hard morning to Normal and it stays
there, leave it and the line tells you the injury multiplier goes from x1 to x2. Two hovers on the line: *"tired: learns
at three-fifths"* and *"a hard week: hurt more easily"*.

No fit number anywhere on the page. No word ladder, no grid, no roster column. The player's eye goes: the week, the
reason under the gain, the coach card, the fatigue line, and the two presses that change something - who takes her
mornings, and which morning gets eased.

## Loose ends, and what I could not check

- I did not run Godot, so nothing here is a measurement: every code claim is read, and every sum is hand arithmetic
  reproduced from the constants.
- The probe's per-boxer star lines (boxer 2 shows a 9.5 gap) are consistent with its summary average of 6.6 on 20 boxers;
  I did not replay the run.
- `tools/fit_probe2.gd`'s morning lever is described in its own header as the focus gain; I read the header and the
  constants, not the day loop, so the "different channel" finding rests on the probe's own words plus `WeekPlan.day`'s
  `CoachedMornings.day_mult` line. Worth confirming in the code before the re-run in item 3.
- The 1.6 cap's effect on the wins arm (k 2.0 and 3.0 identical, capped 2682) is the probe's own count; it agrees with
  `capped()` for a plain morning, but a cap that binds more often on a coached week would make the slope look flatter than
  it is - one more reason item 3 has to re-run on the wired lever.
- The pack's coach ratings (pads 74 / 58) are quoted from the pack, not from a data file I read.
