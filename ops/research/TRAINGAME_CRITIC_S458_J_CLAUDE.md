**AS A GAME: 6/10. DEPTH: 5/10.**

Critic: Claude (fresh, S458). Judged: `docs/mockups/s458/training_j/training_scene_j.png` (source `training_scene_j.html`) beside
`docs/mockups/s457/training_h/profile_training_tab_h.png`; look compared with `docs/mockups/s449/camp_v3/camp_plan_v3.png` and
`assets/ui/moves/*.png`. Read: CRITIC_PACK, CRITIC_ACCESS, the brief. My 10/10: `docs/mockups/s458/training_j/critic_claude_j_10.png`
(source `critic_claude_j_10.html`).

## Numbers I checked against the rules

Checked and correct (within rounding):
- The tiredness curve. I ran WeekPlan's rule myself (87% kept a night, a morning's load = RPE x minutes x intensity / 44, a pad
  night 375/44, sparring 210/44). Starting from 62.5 on Sunday I get 68, 64.6, 70.2, 67.5, 70.0, 63.6, 55.3. The screen shows 68, 65,
  70, 67, 70, 63, 55.
- The coach's Hard ghost peaks at 77.6. The screen says 78.
- First bell 48: the taper week (WeekPhase `taper`, three pad nights, light mornings) run from 55.3 ends at 48.6. The fresh line at 50
  is BoutRules.FRESH_FATIGUE, and "under 50: no energy off" matches `tank_parts`.
- 72 "injury x2 by 76" is InjuryRoll.fatigue_mult. 80 "gains x0.6" is WeekPlan.OVERREACHED / TIRED_GAIN.
- Injury 1.0 in 100 for your week: about 7.5 h x 1.3% per 10 h, x1. 2.7 for the coach's Hard week: more hours, peak 78, x2.5.
- Morning gains are consistent: tile = tray at Normal, and Thursday's Light speed bag is 0.6 x 0.09 = 0.05. The "about 0.1 a morning"
  comes from TrainingPreview via WeekPlan.day (a fifth of a week x coach x headroom).
- "This bout +0.5%, ten weeks +5%": fight_power averages six stats. +0.6 spread over six is +0.1 power, about +0.5% over three rounds
  at ROUND_SPREAD 27.
- "+1.5 a move made ready": BoutRules.WEAPON_EDGE 0.3 for each weapon past BASE_WEAPONS 4 is about +1.6% a bout. The profile's
  "6 by Fri" (4 + 2) agrees.
- "Film 0 to +2": FILM_PER_ANSWER 0.4 is about +2.2%, and it counts only when the plan answers the tell (FilmEdge.answered).
- Monday pads "+9 check hook": MoveMastery.gain with 240 units, pad coach 74, mastery 12 of cap 72 gives 9.07.
- The Friday 60 vs 65 minute numbers rise in line with each other, given the screen's starting value of 24.
- Coach minutes add up: 75+45+65 = 185, 35+30 = 65, 40+10 = 50.
- An amateur weighs in on the day. A taper week has no sparring.

Could not check: today's 50% and the coach's week 52% (they need the opponent's rating); the cap of 72 (needs his Technique and
Fight IQ); the open date for the no-gi fighter; "85% SURE" (no rule exists); cash.

## 1. Logic check

1. **The Friday decision rests on a number the rules do not give.** PadWeek's sparring night shares minutes only among cards already at
   30 or more (`run_week`: `mastery >= Combos.LEARN_AT`). The check hook is about 22 after Monday (+9) and Wednesday (+1), so Thursday's
   sparring adds nothing to it. The Friday panel starts it at 24. From 22, 65 minutes ends at about 28.6, and the full 75 at about 29.6.
   So the check hook is **not Usable this Friday**. The +1.5%, the "READY Fri" bar, the coach's note and TAKE THE ADVICE all lean on it.
2. **The body hook does not add up.** Wednesday's tile gives it +3, from 29 to 32. Thursday's sparring then shares minutes with it (it is
   past 30 by then), so about 34. THIS WEEK BUYS says 29 to 31. The profile tab says 29 to 32.
3. **The Friday deadline is not a deadline.** The fight is Sat 28, and the fight-week column shows three pad nights (Monday 23 is a
   full night for a no-camp amateur). That Monday takes the check hook to about 36 whatever Friday does. 60 vs 65 minutes on Friday
   changes nothing on fight night. The screen's sharpest puzzle is a false one: it counts to Friday when the rules count to the bell.
4. **The coach's week does not match the peak week.** WeekPhase `peak` spars twice (Tuesday and Thursday). Its mornings are Hard
   intervals, the focus session, roadwork, Light slip rope, intervals, Light shadow, rest. The board shows one sparring night, Tuesday
   "was: pads", and base-week mornings with "only 2 changed".
5. **Film outside a camp is a new rule.** `WeekPhase.film_night` gives film only in a camp's Build week, and amateur bouts have no camp
   since S428. A Tuesday film night 12 days out, with no camp, needs a rule first.
6. **Sharing the coach's evening between fighters is agreed but not built.** PadWeek gives each fighter a whole night (240 units). The
   split also needs a load rule. The curve charges Wednesday a full 75-minute pad load (70.2), but the hover says "45 min of pads". A
   45-minute load gives about 66.8. Say what he does for the other 30 minutes.
7. **Sat 21 cannot be a club show.** Data.SHOW_EVERY_DAYS is 14 from day 12, so club shows fall on 31 Jan, 14 Feb and 28 Feb. Sat 21 Feb
   is day 47. Yet the coach row says "IN THE CORNER - club show" and the other fighter's card says fight night Sat 21.
8. **TAKE THE ADVICE does nothing.** The advice is "Fri 65 / 10", and Friday is already 65 / 10 (change 2, "was: 60"). "85% SURE" has no
   rule behind it.
9. **The profile tab disagrees with the scene.** Changed evenings: Tue + Wed on the profile, Tue + Fri in the scene. Check hook: 12 to 32
   vs 12 to 30. Coach's week: 51% vs 52%. Tuesday's tiredness: 64 vs 65.
10. **Words.**
    - "READY" sits beside "Usable at 30". The game's word is Usable (MoveMastery.WORDS), and the rule is one word per concept.
    - The stat names mix the old summary (Power, Technique) with the new attributes (Stamina, Fight IQ, Defence). In Attrs.SESSION_ATTRS,
      heavy bag trains Strength + Explosiveness, shadow trains Footwork + Accuracy, pads train Accuracy + Timing, sparring trains five
      attributes, and a rest morning trains Recovery.
11. **Hidden gains.** Pads also train a stat at a full morning's share (WeekPlan.EVENINGS `pads`), and the screen hides it. That makes
    Tuesday's film look cheaper than it is.
12. **ON FIGHT NIGHT holds two lines that are not fight night:** "Peak this week" and "Training injury, this week".
13. **Rest says "-3 tiredness" on Sunday,** but Sunday's real drop is about 8 (63.6 to 55.3). The 3 is the saving against a session; say
    so, or show the real drop.
14. **Names:** only in the fighter strip and the opponent header. Clean.

## 2. As a game: 6/10

What works:
- The coach-minutes row is the first real club-level decision in training: four fighters, one pad coach, 75 minutes. That is new and
  good. Football Manager splits the coaching load, but it never makes you take a hand off one fighter to give it to another.
- The tiredness curve with its ghost line is readable at a glance.

Five-second test: you see seven days and a tray, and you can guess "drag". The tray's line says it in small grey text.

How you change intensity is the weakest read. L / N / H are 20-pixel pills in the tile corner.

How you choose WHAT goes on a pad night is not on the screen at all. There are no move or combination cards in the tray, only a
"Pads +9 / night" token. That is the game's best-loved part (the Playbook), and here it is invisible.

Too much text:
- The right column says the win chance three times: the headline, the stack, and the YOURS vs COACH'S row.
- The NIGHTS switch, the ghost line and the YOURS vs COACH'S row compare the same two weeks three times.
- The owner asked for little text. This screen has about 110 text items.

Art:
- The ink icons do match the Playbook family: a grey/red figure and a gold arrow. At 52 px in a coloured ring they read as dark blobs.
  The opponent's blue is missing except on pads and sparring.
- Each tile also sits on a dark photo of a gym corner. That is a second picture style under the ink icon, and it adds noise without
  information.
- The camp plan screen uses one big picture per choice. Here every tile carries a picture and none dominates.
- Punch Club's training reads in one second: big icon, one bar. Motorsport Manager's practice screen shows the one thing each choice
  moves.

What I would not defend: I would not defend to the owner the main decision taking three panels and still resting on a wrong number.

## 3. Depth: 5/10

The week is mostly one right plan:
- Work each move up to 30 and stay under 72.
- In the example, Light, Standard and Yours all peak at 70, so tiredness constrains nothing and the switch numbers cannot tell the options apart.
- First-bell tiredness is 48 whatever this week does, because the taper resets it. So this week's tiredness has no fight-night cost
  short of injury.
- Mornings are worth +0.5% and the screen says so. Being honest about it shows the mornings are nearly free choices.
- The only live tension is the other fighter's minutes, and the example makes that free: "jab -0.3, win +0".

The rules hold real trade-offs that the screen does not use:
- Diet and intensity against the scale. WeekPlan burns 1.35x on Hard, and he is 69.6 of 70.0. No tile shows kilograms.
- The twist card (WeekTwist): "The scale will not move" with Cut harder (+2 tiredness a day) vs Trust the process (0.2 kg over).
  That card would push this exact week past 72. It is built and not on the screen.
- FireLevel: a Usable line fires 1 use in 2, a Sharp one 3 in 4. A fighter fighting TOMORROW whose combination sits at 59.5 needs
  15 minutes for Sharp, worth about 2.8 wins in 100 (pack, S427). That is a real Friday dilemma between two fighters, and the rules
  already price it.
- Stamina goal vs injury line: one Normal roadwork on Thursday meets the 60.4 goal, but Friday then peaks at 73 (injury x1.25). A real
  either-or, not shown.

## 4. Missing, useless, the profile tab

Missing, and what each would change:
- **Pad cards** (moves AND combinations, the LEARN ON THE PADS tray) with their mastery rings, dragged onto a fighter's slice of an
  evening. This makes the pad night a Playbook choice, not just a minute count.
- **The horizon to fight night.** Each move's mastery ON THE NIGHT (with the fight week's pads), not "ready Friday". This turns the false
  deadline into the real one.
- **The twist card** with its two answers and their prices on the curve. Built; it changes tiredness, weight, risk and morale.
- **Diet Hold / Cut** as a switch, with the scale forecast beside it. It changes weight on the day and the tank.
- **Kilograms on morning tiles** for a fighter who is cutting. That changes which morning goes Hard.
- **Back to the coach's week** for the whole week. The NIGHTS switch resets only the nights.
- **Plan next week** (WeekPhase weekend planning exists). On Friday or Saturday the fight week is the week to plan.
- **The other fighter's real cost** on a shared night: the tier her move misses, worded as wins in 100 for HER bout.
- **Overflow minutes:** what he does while the coach holds pads for someone else. Bag work, using the existing CARD_STATION heavy-bag
  rate, so the minutes are not wasted. Today's rules have no such split.

Useless or repeated:
- The NIGHTS peak numbers (three of four say 70).
- The YOURS vs COACH'S row, which repeats the headline and the ghost line.
- "Peak this week" and "Training injury" under ON FIGHT NIGHT.
- The photo backgrounds behind the icons.
- "85% SURE".

The profile tab is the right idea: read-only, one button, nothing planned in two places. It must read the same numbers as the scene;
today it does not (point 9). It should also show the mastery on fight night, not "12 to 32", and drop the long explanation box (a design
note, not a screen).

## To reach 10/10

Most important first. These are the changes my score depends on.

1. **Count every gain to the bell, not to Sunday.**
   - Each move shows mastery on fight night, from this week + the fight week's pad nights, using PadWeek.run_week /
     `project` across both weeks.
   - The Friday decision is then judged on fight night. Fix the sparring-share error (cards under 30 get nothing) so the check-hook
     numbers come from `run_week`.
   - Without this, the screen's main puzzle is false.
2. **Make the shared coach a priced trade between two fighters.**
   - The panel for the picked evening shows both sides in the same unit: tier crossed or missed, in wins in 100 for each fighter's own
     bout.
   - Use FireLevel's shares (Usable 1 in 2, Sharp 3 in 4) and WEAPON_EDGE for a new weapon.
   - Example: Friday, 60 / 15 gives the other fighter's 1-2 Sharp for TOMORROW (+2.8) and costs this fighter nothing on his night (the
     check hook is Usable Monday 23 anyway).
   - Needs the new split rule (agreed, not built): minutes by fighter, and what the waiting fighter does. I suggest bag work at
     CARD_STATION's rate, with a full night's load.
3. **Put the pad cards on the board.**
   - Moves and combinations from the Playbook as ink-picture cards, each with a ring to its next tier.
   - Drag them onto the fighter's slice of an evening; the slice shows the picture of the move being drilled.
   - The session tray keeps the mornings only.
4. **Show the levers the rules already have.**
   - This week's twist card with both answers drawn on the curve (e.g. "Cut harder" turns the curve amber past 72).
   - The diet switch with the weigh-in forecast.
   - Kilograms on morning tiles when cutting.
5. **Fix the logic points in section 1.**
   - Sparring twice in a peak week, or say the coach chose once.
   - Film needs a rule outside camp, or show it only with a camp.
   - Move the other fighter's bout to a real show date.
   - The coach's advice must be a change not yet made, and drop "85% SURE".
   - One word: Usable.
   - One stat vocabulary: the Attrs names, with pads' and sparring's stat gains shown.
6. **Cut the repeats.**
   - One win number, with its parts on hover.
   - One coach comparison (the ghost line), and a NIGHTS switch with no numbers.
   - ON FIGHT NIGHT holds only fight-night facts: weight on the day, the tank at the first bell, moves Usable, tells answered, the goal.
7. **Art.**
   - Drop the photo backgrounds; give each morning tile one large ink icon (80-90 px) on paper or dark ground.
   - The intensity choice as three big ticks under the icon.
   - Pad nights show the Playbook move picture (red vs blue, gold arrow) of the move on them, so the evening row looks like the Playbook.
8. **Let the curve bite.**
   - When a plan crosses 72, the curve turns amber from that day, and the tiles that put it there get a small mark.
   - When it would carry over 50 into fight night, the first-bell number shows the energy it costs (BoutRules.tank_parts).
9. **The profile tab reads the same numbers as the scene.** Mastery on fight night, the same changed evenings, the same win chance. Cut
   the explanation box.
10. **Week to week.** "Plan next week" from Friday on, and "Keep this week" for the next one when the phase repeats (WeekPhase.keep_ahead).

## My 10/10, panel by panel (`docs/mockups/s458/training_j/critic_claude_j_10.png`)

- **Top bar:** same as J (gym, Gym floor, date, cash, CONTINUE).
- **Fighter strip:** four cards. Each shows the next event and days, the kind of week, a mini coach-minutes bar, and one flag for what
  needs a decision ("Friday split", "Fights tomorrow", "Cut stalled").
- **The board, two weeks:**
  - This week and the fight week, side by side. The fight week is compressed but editable, so every number counts to the bell.
  - COACH row: shared bars.
  - MORNING row: one big ink icon per day, one number, three intensity ticks, kilograms when cutting.
  - EVENING row: the fighter's slice of the night shows the Playbook picture of the move on it, the minutes, and a ring to Usable or
    Sharp.
  - TIREDNESS: the curve runs across both weeks to the first bell. Zones (fresh, 72, 80) colour the curve itself. The coach's week is a
    grey ghost. The twist card's answer is drawn as a dashed branch.
- **Bottom tray:**
  - Mornings, as large ink icons.
  - PAD CARDS: moves and combinations from the Playbook, each with its mastery ring and its tier on fight night.
  - THIS WEEK'S CARD: the twist card, with both answers and their prices.
- **Assumptions my drawing makes:**
  - The other fighter's Sat 21 bout is an AWAY show (another club's card). The game has no such event yet, so it needs a rule, or the
    bout moves to a real show date.
  - The fighter waiting during a split night does bag work, so the curve charges a full night's load.
  - Film outside a camp is kept as in J, and needs the rule in section 1 point 5.
  - The check hook picture is the Playbook's lead hook (the check hook has no picture of its own).
- **Right column:**
  - TO WIN: one number, parts on hover.
  - FRIDAY, ONE COACH: the trade in the same unit for both fighters (wins in 100 for each one's own bout) with the split slider.
  - ON FIGHT NIGHT: only fight-night facts, with the diet switch inline.
  - The coach's note, suggesting a change not yet made, with its price, and DO IT.
