# CARDSCOPE3 - the bot probe of the card game scope, round 3 (S537)

Design: `ops/research/DESIGN_CARDGAME_SCOPE.md` (2b the form, 3R the design, 4c the bars, 6c the result). Greybox:
`proto/cardscope3/` (plain node, no page, no Godot; `proto/cardscope` is rounds 1 and 2 and was not touched).
Read first: `ops/research/OWNER_CARDGAME_INTERVIEW_S537.md` (fast and punchy, about 5 minutes, every number shown).
`node proto/cardscope3/engine.test.mjs` -> RESULT: PASS - all 29 checks green.
`node proto/cardscope3/probe.mjs run2 per=400 card=800 runs=400` then `node proto/cardscope3/report.mjs run2` print the table below.

## Verdict: FAIL (run 2: 18 of 24 core bars, 3 of 11 supporting; run 1: 14 of 24 and 4 of 11)

The form changed: the three-beat exchange is gone, the bout is a **rally**. He throws his punches face up; on your
turn you answer them with one guard (or take them), they land at once, and you throw back; each boxer has one
face-down trap that watches for one kind of lead punch. What round 2 named as the real fault is fixed by rule: a punch
does not stop a punch, so a boxer who never guards wins 1.8% of bouts against 59.1% for the one who chooses, a third of
all punches are stopped, and Block, Slip, Roll and Parry are top-half picks against some style. A bout is 37 decisions,
5.0 minutes at 8 seconds each. A player who only reads the printed numbers, one card at a time, wins 47.1% where the
best bot wins 59.1% and the rule-of-thumb beginner 20.0%. It does not pass: the beginner is still 5 points short at
regional class (round 2: 4.3%), a thin deck of cheap punches wins the pro debut 67.5%, ten of fourteen cards have no
matchup swing, and three bars miss by a hair (C6 by 0.3, B15 by 0.2, D2 on one clause).

## What changed for round 3 (round 2 finding -> change)

| Round 2 finding | Change in the greybox |
|---|---|
| The owner: fast and punchy, about 5 minutes, quick turns | One card at a time. A turn is "answer, then throw". 3 rounds of 3 turns each. 5 choices in front of you at a decision (round 2: 112 legal answers an exchange). |
| The answering boxer wins by hitting, so guards are worth nothing | Punches no longer meet on a beat. His volley lands on you unless you stop it; hitting back stops nothing. A guard is played against a punch you can see, so it never misses. |
| A punch answers the hidden card half the time | The hidden card is a trap in its own slot. It watches the first punch of your volley only: the question is what to lead with (jab / cross or uppercut / hook), or to throw nothing. |
| Four Check hooks break the debut; every sizing crowns the card that takes his next action | At most 2 of each trap. No card takes his next action or his cards any more; a trap makes one punch miss and lands 8. |
| A rule-of-thumb beginner wins 4% at regional | "Guard what you see, then jab, cross, hook" is now a legal, sound-looking line; the table prints the result of every guard and every punch before you commit. |
| He tires only through one card | Wind is short for both (3 back, top 6): a boxer starts 11.7% of his turns on 2 wind or less, from body work, a knockdown, or having spent it. |

## How it was run

- Bots in the player's chair: random; the best of 400 fixed lines (a fixed order of card names played top down; best 5
  re-measured on fresh seeds); greedy (damage thrown less damage taken, blind to traps); beginner (the rule of thumb:
  right guard on the biggest punch, then jab, cross, hook; sets no trap, ignores his); table player (one card at a
  time on the printed numbers); reader (public information only); all-seeing (shown his trap and his hand: a ceiling).
- Population: 4 player boxers x 4 opponent boxers from other clubs, one of each style, all different in cards and head
  points, never the same boxer on both sides; 400 bouts a pair a bot (6,400 an arm); card table 800 bouts a cell;
  400 runs of 8 bouts; breaker search 32 decks and two rounds of one-card swaps, the best five re-measured on 1,000 bouts.
- The round 3 bars were written and committed (573c584a1) before any round 3 code existed and were not edited.
- **Sizing before run 1, on its own seeds (300000 and up, `calib.mjs`, `diag.mjs`, small probes), changed two rules, not
  only numbers.** (1) With a guard allowed on every punch, guarding everything was automatic (free choice 58%, "guard
  all" 57%), 40% of volleys landed nothing and a trapless deck of guards won 90%: now **one guard a turn** (a Parry is
  extra). (2) A trap at 2 wind that was thrown away unsprung was a card no deck wanted: now a trap is **free, watches
  the lead punch only, and comes back to the hand** if nothing walks onto it. Also sized there: the first thrower of a
  round gets less wind back (he won 60% without it), no wind back for the answer at the bell, head points, decks.
  The sentence in 4c "a guard on any of them" therefore reads "one guard on one of them"; no bar changed.
- Two measured runs: run 1 as sized; run 2 after the one resize (numbers only: Parry 1 wind not 0, Tie up 4 not 2, the
  first thrower 1 wind less not 2, knockdown line 18 / 14 not 16 / 12, a trap does 8 not 6, ice 14 not 10).
  **The design-change run was not spent.** Two candidates were tried on sizing seeds: an unsprung trap thrown away
  face up (17 of 24: the last clause of D2 passes, C1 and C4 fall out) and the body track cut (17 of 24: C6 and B15
  pass, C2 and D3 fall out). Neither beat 18, so run 2 stands as the result.
- Bots are not people: nothing below says a person enjoys it. The regional opponent is the reader's own planner
  without habit knowledge and with another deck.

## What failed in run 2, and the cause in the design

| Bar | Run 1 | Run 2 | Cause |
|---|---|---|---|
| C11 no cliff (beginner 70+ / 45-60 / 25-40) | 83.1 / 48.1 / 18.1 | 83.7 / 48.4 / 20.0 | Novice and open class pass. At regional the bar's beginner never sets its own free trap and leads jab-first onto his Check hook. The equally trap-blind damage chaser wins 21.4%; the table player, who reads the printed line under the set card, 47.1%. The set card has to be taught (open class: his trap face up for two rounds), not softened: trap damage 4, 6 or 8 moved the beginner by under 2 points in sizing. |
| C8 no breaker deck (50%) | 59.7% (two Tie ups, a Parry) | 67.5% (five Body jabs, three Jabs, three Crosses, Parry, Block, Slip, Roll) | No key card any more (C9: biggest lift +11.3). The winner is a thin deck of the cheapest punches with four guards and no trap. Body damage takes his wind for the rest of the bout and the Body jab buys it for 1 wind; and a trap is a burden to its own deck, so the style decks are weaker than a plain one (the neutral deck wins 29.8% of pro debuts, the four style decks 28.2%). |
| B6 every card has a matchup | 10 of 14 flat | 10 of 14 flat | Cross, Lead hook, Body hook and Roll swing by opponent. The 1-wind cards (Jab, Body jab, Block, Parry) are good against everybody and the dear ones (Uppercut 3, Tie up 4) bad against everybody: with 3 wind a turn the price decides first. The traps are bottom-half nearly everywhere (Check hook 5th against the volume puncher, Pull counter 5th against the pressure fighter): a trap that nothing walks onto comes back and sits in the hand where a punch would be. |
| D2 guards are worth something | fails on one clause | fails on one clause | Three clauses pass (never guards 1.8% v 59.1%; 31.8% of punches stopped; four guards top-half somewhere). "Guards all it can" is only 1.7 under free choice (bar 5): with one guard a turn, using it is nearly always right. The decision is which punch and which guard. |
| C12 habits rule and flip | 17.2% / B15 passes | 17.3% / B15 fails by 0.2 | A habit is on the table in 79% of his turns. It changes the volley in 17% of the turns where it applies (bar 30): a trap watches the lead only, so a habit can only change the lead, and the count of what he can still hold already says most of it (counting +9.1). |
| C6 no fixed answer to the set card | jab first -9.4 | jab first -9.7 | Three of four pass by 18 to 32 points. Leading with the jab is the cheap probe: it costs 1 wind and only the Check hook punishes it (28% of his traps). |
| B8 ladder | greedy under fixed | same | 4.7 / 30.9 / 21.4 / 59.1 / 64.3. The damage chaser is blind to traps; the best fixed line happens to set them. Reader over greedy by 38. |
| B11 stoppages 10-25% | 5.5%, 0.85 knockdowns | 1.8%, 0.39 | The resize raised the knockdown line to get close rounds (B5 and B14 pass in run 2). Head points 68 to 75 against 54 taken a bout: bouts go to the cards. |
| B12 no blanks (15% / 25%) | 19.2% / 15.1% | 19.5% / 15.7% | One volley in five lands nothing: a single punch met by the one guard. Dead cards pass. |
| B13 no dead card | passes | Tie up 2.9% | At 4 wind the Tie up is nearly unplayable; at 2 it was the best card against every style. It needs a rule, not a price. |
| B15 film and counting (4+ / 3+) | +4.4 / +9.8 | +3.8 / +9.1 | Counting passes for the first time in three rounds: what he can still hold is printed and it changes what you throw. Habits are 0.2 short. |
| B16 he reads you back (8) | 0.5 | 1.4 | His tally of what you lead with changes which trap he sets only when no habit applies. |
| B17 the corner | water always best | water always best | Informed 59.1%, always water 62.3%, random 49.0%. Wind is still the strongest currency; ice and "watch him" are wrong picks nearly always. |
| B18 styles 40-90% | 51.5 to 83.8 PASS | 37.8 to 79.8 | One pair under 40 after the resize (pressure fighter v volume puncher). Content sizing. |

Passed in both runs: B1 to B4, B7, B10, C1, C2, C4, C5, C7, C10, D1, D4, D5. Passed in run 2 only: B5, B9, B14, C3, C9, D3.

## Run 2 - after the one resize (the greybox as committed)

Population: 4 player boxers x 4 opponents (16 pairs), regional class, 400 bouts a pair. Card table: neutral 12-card deck + 2 copies of one card v each opponent boxer, reader, 800 bouts a cell. Run: 400 runs of 8 bouts. Breaker: pro debut (class 5, four rounds), reader, neutral boxer with the deck v each of 4 opponents; final measure 250 bouts an opponent.

| # | Bar | Result | Measured |
|---|---|---|---|
| B1 (core) | Reading beats a fixed line (15+) | **PASS** | reader 59.1% v best fixed line 30.9% = +28.2 (Jab > Tie up > Roll > Slip > Block > Parry > Cross counter > Lead hook > Pull counter > Body hook > Check hook > Uppercut > Body jab > Cross) |
| B2 (core) | Thinking beats not thinking (30+) | **PASS** | reader 59.1% v random 4.7% |
| B3 (core) | No line that needs no reading (best fixed under 45%, 10+ under the reader) | **PASS** | best fixed 30.9% on fresh seeds (screen 34.4%) |
| B4 (core) | Close fights (one-sided under 35%) | **PASS** | 19.8% one-sided |
| B5 (core) | Decided late (30%+ won from level or behind after round 2) | **PASS** | 32.3% |
| B6 (core) | Every card has a matchup (top four v one style, bottom half v another) | **FAIL** | no matchup swing: Jab, Body jab, Uppercut, Block, Slip, Parry, Tie up, Check hook, Cross counter, Pull counter |
| B7 (core) | The run has choices (3+ wide offers a run; informed picks beat random picks) | **PASS** | 7.6 wide offers of 8.0 a run; bouts won: informed 80.0%, random pick 64.7%, no pick 69.9%; wins a run 6.40 v 5.17 |
| B8 | A ladder of skill (random < fixed < greedy < reader < all-seeing; reader 8+ over greedy) | **FAIL** | 4.7 / 30.9 / 21.4 / 59.1 / 64.3 |
| B9 | The set card is a bet, not the game (all-seeing 5 to 20 over the reader) | **PASS** | +5.2 |
| B10 | Showing beats guessing (lead over random 10+ bigger with punches shown than unseen) | **PASS** | shown 54.5, unseen 17.9 |
| B11 | Stoppages 10-25%, knockdowns 0.3-1.0 a bout, round-1 stoppages under 3% | **FAIL** | 1.8% stopped, 0.39 knockdowns a bout, 0.0% in round 1 |
| B12 | No blanks (volleys from which nothing lands under 15%; dead cards under 25%) | **FAIL** | 19.5% of volleys, 15.7% of cards |
| B13 | No dead card, no card for everything (3%+ where held, none over 30%) | **FAIL** | Jab 19.9, Body jab 8.0, Cross 13.1, Lead hook 11.1, Body hook 12.6, Uppercut 5.0, Block 7.0, Slip 5.3, Roll 4.3, Parry 4.9, Tie up 2.9, Check hook 14.1, Cross counter 15.5, Pull counter 16.0 |
| B14 | Split cards (15%+ of points decisions) | **PASS** | 16.8% |
| B15 | Film and counting pay (habits known 4+, counting 3+) | **FAIL** | both habits known +3.8 (one habit +2.7), counting +9.1, the tally +0.0 |
| B16 | He reads you back (best fixed line loses 8+ to the adapting opponent) | **FAIL** | fixed line 32.3% v a non-adapting opponent, 30.9% v the adapting one; a reader who always leads with the jab: 50.5% v 49.4% |
| B17 | The corner is a decision (informed 3+ over random; each card 15%+ of informed picks) | **FAIL** | informed 59.1%, random 49.0%, always water 62.3%, ice 40.0%, watch him 41.2%; informed picks water 76.4%, ice 20.5%, watch him 3.2% |
| B18 | Styles (every pair 40-90% for the reader) | **FAIL** | lowest 37.8%, highest 79.8% |
| C1 (core) | Equal paper holds (reader 55-65% at regional) | **PASS** | 59.1% |
| C2 (core) | He tires (starts 5-15% of his turns on 2 wind or less) | **PASS** | 11.7% of his turns |
| C3 (core) | Nobody is the heavier hitter (damage dealt and taken within 10%) | **PASS** | dealt 59.5 and taken 54.4 a bout (ratio 1.09); 29.2% of wins with more head damage taken than given |
| C4 (core) | You set traps (the reader sets one on 30%+ of its turns) | **PASS** | 63.0% of its turns |
| C5 (core) | The set card is a fork (no kind over 55%; a trap down on 20-85% of his turns) | **PASS** | Cross counter 43.2, Check hook 27.8, Pull counter 29.0; a trap down on 59.9% of his turns |
| C6 (core) | No fixed answer to the set card (each of four forced answers 10+ under free choice) | **FAIL** | free 59.1%; always ignore 40.6%, jab first 49.4%, jabs only 34.5%, nothing 26.8% |
| C7 (core) | The answers spread (no class of first punch at a set card over 40%) | **PASS** | jab 36.7%, body jab 0.0%, cross or uppercut 16.1%, hook 22.1%, none 25.1% |
| C8 (core) | No breaker deck (no legal deck over 50% in the pro debut) | **FAIL** | best found: 67.5% (Jab, Jab, Jab, Body jab, Cross, Cross, Cross, Body jab, Parry, Block, Slip, Roll, Body jab, Body jab); neutral deck 29.8% |
| C9 (core) | No pair is a key (no added pair lifts a pair-up by more than 25) | **PASS** | biggest lift +11.3 (Body jab v out) |
| C10 (core) | The table makes the skill a person can reach (table player closes half the gap, 10+ over the beginner) | **PASS** | beginner 20.0%, table player 47.1%, reader 59.1%: 69.3% of the gap |
| C11 (core) | No cliff (beginner 70%+ novice, 45-60% open class, 25-40% regional) | **FAIL** | beginner 83.7 / 48.4 / 20.0% |
| C12 (core) | Habits rule and flip (a habit on the table in 50%+ of his turns; the volley flips in 30%+ where one applies; B15) | **FAIL** | habit on the table in 79.0% of his turns; volley differs in 17.3% of 17289 turns where a known habit applies; B15 fails |
| D1 (core) | Fast and punchy (3-6 minutes: 22.5-45 decisions; 95% under 52) | **PASS** | reader 37.4 decisions = 5.0 min (95%: 42); table player 37.2 = 5.0 min (95%: 42) |
| D2 (core) | Guards are worth something (no guard -15, guard all -5, 30-70% of punches stopped, 2+ guards top-half somewhere) | **FAIL** | never guards 1.8%, guards all it can 57.4%, free 59.1%; 31.8% of punches stopped; top-half guards: Block, Slip, Roll, Parry |
| D3 (core) | The chairs are equal (first thrower wins 45-55%, reader v reader) | **PASS** | 52.9% (player chair 45.9%) |
| D4 (core) | Quick turns (choices at a decision under 10 on average, never over 20) | **PASS** | 5.0 on average, most 15 |
| D5 (core) | No trap deck (six traps under the neutral deck plus the best two) | **PASS** | six traps 5.3%, neutral + 2 Body jab 46.4% |

Core bars (B1-B7, C1-C12, D1-D5): 18 of 24 pass. Supporting bars (B8-B18): 3 of 11 pass. Verdict: **FAIL**.

Reader by pair (player out, press, counter, volume; each v opponent out / press / counter / volume): 44.5, 46.0, 72.3, 57.0, 58.3, 72.8, 58.8, 37.8, 47.8, 45.8, 61.5, 60.5, 73.8, 71.8, 79.8, 58.3

Opponent class (beginner / table player / greedy / reader): novice 83.7 / 95.0 / 84.0 / 96.6, open class 48.4 / 83.7 / 49.8 / 90.2, regional 20.0 / 47.1 / 21.4 / 59.1, title 9.8 / 32.5 / 11.5 / 44.1, professional 2.6 / 17.5 / 5.4 / 28.2

Best fixed lines: 30.9% Jab > Tie up > Roll > Slip > Block > Parry > Cross counter > Lead hook > Pull counter > Body hook > Check hook > Uppercut > Body jab > Cross; 30.9% Lead hook > Check hook > Cross counter > Roll > Slip > Body jab > Uppercut > Tie up > Parry > Pull counter > Body hook > Block > Jab > Cross; 30.0% Cross counter > Jab > Tie up > Pull counter > Slip > Check hook > Block > Body hook > Cross > Roll > Lead hook > Uppercut > Body jab > Parry; 29.2% Check hook > Slip > Tie up > Roll > Jab > Cross > Parry > Cross counter > Uppercut > Pull counter > Body hook > Lead hook > Body jab > Block; 18.5% Parry > Slip > Roll > Block > Jab > Cross > Lead hook > Body hook > Uppercut > Body jab

Breaker search, final measure: 67.5% swap round 2: Lead hook out, Parry in [Jab, Jab, Jab, Body jab, Cross, Cross, Cross, Body jab, Parry, Block, Slip, Roll, Body jab, Body jab]; 62.1% swap round 1: Lead hook out, Body jab in [Jab, Jab, Jab, Body jab, Cross, Cross, Cross, Body jab, Lead hook, Block, Slip, Roll, Body jab, Body jab]; 59.4% swap round 1: Cross out, Body jab in [Jab, Jab, Jab, Body jab, Body jab, Cross, Cross, Lead hook, Lead hook, Block, Slip, Roll, Body jab, Body jab]; 58.1% swap round 2: Jab out, Check hook in [Check hook, Jab, Jab, Body jab, Cross, Cross, Cross, Body jab, Lead hook, Block, Slip, Roll, Body jab, Body jab]; 55.4% swap round 2: Jab out, Pull counter in [Pull counter, Jab, Jab, Body jab, Cross, Cross, Cross, Body jab, Lead hook, Block, Slip, Roll, Body jab, Body jab]

What two more copies of a card are worth (reader win %, neutral deck alone: 54.6, 78.9, 82.1, 61.5):

| card | v out | v press | v counter | v volume |
|---|---:|---:|---:|---:|
| Jab | 59.1 (4) | 78.8 (4) | 85.6 (3) | 50.1 (7) |
| Body jab | 65.9 (1) | 88.9 (1) | 90.8 (1) | 58.3 (2) |
| Cross | 46.5 (9) | 67.1 (8) | 70.9 (7) | 53.8 (4) |
| Lead hook | 49.5 (7) | 57.6 (12) | 66.9 (10) | 54.1 (3) |
| Body hook | 65.0 (2) | 61.6 (10) | 74.6 (6) | 42.0 (11) |
| Uppercut | 34.5 (12) | 49.1 (14) | 47.0 (14) | 45.0 (8) |
| Block | 57.6 (5) | 85.4 (2) | 84.3 (4) | 52.9 (5) |
| Slip | 50.3 (6) | 67.4 (7) | 78.8 (5) | 42.1 (10) |
| Roll | 34.8 (11) | 80.6 (3) | 69.1 (9) | 43.8 (9) |
| Parry | 62.8 (3) | 70.9 (6) | 86.9 (2) | 63.9 (1) |
| Tie up | 32.5 (14) | 63.1 (9) | 66.6 (11) | 32.0 (14) |
| Check hook | 49.1 (8) | 56.8 (13) | 65.1 (12) | 52.9 (5) |
| Cross counter | 36.6 (10) | 59.3 (11) | 69.3 (8) | 34.3 (13) |
| Pull counter | 33.4 (13) | 76.6 (5) | 61.3 (13) | 35.8 (12) |

## Run 1 - as sized before the first measured run

Population: 4 player boxers x 4 opponents (16 pairs), regional class, 400 bouts a pair. Card table: neutral 12-card deck + 2 copies of one card v each opponent boxer, reader, 800 bouts a cell. Run: 400 runs of 8 bouts. Breaker: pro debut (class 5, four rounds), reader, neutral boxer with the deck v each of 4 opponents; final measure 250 bouts an opponent.

| # | Bar | Result | Measured |
|---|---|---|---|
| B1 (core) | Reading beats a fixed line (15+) | **PASS** | reader 64.2% v best fixed line 36.0% = +28.2 (Lead hook > Check hook > Cross counter > Roll > Slip > Body jab > Uppercut > Tie up > Parry > Pull counter > Body hook > Block > Jab > Cross) |
| B2 (core) | Thinking beats not thinking (30+) | **PASS** | reader 64.2% v random 4.7% |
| B3 (core) | No line that needs no reading (best fixed under 45%, 10+ under the reader) | **PASS** | best fixed 36.0% on fresh seeds (screen 44.8%) |
| B4 (core) | Close fights (one-sided under 35%) | **PASS** | 21.8% one-sided |
| B5 (core) | Decided late (30%+ won from level or behind after round 2) | **FAIL** | 28.5% |
| B6 (core) | Every card has a matchup (top four v one style, bottom half v another) | **FAIL** | no matchup swing: Jab, Body jab, Body hook, Uppercut, Roll, Parry, Tie up, Check hook, Cross counter, Pull counter |
| B7 (core) | The run has choices (3+ wide offers a run; informed picks beat random picks) | **PASS** | 7.8 wide offers of 8.0 a run; bouts won: informed 82.9%, random pick 68.5%, no pick 73.2%; wins a run 6.63 v 5.48 |
| B8 | A ladder of skill (random < fixed < greedy < reader < all-seeing; reader 8+ over greedy) | **FAIL** | 4.7 / 36.0 / 26.5 / 64.2 / 68.8 |
| B9 | The set card is a bet, not the game (all-seeing 5 to 20 over the reader) | **FAIL** | +4.6 |
| B10 | Showing beats guessing (lead over random 10+ bigger with punches shown than unseen) | **PASS** | shown 59.4, unseen 21.1 |
| B11 | Stoppages 10-25%, knockdowns 0.3-1.0 a bout, round-1 stoppages under 3% | **FAIL** | 5.5% stopped, 0.85 knockdowns a bout, 0.0% in round 1 |
| B12 | No blanks (volleys from which nothing lands under 15%; dead cards under 25%) | **FAIL** | 19.2% of volleys, 15.1% of cards |
| B13 | No dead card, no card for everything (3%+ where held, none over 30%) | **PASS** | Jab 20.0, Body jab 8.0, Cross 13.2, Lead hook 11.1, Body hook 12.3, Uppercut 5.0, Block 6.9, Slip 5.2, Roll 4.2, Parry 5.3, Tie up 5.1, Check hook 13.7, Cross counter 15.0, Pull counter 15.9 |
| B14 | Split cards (15%+ of points decisions) | **FAIL** | 11.5% |
| B15 | Film and counting pay (habits known 4+, counting 3+) | **PASS** | both habits known +4.4 (one habit +3.0), counting +9.8, the tally +0.0 |
| B16 | He reads you back (best fixed line loses 8+ to the adapting opponent) | **FAIL** | fixed line 36.5% v a non-adapting opponent, 36.0% v the adapting one; a reader who always leads with the jab: 55.5% v 54.8% |
| B17 | The corner is a decision (informed 3+ over random; each card 15%+ of informed picks) | **FAIL** | informed 64.2%, random 47.2%, always water 69.5%, ice 35.3%, watch him 36.5%; informed picks water 78.2%, ice 18.7%, watch him 3.1% |
| B18 | Styles (every pair 40-90% for the reader) | **PASS** | lowest 51.5%, highest 83.8% |
| C1 (core) | Equal paper holds (reader 55-65% at regional) | **PASS** | 64.2% |
| C2 (core) | He tires (starts 5-15% of his turns on 2 wind or less) | **PASS** | 11.0% of his turns |
| C3 (core) | Nobody is the heavier hitter (damage dealt and taken within 10%) | **FAIL** | dealt 59.9 and taken 52.8 a bout (ratio 1.13); 20.6% of wins with more head damage taken than given |
| C4 (core) | You set traps (the reader sets one on 30%+ of its turns) | **PASS** | 62.0% of its turns |
| C5 (core) | The set card is a fork (no kind over 55%; a trap down on 20-85% of his turns) | **PASS** | Cross counter 43.2, Check hook 27.8, Pull counter 29.1; a trap down on 57.9% of his turns |
| C6 (core) | No fixed answer to the set card (each of four forced answers 10+ under free choice) | **FAIL** | free 64.2%; always ignore 46.8%, jab first 54.8%, jabs only 38.2%, nothing 31.3% |
| C7 (core) | The answers spread (no class of first punch at a set card over 40%) | **PASS** | jab 38.1%, body jab 0.0%, cross or uppercut 16.9%, hook 23.2%, none 21.7% |
| C8 (core) | No breaker deck (no legal deck over 50% in the pro debut) | **FAIL** | best found: 59.7% (Jab, Jab, Jab, Parry, Cross, Cross, Cross, Lead hook, Lead hook, Block, Slip, Block, Tie up, Tie up); neutral deck 31.5% |
| C9 (core) | No pair is a key (no added pair lifts a pair-up by more than 25) | **FAIL** | biggest lift +25.4 (Parry v out) |
| C10 (core) | The table makes the skill a person can reach (table player closes half the gap, 10+ over the beginner) | **PASS** | beginner 18.1%, table player 52.4%, reader 64.2%: 74.5% of the gap |
| C11 (core) | No cliff (beginner 70%+ novice, 45-60% open class, 25-40% regional) | **FAIL** | beginner 83.1 / 48.1 / 18.1% |
| C12 (core) | Habits rule and flip (a habit on the table in 50%+ of his turns; the volley flips in 30%+ where one applies; B15) | **FAIL** | habit on the table in 79.1% of his turns; volley differs in 17.2% of 17059 turns where a known habit applies; B15 passes |
| D1 (core) | Fast and punchy (3-6 minutes: 22.5-45 decisions; 95% under 52) | **PASS** | reader 37.7 decisions = 5.0 min (95%: 43); table player 37.5 = 5.0 min (95%: 43) |
| D2 (core) | Guards are worth something (no guard -15, guard all -5, 30-70% of punches stopped, 2+ guards top-half somewhere) | **FAIL** | never guards 1.9%, guards all it can 61.9%, free 64.2%; 33.1% of punches stopped; top-half guards: Block, Slip, Roll, Parry, Tie up |
| D3 (core) | The chairs are equal (first thrower wins 45-55%, reader v reader) | **FAIL** | 41.1% (player chair 50.8%) |
| D4 (core) | Quick turns (choices at a decision under 10 on average, never over 20) | **PASS** | 5.0 on average, most 15 |
| D5 (core) | No trap deck (six traps under the neutral deck plus the best two) | **PASS** | six traps 2.5%, neutral + 2 Parry 48.6% |

Core bars (B1-B7, C1-C12, D1-D5): 14 of 24 pass. Supporting bars (B8-B18): 4 of 11 pass. Verdict: **FAIL**.

Reader by pair (player out, press, counter, volume; each v opponent out / press / counter / volume): 53.3, 51.5, 56.8, 69.3, 69.3, 83.8, 55.8, 62.8, 58.5, 61.5, 62.8, 80.3, 68.0, 68.5, 58.8, 66.3

Opponent class (beginner / table player / greedy / reader): novice 83.1 / 95.8 / 88.1 / 97.2, open class 48.1 / 85.7 / 57.9 / 91.0, regional 18.1 / 52.4 / 26.5 / 64.2, title 11.1 / 39.0 / 17.2 / 51.3, professional 3.8 / 20.2 / 7.3 / 29.3

Best fixed lines: 36.0% Lead hook > Check hook > Cross counter > Roll > Slip > Body jab > Uppercut > Tie up > Parry > Pull counter > Body hook > Block > Jab > Cross; 35.8% Cross counter > Jab > Tie up > Pull counter > Slip > Check hook > Block > Body hook > Cross > Roll > Lead hook > Uppercut > Body jab > Parry; 31.5% Slip > Tie up > Uppercut > Pull counter > Check hook > Parry > Cross counter > Lead hook > Body hook > Jab > Block > Cross > Roll > Body jab; 29.7% Cross counter > Uppercut > Lead hook > Parry > Tie up > Check hook > Body jab > Body hook > Block > Pull counter > Jab > Slip > Roll > Cross; 18.6% Parry > Slip > Roll > Block > Jab > Cross > Lead hook > Body hook > Uppercut > Body jab

Breaker search, final measure: 59.7% swap round 2: Roll out, Block in [Jab, Jab, Jab, Parry, Cross, Cross, Cross, Lead hook, Lead hook, Block, Slip, Block, Tie up, Tie up]; 57.0% swap round 2: Cross out, Jab in [Jab, Jab, Jab, Parry, Jab, Cross, Cross, Lead hook, Lead hook, Block, Slip, Roll, Tie up, Tie up]; 56.5% swap round 2: Jab out, Parry in [Parry, Jab, Jab, Parry, Cross, Cross, Cross, Lead hook, Lead hook, Block, Slip, Roll, Tie up, Tie up]; 54.7% swap round 1: Body jab out, Parry in [Jab, Jab, Jab, Parry, Cross, Cross, Cross, Lead hook, Lead hook, Block, Slip, Roll, Tie up, Tie up]; 54.4% swap round 1: Lead hook out, Body jab in [Jab, Jab, Jab, Body jab, Cross, Cross, Cross, Body jab, Lead hook, Block, Slip, Roll, Tie up, Tie up]

What two more copies of a card are worth (reader win %, neutral deck alone: 54.4, 84.9, 68.5, 76.4):

| card | v out | v press | v counter | v volume |
|---|---:|---:|---:|---:|
| Jab | 48.0 (7) | 82.6 (5) | 63.3 (6) | 64.8 (7) |
| Body jab | 52.0 (5) | 87.4 (2) | 71.5 (4) | 66.9 (5) |
| Cross | 44.3 (10) | 75.4 (8) | 49.9 (10) | 71.4 (3) |
| Lead hook | 52.9 (4) | 68.5 (10) | 45.8 (12) | 71.4 (3) |
| Body hook | 50.6 (6) | 66.0 (12) | 50.0 (9) | 55.1 (11) |
| Uppercut | 39.0 (11) | 59.6 (14) | 34.4 (14) | 65.1 (6) |
| Block | 48.0 (7) | 87.4 (2) | 63.9 (5) | 62.1 (9) |
| Slip | 53.8 (3) | 69.0 (9) | 73.9 (3) | 57.4 (10) |
| Roll | 33.9 (13) | 82.5 (6) | 61.9 (7) | 53.4 (12) |
| Parry | 79.8 (1) | 85.9 (4) | 84.1 (1) | 92.6 (1) |
| Tie up | 63.6 (2) | 93.1 (1) | 79.4 (2) | 75.8 (2) |
| Check hook | 46.8 (9) | 62.1 (13) | 45.9 (11) | 62.3 (8) |
| Cross counter | 35.8 (12) | 67.5 (11) | 57.6 (8) | 43.4 (14) |
| Pull counter | 33.3 (14) | 79.6 (7) | 42.5 (13) | 48.6 (13) |
