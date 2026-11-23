# DESIGN TURNPRO1 v18 - turning pro: WHEN, HOW, and the matchup that decides (S543)

One clean map, not a diff. The spec is the owner's interview (`ops/research/TURNPRO_INTERVIEW_S541.md`) and the rules the owner
approved for v17 (`ops/research/TURNPRO17_RULES_S542.md`, Q-S294-320 "Yes, build it"). v18 is one round on top of v17 (task
`ops/research/TASK_TURNPRO18.md`): the owner's shape stays (WHEN: the offer, Not yet, three patience marks, the rival gym; HOW:
pro fights 1-6, two bouts side by side; two bars on the boxer, CONFIDENCE and HUNGER, 0-100). Nothing else of v1-v16 returns.
Boxing only, men and women alike, each against their own sex and weight class.

**Status: STOPPED at rule 1's measure-first gate (section 9).** The game's read does not let the plan line decide the
matchup today; no career was run and no critic brief was written. The rest of this map is the design as briefed, kept
whole so the coordinator can pick it up after the next step.

## 1. WHEN - the offer and "Not yet"

- The offer line stays as built: `scripts/state/Roster.gd:186-196` `pro_ready` - 7 wins and top 3, or 9 wins. A national
  finalist is called whatever the record (the old "only with 0 declines" condition, `Roster.gd:189`, goes with the declines).
- The pop-up: **Turn pro now** / **Not yet**. It prints fight 1's two bouts (the tune-up's and the step up's chance) and
  the same two chances four weeks on: four weeks of the boxer's current training focus (`TrainingPreview.plan_gain`, the
  gym coach's rating) fed into the same read. Patience shows as 3 marks on the boxer card.
- First "Not yet": one mark, hunger -15, the offer returns in 4 weeks. Second: the same; the card says it was the last.
  Third time the RIVAL GYM calls: turn pro now, or the boxer leaves the gym.
- "Not yet" costs a mark and hunger ONLY. Today's decline also moves morale (`ProOfferWire.apply_morale`, `Roster.gd:330`),
  loyalty (`Loyalty.apply(f, "decline_pro")` -8, `Roster.gd:331`, `Loyalty.gd:61`) and shuts the door at 3 declines
  (`Roster.gd:187`): those three go.
- During a live nationals run (`scripts/state/Champs.gd:26` `active`) "Not yet" costs no mark and no hunger: the offer waits for
  the final.

## 2. HOW - pro fights 1-6: a TUNE-UP and a STEP UP side by side

| | Where the promoter aims (usual plan) | Purse | Name on a win |
|---|---|---|---|
| TUNE-UP | `ProLadder.TUNE_AIM` 0.82 inside `TUNE_READ` 0.70-0.93 (v17 band 75-90%) | as today: $1,500, +$500 a win, top $3,000 | +1 |
| STEP UP | `ProLadder.STEP_READ` 0.50 (v17 band 40-55%) | x1.75 | +3 |

- THE MATCHUP DECIDES. Each bout is a real opponent with a style, a best weapon (public tape, `ProLadder.PUBLIC_TAPE`) and
  one weakness (a journeyman's file is open: many fights on tape). The two men come from a pair builder over the
  division's unranked pool by rating (new: `ProLadder._make_offers`, `ProLadder.gd:175-216`, needs a ranked name inside the
  band, which an unranked debutant often lacks). No man inside the step-up band = the card shows the tune-up only, with
  the reason.
- The PRINTED chance is the game's own read of THIS boxer with THIS plan against THIS opponent (`DebutRead.card`'s steps:
  `DebutOpp.make` -> `BoutRead.round_edges` -> `CardOdds.result`), not squeezed into a band. A plan line that answers the
  opponent's tell moves the number; a line that walks into the weapon lowers it. The card says why in one line ("The plan
  answers the body hook: +6"). The printed number is the number the fight uses.
- The card's bar line: "Confidence 66: +1.6 -> 84%" (section 3).
- Fights 1-6 are a fixed 8 weeks apart (`Matchmaking.NEXT_WEEKS`; `QUICK_WEEKS` / `HARD_WEEKS`, `Matchmaking.gd:32-33`, apply only
  from fight 7). The debut is `Roster.PRO_DEBUT_WEEKS` (4) after signing; a stoppage loss adds the medical rest
  (`Matchmaking.STOP_REST_WEEKS`, 8).
- THE NAME PAYS AFTER FIGHT 6. Name from the six fights (tune-up win +1, step up win +3, 0-18) sets where the normal booking
  starts: under 6 = unranked reach as today (`Matchmaking.UNRANKED_REACH` 15); 6-11 = offers reach five places higher (#10);
  12 or more = the boxer enters the board's bottom seat (as `ProLadder.REVIEW_WINS`) with a step up on the first card
  (`BAND_UP` 5 places up). The name never changes a fight 1-6 offer.
- After fight 6, one page: the record, the name and where the booking now starts, both bars. Then the normal booking
  (`ProLadder._make_offers`, three offers) unchanged.

## 3. The two bars on the boxer, 0-100 (both stop at 0 and 100)

| Bar | Start | Moves | What it does |
|---|---|---|---|
| CONFIDENCE | 50 | tune-up win +4, step up win +12, points loss -10, knockout loss -40 to -20 by the confidence trait (linear: trait 35 or less -40, 65 or more -20) | moves the chance: linear, 0 = -5 points, 50 = 0, 100 = +5 |
| HUNGER | 70 | by ambition (`Recruit.ambition`: potential 78+ chases a title): title chaser tune-up win -14, step up +12 (win or lose); steady boxer -6 / +8. A tune-up loss moves nothing. Only EXTRA weeks cost: -5 a full four weeks (the medical rest after a stoppage = -10); each "Not yet" -15 | at 0 the boxer asks to leave: a warning at the next booking, a second at the one after, the third booking at 0 = gone. IN THE RING (the rule held back in v17; a SWITCH in the probe): hunger 20 or less -3 points (a flat boxer), 90 or more +2 |

Confidence and hunger share ONE cap: together never more than 5 points either way. On screen the trait keeps its own
words (Fragile, Confident: `Recruit.gd:30,36`); only the bar is called CONFIDENCE.

## 4. Numbers and their real-world reasons (all ESTIMATE until the owner plays)

| Number | Value | Why |
|---|---|---|
| Tune-up / step-up aim | 0.82 / 0.50 | The game's own promoter reads (`ProLadder.TUNE_AIM`, `STEP_READ`); British small-hall debuts against losing-record journeymen are won about 9 in 10 (BoxRec; v17 map). |
| Step-up purse | x1.75 | v17's probe-tuned value (S542); a 6-round test pays about double a 4-rounder (v17 map). |
| Hunger by ambition | -14 / +12 (title), -6 / +8 (steady) | A title-chasing prospect fed soft fights "goes flat" and looks for a new team; a boxer who wants a steady record is content earning (manager practice: keep a hungry prospect busy with real fights). |
| Knockout hit by trait | -40 to -20 | A stoppage early in a career "sets a boxer back a year" for some and not others; the game already names the difference (Fragile / Confident, `Recruit.gd`). |
| Hunger in the ring | -3 at 20 or less, +2 at 90 or more, inside one 5-point cap with confidence | "The prospect went flat": real but small next to skill; the cap keeps the bars from deciding fights. |
| Name tiers | 6 / 12 | 6 = six tune-up wins; 12 needs at least three step-up wins. Five places = `Matchmaking.BAND_UP`. |
| What a tier is worth | the gym's real cut of the first normal card's best purse (`Matchmaking.pay_of`) | tier 0 $2,400 (v #15), tier 1 $3,150 (v #10, 8 rounds), tier 2 $2,800 (#20 v #15, 6 rounds): at the 25% cut 6.0 / 7.9 / 7.0 points. |
| Fight gap | 8 weeks fixed, free | A pro camp is 6-8 weeks (`assets/data/world/SOURCES.md`, quoted at `Matchmaking.gd:27`); boards suspend a stopped boxer 28 days or more (`Matchmaking.gd:30`). |

The probe may tune a number (before -> after in section 9); it may not add a rule, a bar on the boxer or a choice.

## 5. Feedback loops

- Plan -> chance: one way (the plan is the player's; nothing here writes it back). Cap: the largest shift a line makes for
  any type is printed; over 10 points = stop. MEASURED: 14.5 points (the fade answer), over the cap.
- Confidence -> chance -> wins -> confidence, and knockout loss -> confidence -> chance -> loss: the shared 5-point cap;
  the bar stops at 0 and 100. Trial check (not reached): fight 6's printed chance within 5 points of the same bout with
  both bars neutral; the longest losing run printed.
- Hunger -> chance (new): tune-up wins lower hunger -> a flat boxer (-3) -> a loss, and a tune-up loss moves nothing, so it
  stops itself; step ups raise hunger -> +2 -> more wins. Cap: +2 at most, inside the shared 5; the bar stops at 100.
- Hunger -> leaves: a one-way sink fed back only by the player's picks. Ambition only scales the steps (a fixed trait).
- Name -> where the booking starts: read only after fight 6; it never changes a fight 1-6 offer.
- Four more weeks -> stats -> chance: one way; "Not yet" is capped by the three marks.
- Purse -> cash: no rule here reads cash back.

## 6. CUT, by file (read from today's tree)

| What | File and line | Verdict |
|---|---|---|
| The second promoter house (who calls by seats, two houses side by side) | `scripts/state/ProOfferWire.gd:25` make, `:201` waited; `scripts/rules/ProCall.gd` promoters / who_calls; `scripts/state/ProLean.gd` LEAN_KIND / LEAN_WORD; `Roster.gd:42` PROMOTERS | DELETED: one promoter, one offer |
| The asks and counter-offers | `scripts/rules/ProCall.gd` asks; `ProOfferWire.ask` | DELETED |
| Debutant pick | `scripts/rules/DebutPick.gd` | SHRINKS: the debut is fight 1 of the six |
| Favours, home nights, favour title shots | the v15/v16 map rules (never built) | DELETED from the design |
| Decline rule: +2 wins, terms x 0.9, rank 1 after two, the door at three | `Roster.gd:38` PRO_RETURN_WINS, `:41` PRO_SECOND_TERMS, `:186-196` pro_ready, `:187` the door | REPLACED by patience (section 1) |
| The decline's morale and loyalty | `Roster.gd:330` `ProOfferWire.apply_morale` (`ProOfferWire.gd:173`), `Roster.gd:331` `Loyalty.apply("decline_pro")` (`Loyalty.gd:61` -8) | DELETED: "Not yet" costs a mark and hunger only |
| The national-finalist call only with 0 declines | `Roster.gd:189` | the condition goes; a finalist is called whatever the record |
| The pro road's first offers | `ProLadder._make_offers` (`ProLadder.gd:175-216`) for fights 2-6 | REPLACED by the pair builder; from fight 7 unchanged, its start set by the name tier |
| The night's gap by the fight | `Matchmaking.next_weeks` (`Matchmaking.gd:283-285`) for fights 1-6 | fixed 8 weeks; from fight 7 unchanged |
| Gym's purse share | `Roster.signing_share` (`Roster.gd:223-224`), `Loyalty.pro_share` (`Loyalty.gd:230-233`: 10% under loyalty 50) | STAYS; the score reads the real share |
| Pro debut costs, licence, tickets | `ProDebut.gd` | STAYS |

## 7. Menus and what each is wired to (S425)

| Menu | Shows | Wired to |
|---|---|---|
| Pro offer pop-up | the purse; fight 1's tune-up and step-up chance now and four weeks on; patience marks; Turn pro now / Not yet (third time: the rival gym's call, Turn pro now / Let the boxer go); during nationals "the offer waits for the final" | `Roster.pro_ready`, patience on the fighter, the pair builder, the read (`DebutRead` steps), `TrainingPreview.plan_gain`, `Champs.active` |
| Boxer card | patience (3 marks, until pro), CONFIDENCE and HUNGER (animated meters), the trait word (Fragile / Confident), the ambition, a warning line at hunger 0 | the fighter's v18 state, `Recruit` |
| Booking, pro fights 1-6 | two cards: TUNE-UP and STEP UP; each the opponent (style, weapon, weakness), the printed chance, the plan line's why ("The plan answers the body hook: +6"), the bar line ("Confidence 66: +1.6 -> 84%"), purse, name on a win, what a win / loss does to both bars | the pair builder, the read with the boxer's plan, the bars |
| Result page | one line: what the fight did to confidence and hunger | the after-fight rule |
| After fight 6 | the record, the name and where the booking now starts (tier words), both bars | the name tier, then `ProLadder._make_offers` |

Plain game words; names only in headers; "the boxer", "the opponent".

## 8. Bars for the probe (copied unchanged from the task brief; never loosened)

Arms: ALWAYS TUNE-UP, ALWAYS STEP UP, ALWAYS WAIT (both "Not yet"s, then tune-ups), ALTERNATE, PRICE BOT (picks on printed
chance x purse on the usual plan, never touches the plan, ignores the bars and the boxer), READER (reads the tell and writes
the plan line, reads both bars, the chin, the ambition and the name tier in reach; no hidden number). Every bar printed with
the ring switch ON (the design) and OFF (the control arm). 2,000 careers a cell before any verdict.

- (1) No habit is the best arm in more than 6 of the 10 types.
- (2) The READER beats every habit by more than 2 standard errors in at least 5 of the 10 types.
- (3) Both bouts alive: the reader takes the TUNE-UP in 25%+ and the STEP UP in 25%+ of fights 1-6.
- (4) Waiting is a question: the reader says "Not yet" at least once for 2+ types, and never for 2+.
- (5) Mistakes are felt: ALWAYS TUNE-UP or ALWAYS WAIT loses the boxer (20%+) in 2+ types; the reader in at most 1; a
  knockout loss in fights 1-3 lowers the win rate of fights 4-6 by 2+ points and by more than 2 standard errors.
- (6) Nothing runs away: the bars never move the chance more than 5 points; both stay inside 0-100.
- (7) The reader's edge is real to a player: it beats the best habit by 8% of the score or more in at least 5 of 10 types.
- (8) Not one tuned price: both bouts are each taken in 25%+ of the reader's fights at step-up purse x1.5, x1.75 and x2.
- (9) Reading beats pricing: the reader beats the PRICE BOT by more than 2% of the score in at least 5 of 10 types.
- (10) Waiting is a real call: "Not yet" is in the reader's best line for 3+ types, and ALWAYS WAIT keeps the boxer (under
  20% gone) in 3+ types.

Printed without a bar: the share of fights where the better bout beats the other by 5%+ of expected score; how often the
standing after fight 6 differs between the READER and ALWAYS TUNE-UP on the same boxer and dice.

THE SCORE: gone = 0; kept = 10 a pro win - 5 a pro loss + 0.2 x (confidence - 50) + 1 a $100 of the gym's REAL cut
(`Roster.signing_share`) + the worth of the name tier (section 4: the gym's cut of the first normal card's best purse), each
part printed apart. MEASURE FIRST (before any career): for each type, the same-rated opponent across every style, weapon
and weakness, usual plan v the best line the boxer can write; STOP if the read moves less than 4 points between the best
and the worst plan against a tell for most types.

## 9. Result (S543): STOPPED at the measure-first gate

Probe `tools/turnprobe18.gd` stage=measure (rules `tools/turnprobe18_rules.gd`, tables `tools/turnprobe18_sum.py`), 33,631
reads of the game's own read, 180 opponent files (6 styles x 6 weapons x 5 weaknesses) per type, ten types.

- Best line minus worst line: median under 4 points for **7 of 10** types -> STOP (rule 1).
- The best line the boxer can write beats the usual plan (the coach's) by a median of **0.2 to 1.1 points**, every type.
- One tell carries it: "Fades after round 2" (the tiring situation). Combinations inside when the opponent tires add a
  median 7.5-12.5 points for the eight types who can throw one, up to **14.5** (over the 10-point cap). Answers to the
  style, the weapon and the other weaknesses add 0-4 points: the coach's plan already writes the drilled best answer on the
  most-fought card, and a weapon does not make the opponent play its situation more often, so its answer fires in a small
  share of the exchanges. A wrong line costs a median of up to 7 points and as much as 20 (stepping out against a range boxer).
- The FILE itself is what moves the read: at the tune-up's aim, two men of the same rating read about 70% and 92% (10th to
  90th file) on the usual plan. On the card that is a printed number, so the choice again comes down to comparing two
  printed numbers (TURNPROBE16's "the honest card solves the decision").
- Also found: the name tiers pay little and out of order on the game's own purse rule (6.0 / 7.9 / 7.0 points at the 25%
  cut): an unranked boxer reaching #10 earns more on the first card than a ranked #20 reaching #15.

Tuned: nothing. Population (not a rule): each type got a pro-ready book by style (punches, drilled combinations, step
bars); the signing's own book is the same for all ten and drills no combination, so on it no written line fired at all
(first measure, in the result). Details, tables and the recommended next step: `docs/TURNPROBE18_RESULT.md`.
