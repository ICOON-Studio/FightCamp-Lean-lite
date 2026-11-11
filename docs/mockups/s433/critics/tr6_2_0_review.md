# Training depth, v6.1: blind review by a strength and conditioning coach (tr6_2_0)

Read: CRITIC_PACK.md, CRITIC_ACCESS.md, TRAINING_MAP_S432.md (whole, 744 lines), training_v2.png. Checked against the code:
WeekPlan.gd, Attrs.gd, TrainingLoad.gd, InjuryRoll.gd, Injuries.gd, MoveMastery.gd, BoutRules.gd, LiveRound.gd, Combos.gd,
Exchanges.gd, NoGi.gd, Knowledge.gd, Recruit.gd, Sim.gd, GymSpend.gd, Roster.gd. No other critic's file opened.

## Score: 7 / 10

One line: A real camp planner in game form (load by effort x minutes, base before specific, a taper, rest days, recovery rules,
exposure to head shots, a weigh-in with water), honestly checked against the code. What holds it under 8: conditioning, the
heart of the job, still barely shows on fight night, and every new number is still a guess waiting on its measurement.

## Code claims checked (all hold)
| Claim in the map | What the code says |
|---|---|
| Light 0.6 / Normal 1.0 / Hard 1.3 gain; load 0.6 / 1.0 / 1.5; a morning is 0.2 of a week; x0.6 from 80 | WeekPlan.INTENSITY, SESSION_SHARE 0.2, TIRED_GAIN 0.6, OVERREACHED 80: yes |
| The night keeps 0.87 - 0.003 per Recovery point over 55, held 0.70-0.95; 44 load a point | WeekPlan.fatigue_keep, LOAD_PER_FATIGUE: yes |
| The gain is worked on the old stat against one `pot` (F2b) | WeekPlan.day calls TrainingPreview.preview_gain(stats, ctx.pot, ...): yes |
| F1 rest drains Stamina | already fixed on main (Attrs.train comment "S433 REST1": rest adds Recovery only), counted as handled |
| Today's shares | Attrs.SESSION_ATTRS + LEGACY + NAMED_MAX 2.0 / OUTSIDE_SHARE 0.5: the map's "Today" column matches |
| The Tank: 2 a point over 50, at most 20, nothing without a camp | BoutRules.stale_energy, FRESH_FATIGUE 50, STALE_MAX 20, protocol < 1 returns 0: yes |
| The round-3 fade is a cliff at 64 on the old conditioning | LiveRound 65-66, BoutRules 209, BoutRead 326, FADE_CONDITIONING 64, OWN_FADE 1.0; ROUNDS 3: yes |
| Energy cost and refill read the old conditioning | Combos.spend_factor 1.2 - 0.4 x c/100, refill x (0.8 + 0.4 x c/100): yes |
| Camp levels are free and add up to +1.0 | BoutRules.PROTOCOLS, all cost 0, edge 0.25 / 0.6 / 1.0: yes |
| The usual is a 42-day average; ratio from 1.3 to x3 at 1.5; tiredness from 72 | TrainingLoad.CHRONIC_DECAY 0.1535, InjuryRoll.load_mult, fatigue_mult: yes |
| Move fade 0.75 a week, Usable kept | MoveMastery.decay_week: yes |
| Known is called by no script; three groups as named | Knowledge.gd BODY / SKILLS / FIRE; no caller outside the file: yes |
| turn_pro leaves the day job | no `day_job` in Roster.gd; GymSpend.DAY_JOB_GAIN still applied: yes |
| Ana: 3.2 a week drill, body to one ceiling 90, no class kinds | NoGi.DRILL_GAIN 3.2, BODY_CEIL 90, train_body: yes |
| The worked weeks | Normal base week 1,951.5 effort-minutes = work 75 (82% of 92); Hard 2,547 = 98 (106%); Tank at tiredness 35 = 95.5; one coached Hard drill +0.20, +0.26 with the dose: the sums are right |

One thing the map leaves out: InjuryRoll.flex_mult already lets Flexibility lower the training injury chance. The T17 table
gives Flexibility no line; it has one in the code ("fewer niggles from 55").

## What is deep (how a working S&C coach would see it)
- The load unit is the right one: effort x minutes (session-RPE), evenings included, against a 42-day usual, with the spike ratio
  and the week's peak tiredness both pricing injury. That is how camps are monitored in real gyms.
- Base, then specific, then a taper that cuts volume and keeps intensity (Sharpen). A base that makes the next block pay more
  turns the season strip into a plan, not a list of weeks.
- Two engines with one job each (roadwork for recovery between efforts and overnight, intervals for the cost of each round) is
  a fair simplification, and it is linked: more Recovery clears tiredness faster, so later Hard weeks stay under the lines.
- Morning rules set on Monday are how good coaches work: decide the rules in advance, then let them fire. No extra stops.
- Losing fitness by missed sessions, with windows by quality (speed fades fastest, strength and aerobic fitness slowest), follows
  the residual-training research.
- Head contact counted over 8 weeks with a lasting cost is responsible and turns sparring into a season choice.
- The water rule (pros only, day-before scale, up to 2%) is conservative and correct.
- Every price comes from one run of the week with and without the choice: the player can trust the numbers.
- The gate table names a pass line and the cut for each failure, and nothing is drawn until the gate passes.
- Section 8 gives every menu the mechanic appears on and what it is wired to, and the golden path walks it: the owner's bar,
  as far as the design goes.

## What holds it at 7
1. CONDITIONING BARELY SHOWS ON FIGHT NIGHT. The map says so itself: a Hard Stamina block moves round-3 energy 57 to 57.5, and
   the fade from 0.35 to 0.04 of a power point in the last round only. With spend_factor 1.2 - 0.4 x Stamina/100, five points of
   Stamina change a round's cost by 2%. In a real camp, conditioning decides who still throws and still holds the guard in the
   last round. Here the player can spend six weeks on it and see almost nothing in the ring. Moving Stamina to its own number
   with a slope (F3) is correct, but the slope has to be steeper and has to reach output and guard.
2. EVERYTHING NEW IS STILL A GUESS. Hard 1.6, the dose x1.3, the base x1.2, the response, age, the 48 rounds, the water: all are
   estimates, worked by hand on one fighter. BLOCKORDER1 by hand gives the base +0.3 Footwork, which may be too small to
   matter. The design is honest about this, but depth only counts once a choice is measured to matter.
3. THE WEEK GRID HAS NO DECISIONS OF ITS OWN. The load card makes the choice, Coach lays out the days, and the player only edits
   exceptions. In real programming, the order of sessions matters: lifting the morning after hard sparring, intervals the day
   before a strength day. The grid could be a puzzle with a price on each cell. Today it is a display.
4. MAKING WEIGHT ONLY COSTS ENERGY. Water left to refill costs Tank, but not the ability to take a punch. Dehydration lowering
   resistance to being knocked down is the real reason commissions regulate cuts, and it would make water against Cut a real
   trade.
5. SPARRING IS NOT SPECIFIC. Hard, Technical or Body only, plus partner level. No "spar like the opponent" (a partner set to the
   booked opponent's style), which is the heart of a specific block in a real camp. Only the pro's paid outside partner touches
   it, and only for stance.
6. THE TAPER'S PAYOFF IS ONE WORD. "Sharp" means readiness +1 and a fuller Tank. The map rejects a Speed bonus from Sharpen,
   which is fine, but readiness then needs a printed effect on the night in exchanges, or the taper is just "lose fewer points".
7. A VERY DENSE SCREEN. 14 rows, four cards, rules, the strip, 13 days, pad places, weight, what the week buys. The reveal order
   helps, but week 1, Lucy's camp and Ana's mat are still not drawn (the map says so: step 4).

## To reach 10/10 (most important first)
1. Make conditioning win rounds you can see. With F3, Stamina sets (a) the punches thrown per exchange once energy is under 50
   (Combos.energy_scale already shrinks combinations; add output), (b) how much Defence counts once energy is under 40 (the guard
   drops), and (c) a steeper cost: spend_factor 1.4 - 0.8 x Stamina/100, so a 5-point block is about 4 energy by round 3. Recovery
   adds to how fast a fighter gets up from a knockdown (Recovery 60+ beats the count 2 seconds sooner). Pros fade from round 3
   every round (move PROFADE1 out of the small batch). Bar (LINES1): a 5-point Stamina block wins 3+ bouts in 100 in amateur
   3-rounders and 5+ in 6-round pro bouts; print it in exchanges on the bill and on the Stamina row.
2. Run the gate table before the next version and fill its Result column: PACE1, DOSE1, BLOCKORDER1, SEASON1 first. Every
   number drawn on the tab is then a measured one. If BLOCKORDER1 fails, drop the x1.2 as the map plans.
3. Give the week grid its own decisions: SEQUENCE1, a pure rule read inside WeekPlan.week: strength the morning after hard
   sparring or intervals gains x0.8; two hand days back to back already count toward the niggle. The cell turns amber with the
   price and a one-click "swap with Sat" that names what comes back. Coach lays a clean order; the player's changes can break it.
4. Durability pays for water: water over 1.5% of body weight left to refill lowers Durability by 2 for the night (more
   knockdowns), printed on the WEIGHT panel beside the Tank. WATERCUT1 measures water against Cut with both prices in.
5. Specific sparring: on a SPECIFIC block, a club partner can "box like" the booked opponent (style word only). It gives the
   abilities that opponent tests (OppTests) x1.2 from sparring, and opens one tell on the opponent's file at 1 in 3. The map's
   partner level (SPARLEVEL1) stays; a partner of the right style is the pick.
6. Readiness in exchanges: once LEVERS1 runs, "sharp" and PEAK CAMP each print what they win on the night ("sharp: +0.8
   exchanges"), on the strip's bout day and the bill. If FITLEGS1 shows sharp is worth under the cut rule, fold Sharpen into
   Easy as planned.
7. Draw the three missing stills (week 1, Lucy's 6-week camp, Ana's mat week) at 20 px or more, and cut the drawn tab to what
   the week-1 reveal shows. Fix "Mall (2 new)" in the top bar of training_v2.png: it should read "Mail".
8. Give Flexibility its line on the board: "fewer training niggles from 55" (InjuryRoll.flex_mult exists in the code).
9. A season ledger the player can learn from: "Season so far" splits the points by cause (load, base x1.2, response, rules fired,
   fades) and shows the week the season peaked. SEASON1's "you against Coach runs it" prints there once measured.
10. Ana: BJJCLASS1 before any picture. A class kind that moves neither the next open nor weeks to Owned is folded into DRILL.

## Complete?
Not complete. The design is complete as a design: every mechanic has a rule, a hook, a menu and a test, and nothing is left
open. It is not complete as depth: the gate table is all "pending", and the biggest payoff (conditioning on fight night) is,
by the map's own sums, too small to feel.

## My 10/10 drawing
`docs/mockups/s433/critics/tr6_2_0_10.png` (from `tr6_2_0_10.html`): the camp as volume bars and an intensity line peaking
into the bout; a week grid where the order of sessions has a price (Thursday's lift after hard sparring, x0.8, with the swap);
sparring with a partner set to box like the opponent; ON THE NIGHT, what conditioning buys round by round (energy, punches,
the guard, getting up from a knockdown) in exchanges; the weight panel pricing water in both Tank and Durability; and a
measured strip in place of estimates.
