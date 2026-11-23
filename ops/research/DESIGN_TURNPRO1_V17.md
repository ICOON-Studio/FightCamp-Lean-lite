# DESIGN TURNPRO1 v17 - turning pro: WHEN and HOW (S542)

The spec is the owner's interview (`ops/research/TURNPRO_INTERVIEW_S541.md`, 15 answers) and the rules with numbers he
approved (`ops/research/TURNPRO17_RULES_S542.md`, Q-S294-320 "Yes, build it"). Nothing is carried from v1-v16 unless the
interview keeps it. v17 is not a patch: the moment is about WHEN the boxer turns pro and HOW the first six pro fights are
picked. The promoter is background: one simple offer. Boxing only, men and women alike; the BJJ fighter keeps its own road.

## 1. WHEN - the offer and "Not yet"

- The offer line stays as built: `scripts/state/Roster.gd` `pro_ready` - 7 wins and top 3 (`PRO_WINS`, `PRO_RANK`), or 9
  wins (`PRO_WINS_ANY_RANK`); a national finalist is called whatever the record. One promoter, one offer, purse $1,500
  (`PRO_PURSE`).
- The pop-up: **Turn pro now** / **Not yet**. It prints the two bouts of fight 1 (safe and risky chance) and the trainer's
  read of those two chances four weeks on (the game's own training read, `TrainingPreview`). Patience shows as 3 marks
  on the boxer's card.
- First "Not yet": one mark gone, hunger -15, the offer returns in 4 weeks (room for about 2 amateur bouts).
- Second "Not yet": the same; the card says it was the last time.
- Third time a RIVAL GYM comes instead: turn pro now, or refuse and the boxer leaves the gym for good.
- REPLACES today's rule in `Roster.decline_pro` / `pro_ready` (each decline +2 wins on the line, `PRO_RETURN_WINS`; terms
  x 0.9, `PRO_SECOND_TERMS`; after two declines only at rank 1). With v17 the line does not move after a "Not yet": the
  offer simply returns 4 weeks later.

## 2. HOW - pro fights 1 to 6, two bouts side by side

| | Chance to win (printed) | Purse | Name (on a win) |
|---|---|---|---|
| SAFE | 75-90% | as today: $1,500, +$500 a win, top $3,000 (`Roster.PRO_PURSE*`) | +1 |
| RISKY | 40-55% | x1.75 (probe-tuned from double: at x2 the risky bout is taken 81% of the time, at x1.5 the safe one 90%) | +3 |

- How the two bouts are made from what the game has: the SAFE man is the promoter's tune-up (`ProLadder.TUNE_READ`
  0.70-0.93, aim `TUNE_AIM` 0.82); the RISKY man is the promoter's step up (`ProLadder.STEP_READ` 0.5). Both are real
  men of a fixed level for the division (rated so the division's middle boxer reads 0.82 and 0.50 at the offer); each
  fight's men are a little better (+0.3 rating a fight, ESTIMATE: records climb). The game's read (`DebutRead.card`, the
  read the pro offer already prints) gives the chance; the matchmaker keeps it inside the band (a better boxer sits high
  in the band, a weaker one low). Then confidence moves it (section 3). The printed number is the number the fight uses.
- After fight 6 the normal booking (`scripts/state/ProLadder.gd`, three offers) takes over.
- Fights are `Matchmaking.NEXT_WEEKS` (8) apart; the debut `Roster.PRO_DEBUT_WEEKS` (4) after signing; a stoppage loss adds
  the game's medical rest (`Matchmaking.STOP_REST_WEEKS`, 8).

## 3. Two bars on the boxer, 0-100

| Bar | Start | Moves | What it does |
|---|---|---|---|
| CONFIDENCE | 50 | safe win +4, risky win +12, points loss -10, knockout loss -30 | moves the win chance: linear, 0 = -5 points, 50 = 0, 100 = +5; never more than 5 either way |
| HUNGER | 70 | safe win -10 (probe-tuned from -8); a risky fight +10 win or lose; each "Not yet" -15; four weeks without a fight -5 (the rest after a stoppage = -10); a safe loss moves nothing | at 0 the boxer asks to leave: a warning at the next booking, a second at the one after, the third booking at 0 = gone (to a rival gym) |

Both bars stop at 0 and 100. The boxer card shows both; the result page says what the fight did to each.

## 4. Numbers and their real-world reasons (all ESTIMATE until the owner plays)

| Number | Value | Why |
|---|---|---|
| Safe band | 75-90% | A debutant's first opponents are "journeymen": in British small-hall boxing most debuts are 4-rounders against a losing-record opponent, won by the home fighter about 9 times in 10 (BoxRec records; the game's own tune-up read is 0.70-0.93). |
| Risky band | 40-55% | A "real test" in fights 2-6 is a 50-50 match with an unbeaten or winning-record man; the game's step up reads 0.5. |
| Risky purse x2, name +3 | | A step-up is a TV/undercard spot: purses for 4-rounders are ~£1,000-2,000; a 6-rounder against a name pays about double; promoters push a prospect who beats a real opponent. |
| Patience 3, 4 weeks | | Amateurs who delay the move are typically waiting a tournament cycle (a month or two); a rival gym/manager approaching an unsigned prospect is how prospects change gyms. |
| Confidence -30 on a KO loss, max 5 points | | A stoppage loss early is the classic "sets him back a year" moment; the effect on the next fight is real but small in the data (managers rebuild with easier fights), so the cap is 5 points. |
| Hunger | 70; -10 a safe win (was -8); +10 a risky fight | Prospects fed too many soft fights "go flat" and change trainers; a real test keeps them motivated. |
| Stoppage share of a loss | 30% (+10% risky, +1% a chin point under 60), 10-60% | About a third of early pro losses are stoppages (4-6 rounders); a harder opponent stops more. |
| Opponents +0.3 a fight | | Records of a prospect's opponents climb through his first year. |

The probe may tune a number (before/after written in section 9); it may not add a rule, a bar on the boxer or a choice.

## 5. Feedback loops

- Confidence -> win chance -> wins -> confidence. Cap: the shift is at most 5 points and the bar stops at 0 and 100. Trial
  check: fight 6's printed chance is within 5 points of the same bout at confidence 50.
- Knockout loss -> confidence -30 -> lower chance -> another loss. Cap: the same 5 points; the probe prints the longest
  losing run.
- Hunger -> leaves. A one-way sink, fed back only by the player's own picks (risky fights raise it). The probe prints hunger
  after each of fights 1-6 per arm.
- Name -> ? In fights 1-6 the name does NOT change the two offers' chances: the safe and risky men are made from the
  boxer's strength against the division's fixed men, never from the name (after fight 6 the normal booking reads the
  rank; that is ProLadder's own path, unchanged).
- Purse -> cash: no rule in this mechanic reads cash back. Cash is printed, never fed in.

## 6. CUT, by file

| What | File | Verdict |
|---|---|---|
| The second promoter house (Bow Lane / Harrow & Finch side by side, who calls by seats) | `scripts/state/ProOfferWire.gd` (make, forecast, waited, offer), `scripts/rules/ProCall.gd` `promoters()`, `who_calls()`, `scripts/state/ProLean.gd` LEAN_KIND / LEAN_WORD | DELETED: one promoter, one offer |
| The five asks and counter-offers (later dates, purse splits, costs, softer opponents, tickets) | `scripts/rules/ProCall.gd` asks (LATER2/4, SPLIT_*, PRICE_*, COSTS_*, SOFTER_*), `ProOfferWire.ask` | DELETED |
| Debutant pick (build / test) | `scripts/rules/DebutPick.gd` | SHRINKS: the debut is fight 1 of the six, safe or risky |
| Favours, home nights, favour title shots | the v15/v16 map rules (never built in scripts/) | DELETED from the design |
| Decline rule (+2 wins, terms x 0.9, rank 1 after two) | `Roster.pro_ready`, `decline_pro`, `PRO_RETURN_WINS`, `PRO_SECOND_TERMS`, `ProCall.SECOND_TERMS` | REPLACED by patience (section 1) |
| The pro road's first offers after the debut | `ProLadder._make_offers` for pro fights 2-6 | REPLACED by the safe / risky pair; from fight 7 unchanged |
| Gym's purse share, name from wins | `Roster.GYM_SHARE`, `StarDeal`, `BoutRules.WIN_REPUTATION` | STAYS as built; no new money rules |
| Pro debut costs, licence, tickets | `ProDebut.gd` | STAYS |

## 7. Menus and what each is wired to (S425)

| Menu | Shows | Wired to |
|---|---|---|
| Pro offer pop-up | the purse; fight 1's safe and risky chance; the trainer's four-weeks-on read; patience marks; Turn pro now / Not yet (the third time: the rival gym's call, Turn pro now / Let the boxer go) | `Roster.pro_ready`, the new patience state on the fighter, `DebutRead.card` for the two chances, `TrainingPreview` for the read |
| Boxer card | patience (3 marks, until pro), CONFIDENCE and HUNGER bars (animated meters), a warning line at hunger 0 | the fighter's `pro17` state |
| Booking screen, pro fights 1-6 | two cards side by side: SAFE and RISKY, each with the opponent, printed chance, purse, name gain, and what a win / loss does to confidence and hunger | the pair builder (ProLadder tune-up and step-up reads), the bars |
| Result page | one line: what the fight did to confidence and hunger | after-fight rule |

Plain game words; names only in headers; no he/she in game text ("the boxer").

## 8. Bars for the probe (written BEFORE any run; never loosened)

Arms: ALWAYS SAFE (turn now, safe x6), ALWAYS RISKY (turn now, risky x6), ALWAYS WAIT (Not yet twice, then safe x6), TURN NOW
+ ALTERNATE (safe, risky, safe, ...), READER (plans on the printed chances, the boxer's chin and the two bars - no hidden
number; it reads the pop-up's four-weeks-on read to decide "Not yet").

- (1) No habit is the best arm in more than 6 of the 10 boxer types.
- (2) The READER beats every habit by more than 2 standard errors in at least 5 of the 10 types.
- (3) Both bouts are alive: the reader takes SAFE in at least 25% and RISKY in at least 25% of all fights 1-6.
- (4) Waiting is a real question: the reader says "Not yet" at least once for at least 2 types, and never for at least 2.
- (5) Mistakes are felt: ALWAYS SAFE or ALWAYS WAIT loses the boxer (20%+ of that type's careers end with the boxer gone) in
  at least 2 types; the reader loses the boxer (20%+) in at most 1 of 10; a knockout loss in pro fights 1-3 lowers the win
  rate of fights 4-6 by at least 2 points and by more than 2 standard errors (same type, same arm, pooled).
- (6) Nothing runs away: confidence never moves the chance more than 5 points; both bars stay inside 0-100.

THE SCORE (one number, written before the run): the boxer's standing after fight 6 (and the booking after it).
Gone = 0. Kept = 10 a pro win - 5 a pro loss + 2 a name point + 0.2 x (confidence - 50) + (after the one-rep trial,
see section 9) 1 a $100 of the gym's purse cut. Printed in parts (kept, wins,
losses, name, confidence, gym cut) so no part hides behind another; the whole purse and hunger are printed apart.

## 9. Probe result (S542)

**PASS, 6 of 6, at risky purse x1.75** (Claude's full-size rerun of the worker's probe, 2,000 careers a cell, 116 s;
`tools/turnprobe17_rules.gd` RISKY_PURSE 1.75; raw: E:/FightCamp/tmp/turnprobe17/x175.txt).
- (1) best arm by type: READER 9, ALTERNATE 1. Among the habits alone ALWAYS SAFE leads in 7 types and ALTERNATE in 3.
- (2) the READER beats every habit by more than 2 standard errors in 7 of 10 types. Size of the edge: +1.2 to +3.7 points on
  a score of about 90-104 (one type -0.1). Reading the two bars is worth about 2-3% - real, not large.
- (3) the READER takes SAFE 35.8% and RISKY 64.2% of fights 1-6.
- (4) the READER says "Not yet" once for 2 types (Reece Doyle, Kai Turner), never for the other 8.
- (5) ALWAYS WAIT loses the boxer in 10 of 10 types; ALWAYS SAFE and the READER in none; a knockout loss in fights 1-3
  lowers the win rate of fights 4-6 by 3.3 points (SE 0.3).
- (6) the confidence shift tops out at 5.0 points; both bars stay inside 0-100.

The worker's first full run, at x1.5, FAILED 4 of 6 (the reader took SAFE 90%; ALWAYS SAFE best for all ten types): its
300-career check of x1.75 read bar 2 as 0 of 10 because the edge (1-4 points) sat inside that sample's error.
KNOWN WEAKNESS, measured: the pick is sensitive to the purse multiple (x1.5 -> 90% safe, x1.75 -> 36 / 64, x2 -> 81% risky).

Tuned by the probe (before -> after): safe-win hunger -8 -> -10; risky purse x2 -> x1.75.
Score fix after the one-rep trial: +1 point per $100 of the gym's purse cut (section 8; the trial converged without it).
Held in reserve, not used (would need the owner's yes): hunger also moving the win chance. Details: `docs/TURNPROBE17_RESULT.md`.
