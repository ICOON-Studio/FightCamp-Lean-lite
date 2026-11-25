# DESIGN_STYLEPLACE1 - opponents that fight in different places (S551, written BEFORE any run)

Task: `ops/research/TASK_STYLEPLACE1.md`; scope (the spec): `ops/research/STYLEPLACE_SCOPE_S551.md`. Probe only: nothing under
scripts/ or tests/ changes. Tools: `tools/styleplace1_probe.gd` (extends PLANIMPACT2's probe), `tools/styleplace1_rules.gd`
(the switches), `tools/styleplace1_sum.py`. Runs: `E:/FightCamp/tmp/styleplace1/`.

METHOD followed: probe first (owner S534); the written plan stays and must matter (Q-328, Q-333); NO third plan-rule probe (this
changes how OPPONENTS fight - PLANIMPACT2's rule stays at strength 0 in every arm); the corner command grade is COACHMAP2's and is
not touched; control first; each lever follows real bouts, named below before any run; full and half strength only, no tuning.
Study each lever follows: lever 1 and 2 follow `REALPLANS_S341.md` (14 documented plans, s3 "Comparison") and
`CARDBOX1_JOHN_BRIEF_JOHN.md` (Fury-Wilder II CompuTrack); lever 3 follows `DESIGN_KNOW_STAKES1_V9.md` / MODETELLS1 (what one film shows).

## 1. The code each lever has to switch (read, S551)
| Table / line | What it does today | Lever |
|---|---|---|
| `PlanFight.GAME_CARD` l.25 | the card the next exchange is fought on after she LOSES an exchange to a game (or the round opener, `LiveRound` l.228); keyed by game only: press/loadup -> mid, range -> long, counter -> outside | 1 (per style) |
| `PlanFight.LOST_CARD` l.28 | losing to press or loadup leaves her on her own ropes, every style | 1 (per style) |
| `PlanFight.where_next` l.164 | won: the card her move goes to; lost: LOST_CARD, else GAME_CARD. Read by `RingDuel` l.388 every exchange and by `PlanChain` l.43 (the read) | 1 (hook) |
| `PlanFight.ANSWERS` l.50 (via `fit` l.97) | best / ok / wrong of each move per game; press and loadup share 4 of 5 best moves (step_back, slip 2-3, roll_out, 1-1) | 2 |
| `CoachPlan.cards` l.37 | the coach's (and K2's, and the paper's) cards of a style = GAME_CARD + LOST_CARD x 0.5 over the style's mix | follows 1 |
| `OppFile.main_game` l.112, the "style" row l.84 | the file says her game ("walks you down"), never her place | 3 |
| `ModeTells.shown` / `FilmBout.mode_counts` | what one film shows of her games | 3 (measure) |
Other readers that follow the swapped tables with no edit of theirs: `PlanChain` l.29/82/118, `PlanFile` l.60, `PlanLines` l.111,
`GuardNotes` l.16 (ropes wear keys on LOST_CARD), `CoachReadWire` l.36, `TapeClips` l.301/351, `FightWhy` l.223, `StepWire` l.47 (fit),
`LiveRound` l.228/243/374. `Exchanges.STYLE_MODES` (the mix) is NOT changed: a style plays the same games as today, only where.

How the probe switches them (no game file edited): at start the probe reloads `PlanFight.gd` in memory from its own source with
GAME_CARD / LOST_CARD / ANSWERS as static vars and two hooks (`where_next` and `fit` ask `styleplace1_rules.gd` when a hook is
set), then reloads every script above in memory so none keeps a compiled-in copy of the old tables. With every lever off the hooks
return exactly today's tables; the control proves it bout for bout.

## 2. The levers (each with its real-bout reason)
### Lever 1 - a style owns a place
| Style (probe cell) | Change (GAME = where her game puts the fight; LOST = where losing to it leaves your boxer) | Real-bout reason |
|---|---|---|
| Pressure fighter (presser) | press: GAME own_ropes (today mid); LOST own_ropes (as today) | She cuts the ring off at once: Foreman v Ali (B1, "cut the ring off"), Serrano trapped Taylor in a corner rd 5 (B12), Cameron put Taylor on the ropes rd 2 (B14) |
| Slugger (loader) | loadup: GAME inside, LOST inside (today mid / own_ropes) | The press+loadup slugger loads up in the pocket: Tyson dips and loads the hook, Holyfield answered by clinching (B4); Ruiz "wins inside exchanges" (B7); REALPLANS s3: "loads up in the pocket -> slip/roll", tie up "best when inside" (Fury, Ali, Holyfield) |
| Out-boxer (mover) | counter: GAME long (today outside); loadup: GAME long, no LOST (today mid / own_ropes) | She counters at the end of her jab, not from outside it: Taylor as Moore read her, "speed, footwork, distance ... drops counters" (B13); a range boxer loads up at range: Wilder "needs distance" (B8), CompuTrack "From Distance 63.7%" (John brief) |
| Boxer-puncher (slow, body, switch, favourite, underdog) | loadup: GAME long, no LOST (today mid / own_ropes) | Range + loadup is the Wilder shape (B8, range .35 / loadup .25 in STYLE_MODES); REALPLANS s3: "loads up at range -> step in" |
| Counter-puncher (counter) | none - she already owns outside | Lomachenko waits (B9), Ochigava invites her on (B11): today's table is the real one |
| Volume puncher (fader) | none - mid range | No documented plan moves her; she outworks at hook range (today) |
Result: the six probe styles' main places become own_ropes, inside, long, long, outside, mid (today: mid, mid, long, long, outside, mid).
Half strength: on each exchange a seeded coin (bout, exchange index) takes the style's place half the time and today's the other half.

### Lever 2 - press and load-up stop sharing their answers
| Row | best | ok | wrong (unchanged) |
|---|---|---|---|
| press (today best step_back, pivot_out, slip 2-3, roll_out, 1-1) | step_back, pivot_out, 1-1 | slip 2-3, roll_out, tie_up, push_off, 1-2, 3b-3, 1-2-3b | step_in, 1-2-3-2, cut_off, herd |
| loadup (today best slip 2-3, roll_out, step_back, 1-1, tie_up) | slip 2-3, roll_out, tie_up, 1-2 | step_back, 1-1, pivot_out, step_in | 3b-3, 1-6-3, 1-2-3b |
Real-bout reasons (REALPLANS s3 counts): against a presser five plans jab, step back and turn her (Leonard-Hagler B3, Joshua-Ruiz II
B7, Mayweather-Canelo B6, Steward's plan for Hearns B2, Enamait's for Taylor-Serrano B12: `{1-1, press}`, `{step_back, press}`,
`{pivot_out, press}`); slip 2-3 against a presser is one plan (Pacquiao-Hatton B5), so it drops to ok. Against a loader the plans take
the shot away and counter inside it: slip and counter (Pacquiao B5, Mayweather B6, Ali off the ropes B1), the straight right inside the
wide one (Mayweather's lead right B6, Holyfield's counters as Tyson loaded B4 -> 1-2 best), roll under, and lean/hold (Fury B8, Ali B1,
Holyfield B4 -> tie_up best). Stepping back from a loader is only Joshua-Ruiz II, whose opponent pressed as well (ok); the double jab
answers a loader at range only (ok). After the split no move is best against both, and each card holds a different best line:
mid step_back v slip 2-3, inside (none) v tie_up / roll_out, own_ropes pivot_out v slip 2-3@own_ropes / tie_up@own_ropes, long 1-1 v 1-2.
Half strength: the same seeded coin per exchange uses the split rows half the time, today's the other half (a plan read uses the split).

### Lever 3 - the file says where she fights
The file's style row gets one plain line: her main game and her MAIN PLACE (the top card of `CoachPlan.cards` under lever 1), e.g.
"loads up big shots - chest to chest". Measured with no bouts: for each style, 200 seeded one-film nights (`FilmBout.build`, the
game's film model; its `mode_counts` are the film's games); the scout's line names the place of the game the film shows most
(ties: ModeTells.MODES order, the game's own tie rule). Right = that place equals the style's main place. Also printed:
`ModeTells.shown(mix, 1)` (the game's deterministic one-film reading).

## 3. Arms, population, dice
- Configs (one Godot process each, because `BoutRead` caches reads by stat bucket): off, L1, L1h (half), L2, L2h, L12 (1+2 full).
  "All on" = L12 + lever 3 (lever 3 changes no bout).
- CB (five women: Lucy Jackson, Samira Khan, Tess Reilly, Cara Bello, Jade Yates; CORNERCMD2's ten cells; reader corner; 3 rounds;
  dice day 70000 + 7k): arms reader:none, reader:coach, reader:C (re-picked for the config by PLANIMPACT1's read greedy, one per
  boxer x style), reader:K2 (PLANIMPACT2's corner plan, written from `CoachPlan.cards`, so it follows the config), reader:E (careless).
  n = 40. Control arms (config off): reader:none / coach / C0 (the frozen PLANIMPACT1 plans P2 used) / K2 / E, compared with
  `E:/FightCamp/tmp/planimpact2/full_L3.jsonl` bout for bout.
- Bar 5 arm: reader:none with n = 200 on every config (so a 3-win change can be told from noise).
- Cross (bar 3): C@sj and K2@sj (each style's plan) against the six single-style cells, n = 40.
- PW (the ten TELLPLAY1 types, corner off, the plain bout `BoutNight.play_out`, 4 rounds, dice 50000 + 7k, 3 files a style):
  A (no coach, no plan), B58 (the coach's plan), C (re-picked), E (careless); n = 20. Bars read as 6 of 10 types.

## 4. Bars (the scope's, unchanged; how each is read, fixed before the run)
1. best - careless >= 6 wins in 100 for 3 of 5 boxers (best = the higher of C and K2 per boxer, PLANIMPACT2's reading).
2. best - coach >= 6 for 3 of 5.
3. No single plan is best against more than 3 of 6 styles, for 3 of 5 boxers (cross play; plans with the same lines count as one).
4. careless - coach <= -3 over all.
5. With no plan (reader:none, n 200), each boxer x cell within 3 of the control - a cell fails when its change is beyond 3 AND beyond
   its own 2 SE; and no cell goes under 25 or over 85 that was not already there. A lever that fails bar 5 is DROPPED, not tuned.
6. Each of the six places (mid, long, outside, inside, own_ropes, opp_ropes) holds >= 5% of all exchanges over the ten cells; for
   each style the mean (over bouts) share of its single most-fought place is <= 70%.
7. Per style, the one-film line names the right place in >= 80% of films (4 of 5), for every style.
8. Per boxer, the distinct plans (C, as sets of lines) a reader of the file writes over the six styles: target >= 3; today's answer 1.
   Where bar 7 misreads a style the player writes the plan of the misread style.

## 5. Feedback loops (from the scope; printed every run)
- Ropes: share of exchanges on own_ropes per style; STOP if any style passes 50% (GuardNotes' wear cap is the cap in the game).
- Inside: inside share per round; STOP if it climbs every round in more than half the bouts of a style.
- Styles do not learn: confirmed in code - `Exchanges.next_mode` (l.279-308) rolls from STYLE_MODES x the bout's fixed mode_bias
  (RingDuel.mode_bias, cached once a bout in bout.mode_bias) x PlaceEdge/StepWrong per exchange; nothing writes the opponent's style
  or mix from a result. The plan cannot feed back into her style.
- One-rep trial first: one boxer (Lucy Jackson), two styles (presser, loader), 40 bouts, all configs: STOP if two configs print the
  same bouts (a switch not wired) or the control differs from PLANIMPACT2.

## 6. Phase 0 paper (no bouts; run after the page above was committed, before any bout)

Run: `stage=paper` (no bouts), `E:/FightCamp/tmp/styleplace1/paper.jsonl`. A style's lines = on each card `CoachPlan.cards(style)`
lists, the moves out of that card that are a BEST answer to the game she brings there most (the coach's own rule). "Best plan" = the
lines on her top 3 cards (the coach reads at most two; a gym plan holds 3-4). The number = the share of X's best-plan lines that are
also best lines against Y, averaged over the 30 pairs. Per boxer = only the lines that boxer fires (PLANIMPACT2's fire test).
| Config | all lines on every card | best plan (top 3 cards), generic | best plan, the 12 boxers' own lines | top 4 cards, own lines |
|---|---|---|---|---|
| off (today) | 0.94 | 0.94 | 0.83 | 0.94 |
| L1 a style owns a place | 0.94 | 0.92 | 0.81 | 0.89 |
| L2 press / load-up split | 0.83 | 0.79 | 0.77 | 0.91 |
| L12 both | 0.89 | 0.81 | 0.78 | 0.87 |
Best plan (top 3 cards), generic, L12 - the rows that move are the two styles the levers gave their own place:
| X \ Y | Pres | Ctr | Vol | BxP | Out | Slug |
|---|---|---|---|---|---|---|
| Pres | 1.00 | 0.75 | 0.75 | 0.75 | 0.25 | 0.75 |
| Ctr | 0.86 | 1.00 | 1.00 | 1.00 | 0.71 | 1.00 |
| Vol | 0.83 | 1.00 | 1.00 | 1.00 | 1.00 | 1.00 |
| BxP | 0.86 | 1.00 | 1.00 | 1.00 | 0.71 | 1.00 |
| Out | 0.83 | 1.00 | 1.00 | 1.00 | 1.00 | 1.00 |
| Slug | 0.25 | 0.50 | 0.50 | 0.50 | 0.50 | 1.00 |
Reading, before any bout:
- The table moves (0.94 -> 0.79-0.81), so the stop rule ("no lever moves the table") does not trigger and the bout run goes ahead.
- Lever 1 ALONE barely moves it (0.94 -> 0.92). A style's own place adds one card, but every style still plays range at long and
  counter outside (STYLE_MODES is unchanged), and losing to press still puts every presser's opponent on her ropes, so most of a
  best plan (long: 1-2 / 1-2-3b / 2-3 / cut_off; own_ropes: pivot_out) stays best against everyone. Expect lever 1 to fail bar 3.
- Lever 2 moves it most, and only between the press styles (Pressure, Counter, Volume) and the load-up styles (Boxer-puncher,
  Out-boxer, Slugger): two groups, not six. Within a group the share stays 1.00. Expect at most two plans, i.e. bar 3 (no plan
  best against more than 3 of 6) is borderline at best, bar 8 (3 or more plans) at risk.
- With both, the Pressure fighter (own ropes) and the Slugger (inside) get plans of their own; the other four still share theirs.
- The per-boxer numbers move less: a boxer whose few firing lines are all on long (Jade: 1-2, 1-2-3b, cut_off) has the same plan
  against everyone whatever the opponent does, because long is range for every style.
