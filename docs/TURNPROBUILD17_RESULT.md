# TURNPROBUILD17 - turning pro v17 built into the game (S543)

Brief: `ops/research/TASK_TURNPROBUILD17.md`. Map: `ops/research/DESIGN_TURNPRO1_V17.md` (owner Q-S294-320 "Yes, build it",
Q-S294-323 "Yes, build v17 now"). Branch `build/turnpro17`, worktree `E:\FightCamp\wt\TURNPROBUILD17`. Step 1 (`ProStart.gd`)
was on main and is used as it is: **no number in ProStart was changed.**

## What each step changed

**Step 5 first (red):** `tests/turnpro17_walk_test.gd` committed red before any code (the preload of ProPair, ResultPage.bar_row
and Roster.refuse_rival failed). It walks: the offer; Not yet (a mark gone, hunger 55, the offer back exactly four weeks later,
no morale, loyalty or wins added); Not yet again (hunger 40); the rival gym's call (no Not yet on it); save and load; Turn pro
now; the debut's two bouts inside their bands (the printed chance equals the read with the bout's own confidence edge); the
risky bout booked and fought; the bar line on the result page; bookings 2-6 offering two bouts and no ladder offers beside
them; the normal ProLadder booking after fight 6. Walk 2: six safe wins take hunger 70 -> 10; at hunger 0 two warnings at two
bookings, gone at the third (the boxer leaves the club). Walk 3: refusing the rival gym's call sends the boxer away, one news line.

**Steps 2 and 3 landed in one commit** (Roster.turn_pro hands the debut to the pair, so step 2 could not be green without
ProPair; said plainly here instead of a throwaway half-step).

Step 2 - WHEN:
- `scripts/state/Roster.gd`: `pro_ready` = 7 wins and a regional top 3, or 9 wins; a national finalist always (the
  "with 0 declines" condition went with the declines - Kalli's code check point 2). `PRO_RETURN_WINS`, `PRO_SECOND_TERMS`,
  `DECLINE_NEWS`, `PROMOTERS` deleted; `PROMOTER` = "Bow Lane Promotions" (one promoter). `check_pro`: the offer comes when
  ready, not during a nationals run (`Champs.active`, as before), not before `f["pro_back"]` (four weeks after a Not yet).
  `decline_pro` = Not yet: `ProStart.not_yet`, `pro_back` = day + 28, one news line; NO morale (`ProOfferWire.apply_morale`
  is not called), NO loyalty (`Loyalty "decline_pro"` is not called), NO line moved. Nothing on a rival call. New
  `refuse_rival`: the boxer leaves through `Leaving.leave(c, fid, "rival_gym")` (the game's leaving path: reputation, the
  roster place, team-mates' loyalty, its one news line "X leaves for Eastside ABC."). `turn_pro`: pays the signing costs,
  licences, the share rules (`Loyalty.pro_share`, `StarDeal`, unchanged), the turning-pro morale (kept: it is the boxer's
  ambition, not the decline rule), sets `pro_due` = the Saturday four weeks out and `f["pro_pair"]` = fight 1's two bouts;
  nothing is booked until the player picks.
- `f["pro_start"]` (`ProStart.new_state()`) is made at the first offer (`ProOfferWire.make` via `ProPair.state`) and saved with
  the fighter (walk test: save -> JSON -> load keeps marks, hunger and the rival call).
- `scripts/state/ProOfferWire.gd` 202 -> 55 lines: `forecast`, `make` (one offer on the old keys fid / promoter / purse /
  terms / step / top, plus `rival`, `pair_now`, `pair_later`, `forecast`, `day`), `morale`, `morale_line` (the stay half
  is gone: Not yet costs no morale), `apply_morale`. Deleted: sync, offer, days_left, answers, ask, back_to_plain, signed,
  money, night, night_words, on_decline, lapse_if_due, waited.
- `scripts/rules/ProCall.gd` 337 -> 47 lines: kept LOST_CUT_A_WEEK (ProWeekLines reads it), AGE_STOP / calls_open / age_line
  (no first call at 32 - the brief did not cut it), morale / ambition_kind. Deleted: promoters, who_calls, terms,
  SECOND_TERMS, debut_purse, money, pays_back_line, the five asks (LATER2/4, SPLIT_*, PRICE_*, COSTS_*, SOFTER_*), apply_ask,
  WINDOW_DAYS / expires.
- `scripts/state/ProLean.gd` 47 -> 20 lines: LEAN_KIND / LEAN_WORD / line deleted; `extra()` stays as a pass-through so
  `ProLadder` stays untouched (its call site is in the normal booking); LEAN_FIGHTS kept (tools/turnprobe17.gd reads it).
- `scripts/rules/DebutPick.gd` 100 -> 37 lines: only `search(read_of, want)` - the gap search, now ProPair's.
- `scripts/ui/modals/ProOffer.gd`: the houses, the ask grid, the money columns and the pays-back line are gone (step 4).
- Decided: the 14-day window and its lapse are gone with the v2 rules (they used "+2 wins", which v17 replaces): the offer
  stands until answered. An old save's in-flight v2 debut (a `deal` on the bout) now pays the S329 ticket night, not the v2
  deal (Roster.debut_night).

Step 3 - HOW (`scripts/state/ProPair.gd`, new, 210 lines):
- Each fight 1-6 has two fixed men per sex (TURNPROBE17's pools: women 43.0 / 49.65, men 43.85 / 50.95), +0.3 rating each
  fight (DebutOpp.make with names and records of their own: the tune-up a journeyman with a losing record, the step up
  unbeaten). The game's read (the DebutRead walk: `BoutRead.round_edges` on a 4-round card) gives the chance; when it falls
  outside the band the matchmaker SEARCHES the rating gap (`DebutPick.search`) to just inside the band edge, then steps 0.1 at
  a time if the grid lands a hair outside. The number is never squeezed after.
- CONFIDENCE moves the fight: `bout["conf_edge"]` (power points, every round) is added by the live round
  (`LiveRound.gd` line 79) and the read (`BoutRead.gd` line 336, and in its cache key) through the new
  `BoutRules.conf_edge(bout)`. Where mood already enters: MOODREAD1 keyed the read's caches on the mood word and mood scales
  the corner's uptake (`FighterProfile.trust`); confidence sits beside it as a flat edge on every round, next to the fight
  week's `spar_edge` / `r1_edge` - the same hook both the fight and the read use. The chance printed is the read WITH the edge.
- `book`: the night is `pro_due` (the debut four weeks after signing, then `Matchmaking.NEXT_WEEKS` apart, +`STOP_REST_WEEKS`
  after a stoppage), at least a week out; a booking made later than due costs hunger as idle months (ProStart.rest). The
  debut keeps its tickets (`tickets: true`, ProDebut) AND now pays its purse (the map: safe = today's $1,500, risky x1.75);
  BoutFinish pays both. Risky purse = `ProStart.purse` (x1.75).
- `after_bout` (from `BoutFinish`): win / points (a loss on the cards; a draw counts as a loss, as the probe) / ko (stopped;
  a corner retirement, RTD, counts as points as BoutFinish already prices it as an ordinary loss). `ProStart.after_fight`,
  the medical rest's hunger (`ProStart.rest`), **the name gain added to the club's reputation on top of BoutRules.WIN_REPUTATION**
  (coordinator's decision), the table record synced (a pair bout is not a ladder bout), `pro_open` = tomorrow,
  `pro_next` held so ProLadder brings no offers beside the pair.
- `day_events` (called from `Sim.step_day` after ProLadder's): the booking that opens runs `ProStart.booking_check` - a warning
  news line, or gone (`Leaving.leave(..., "hunger")`) - then the next pair; after fight 6 it sets `pro_next` so
  `ProLadder._make_offers` books as before (untouched). The check runs at bookings 2-6 and the first booking after fight 6
  (as the probe; the debut booking at hunger >= 40 never needs it).
- `BoutActs` "probook" refuses a World ladder "Ask for this fight" while the pair runs (fights 1-6 are picked on Fights).

Step 4 - THE SCREENS (S425: wired and shown):

| Menu | Shows | File |
|---|---|---|
| Pro offer pop-up | purse line; PRO FIGHT 1 card: SAFE / RISKY, today's chance, the same chance four weeks on (four weeks of `TrainingPreview.plan_gain` on the current focus, `ProPair.trained`, read the same way), purse, name; three patience marks; Not yet / Turn pro now; the rival gym's call: a red line, Let the boxer go / Turn pro now | `scripts/ui/modals/ProOffer.gd` |
| Boxer card (Overview) | TURNING PRO card: patience marks (until pro), CONFIDENCE and HUNGER with `UI.meter` (the bar the goal card uses), the warning line at hunger 0 ("Warning 1 of 2 ...") | `scripts/ui/areas/FighterPage.gd` (the brief's `scripts/ui/FighterPage.gd` does not exist; this is the boxer page) |
| Booking, pro fights 1-6 | two cards side by side: SAFE / RISKY chip and the promoter's line, the opponent (record, style, threat), the chance and its bar, purse, name gain, what a win / a loss on points / a stoppage does to both bars, Take this fight | `scripts/ui/ProFights.gd` (+ `scripts/ui/areas/Fights.gd` shows the pro section before the debut too) |
| Result page | "The boxer after the fight: Confidence 50 -> 62, Hunger 40 -> 50, name +3." (`ProStart.bar_line`) | `scripts/ui/ResultPage.gd` (`bar_row`) |

Hovers explain what each thing does. Colours from UI/Palette only. Words: SAFE / RISKY with "The promoter's tune-up" /
"The promoter's step up"; no he / she in game text (no_pronoun_test green). NextStep's Pro offer line says the Not yets left
and the promoter's break-even (one promoter); "Pick the debut on Fights" after signing.

## The confidence table (tools/conf_edge_probe.gd, ten boxers, fight 1's safe and risky man)

First measured: ONE fixed edge for every bout. It cannot hold "about 5, never more" for both bouts - a near-even bout moves
about twice as far as a safe one:

```
CONF_MAX K 2.0 -> the largest move 8.1 points
CONF_MAX K 2.6 -> the largest move 10.5 points
CONF_MAX K 3.4 -> the largest move 13.7 points
```

(at K 2.0 the safe bouts moved 3-6 points, the risky ones 8). So the edge is SOLVED per bout (`ProPair.conf_edge_for`: the
power edge whose read moves by `ProStart.shift(confidence)`, kept on the side that never moves it further). At confidence
100 and 0:

| Boxer | Sex, style | Bout | Read at 50 | Edge at 100 | Moves | Edge at 0 | Moves |
|---|---|---|---|---|---|---|---|
| Lucy Jackson | f, Out-boxer | safe | 89.0% | +3.55 | +5.00 | -2.45 | -5.00 |
| Lucy Jackson | f, Out-boxer | risky | 54.1% | +1.27 | +5.00 | -1.25 | -5.00 |
| Kira Mensah | f, Out-boxer | safe | 86.5% | +2.87 | +5.00 | -2.17 | -5.00 |
| Kira Mensah | f, Out-boxer | risky | 53.9% | +1.27 | +5.00 | -1.25 | -5.00 |
| Samira Khan | f, Slugger | safe | 75.8% | +1.80 | +5.00 | -1.59 | -5.00 |
| Samira Khan | f, Slugger | risky | 41.2% | +1.29 | +5.00 | -1.33 | -5.00 |
| Tess Reilly | f, Pressure fighter | safe | 87.5% | +3.14 | +5.00 | -2.30 | -5.00 |
| Tess Reilly | f, Pressure fighter | risky | 50.6% | +1.27 | +5.00 | -1.26 | -5.00 |
| Danny Osei | m, Boxer-puncher | safe | 88.1% | +3.26 | +5.00 | -2.33 | -5.00 |
| Danny Osei | m, Boxer-puncher | risky | 54.2% | +1.27 | +5.00 | -1.24 | -5.00 |
| Josh Harper | m, Pressure fighter | safe | 86.6% | +2.90 | +5.00 | -2.18 | -5.00 |
| Josh Harper | m, Pressure fighter | risky | 53.9% | +1.27 | +5.00 | -1.24 | -5.00 |
| Nell Ward | f, Counter-puncher | safe | 89.1% | +3.57 | +5.00 | -2.46 | -5.00 |
| Nell Ward | f, Counter-puncher | risky | 54.0% | +1.27 | +5.00 | -1.24 | -5.00 |
| Reece Doyle | m, Out-boxer | safe | 79.8% | +2.02 | +5.00 | -1.72 | -5.00 |
| Reece Doyle | m, Out-boxer | risky | 47.3% | +1.24 | +5.00 | -1.24 | -5.00 |
| Bayo Adams | m, Slugger | safe | 87.7% | +3.17 | +5.00 | -2.31 | -5.00 |
| Bayo Adams | m, Slugger | risky | 54.2% | +1.27 | +5.00 | -1.25 | -5.00 |
| Kai Turner | m, Volume puncher | safe | 82.9% | +2.31 | +5.00 | -1.88 | -5.00 |
| Kai Turner | m, Volume puncher | risky | 50.3% | +1.24 | +5.00 | -1.24 | -5.00 |

Largest move: **5.00 points**, never more. The live fight carries the same edge (`bout.conf_edge`), so the printed chance is
the number the fight is fought at.

## Tests deleted or rewritten (map section 6), each with the rule it tested

| Test | Check | Rule | Done |
|---|---|---|---|
| pro_call_test | promoters, who_calls, terms (decline / title reset), debut_purse, money cases A/B/C, own price, pays_back_line, asks later/softer/split/price/costs, apply_ask, expires | two houses, the asks, 0.9x terms, the 14-day window | deleted with the rules |
| pro_call_test | no pronouns | game text | rewritten to the lines left (age_line) |
| pro_offer_wire_test | both houses / one house by forecast, the 14-day stand, won't / counter / Back to plain / one ask, signing with Harrow & Finch (6 weeks, $1,800, purse cut, house in news and History), Stay amateur same house, the window lapse (+2 wins), the deal's own ticket price | houses, asks, window, decline | deleted |
| pro_offer_wire_test | old keys, History milestone, buzz, club show +10, age 32, old save signs | still stand | kept, rewritten to one promoter / the pair |
| pro_contract_test | offers array, expires, asked/plain; two houses and forecast (8 checks); window and lapse (6); asks and plain (8); hf 6 weeks, costs 0 when covered; declines (+2 wins, same house first, rank 1 after two, door closed at three) | houses, window, asks, decline rule | deleted; the decline block REWRITTEN as Not yet (offer back at 28 days not 27, same wins, the rival third call, Not yet does nothing on it or with no offer) |
| pro_contract_test | "second check_pro changes nothing" read `expires` | still stands | rewritten to read the offer's `day` |
| pro_contract_test | debut booked 4 weeks out | debut is now picked | rewritten: the pair waits, `pro_due` is 4 weeks out |
| pro_lean_test | the houses' lean (2), no step while rebuilding, the lean ends at 6, no house, the softer ask, the Fights line | the lean, the softer ask | deleted; rewritten to: rows pass through unchanged, pro_fights counts |
| debut_pick_test | house aims and noise (4), each house's pick on target for six, cache, picked spread vs fixed, hf weaker than bow, the words and hover card, both houses' gaps on the offer, the softer ask moves the gap, a save keeps the pick, turn_pro books it, played debuts inside each house's aim | the houses' pick, the softer ask | deleted |
| debut_pick_test | the search lands on the wanted read for six boxers, the same inputs the same gap, a control arm (one fixed man reads far apart), a stronger boxer gets a stronger man; the morale line | the matchmaker's search (now ProPair's), morale | rewritten |
| debut_read_test | the guarantee house books the weaker debutant / is the safer read | two houses | deleted |
| debut_read_test | turn_pro books the opponent the offer read | one opponent rule | rewritten: the debut booked from the pair with DebutOpp at the measured gap; the read vs played bands unchanged |
| next_step_test | test 6 (2 declines -> rank 1 only, 3 -> no more offers) | decline rule | rewritten: Not yets move no line |
| next_step_test | test 7 / 9 loops over pro_declines | decline rule | rewritten over patience |
| next_step_test | test 10 the pro line (both houses, declines left) | houses, declines | rewritten: the promoter's break-even, Not yet left |
| next_step_test | the lapse (+2 wins) | the window | rewritten: Not yet's four weeks |
| loyalty_hooks_test | declining costs loyalty -8 | decline rule | rewritten: Not yet costs no loyalty |
| pro_week_lines_test | Bow Lane calls; the covered-costs control | houses, costs ask | rewritten (the promoter calls) / deleted |
| pro_ladder_test, golden_path_test, test_jump_test (+ `scripts/ui/TestJump.gd`) | the debut auto-booked at signing | the debut is now picked | setup rewritten: pro_ladder and the ladder jumps book the pair's last fight (fights = 5) so they still read the normal booking; golden path presses Take this fight on FIGHTS and now checks the debut's purse share beside the tickets and the bar line |
| approach_test, promises_test | decline_pro as a loyalty-history label, can_decline_pro | pure rules, still stand | unchanged |

## Test run (JOBS 1-3, headless, Dummy audio)

```
PASS turnpro17_walk_test
PASS pro_start_test
PASS golden_path_test
PASS save_load_test
PASS pro_ladder_test
PASS pro_debut_test
PASS pro_read_test
PASS loyal_pro_share_test
PASS file_limits_test
PASS no_pronoun_test
FAIL palette_guard_test (exit 1)
FAIL res://scripts/ui/FightPictures.gd new file with 11 raw colours - use Palette.gd
FAIL res://scripts/ui/FightPictures.gd new file with 11 raw colours - use Palette.gd
PASS words_on_screens_test
PASS plain_words_test
PASS pro_call_test
PASS pro_offer_wire_test
PASS pro_contract_test
PASS pro_lean_test
PASS debut_pick_test
PASS approach_test
PASS loyalty_hooks_test
PASS promises_test
PASS next_step_test
PASS pro_week_lines_test
PASS debut_read_test
PASS test_jump_test
PASS next_step_card_test
PASS result_tabs_test
PASS leaving_test

(palette_guard_test: the one failure is scripts/ui/FightPictures.gd, S540 PICS2D2; neither that file nor the test differs from main at 148d2d66c.)

turnpro17_walk_test, run alone: 43 checks, "TURNPRO17_WALK failures=0".
```

## Stills (`docs/playtest/s543_turnpro17/`, rendered on the never-shown desktop by `tools/turnpro17_snapshot.gd`, opened)

- `01_pro_offer_real.png` - the offer: purse, PRO FIGHT 1 safe 89% / risky 54% today and four weeks on, patience, Not yet / Turn pro now.
- `01b_rival_call_real.png` - the rival gym's call: the red line, "0 Not yet left", Let the boxer go / Turn pro now.
- `02_boxer_card_real.png` - after one Not yet: TURNING PRO card, patience 2 of 3 ("1 Not yet left"), confidence 50, hunger 55.
- `03_booking_pair_real.png` - Fights: pro fight 1 of 6, SAFE Kayleigh Doran 89% $1,500 +1, RISKY Stacey Mills 54% $2,625 +3, what each result does to the bars.
- `04_result_real.png` - the risky debut won: "The boxer after the fight: Confidence 50 -> 62, Hunger 40 -> 50, name +3."

Fixed after opening them: the promoter's line read "The Promoter's Tune Up" (capitalize() dropped the hyphen) -> "The
promoter's tune-up"; the Fights side card said "The debut is booked 4 weeks after signing" -> "Pick the debut on Fights ...".

## What the map says that the code could not do, and gaps (written down, no rule invented)

- **The four-weeks-on read rarely moves for a strong boxer.** Lucy reads 89% / 54% today AND four weeks on: her raw read is
  above both bands, the matchmaker finds harder men, and the band holds the number. The probe saw the same ("Strong types sit
  at the top of both bands, so waiting gains them nothing"). The pop-up prints it honestly; it moves for weaker boxers.
- **Confidence edge size per bout.** The map says "linear, 0 = -5, 100 = +5"; one fixed power edge cannot do that across a
  90% and a 50% bout (table above), so the edge is solved per bout. A fight then carries 1.2-3.6 power points at confidence
  100 depending on the bout.
- **The rival gym and the hunger leaver go to `Leaving.TO_CLUB` (Eastside ABC)**, the game's one rival club; a pro who
  leaves on hunger follows Leaving's pro path (release fee, no rival row).
- **Kalli's code check:** the four-weeks-on read did not exist (built: ProPair.trained + the same read); the finalist rule
  (now always called); the decline path's morale and loyalty (both removed from Not yet; the turning-pro morale stays);
  the gym share is not flat (kept as built: `Roster.signing_share` / StarDeal, shown on the pop-up); a step up needs a ranked
  name (no longer: the pair's step up is a fixed man of the division, not a table name; from fight 7 ProLadder's rule as before).
- **The draw** counts as "points" for the bars (the probe's rule); a corner retirement (RTD) too.
- Old probe tools `tools/turn_pro_probe*.gd`, `tools/turnprobe11-16*.gd`, `tools/turn_gap_probe.gd` call the deleted v2
  functions and no longer parse; they are history (v2-v16 probes), not game code, and were left as they are.
- `palette_guard_test` fails on `scripts/ui/FightPictures.gd` (S540 PICS2D2, "new file with 11 raw colours") - a file this
  branch does not touch; it fails the same way on main.
- PC: the first render of the stills ran just as the owner's ArcheAge appeared in the watchdog's top list (memory AMBER) -
  seen in that render's own watchdog line, after the fact. No Godot job started after that until the watchdog read GREEN with
  the game closed (about 40 minutes); the final test run and the stills in the folder are from after that.

## Files outside the brief's OWNS list, and why
`scripts/rules/BoutRules.gd` (conf_edge, 6 lines), `scripts/state/LiveRound.gd` and `scripts/rules/BoutRead.gd` (the same line
each + the cache key: confidence must move the fight and the read alike), `scripts/state/Sim.gd` (one line: ProPair.day_events),
`scripts/rules/NextStep.gd` (the Pro offer step's words and the deleted decline fields), `scripts/ui/RosterActs.gd` (Not yet,
rivalgo, propair acts; the ask acts deleted), `scripts/ui/BoutActs.gd` (no ladder ask during the pair),
`scripts/ui/areas/Fights.gd` (show the pro section before the debut), `scripts/ui/TestJump.gd` (its pro jumps),
`tools/run_tests.sh` (the walk test joins the list), `tools/conf_edge_probe.gd`, `tools/turnpro17_snapshot.gd` (new tools).
