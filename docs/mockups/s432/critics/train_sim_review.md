# Training depth: a blind review by a sports-sim training designer (S432)

Critic: lead designer of player development and training systems in Football Manager-style sims. Fresh and blind: no earlier score read.
Read: CRITIC_PACK, CRITIC_ACCESS, the code (WeekPlan, TrainingPreview, TrainingLoad, TrainingPlan, TrainingWeek, WeekPhase, WeekTwist, WeekCoach,
WeekActual, WeekRead, PadWeek, PadEdit, MoveMastery, HabitFix, CoachAreas, Attrs, PerkRoad, Recruit, FighterGoal, PeakCamp, SparNights, BjjSide,
BoutRules camp rules, Sim.step_day and end_week, Injuries' training roll), the real Training tab (`docs/mockups/s432/trainingb2_23e_real.png`),
CLUBWEEK v4.1 and the RPG layer map v3 (proposals, not built), and the R55 pads map (depth 4 twice).

## Score: 5 / 10 for the training as built (about 6.5 if CLUBWEEK v4.1 and the RPG layer were built as written)

One line: a careful week model for ONE fighter (real kcal, a tiredness curve with a line at 80, injury from load spikes, phases counted back from the bout),
but four fighters train in four separate rooms with nothing shared between them, most choices move numbers too small to see, and the fighter as a
person (mood, discipline, habits) plays no part in the week.

## What really happens in a week (traced in the code)
- Monday: the coach's week for the phase is written (BASE / BUILD / PEAK / TAPER, WeekPhase), the player's exceptions sit on top, one twist card is dealt
  PER FIGHTER (WeekTwist, seeded by fighter), and Monday's plan is saved to compare later (WeekActual).
- Each day (Sim.step_day): the morning session gives its stat a fifth of a focused week x intensity (0.6 / 1.0 / 1.3) x coach area rating x headroom, x0.6
  when tiredness is already 80+; the evening adds pads (technique, or the camp stat), sparring (fight IQ) or nothing; kcal set the weight; tiredness keeps
  87% a night (better with Recovery). The new attributes get their share (Attrs.apply_session).
- End of week: one injury roll from hours against the fighter's usual (EWMA) and the week's peak tiredness (Injuries); a habit chosen at signing goes after
  4 weeks; perks open when their numbers are met; the review shows planned against actual and the coach's one change.
- Fight night: tiredness carried in from a camp empties the tank at the first bell (BoutRules.stale_energy); a camp that met weight, its stat line and never
  passed 80 gives PEAK CAMP.
- Evenings: pad nights carry drill cards (75 minutes, split 50/50, 70/30); mastery 2.1 a pad hour, Usable at 30 is a weapon; sparring gives every held
  card a share. Sizes: a Normal roadwork morning +0.13 Stamina, Hard +0.17, Light +0.08 (the real screen).

## What is good
- Real numbers under the hood: MET x kg x hours for kcal, 7,700 kcal a kg, a 500 kcal cut, session RPE x minutes for load, a ~7-day fatigue constant,
  an EWMA "usual" that does not punish a rest week, acute against chronic load for injuries. That is a better base than most sports sims ship with.
- Cause and effect is honest: one rule (TrainingPreview) drives the forecast, the day and the review, so the board never lies.
- The phase-writes-the-week idea (coach drafts, player edits exceptions) is the right answer to "14 picks a week" and matches FM's schedule-plus-overrides.
- The tiredness curve with a named line at 80 is the clearest thing on the screen; it links to injury risk and to the fight (stale tank).
- Peak camp: three lines (weight, stat, never overreached) met on fight night pay a bonus. That is a real goal for a camp.
- Pad nights with drill cards and dated tiers ("usable Wed") are the most game-like part: a visible date, a scarce slot, a reason.
- Coach areas (pads, bag, cardio, strength, sparring) make WHO coaches a session matter, and the head coach's edge (strength coach +10% body) is felt here.
- Perks open from trained numbers: the week has a payoff to aim at.
- Twist choice cards have a visible price (cut harder, push through at twice the risk) and are locked on Monday.

## What is missing (options a training screen should have)
1. ANY SHARED LIMIT BETWEEN THE FOUR. Coach, pads and mornings are unlimited: every fighter gets the full coach on every session. Four Training tabs are four
   copies of the same puzzle with no trade-off between them. This is the single biggest gap (R55 and CLUBWEEK v4.1 both see it; neither is built).
2. A SQUAD VIEW. No board shows all four weeks at once; no copy a week to another fighter; no group session (two fighters on the same morning).
3. SPARRING AS A CHOICE: who with (weight, stance, style), how hard (hard, technical, body only), and its price (cuts, knocks, tiredness for both). Today it is
   a count of nights and a flat fight-IQ share.
4. THE PERSON IN THE WEEK: discipline, coachability and mood do nothing to training (checked: none of them is read by WeekPlan or Sim.step_day). In FM the
   professionalism and morale of a player are half the training story.
5. HABITS AS TRAINING WORK: a habit only goes through the one starting focus at signing (4 weeks) or a single corner fix. The week cannot target "drops the
   right after the jab".
6. SEASON PERIODISATION: the phases are automatic from one booked bout. No season target, no deload week chosen by the player, no "peak for the nationals,
   not for this club show", no form forecast (fitness against tiredness) to a date.
7. WEIGHT AS A DECISION: Hold or Cut is the only choice. No walking weight, no cut speed with a price, no "move up a class" call, no weight on the Training tab
   outside a camp.
8. SESSIONS FOR THE NEW ATTRIBUTES: explosiveness only through the heavy bag, composure and inside fighting only through sparring, footwork only through
   shadow boxing. No plyometrics, no footwork drills, no inside work, no technical sparring.
9. STALENESS AND BREAKTHROUGHS: the same week repeated for ten weeks trains exactly as well as a varied one. Nothing rewards changing the stimulus; nothing
   surprises (a "it clicked" week, a plateau with its reason).
10. A SEASON'S STORY VIEW: no chart of each ability across the season with its causes (camp, injury, perk, habit gone). The review is weekly and forgets.
11. ANA'S MAT HAS ONE CHOICE: the class drills the move closest to owning by itself; no guard/top focus, no rolling intensity, no positional sparring.
12. DELEGATION: "Coach runs it" per fighter is agreed but not built; with four fighters, a player needs to hand one fighter's week to the coach knowingly.

## What is useless or near-useless today
- Light / Normal / Hard per morning: +0.08 / +0.13 / +0.17 on a whole-number stat. The tiredness part is visible; the gain part is invisible in a week and
  barely visible in a month. The choice is really "how tired", which is fine, but the screen sells it as gain.
- Mobility: trains Flexibility, valued 0.015 a point in the fight (the lowest of all); a rest morning that looks like a session.
- Rest as a morning that trains Recovery while taking the same points off Stamina (Attrs.train): net nothing on the summary, confusing on the board.
- Film on an evening with no bout booked (the button is always there; it needs an opponent's tape).
- Sharp and Signature on a drill card: past Usable a planned line fires every time today (the firing rule is switched off), so sharp is worth about 1 win in
  100: pad time on a usable card is near-wasted (R55's own measure).
- The "Leave" button beside "Do it" on the Training tab (it is "back to the coach's week"; the word says the opposite).
- "240 min tonight" on a pad night (game units; the night is 75 minutes).
- An older block plan (TrainingPlan, 0-6 blocks per session) still answers one action but the day's training reads the seven mornings: one of the two should go.
- Four personal twist cards a week once there are four fighters: four small chores instead of one interesting club problem (CLUBWEEK's club twist is right).

## Can the player read cause and effect?
Partly. The tiredness curve, "usable Wed" on cards, planned against actual and the coach's one change are readable. But the real screen shows day tiles as
icons only (no session words), the coach's line is hidden behind the guide, there is no goal line or weight on the tab outside a camp, and every gain is a
two-decimal number. A player can see that a week was tiring; it is hard to see that it was GOOD.

## Does a season of training tell a story?
For one fighter, a thin one: perks open, a move turns usable, a camp peaks. For four, no: nobody went short, nobody was favoured, nothing was given up.
The story in FM training comes from scarcity (one coach, one focus), from the person (a lazy talent, a flat month after a loss) and from the target date.
All three are missing as built; CLUBWEEK v4.1 adds the first and third, the RPG layer the second.

## To reach 10/10 (most important first, each buildable)
1. SHARED LIMITS ON ONE SQUAD BOARD. Build the core of CLUBWEEK v4.1 only: pad places (8 owned for 10 to 13 asked), coached mornings (your 4, Coach's 2;
   two on one session share at 0.8), alone at the mood rate. One board, four rows, seven days, colour = who coaches. Leave seats, favours and the job rota
   for later if time is short: the scarcity is what makes training a decision.
2. SIZE EVERY CHOICE IN UNITS A PLAYER FEELS. On each cell and each row: the whole point it crosses and the day ("Stamina 66 to 67 Thu"), and for a booked
   bout the range in wins in 100 ("+3 to +5 on Sat"), from probes. Hide two-decimal gains in the hover.
3. SPARRING PAIR AND SETTING on each sparring night: partner from the roster by weight (under 5 kg full, 5 to 10 kg half, over 10 kg tiring), stance and style
   (a southpaw mate removes the round-1 penalty), setting Hard x1.3 / Technical x1.0 / Body only x0.8 with a cut or knock risk inside 10 days of a show.
   A partner of better Fight IQ gives more; both fighters pay the tiredness.
4. THE PERSON IN THE WEEK: alone sessions at the mood rate (0.8 / 0.6 / 0.4); discipline under 45 skips one alone morning in 3 unless a team-mate is in the
   room; coachability scales what a coached session adds (0.85 to 1.15). Show it on the row ("Flat: alone at 0.4").
5. INDIVIDUAL FOCUS, one per fighter, FM-style: a habit (trained out on your own pad places in 3 to 6 weeks, dated), a perk's number (with weeks to it), or a
   move to Sharp. Switch on the measured firing rule (1 in 2 at usable, 3 in 4 sharp, always at Signature) so a move past Usable is worth pad time.
6. A SEASON TARGET AND A FORM CURVE: one target per fighter (the nationals, the pro offer, a year to grow; for Ana a medal or blue), the phases counted back
   from THAT date, a deload week the player can place, and a fitness-against-tiredness curve with "form on the day: sharp / fresh / flat" (Banister: the
   code already has the 7-day and 42-day constants).
7. WEIGHT AS A SEASON CALL: walking weight, the day's forecast always on the tab, cut speed Steady or Fast (Fast: tank -2 and mood -3), and once a season
   "move up a class" with what it changes (no cut, new names on the ladder).
8. STALENESS AND VARIETY: the same mix of mornings for 5+ weeks trains at x0.8 until one session changes; one "it clicked" week now and then with its named
   cause (a coached streak, a new partner). Both shown on the row before they land.
9. SESSIONS FOR EVERY TRAINABLE ATTRIBUTE: plyometrics (Explosiveness), footwork drills (Footwork), inside work on the bag (Inside fighting), technical
   sparring (Timing, Composure); cut Mobility to a hover inside Rest.
10. A SEASON STORY VIEW on the fighter page: each ability's line across the season with markers (camp, injury, perk opened, habit gone, short weeks), and a
    monthly coach's report (best and worst trained, who went short).
11. ONE CLUB TWIST A WEEK instead of one per fighter, with priced answers on named fighters (CLUBWEEK 3.4).
12. ANA'S MAT: pick the class focus (guard or top game), positional rolling or hard rolls, and the stripe date shown against it.
13. "COACH RUNS IT" per fighter: that fighter's week is the coach's deal, costs none of your sessions, and the row says what it gives up against your deal.
14. SMALL FIXES on the current tab: session words under the day icons, "75 minutes, 3 cards" not "240 min", "Back to the coach's week" not "Leave", the
    coach's line never under the guide, the goal line and the weight row always on the tab.

## Complete?
Yes, with this list applied, training is complete for this version (four fighters, amateur to a first professional fight). Items 1 to 7 are the ones that
make it complete; 8 to 14 make it rich. Why: the list gives each week a scarce resource to deal between people (1), a visible size for each deal (2), the
two real weekly coaching calls of an amateur club (sparring and weight, 3 and 7), a fighter who is a person and not a stat block (4, 5), and a date the
whole season is built toward (6). Nothing in it needs the fight or the world to change, and nothing in it is MMA, pro belts or the living world.
Two cautions: keep the counter count small (the CLUBWEEK board has many; a first-time player needs pad places and mornings first), and every size on
screen must come from a probe on the played bout, never a guess.

## The drawing
`docs/mockups/s432/critics/train_sim_10.png` (from `train_sim_10.html`): the Squad week tab. Four rows, seven days, morning and evening per day, the left
edge colour says who coaches (You, Coach, alone at the mood rate); counters on top (pad places 8 of 11 asked, 3 short); THIS WEEK BUYS per fighter in whole
points, dated tiers and wins in 100; the coach's one change with its price on both fighters; on the right the selected fighter's fitness against tiredness
with staleness, weight with cut speed and the class call, the sparring pair and setting, and each fighter's individual focus.
