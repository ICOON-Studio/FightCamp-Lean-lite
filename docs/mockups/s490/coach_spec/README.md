# Coach roles and specialties - mockups (S490, COACHSPEC1, review round 1)

Design map: `ops/research/COACHSPEC1_MAP_S490.md`. PROPOSAL screens: nothing here is built, and the map still needs two fresh
critics at depth 7+ before it goes on the owner's board (S425 rule). Balance probe: `probe_coachspec.py` (this folder; pure
Python copy of the game's gain and mastery rules, `python docs/mockups/s490/coach_spec/probe_coachspec.py`).

## What it answers
Owner, S490: "have you consider adding specialties on coaches : Head Coach / Program Director ... Striking Coaches ...
Grappling & Ground Coaches ... MMA / Transition Coaches ... Strength and Conditioning (S&C) & Fitness Coaches ...
sometimes supplemented by mobility or yoga instructors".

Inside today's scope (boxing + one BJJ athlete) the screens show four roles: you (head coach), the boxing coach, the S&C
coach (mobility inside it) and the BJJ coach. Wrestling, Muay Thai and MMA roles are left out on purpose (map section 8).

## Files
- `staff_hire.html` / `.png` - Club > People > Staff. Left: the four role cards (you, the boxing coach, the open S&C slot with
  today's Stamina 48 / Strength 46, the BJJ coach with brown vs black belt). Each card: what the role runs (sun Mornings, moon
  Pads, stool Corner, mat Mat, a word under each), its five area meters with the area word, and its week (you: 4; the boxing
  coach: 2 mornings + 3 pad nights). Middle: the S&C market (two candidates: his days, Stamina and Strength meters against the
  blue tick of today's rating, the lift before -> after, the injury shield needing one mobility morning on his day, wage, HIRE),
  then what one of his mornings does to each fighter. Right: the four hiring routes - coaches' faces, coached mornings as pips
  (gold yours, blue the coach's, teal bars his group days), the pads lift, the weekly bill and the probe's 12-week club points.
- `evening_plan.html` / `.png` - the Training board in the s483 training_k look, with roles on it. S&C DAYS chips (Wed, Sat),
  the COACH row in minutes by face (training_k: 75 min a night split; your 75 on Wednesday), morning tiles tinted by who runs
  them (gold you, blue boxing coach, teal S&C, plain = nobody: the boxing coach's programme), evening tiles with the coin of
  who holds the pads, the WEDNESDAY · PADS choice with both outcomes, COACHES THIS WEEK (each role's slots with faces), HER
  WEEK roles vs today, the coach's note on the mobility trade.

## Every number and its source
Code (real today):
- Coaches: Reid pads 74, bag 64, sparring 58, conditioning (Stamina) 48, strength 46, $450 a week; Hale $1,090, 90 / 84 / 72 /
  66 / pads 58: `scripts/state/Data.gd:33-40`.
- Lift vs no coach: (0.5 + 0.007 r) / 0.6 - 1; pads r x 0.40%: `scripts/rules/CoachAreas.gd:63-71` (Reid +39% / +37%, pads
  +30%; Hale pads +23%).
- Morning gain = 0.2 (`WeekPlan.gd:68`) x intensity (Light 0.6, Normal 1.0, Hard 1.3, `WeekPlan.gd:45-49`) x coach factor
  0.5 + 0.007 r (`TrainingPreview.gd:32-33`) x headroom clamp((pot - stat) / 25, 0.10, 1.25) (`TrainingPreview.gd:28-29`).
- Fighters (test club, `scripts/state/TestClub.gd`): Lucy `Data.gd:60-64` (pot 84, Stamina 61.6, Power 58.4, Speed 63.2,
  Technique 60.1, Fight IQ 59); Kira `:222-225`; Josh `:239-242`. Portraits `scripts/rules/Faces.gd:25-30`.
- Lucy's week: BUILD week (an amateur bout 12 days out is never PEAK, `WeekPhase.gd:51`), focus Stamina, so the coach's build
  week is roadwork N, intervals H, intervals N, speed bag L, roadwork N, strength N, rest (`WeekPhase.gd:28-29`, `FOCUS :35`).
- Her nights: Standard between fights = pads Mon / Wed / Fri, sparring Thu (`PadWeek.gd:49-54`); 75 min a pad night
  (`WeekPlan.gd:57`) = 240 drill units (`PadWeek.gd:38`); sparring shares only to moves at 30+ (`PadWeek.gd:384-394`,
  `Combos.LEARN_AT` 30).
- Move mastery: 2.1 an hour x (1 + 0.40 r / 100) x (1 - m / cap) (`MoveMastery.gd:8,62-79`); her cap 75.8 =
  40 + 0.4 x 60.1 + 0.2 x 59 (`MoveMastery.gd:47-48`). Mon 45 min: 18.5 -> 23.4; Wed you 75 min at 40: -> 30.2; Wed your
  coach 45 min at 74: -> 28.0, Fri 30 min -> 30.7; Fri 30 min after Wed's 30.2: +2.6. Kira's check hook (cap 75.0):
  12 -> 15.7 (30 min) or 21.1 (75 min). Usable 30, Sharp 60 (`MoveMastery.LADDER`).
- Morning tiles (Lucy): Mon roadwork 0.150; Fri roadwork 0.150 (Reid's programme 48); Speed today 0.095.
- S&C staff job $100 a week, injuries -15%: `scripts/rules/StaffRoles.gd:10,18`.
- BJJ coach $170 a week (5 classes x $34), +3.2 a week (owned in 9.4 weeks): `BjjSide.gd:20-22,42-43`, `NoGi.gd:16,19`.
- Coach bills: $620 = $450 + $170; Hale route $1,260 = $1,090 + $170.

Designed, not built (DASHED underline on screen):
- You own 4 coached mornings, a sessional coach 2, a full-time 3; a coached morning x1.25, a group x1.15:
  `scripts/rules/CoachedMornings.gd:14-20` (tests only). The "4 a week", "4 of 4", "2 + 3", "x1.15", Thu speed bag 0.118
  (Reid coaching it) and Speed +0.118 read these.
- The coach's 75 minutes split per fighter (Lucy coach 75, Kira 75, Josh 75; the 45 / 30 slices): the agreed training_k coach
  row (CRITIC_PACK 4.2 "AGREED, NOT BUILT").

New in this proposal (DOTTED underline; all checked by the probe):
- Head coach areas 40, edge area 55 (Old hand -> bag): pads +16%; your coached Tue intervals Hard 0.227.
- You may take a fighter's whole pad night with one of your 4: Wed uppercut 23.4 -> 30.2, the sun pip "-1".
- S&C A (Dev Sandhu): Stamina 66 (+60%), strength 68 (+63%), 2 days, $100 (the wage is code). S&C B (Gemma Marsden): 60 / 60
  (+53%), 4 days, $200. Was 80 / 82 and 72 / 70 in v1; the probe cut them (map section 6).
- On his day (group x1.15): Lucy Stamina 0.198, Power 0.230; per fighter on staff_hire 0.150 -> 0.198 / 0.168 -> 0.230,
  0.187 -> 0.248 / 0.206 -> 0.281, 0.094 -> 0.124 / 0.105 -> 0.144.
- Her week, roles vs today: Stamina +0.725 vs +0.644, Power +0.230 vs +0.168, Speed +0.118 vs +0.095, uppercut Usable Wed vs Fri,
  injury cut off vs on (the cut needs a mobility morning on his day). Mobility Sat costs her -0.230 Power.
- Routes, 12 weeks, club morning stat points (probe): Reid alone 31.4; + S&C A +2.6 ($720 a week with BJJ); + S&C B +3.8 ($820);
  Hale +6.5 ($1,260).
- BJJ black belt: +4.0 a week (x1.25), owned in 7.5 weeks.

Stand-ins (not numbers from the game):
- Top bar date, week, cash ($12,940) and gym name: copied from the s483 training_k mockup.
- Lucy's uppercut 18.5 and Kira's check hook 12 at the start of week 7: picked so the outcomes can be read; every step after
  them is the code's formula.
- The split of the boxing coach's nights (Mon Lucy 45 / Josh 30, Wed Kira 75, Fri Josh 45 / Lucy 30) and which fighters your
  and his coached mornings went to: a worked example.
- Names of the new candidates (Dev Sandhu, Gemma Marsden) and the BJJ coach (Tomas Vieira): invented (grep: no hit in
  scripts/); the code's no-gi coach has no name. Portraits reuse existing headshots (mh_staff_cutman_1, mh_staff_coach_2,
  mh_boxer_08, Reid on mh_boxer_07, Hale on mh_staff_trainer); the BJJ athlete's portrait (mh_boxer_16) is a stand-in.

## Screen rules followed
- Show, don't tell: roles as colour + icon (gold board = you, blue glove = boxing coach, teal kettlebell = S&C, purple belt =
  BJJ); tiles tinted by who runs them; time as slots with faces; outcomes as bars with the Usable 30 line.
- Names only in headers: card headers and the fighter strip carry names; rows, options and the note say you / your coach / her
  and faces.
- Game words: Stamina, Power, Speed, Technique, Fight IQ (`Data.LABEL`, `Data.gd:14`; `CoachedMornings.WORDS`, `:30`).
- One glowing button per screen (CONTINUE); HIRE is a plain button.

## Open questions for the owner (taste only)
1. Role names: sport names ("Boxing coach", "BJJ coach", "S&C coach"), or your wider ones ("Striking", "Grappling")?
2. Tinting each morning tile by who runs it: clear, or too colourful for the training board?
3. Picking the S&C coach's two days for the whole club: a choice you would enjoy every week, or set once and forget?

## Review round 1 (fresh reviewer, 6/10)
Must-fix:
1. "Cardio" on both PNGs -> **Stamina** everywhere (candidate meters, tiles, HER WEEK, fighter rows). The v1 README claimed
   "Cardio" came from `CoachedMornings.gd:28-31`: false, those lines say Stamina (S486 one vocabulary); corrected above.
2. Name collision: "Kerry Walsh" is an opponent (`Data.gd:142,180`): candidate renamed **Gemma Marsden** (no hit in scripts/).
3. Degenerate head coach rating: base 50 -> **40**, edge 65 -> **55**. 40 is under every Reid area (lowest strength 46), so the
   "was" baselines (Reid 48 / 46) are the better of you and Reid; the open slot shows Reid's coin with 48 / 46. Map 3.1 and the
   3.3 table redone.
4. Head coach contradiction: one rule - you run mornings, pads and the corner, never the mat. The head card greys the mat; the
   roles strip ("any session") and the grid are gone; map 3.1 says the same.
5. CoachFit numbers shown as real: CoachFit is dropped from this map (no "10 of 10", "2 of 4", "1 over", "fit -8", "9 of 10"
   left). A second marker added: **dashed = designed, not built** (CoachedMornings, the 75-min split), dotted = new in this
   proposal; legend on both screens.
6. "fit -8 this week": gone. The pick's cost is shown in game words: one of your 4 mornings (gold sun pip, -1) and what the
   other fighter gets (her face, 75 min vs 30 min, check hook 21.1 vs 15.7).
7. The Wednesday outcome: each pick shows the uppercut bar before -> after against the Usable 30 line and the day it becomes
   Usable: you 23.4 -> 30.2, Usable Wed (Thu's sparring then drills it); your coach 23.4 -> 28.0, Usable Fri. The old +20% / +30%
   are replaced by the pads rating each pick uses (40 / 74) and the minutes (75 / 45): a full night at a lower rating beats a
   short one at a higher.
8. Nights now follow PadWeek (pads Mon / Wed / Fri, sparring Thu); "PEAK WEEK" -> **BUILD WEEK** (amateur, 12 days out,
   `WeekPhase.gd:51`); her FIGHT WEEK is next week (Mon 23 - Sat 28), so the strip reads "Club show Sat 28 · 12 days".
9. Meters fail the 2-second test: every area meter now carries its word (Pads, Bag, Sparring, Stamina, Strength) on every
   card, every run icon a word (Mornings, Pads, Corner, Mat); corner redrawn as the corner stool, mat as a tiled mat.
10. 25 px coins with no role difference: morning tiles are tinted by who runs them (gold / blue / teal / plain) and carry a
    38 px coin with the role-colour ring and role badge (board, glove, kettlebell, whistle on sparring).
To 10:
- Reconciled with the existing models (map 3.0): mornings use CoachedMornings, nights use the training_k minutes; the
  evening_plan coach row is redrawn in minutes by face.
- Tell text cut: removed THE ROLES ON THIS BOARD strip, the WHO RUNS WHAT grid, "group mornings: ...", "boxing coach or you
  only ...", "her own mat ...", "the gap between the two picks ...", "Drag a coach coin ...", "Hover any number ...", the
  "her week is on the mat" row (now a mat icon and a dash). What text remains: headers, labels, numbers, the coach's one note.
- The probe ran before any number was shown (map section 6): the $100 S&C at 80 / 82 bought 59% of Hale's extra points for
  16% of his extra money; at 66 / 68 the routes line up (+2.6 at $454 a point, +3.8 at $632, Hale +6.5 at $1,179) and Hale
  stays the most points, with worse pads (+23% vs +30%). Shown on staff_hire's right panel.
Not done: the probe does not yet measure the mobility cut's injury effect, 12-week pad mastery per route, or the BJJ belt.
