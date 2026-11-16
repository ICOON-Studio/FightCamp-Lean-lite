# TRAININGK1 - Training K v6c built (S496)

Owner: Q-S294-259 "Yes, build it" (2026-11-16 07:29) on `ops/AgentComms/board_attach/Q-S294-259_0_training_k_v6c_nobout.png`;
C416 on the old fighter-page Training tab: "remove this training picture from the game".

## What changed in the game
- New screen TRAINING (`scenes/areas/Training.tscn`, `scripts/ui/areas/Training.gd`), reached from the gym floor's new
  **Training** pin and from every old "the week" link: `Routes.canon` sends the fighter page's tab 3 to it, the first-week
  guide's "Set the week" opens it, `Main.on_week_tab()` is true on it.
- The fighter page's Training tab is gone (`FighterPage.TAB_ORDER` 0, 5, 7, 4). Her road (AwardCard) moved to History.
- New rule: the boxing coach's 75 pad minutes a night are SHARED by the boxers on pads that night (`scripts/rules/CoachNights.gd`),
  wired into the drilling the week runs (`DrillWeek.coach_share` -> `nights.per`, read by `PadWeek.night_minutes`, so the
  sim, the card projections and the night log all read it). Linear: a boxer's pad night drills her minutes / 75 of a full
  night (240 units) - the coach spec's own model (COACHSPEC1_MAP_R5_S495.md 12). A lone boxer keeps whole nights (the
  normal start is unchanged). Three boxers on one night = 25 min each = a third of a night each, until the player drags
  the line.
- Data moved out of the old board: `scripts/state/WeekData.gd` (plan_of, goal_of, tired_days, pack, fight_dow);
  `WeekBoard`'s statics delegate to it. `WeekCards.gd` (552 lines) split: `WeekPopKit.gd` (popovers), `WeekBars.gd` (bars).

## Every element -> the rule that computes it
| Element on the picture | Shown as | Wired to |
|---|---|---|
| Fighter card: class, bout, week kind | "Light 60 kg · boxing", "Bout Sat 7 Feb · 19 days", BASE / BUILD / PEAK / FIGHT WEEK | f wc/limit, f.bout, WeekPhase.PHASES (ClubWeek.card) |
| Fighter card: coach minutes | coach icon + "95 min" | sum of her CoachNights share on her pad nights (DrillWeek.night_mins) |
| Fighter card: tiredness sparkline | 7 points | WeekPlan.week fatigue by day (WeekData.tired_days) |
| Grappler card | "MAT WEEK 3 no-gi classes" | NoGi.CLASSES_PER_WEEK (the mat coach's week; not selectable) |
| COACH row, pad night | bar split by face, minutes, white line drag | CoachNights.split / drag; stored f.coach_min {dow: min}; act `tksplit` |
| COACH row, other nights | SPARRING NIGHT / IN THE CORNER / CLOSED / NO COACHING | PadWeek.nights_of spar, a bout that night, Sunday |
| MORNING tile | picture, L N H, kg, "+0.15 Stamina" | WeekPlan.week day (gain, kg); edit act `wday` via `tkam` / `tklevel` |
| MORNING "WORK" | WORK, day job | DayJob.lost_days |
| Rest morning | "-7 Tiredness" | WeekPlan fatigue drop (tired_days) |
| EVENING pads | her coach minutes, the move, mastery bar (had / tonight / +1 night / Usable flag) | CoachNights share; PadEdit.night_rows over PadWeek.project (drill = minutes share) |
| EVENING sparring | "Fight IQ +0.18" | WeekPlan.full_day gain2 |
| EVENING drop | Pads / Sparring / Rest onto any evening | act `weve` (WeekPhase.edit_eve) |
| TIREDNESS chart | carried-in start, end of each day, "too tired: gains drop 80", fresh 50, first bell est. | WeekPlan.week; WeekPlan.OVERREACHED (mornings at 60%); BoutRules.FRESH_FATIGUE; CampForecast + Gauges legs |
| DIET | Normal / Cut harder, "Sunday 60.9 kg" or "Fight day 59.8 kg est." | f.diet (act `diet`); WeekPlan weight_end; CampForecast + Gauges kg |
| Bout panel | NO BOUT BOOKED / BOUT AHEAD / FIGHT WEEK, scale, first bell | WeekData.booked, fight_dow, CampForecast + Gauges |
| THIS WEEK | each drilled move: Mon -> Sun mastery, "usable from Wed" or "20.2 short of Usable" | PadEdit.night_rows; MoveMastery Usable 30 |
| MORNINGS | stat gains, week total, rest day | WeekPlan.week gains |
| Selected EVENING | the split bar (drag), each boxer's minutes, when she fights, her move's bar | ClubWeek.night (CoachNights + each boxer's PadWeek.project) |
| COACH'S PICK | his line + Do it | WeekCoach.advice (fix applied by `tkfix`); the opponent's name replaced by "the opponent" (S448) |
| SESSIONS tray | each morning at Normal for her, Pads "+6.5 a night", Sparring Fight IQ | WeekPlan.day / full_day; her first pad night's mastery gain |
| START THE WEEK | play the days | Main.on_go |

## Not built (said, not faked)
- Film on the tray is shown but not dragged: a film night comes with a booked bout's camp (WeekPhase film_night).
- "1 of 2 coaches free": the game has one boxing coach (evening class coaches are not pad coaches); the split's total is
  `CoachNights.total(coaches)` so a second boxing coach is one argument away.
- The picture's per-stat colours: the one palette (Palette.gd) has no stat colours; numbers use GOOD / ACCENT / ELITE.
- The week's twist card (WeekTwist, two answers) was on the old tab; on TRAINING it is not drawn - it is still answered in
  the Monday week review (TwistCard), where it is dealt. Say if he wants it back on the screen.
- "Cardio": the game's word is Data.LABEL "Stamina" on every other page; kept for one word across screens.

## Old tab retired
- Tests of the removed page deleted: week_b, week_board_clarity, week_slate, drill_card, plan_tray. hover_ghosts lost its
  whiteboard part (the camp modal's ghosts stay); week_strip's section 3 checks the link opens TRAINING.
- golden_path: Kira's uppercut now needs the coach's line dragged to her (TEST: shared nights, a weapon inside 3 weeks).
- Still in the repo, unreachable from the game: WeekBoard, WeekDay, WeekTiles, WeekTired, WeekEditors, WeekPops, WeekPopKit,
  WeekCards, WeekBars, WeekCamp, DrillTray (+ their still tools). Live tests still call WeekCamp.forecast, WeekEditors.line_tip,
  DrillTray.make and BoutActs clears DrillTray.picked: a follow-up moves those few helpers and deletes the rest.

## Tests
- `tests/coach_nights_test.gd` (rule + wiring: 3 boxers drill 80 of 240 each, dragged 65 min -> 208, a lone boxer 240).
- `tests/training_k_test.gd` (golden path: club4 -> TRAINING, every number a rule's, drag a morning, Hard, an evening to
  pads, drag the coach's line, the coach's pick, select another boxer, the old tab link opens TRAINING, Largest text fits
  1920 with no word spilling, CONTINUE runs the dragged split, a normal start's whole 75 min).
