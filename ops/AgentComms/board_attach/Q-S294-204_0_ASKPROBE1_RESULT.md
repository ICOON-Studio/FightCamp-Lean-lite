# ASKPROBE1 result (round 2, ASK2, S442) - is ASK FOR A FIGHT a decision, and for whom?

Written from the runs it quotes. Probe: `tools/ask_probe.gd`, seed **4421**, every bout the game's real bout
(Bouts.fight_step + LiveRound, auto corner). Logs kept outside the repo: `E:\FightCamp\tmp\s442\ask2\` (base.log,
cases_final.log, cases2000.log, pickup.log, spread450.log, gate0.log, gate2000.log, st05.log, st15.log; no SCRIPT ERROR
in any). The cases run twice with the same seed gave the
same tables to the last digit (base.log vs cases_final.log).

Reproduce (Git Bash, through the slot):
`python ops/Tools/godot_slot.py run --who ASK2 -- "$LOCALAPPDATA/Programs/Godot/Godot_v4.7.2-stable_win64.exe" --headless --audio-driver Dummy --path . --script res://tools/ask_probe.gd -- part=all seed=4421`
(levers: `gate=0|450|2000`, `step_teach=0.5|1|1.5`, `gate_rate=0.10`, `pick_down=0`; `part=cases|spread`).

## What was measured

- Population (printed by the probe): Data.lucy() re-rated per fighter (six fight stats shifted to a target power, +-3
  seeded noise each) in the real women's lightweight division (Career.quick_start rivals, Region.rankings with our row in
  it, Region.day_events playing the rivals' club shows over the season). Cases A-G of the map; 60 generated fighters
  (w 0-8, l 0-2, power 52-68, start day 0-42, 1 in 5 walking 0.5-1.6 kg over). No two fighters identical.
- One night per legal name: 100 real bouts a name for the cases, 30 for the 60.
- THE SEASON (the review's design problem): each fighter played 70 days forward under four policies, 100 seasons each
  for the cases, 30 for the 60 (fewer for time: 33,739 real bouts already took 19 minutes), common dice per season:
  - **WAIT**: never ask. The sheet sends the next legal name in turn when Bouts would (10 days after a bout), 2-4 weeks
    out 1 in 3 each, moved by makeable_day for a fighter over the class; accepted at once.
  - **ASK_SHEET** / **ASK_STEP** (else the sheet name) / **ASK_PLAN** (the legal name with the best one-night win %: a
    stand-in for "the name the written plan beats" - it knows the matchup better than a player can). Each asker asks the
    day the ask opens, only when the printed show makes weight (Sim.weigh_forecast); "Weight at risk" = the sheet runs.
  - Stoppage suspensions from InjuryRoll (30 days, 90 for a second inside 90 days) and every bout injury from the
    game's Injuries; what a fight taught (FightLearn.teach) is added to the six stats as it lands.
- Three players scored APART, never summed: **RECORD** = wins - losses in the 70 days; **GROWTH** = rating the fights
  taught; **SAFE** = bouts fought - days out / 14. A picked name: the club gets $450 - gate for the bout, and (a review
  ASSUMPTION the map does not set) gate/450 x 0.10 of each player's unit.
- "Clear" = the best policy beats the second by more than 2 standard errors of the season-by-season difference.

## Cases (gate $450, step teaching x1, 100 seasons a policy) - season means

| Case | start | WAIT R / G / S | ASK_SHEET | ASK_STEP | ASK_PLAN | best RECORD | best GROWTH | best SAFE |
|---|---|---|---|---|---|---|---|---|
| A 1-0 novice | unranked | -1.09 / 1.62 / 1.66 | -0.77 / 1.63 / 1.69 | -0.61 / 1.29 / 1.68 | -0.45 / 1.33 / 1.68 | PLAN, clear | SHEET (= wait) | SHEET (= wait) |
| B 6-1 | 3rd | -0.68 / 1.11 / 1.55 | -0.51 / 1.17 / 1.63 | -0.43 / 1.18 / 1.63 | +0.10 / 0.71 / 1.46 | PLAN, clear | STEP (= wait) | SHEET (= wait) |
| C 2-0, day 40 | unranked | -0.83 / 1.49 / 1.63 | -0.88 / 2.11 / 2.48 | -0.91 / 1.90 / 2.51 | -0.64 / 1.77 / 2.44 | PLAN (= wait) | SHEET, clear | STEP (ask +0.88) |
| D 5-3, morale 35 | 6th | -0.91 / 1.36 / 1.55 | -0.53 / 1.40 / 1.59 | -0.75 / 1.34 / 1.48 | -0.38 / 1.08 / 1.51 | PLAN, clear | SHEET (= wait) | SHEET (= wait) |
| E 6-2 | 4th | -0.86 / 1.27 / 1.54 | -0.91 / 1.41 / 1.74 | -0.83 / 1.38 / 1.75 | -0.26 / 0.78 / 1.57 | PLAN, clear | SHEET (ask +0.15) | STEP (ask +0.21) |
| F 5-2, 1.5 kg over | 6th | -0.64 / 1.47 / 1.80 | -0.77 / 1.51 / 1.81 | -0.67 / 1.25 / 1.67 | -0.34 / 0.98 / 1.73 | PLAN, clear | SHEET (= wait) | SHEET (= wait) |
| G 2-2, a teammate on the first show | unranked | -1.18 / 1.72 / 1.44 | -1.25 / 1.83 / 1.72 | -0.29 / 1.16 / 1.68 | -0.29 / 1.16 / 1.68 | STEP (ask +0.89) | SHEET (= wait) | SHEET (ask +0.28) |

"(= wait)" = the best ask is within 2 SE of WAIT. Bouts in 70 days: WAIT 1.76-1.95, every ask 1.89-1.97, except C (start
day 40): asks 2.8, WAIT 1.95. Nobody in C reaches the nationals' five by day 70 under any policy (0%). ASK_PLAN paid the
gate 1.9 times a season in B and E (club money $9 and $22 against $877). The asker in F waited out the scale every time
(missed weight 0 under every policy). Our fighters lose more than they win in this division (one-night wins 13-55%):
every RECORD is a loss-limiting score.

## The 60 (gate $450, step x1, 30 seasons a policy)

| Player | WAIT | ASK_SHEET | ASK_STEP | ASK_PLAN | no clear best | best ask vs WAIT: ask / wait / even |
|---|---|---|---|---|---|---|
| RECORD | 22 (1 clear) | 5 (0) | 18 (2) | 15 (2) | 55 | 17 / 1 / 42 |
| GROWTH | 16 (0) | 21 (1) | 19 (8) | 4 (0) | 51 | 17 / 0 / 43 |
| SAFE | 24 (2) | 16 (0) | 19 (0) | 1 (0) | 58 | 7 / 2 / 51 |

Pass line: `ASK_PROBE spread ok: no policy wins more than 6 in 10 for any player`.

A second 60 (the spread-only runs draw their 60 after no cases, so a different population; the lever runs below share
it), same prices: RECORD 16 / 5 / 22 / 17 (2+2 clear), GROWTH 21 / 23 / 11 / 5, SAFE 35 / 15 / 10 / 0; no clear best
56 / 48 / 58; best ask vs WAIT: RECORD 17 / 0 / 43, GROWTH 10 / 0 / 50, SAFE 4 / 2 / 54. Same picture.

## The levers (the second 60, 30 seasons a policy; best-policy counts WAIT / SHEET / STEP / PLAN)

| Run | RECORD | GROWTH | SAFE |
|---|---|---|---|
| gate $0 | 15 / 4 / 22 / **19** (PLAN clear 6) | 21 / 22 / 8 / **9** (PLAN clear 7) | 35 / 15 / 10 / 0 |
| gate $450 (the map) | 16 / 5 / 22 / **17** (2) | 21 / 23 / 11 / **5** (3) | 35 / 15 / 10 / 0 |
| gate $2,000 | 22 / 9 / 23 / **6** (0) | 23 / 24 / 12 / **1** (1) | 35 / 15 / 10 / 0 |
| step teach x0.5 | 16 / 5 / 20 / 19 | 25 / 31 / **0** / 4 | 35 / 15 / 10 / 0 |
| step teach x1.0 | 16 / 5 / 22 / 17 | 21 / 23 / **11** / 5 | 35 / 15 / 10 / 0 |
| step teach x1.5 | 16 / 5 / 21 / 18 | 9 / 10 / **39** (25 clear) / 2 | 35 / 15 / 10 / 0 |

Both levers move the answer the way they should and only for the players they should: the gate moves A NAME YOU PICK
(RECORD 19 -> 17 -> 6, GROWTH 9 -> 5 -> 1); step teaching moves A STEP UP for GROWTH only (0 -> 11 -> 39);
SAFE does not move at all (it counts bouts and days out, and neither lever changes either). At x1.5 the probe prints
`ASK_PROBE DOMINANT: GROWTH: ASK_STEP wins 39 of 60` (GROWTH's best ask beats waiting for 32 of 60): the step-up lever is
steep, and x1 (FightLearn's numbers as they are) is the setting that keeps GROWTH a choice. Do not raise it.

## The plain answer

**Is asking better than waiting, and for whom?** Over a 10-week season:
- **SAFE SEASON: no, with one exception.** Asking does not make more bouts: the ask's 14-day lead on a show every 14 days
  lands where the sheet's 2-4 weeks lands (about 2 bouts in 70 days either way). Best ask vs WAIT is even for 51-54 of
  60. The exception is a short clock: C (2-0 from day 40) gets 2.8 bouts asking against 1.95 waiting (+0.88 SAFE), and G
  (a slot lost to a teammate) +0.28. For this player the panel is a decision only near a deadline.
- **GROWTH: sometimes.** Asking (the sheet name or a step up) is never worse than waiting and better for 10-18 of 60
  at step teaching x1 (7 at x0.5; C: +0.62, clear). Which ask depends on step teaching, as above. No single answer.
- **RECORD: yes, and this is where the decision lives.** Choosing the opponent changes the record by +0.3 to +0.8 net
  wins in 10 weeks (cases A, B, D, E, F, clear). Best ask vs WAIT: ask better 16-20 of 60, wait better 0-4. A surprise
  on the real table: the free STEP UP for an unranked novice can be softer than the sheet name (G: Holly 2-1 at 27% vs
  the sheet's Maria 4-2 at 24%, +0.89 RECORD), because the sheet sends names in turn, not by record.

**Does one policy win more than 6 in 10 for a player?** Over the 60 (both populations, at the map's prices and at every
gate): no (the highest is SAFE-WAIT 35 of 60, and 58 of those 60 have no clear best: a tie, not a win). Only step
teaching x1.5 makes one: ASK_STEP for GROWTH, 39 of 60. In the map's seven cases:
**yes, ASK_PLAN for RECORD, 6 of 7 (5 clear)**. Every ranked case can pick a name up to 4 places BELOW (Maria and
Ellie 4-2, 44-55% wins for B, D, E, F) instead of the sheet or step up above (13-32%). The $450 gate does not stop it:
B's picker gave up $868 of $877 in ticket cuts over the season and still came out +0.78 wins ahead of waiting.

## The smallest change that removes it (before / after, the cases, 100 seasons)

| Case | RECORD best, gate $450 (before) | gate $2,000 | picked names only from places ABOVE (pick_down=0), gate $450 |
|---|---|---|---|
| A 1-0 (unranked, no pick) | PLAN* -0.45 | PLAN* -0.45 (no gate paid) | PLAN* -0.45 |
| B 6-1, 3rd | PLAN* +0.10 (1.93 gates) | STEP -0.43 (PLAN -0.57) | PLAN* -0.25 (no legal name above: PLAN = the better of sheet / step) |
| D 5-3, 6th | PLAN* -0.38 | SHEET* -0.53 (PLAN -0.69) | PLAN -0.46 (not clear of SHEET -0.53) |
| E 6-2, 4th | PLAN* -0.26 | STEP -0.83 (PLAN -0.92) | PLAN* -0.59 (better of sheet / step) |
| F 5-2, 6th | PLAN* -0.34 | WAIT -0.64 (PLAN -0.69) | WAIT -0.64 (PLAN = SHEET) |
| ASK_PLAN best for RECORD | 6 of 7 | 2 of 7 (A, C: no gate paid) | 4 of 7, and in B and E it is the free choice between the sheet and the step up |
| over 60 (first population) | 15 | (second 60: 17 -> 6) | 10 |

Two ways, and my reading of the numbers:
1. **A price**: the gate would have to be about **$1,800** (worked from the case margins at the assumed 0.10 of a unit
   per $450: B needs $1,690, D $1,200, E $1,790, F $1,790). That only works through an exchange rate the map never set,
   and $1,800 a bout is an eighth of the club's start cash: it prices the card out rather than balancing it.
2. **A reach rule (recommended, smallest)**: keep $450, and let A NAME YOU PICK reach up to 4 places ABOVE (or level),
   never below. Picking down the ladder is record padding, not the "style the plan beats / film found / a rematch" the
   map sells the $450 for. After it, ASK_PLAN's remaining RECORD lead in B and E is the free choice between the sheet
   name and the step up by matchup - exactly the decision the panel is for - and F's lead is gone. Cost: for B, E and F
   the paid card disappears on the real table (every legal name above is already the sheet or the step up), so the paid
   answer becomes rare for a ranked novice. That needs a design call (see below).

Neither change is made in game code here (AskBout.picks keeps the map's "either side"; the probe's `pick_down=0` is the
what-if).

## What was not measured

- The written plan. ASK_PLAN picks by a 100-bout (cases) / 30-bout (60) one-night win % - an oracle no player has. It
  is the ceiling of "choosing the name"; a real player choosing by style words gets less.
- Mood, cash and members over the season (D's morale 35 is held, not moved by results); the durability ceiling a
  stoppage costs; camps (the probe fights with no camp: an amateur fight week); our own other fighters except G's slot.
- The fight-week lead (AMATEURWEEK1, 7 days): AskBout.MIN_LEAD_DAYS is a constant read by show_day, so C's "three bouts
  short by day 70" was measured only at 14 days (0% reach the five under every policy).
- The gate's exchange rate into the three players (0.10 of a unit per $450) is the review's assumption; the map sets none.
- The 60 at 30 seasons a policy: the SE of a season difference is about 0.25-0.35 units, so most per-fighter calls are
  "even". The cases at 100 seasons are the firmer numbers.
- The game's sheet date comes from String.hash of the offer id (AmateurBooking.lead_weeks). The probe's season ids differ
  by one character and djb2 mixes those badly (100 of 100 seasons drew 4 weeks for one fighter), so the probe draws the
  same 2-4 week range from a seeded generator. In the game the id changes by fighter and day, which mixes well.

## Open design questions (for Claude and the owner)

1. A NAME YOU PICK: below allowed (the map) or above only? Above-only removes the RECORD padding but leaves most ranked
   novices with no paid card on today's table. Alternative: below allowed, but a win over a lower-placed picked name
   earns no ladder move (RankLine would need a rule for it).
2. What does the $450 cost a player in RECORD / GROWTH terms? The probe needs an exchange rate to score the gate; the
   game has none (money is the club's, the record is the fighter's). Until the map names one, every gate result above
   leans on 0.10 of a unit per $450.
3. SAFE SEASON gets almost nothing from asking because the ask's lead (14 days on a 14-day show calendar) equals the
   sheet's. With AMATEURWEEK1's 7-day lead the ask would buy bouts near a deadline (case C) - measure it when
   MIN_LEAD_DAYS moves (show_day reads the constant; the probe would need it as an argument).
4. The free step up for an unranked novice is "the nearest better record" and can be SOFTER than the sheet name (G).
   Keep it (the map's words) or define it by rating?
5. FightLearn's word cut points (0.4 / 0.7) were never set from data: the one-night teach means seen here run 0.47 to
   1.05 (every case answer is "teaches some" or "a lot"); 0.6 / 0.85 would split them. Not changed (FightLearn is not
   this task's file).
6. In this division our re-rated fighters win 13-55% a night and lose more than they win over a season under every
   policy; a stronger population could move RECORD's answers.
