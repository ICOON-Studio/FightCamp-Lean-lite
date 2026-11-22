# CARDSCOPE2 - the bot probe of the card game scope, round 2 (S537)

Design: `ops/research/DESIGN_CARDGAME_SCOPE.md` (text marked [R2]; bars in sections 4 and 4b). Greybox: `proto/cardscope/`
(plain node, no page, no Godot). Round 1: `docs/CARDSCOPE1_PROBE.md`. Critic answered: `ops/research/CARDSCOPE1_CRITIC_SDK.md`
(6 / 5 / 6), items 1 to 6 and 10 of its list.
`node proto/cardscope/engine.test.mjs` -> RESULT: PASS - all 45 checks green.
`node proto/cardscope/probe.mjs fixed 2`, `ladder 2`, `info 2`, `cards 2`, `breaker 2`, then `report` print the tables below.

## Verdict: FAIL (run 2: 6 of 7 round 1 core bars, 4 of 12 round 2 bars; run 1: 5 of 7 and 6 of 12)

Taking turns to lead on equal paper works as a fight: the reader wins 58% at regional class with the same wind and hands
as the opponent, damage is level (7.0 dealt, 7.0 taken an exchange), the opponent's face-down card is a real mix (44%
punch, 30% guard or trap, 23% nothing), the reader lays a trap of its own on 38% of its leads, a known habit changes the
answer in 32% of the exchanges where it applies and is worth 5.3 points. It does not yet pass: a rule-of-thumb beginner
still wins 4% at regional class, a punch is still the answer to the hidden card half the time, guards are bottom-half
picks against every style, and each sizing made a different card the key (Body hook in run 1, Check hook in run 2).

## What was changed for round 2 (critic item -> change)

| Critic item | Change in the greybox |
|---|---|
| 1. Take turns to lead, equal paper | The lead changes hands every exchange (you lead 1 and 3, he leads 2 and 4), same exchange rules for both corners. No wind or power step for the opponent up to regional class; classes differ in how well he leads and answers. Title: top wind +1. Pro: top wind +1, heavier hands. |
| 2. The hidden card a fork | New card Check hook (the trap: catches a jab or a block for 6 and takes the next beat). Opponent decks re-cut with guards, the trap and a feint. Each opponent has two habits that rule his face-down card, one ending on a punch, one not. |
| 3. Close the breaker deck | Cross counter beats the cross only; a deck holds 12 to 16 cards, at most 4 of a card, at most 2 Cross counters; Tie up costs 2. |
| 4. The table does the sums | Designed (scope page 3.9). Its bar is a bot: the table player places one card at a time on the printed numbers only. |
| 5. Smooth the cliff | Bout 3 adds the hidden card and nothing else; his numbers move only from the title bout. The critic's rule-of-thumb player is in the harness as the beginner bot. |
| 6. Knowledge flips answers | A known habit prints its card on the face-down slot when its trigger is on the table; the reader keeps a tally of what lay face down on each beat and after each shown card. |
| 10. Two code faults | A level judge goes to damage, then the last exchange, then a coin from the seed (tested: it falls both ways). His corner picks every corner card (tested). |
| Also needed to make 1 work | Body work lowers the wind he gets back (so a boxer can be found on 1 wind); corner sizes (water is full wind only, ice 30); head points 95 and the knockdown line sized for level damage. |

## How it was run

- Bots in the player's chair: random; the best of all 4,096 fixed three-card lines (searched, then re-measured on fresh
  seeds with each choice of face-down beat); greedy (most damage now); reader (public information only); all-seeing (the
  reader shown his face-down card: a ceiling); beginner (the critic's rule of thumb); table player (scope page 4b).
- Population: 4 player boxers x 4 opponent boxers from other clubs, one of each style, all different in cards and numbers,
  never the same boxer on both sides; 500 bouts a pair a bot; card table 3,000 bouts a cell; 1,200 runs of 8 bouts;
  breaker search 17 decks and two rounds of one-card swaps, the best five re-measured on 1,000 bouts.
- The round 2 bars were written and committed (54e078a58) before any round 2 code ran and were not edited afterwards.
  Two wordings were fixed in the instruments, not the bars: the "no counting" arm of B15 now ignores his discard pile
  entirely (in round 1 it still dropped cards that had run out), and "bottom half" in B6 is ranks 8 to 14 of 14 cards.
- Before run 1 the numbers were sized on separate seeds (300000 and up, `calib.mjs`, `diag.mjs`): the classes, head
  points, the knockdown line, the corner, how body work takes wind, and the reader's own weights (it was losing to the
  damage chaser until it valued wind and took water in the corner). The bar tables ran on the probe's own seeds.
- Two measured runs: run 1 as sized; run 2 after the one resize the brief allows (numbers only: Body hook costs 3 not 2,
  knockdown line 24 / 18 not 22 / 16, he keeps a habit 90 not 85 times in 100). **The third run (one design change) was
  not spent**: what still fails needs the design work named below, not one more patch, and the method rule of this
  project (findings drive the queue) says to scope that first.
- Bots are not people: nothing below says a person enjoys it.

## What failed, and the cause in the design

| Bar | Run 1 | Run 2 | Cause |
|---|---|---|---|
| C11 no cliff (beginner 70+ / 45-60 / 25-40) | 78.8 / 44.2 / 5.7 | 81.0 / 43.1 / 4.3 | Novice passes, open class is 2 short, regional is far off. Equal paper did not close the gap, so the cliff was never the paper. The rule of thumb guards what it sees and never throws when he shows punches: as the answering boxer it deals 2.5 damage and takes 5.5, where the reader deals 8 and takes 4. With the opponent loose enough for the beginner to win 38%, the reader wins 92% (sizing run). "Guard what you see" has to become a sound line by rule. |
| C10 the table (half the gap) | 38.3% | 46.2% | The table player answers almost as well as the greedy bot (29.0 v 30.8) with one card placed at a time, so the sums are reachable. It stops short because the table cannot help its lead: it leads like the beginner and spends all its wind there. |
| C6 no fixed answer to the hidden card | block -22, jab -8, punch -5, empty -17 | block -30, jab -11, punch -9, empty -22 | Three of four pass in run 2. "Always a punch" is 1.4 short: with nothing face down 23% of the time and a trap that only catches jabs and blocks, a cross or a hook into the unknown is rarely punished. |
| C7 answers spread (none over 40%) | punch 47.7 | punch 50.4 | Same cause. The reader's answers to the hidden card are a punch or nothing (83%); a block or an evade is one answer in six. |
| C2 he tires (5-15%) | 6.6% PASS | 2.3% | Only body work can put a boxer on 1 wind. Run 1 passed with the Body hook at 2 wind; it was then the key card (+47), so the resize made it dearer and he stopped tiring. Tiring and "no key card" pull on the same number. |
| C8 no breaker deck (50%) | 46.5% PASS | 61.1% | Run 2: four Check hooks win the pro debut 61% (neutral deck 10%). The trap is too good in bulk against opponents who jab and block. A copy limit of 2, as for the Cross counter, is the obvious rule; not measured. |
| C9 no pair is a key (25) | +47.2 Body hook v out-boxer | +50.6 Check hook v out-boxer | Wind is the strongest currency on equal paper (one more wind an exchange for a round was worth 25 points in sizing), and both cards take his next action away. |
| C12 habits rule and flip | 66.5% / 29.9% / B15 fails | 70.8% / 31.9% / B15 fails | The two new parts pass in run 2. It fails only through B15's second half: counting his discards is worth 0.9 (bar 3). Knowing both habits is worth 5.3 (bar 4). |
| B6 every card has a matchup (round 1 core) | 13 of 14 flat | 13 of 14 flat | The card table has the same order against every style: Check hook, Body hook, Body jab on top; Block, Slip, Roll, Step back, Feint at the bottom everywhere. More guards never help because the answering boxer wins by hitting, and the leader's guards are seen. |
| B5 decided late (30%) | 27.8% | 30.6% PASS | Fewer knockdown rounds after the resize (0.30 a bout, was 0.74). |
| B8 ladder of skill | fails on one step | same | Random 0.8, fixed 0.0, greedy 30.8, reader 57.8, all-seeing 65.7. Only "fixed above random" fails: no fixed line wins a bout. Reader over greedy by 27. |
| B10 showing beats guessing | 51.6 / 60.4 / 57.1 / 50.7 | 50.6 / 61.6 / 58.7 / 45.8 | The dial now turns for both corners, so hiding more also protects the reader's own leads. The reader's lead over random is best with one card shown, worst with all three. The bar was written for a game where only he led. |
| B11 stoppages 10-25% | 3.2%, 0.74 knockdowns | 1.8%, 0.30 | On level damage (84 a bout against 95 head points) few bouts end early. The damage chaser stops or is stopped far more often; the reader boxes safely. |
| B15 film and counting | +4.4 / +1.6 | +5.3 / +0.9 | Film passes its half. Counting does not pay; round 1 said the same. |
| B16 he reads you back (8) | 0.6 | 1.7 | Fixed lines win nothing either way; a reader who always blocks the hidden card loses 1.7 more to the adapting opponent. |
| B18 styles 40-90% | 8.2 to 94.0 | 16.8 to 87.6 | The counter-puncher and the pressure fighter against the volume puncher (17 to 19%). Content sizing. |

Passed in both runs: B1 to B4, B7, B9, B12 to B14, B17, C1, C3, C4, C5.

## Run 2 - after the one resize (the greybox as committed)

Population: 4 player boxers x 4 opponents (16 pairs), regional class, 500 bouts a pair. Card table: neutral 12-card deck + 2 copies of one card v each opponent boxer, reader, 3000 bouts a cell. Run: 1200 runs of 8 bouts. Breaker: pro debut (class 5, four rounds), reader, neutral boxer with the deck v each of 4 opponents; final measure 250 bouts an opponent.

| # | Bar | Result | Measured |
|---|---|---|---|
| B1 (core) | Reading beats a fixed line (15+) | **PASS** | reader 57.8% v best fixed line 0.0% = +57.8 (- / - / -, hides beat 1) |
| B2 (core) | Thinking beats not thinking (30+) | **PASS** | reader 57.8% v random 0.8% = +57.0 |
| B3 (core) | No line that needs no reading (best fixed under 45%, 10+ under the reader) | **PASS** | best fixed 0.0% on fresh seeds (screen best 0.0%) |
| B4 (core) | Close fights (one-sided under 35%) | **PASS** | 24.9% one-sided |
| B5 (core) | Decided late (30%+ won from level or behind after round 2) | **PASS** | 30.6% |
| B6 (core) | Every card has a matchup (top four v one style, bottom half v another) | **FAIL** | no matchup swing: Jab, Body jab, Cross, Lead hook, Body hook, Uppercut, Cross counter, Block high, Slip, Roll, Step back, Feint, Check hook |
| B7 (core) | The run has choices (3+ wide offers a run; informed picks beat random picks) | **PASS** | 7.23 wide offers of 7.47 a run; bouts won: informed 67.0%, random pick 59.9%, no pick 58.4%; wins a run 5.01 v 4.16 |
| B8 | A ladder of skill (random < fixed < greedy < reader < all-seeing; reader 8+ over greedy) | **FAIL** | 0.8 / 0.0 / 30.8 / 57.8 / 65.7 |
| B9 | The hidden card is a bet, not the game (all-seeing 5 to 20 over the reader) | **PASS** | +7.9 |
| B10 | Showing beats guessing (reader lead over random 10+ bigger with 2 shown than with 0) | **FAIL** | lead over random with 0 / 1 / 2 / 3 cards shown: 50.6 / 61.6 / 58.7 / 45.8 |
| B11 | Stoppages 10-25%, knockdowns 0.3-1.0 a bout, round-1 stoppages under 3% | **FAIL** | 1.8% stopped, 0.30 knockdowns a bout, 0.0% in round 1 |
| B12 | No blanks (no punch lands in under 15% of exchanges; dead beats under 25%) | **PASS** | 3.8% of exchanges, 17.9% of beats |
| B13 | No dead card, no card for everything (3%+ where held, none over 30%) | **PASS** | share of cards played: Jab 26.9, Body jab 4.6, Cross 18.1, Lead hook 15.1, Body hook 3.4, Uppercut 2.4, Cross counter 2.0, Block high 13.1, Slip 3.6, Roll 2.6, Step back 0.8, Tie up 1.8, Feint 0.0, Check hook 5.7 |
| B14 | Split cards (15%+ of points decisions) | **PASS** | 21.9% |
| B15 | Film and counting pay (habits known 4+, counting 3+) | **FAIL** | both habits known +5.3 (one habit +3.7), counting +0.9, watching him +3.8 (reader 57.8%) |
| B16 | He reads you back (best fixed line loses 8+ to the adapting opponent) | **FAIL** | fixed line 0.0% v a non-adapting opponent, 0.0% v the adapting one; a reader who always blocks high on the hidden card: 29.8% v 28.1% |
| B17 | The corner is a decision (informed 3+ over random; each card 15%+ of informed picks) | **PASS** | informed 57.8%, random 52.9%, always water 52.1%, ice 55.2%, watch him 48.9%; informed picks water 26.2%, ice 33.2%, watch him 40.6% |
| B18 | Styles (every pair 40-90% for the reader) | **FAIL** | lowest 16.8%, highest 87.6% |
| C1 (core) | Equal paper holds (reader 55-65% at regional, same wind and hands) | **PASS** | 57.8% |
| C2 (core) | He tires (starts 5-15% of exchanges on 1 wind or less) | **FAIL** | 2.3% of exchanges |
| C3 (core) | Nobody is the heavier hitter (damage dealt and taken within 10%) | **PASS** | dealt 7.0 and taken 7.0 an exchange (ratio 1.00); 28.4% of wins with more head damage taken than given |
| C4 (core) | You set traps (your face-down card is not a punch in 30%+ of leads) | **PASS** | 38.0% of the reader's leads |
| C5 (core) | The hidden card is a fork (punch under 55%, guard or trap 20%+, nothing or feint 15%+) | **PASS** | punch 43.8%, guard or trap 30.3%, nothing 22.5%, feint 3.4% |
| C6 (core) | No fixed answer to the hidden card (always block / jab / punch / empty each 10+ under free choice) | **FAIL** | free 57.8%; always block 28.1%, jab 47.1%, a punch 49.2%, empty 36.3% |
| C7 (core) | The answers spread (no class of answer to the hidden card over 40%) | **FAIL** | punch 50.4%, block 9.0%, evade or tie up 7.7%, nothing 33.0%, feint 0.0% |
| C8 (core) | No breaker deck (no legal deck over 50% in the pro debut) | **FAIL** | best of 17 decks and 2 swap rounds: 61.1% (2 Jab, 2 Body jab, 1 Cross, 2 Block high, 1 Slip, 4 Check hook); neutral deck 10.2% |
| C9 (core) | No pair is a key (no added pair lifts a pair-up by more than 25) | **FAIL** | biggest lift +50.6 (Check hook v out) |
| C10 (core) | The table makes the skill a person's (table player closes half the beginner-reader gap, 10+ over the beginner) | **FAIL** | beginner 4.3%, table player 29.0%, reader 57.8%: 46.2% of the gap |
| C11 (core) | No cliff (beginner 70%+ novice, 45-60% open class, 25-40% regional) | **FAIL** | beginner 81.0 / 43.1 / 4.3% |
| C12 (core) | Habits rule and flip (a habit on the table in 50%+ of his leads; the answer flips in 30%+ where one applies; B15) | **FAIL** | habit on the table in 70.8% of his leads; answer differs in 31.9% of 24215 exchanges where a known habit applies; B15 fails |

Round 1 core bars (B1-B7): 6 of 7 pass. Round 2 bars (C1-C12): 4 of 12 pass. Supporting bars (B8-B18): 5 of 11 pass. Verdict: **FAIL**.

Reader by pair (player style v opponent style): out v out 76.8, out v press 75.0, out v counter 85.8, out v volume 76.4, press v out 59.4, press v press 51.6, press v counter 84.2, press v volume 18.6, counter v out 40.2, counter v press 41.8, counter v counter 55.0, counter v volume 16.8, volume v out 54.0, volume v press 69.8, volume v counter 87.6, volume v volume 31.8

Opponent class (beginner / table player / greedy / reader): novice 81.0 / 91.4 / 91.2 / 93.6, open class 43.1 / 83.2 / 81.5 / 91.1, regional 4.3 / 29.7 / 31.2 / 58.6, title 1.9 / 18.6 / 20.9 / 46.6, professional 0.5 / 6.7 / 7.6 / 27.8

Cards shown by the leader 0 / 1 / 2 / 3 - random, greedy, reader, all-seeing: [0] 6.9, 42.8, 57.5, 91.6  [1] 2.9, 37.6, 64.5, 82.3  [2] 1.1, 31.3, 59.8, 68.9  [3] 0.3, 39.2, 46.1, 46.1

Best fixed lines found: - / - / - (hides beat 1) 0.0%; - / - / - (hides beat 2) 0.0%; - / - / - (hides beat 3) 0.0%; - / - / Jab (hides beat 1) 0.0%; - / - / Jab (hides beat 2) 0.0%; - / - / Jab (hides beat 3) 0.0%

Breaker search, final measure: 61.1% swap round 2: Jab out, Body jab in [2 Jab, 2 Body jab, 1 Cross, 2 Block high, 1 Slip, 4 Check hook]; 47.9% swap round 1: Cross out, Body jab in [3 Jab, 1 Body jab, 1 Cross, 2 Block high, 1 Slip, 4 Check hook]; 40.8% Check hook stacked to its limit [3 Jab, 2 Cross, 2 Block high, 1 Slip, 4 Check hook]; 29.7% Body hook stacked to its limit [3 Jab, 2 Cross, 4 Body hook, 2 Block high, 1 Slip]; 27.4% Body jab stacked to its limit [3 Jab, 4 Body jab, 2 Cross, 2 Block high, 1 Slip]

What two more copies of a card are worth (reader win %, neutral deck alone: out 20.5, press 38.3, counter 56.4, volume 10.5):

| card | v out | v press | v counter | v volume |
|---|---:|---:|---:|---:|
| Jab | 19.1 (9) | 41.6 (5) | 59.3 (6) | 12.5 (6) |
| Body jab | 40.0 (3) | 58.2 (1) | 75.3 (3) | 29.6 (2) |
| Cross | 19.2 (8) | 36.9 (6) | 58.4 (8) | 10.6 (7) |
| Lead hook | 30.4 (4) | 41.8 (4) | 67.0 (4) | 13.1 (5) |
| Body hook | 50.5 (2) | 43.5 (3) | 83.3 (1) | 18.1 (3) |
| Uppercut | 24.1 (6) | 32.6 (8) | 62.5 (5) | 9.5 (8) |
| Cross counter | 26.4 (5) | 26.5 (10) | 58.9 (7) | 6.9 (9) |
| Block high | 12.0 (11) | 24.0 (11) | 33.3 (11) | 6.4 (10) |
| Slip | 14.0 (10) | 16.6 (14) | 29.0 (14) | 6.4 (11) |
| Roll | 10.1 (12) | 27.0 (9) | 34.0 (10) | 6.3 (12) |
| Step back | 9.1 (14) | 22.9 (12) | 31.1 (12) | 5.1 (13) |
| Tie up | 22.6 (7) | 35.2 (7) | 45.8 (9) | 15.3 (4) |
| Feint | 9.2 (13) | 18.1 (13) | 30.8 (13) | 4.6 (14) |
| Check hook | 71.1 (1) | 46.8 (2) | 81.2 (2) | 34.7 (1) |

## Run 1 - as sized before the first measured run

Population: 4 player boxers x 4 opponents (16 pairs), regional class, 500 bouts a pair. Card table: neutral 12-card deck + 2 copies of one card v each opponent boxer, reader, 3000 bouts a cell. Run: 1200 runs of 8 bouts. Breaker: pro debut (class 5, four rounds), reader, neutral boxer with the deck v each of 4 opponents; final measure 250 bouts an opponent.

| # | Bar | Result | Measured |
|---|---|---|---|
| B1 (core) | Reading beats a fixed line (15+) | **PASS** | reader 58.4% v best fixed line 0.0% = +58.4 (- / - / -, hides beat 1) |
| B2 (core) | Thinking beats not thinking (30+) | **PASS** | reader 58.4% v random 1.0% = +57.4 |
| B3 (core) | No line that needs no reading (best fixed under 45%, 10+ under the reader) | **PASS** | best fixed 0.0% on fresh seeds (screen best 0.0%) |
| B4 (core) | Close fights (one-sided under 35%) | **PASS** | 31.9% one-sided |
| B5 (core) | Decided late (30%+ won from level or behind after round 2) | **FAIL** | 27.8% |
| B6 (core) | Every card has a matchup (top four v one style, bottom half v another) | **FAIL** | no matchup swing: Jab, Body jab, Cross, Lead hook, Body hook, Cross counter, Block high, Slip, Roll, Step back, Tie up, Feint, Check hook |
| B7 (core) | The run has choices (3+ wide offers a run; informed picks beat random picks) | **PASS** | 7.34 wide offers of 7.68 a run; bouts won: informed 71.2%, random pick 62.1%, no pick 61.9%; wins a run 5.47 v 4.42 |
| B8 | A ladder of skill (random < fixed < greedy < reader < all-seeing; reader 8+ over greedy) | **FAIL** | 1.0 / 0.0 / 30.8 / 58.4 / 64.4 |
| B9 | The hidden card is a bet, not the game (all-seeing 5 to 20 over the reader) | **PASS** | +6.0 |
| B10 | Showing beats guessing (reader lead over random 10+ bigger with 2 shown than with 0) | **FAIL** | lead over random with 0 / 1 / 2 / 3 cards shown: 51.6 / 60.4 / 57.1 / 50.7 |
| B11 | Stoppages 10-25%, knockdowns 0.3-1.0 a bout, round-1 stoppages under 3% | **FAIL** | 3.2% stopped, 0.74 knockdowns a bout, 0.0% in round 1 |
| B12 | No blanks (no punch lands in under 15% of exchanges; dead beats under 25%) | **PASS** | 3.9% of exchanges, 18.9% of beats |
| B13 | No dead card, no card for everything (3%+ where held, none over 30%) | **PASS** | share of cards played: Jab 26.4, Body jab 4.3, Cross 17.8, Lead hook 14.8, Body hook 6.9, Uppercut 2.2, Cross counter 2.0, Block high 12.1, Slip 3.5, Roll 2.2, Step back 0.8, Tie up 1.5, Feint 0.0, Check hook 5.7 |
| B14 | Split cards (15%+ of points decisions) | **PASS** | 15.4% |
| B15 | Film and counting pay (habits known 4+, counting 3+) | **FAIL** | both habits known +4.4 (one habit +3.4), counting +1.6, watching him +2.9 (reader 58.4%) |
| B16 | He reads you back (best fixed line loses 8+ to the adapting opponent) | **FAIL** | fixed line 0.0% v a non-adapting opponent, 0.0% v the adapting one; a reader who always blocks high on the hidden card: 37.0% v 36.4% |
| B17 | The corner is a decision (informed 3+ over random; each card 15%+ of informed picks) | **PASS** | informed 58.4%, random 53.5%, always water 52.8%, ice 54.5%, watch him 50.3%; informed picks water 24.2%, ice 32.6%, watch him 43.2% |
| B18 | Styles (every pair 40-90% for the reader) | **FAIL** | lowest 8.2%, highest 94.0% |
| C1 (core) | Equal paper holds (reader 55-65% at regional, same wind and hands) | **PASS** | 58.4% |
| C2 (core) | He tires (starts 5-15% of exchanges on 1 wind or less) | **PASS** | 6.6% of exchanges |
| C3 (core) | Nobody is the heavier hitter (damage dealt and taken within 10%) | **PASS** | dealt 7.0 and taken 7.0 an exchange (ratio 0.99); 25.1% of wins with more head damage taken than given |
| C4 (core) | You set traps (your face-down card is not a punch in 30%+ of leads) | **PASS** | 32.8% of the reader's leads |
| C5 (core) | The hidden card is a fork (punch under 55%, guard or trap 20%+, nothing or feint 15%+) | **PASS** | punch 45.1%, guard or trap 28.6%, nothing 22.6%, feint 3.8% |
| C6 (core) | No fixed answer to the hidden card (always block / jab / punch / empty each 10+ under free choice) | **FAIL** | free 58.4%; always block 36.4%, jab 50.0%, a punch 53.2%, empty 41.4% |
| C7 (core) | The answers spread (no class of answer to the hidden card over 40%) | **FAIL** | punch 47.7%, block 8.4%, evade or tie up 6.2%, nothing 37.7%, feint 0.0% |
| C8 (core) | No breaker deck (no legal deck over 50% in the pro debut) | **PASS** | best of 17 decks and 2 swap rounds: 46.5% (3 Jab, 2 Cross, 3 Body hook, 1 Uppercut, 1 Block high, 1 Slip, 1 Check hook); neutral deck 14.0% |
| C9 (core) | No pair is a key (no added pair lifts a pair-up by more than 25) | **FAIL** | biggest lift +47.2 (Body hook v out) |
| C10 (core) | The table makes the skill a person's (table player closes half the beginner-reader gap, 10+ over the beginner) | **FAIL** | beginner 5.7%, table player 25.9%, reader 58.4%: 38.3% of the gap |
| C11 (core) | No cliff (beginner 70%+ novice, 45-60% open class, 25-40% regional) | **FAIL** | beginner 78.8 / 44.2 / 5.7% |
| C12 (core) | Habits rule and flip (a habit on the table in 50%+ of his leads; the answer flips in 30%+ where one applies; B15) | **FAIL** | habit on the table in 66.5% of his leads; answer differs in 29.9% of 21281 exchanges where a known habit applies; B15 fails |

Round 1 core bars (B1-B7): 5 of 7 pass. Round 2 bars (C1-C12): 6 of 12 pass. Supporting bars (B8-B18): 5 of 11 pass. Verdict: **FAIL**.

Reader by pair (player style v opponent style): out v out 76.2, out v press 28.2, out v counter 87.2, out v volume 67.6, press v out 94.0, press v press 48.2, press v counter 93.8, press v volume 57.6, counter v out 39.6, counter v press 8.2, counter v counter 49.4, counter v volume 14.8, volume v out 75.2, volume v press 48.6, volume v counter 89.6, volume v volume 56.8

Opponent class (beginner / table player / greedy / reader): novice 78.8 / 89.5 / 90.2 / 94.7, open class 44.2 / 79.2 / 80.8 / 90.9, regional 5.7 / 26.5 / 31.4 / 58.2, title 3.2 / 18.0 / 22.0 / 50.3, professional 1.1 / 6.2 / 7.9 / 28.6

Cards shown by the leader 0 / 1 / 2 / 3 - random, greedy, reader, all-seeing: [0] 7.4, 46.6, 59.0, 88.5  [1] 2.7, 36.9, 63.1, 78.9  [2] 1.0, 31.6, 58.1, 66.4  [3] 0.4, 35.6, 51.1, 51.1

Best fixed lines found: - / - / - (hides beat 1) 0.0%; - / - / - (hides beat 2) 0.0%; - / - / - (hides beat 3) 0.0%; - / - / Jab (hides beat 1) 0.0%; - / - / Jab (hides beat 2) 0.0%; - / - / Jab (hides beat 3) 0.0%

Breaker search, final measure: 46.5% swap round 2: Block high out, Uppercut in [3 Jab, 2 Cross, 3 Body hook, 1 Uppercut, 1 Block high, 1 Slip, 1 Check hook]; 39.4% swap round 1: Body hook out, Check hook in [3 Jab, 2 Cross, 3 Body hook, 2 Block high, 1 Slip, 1 Check hook]; 38.0% Body hook stacked to its limit [3 Jab, 2 Cross, 4 Body hook, 2 Block high, 1 Slip]; 24.2% Check hook stacked to its limit [3 Jab, 2 Cross, 2 Block high, 1 Slip, 4 Check hook]; 19.9% Uppercut stacked to its limit [3 Jab, 2 Cross, 4 Uppercut, 2 Block high, 1 Slip]

What two more copies of a card are worth (reader win %, neutral deck alone: out 43.6, press 19.1, counter 64.0, volume 24.2):

| card | v out | v press | v counter | v volume |
|---|---:|---:|---:|---:|
| Jab | 37.2 (8) | 18.3 (5) | 64.7 (7) | 22.5 (7) |
| Body jab | 62.1 (3) | 30.8 (2) | 73.1 (4) | 36.1 (3) |
| Cross | 42.7 (7) | 17.0 (7) | 68.8 (6) | 19.7 (8) |
| Lead hook | 50.8 (5) | 19.3 (4) | 73.1 (5) | 26.1 (4) |
| Body hook | 90.8 (1) | 46.5 (1) | 88.5 (1) | 55.8 (1) |
| Uppercut | 54.9 (4) | 15.5 (8) | 73.6 (3) | 23.3 (6) |
| Cross counter | 45.9 (6) | 7.8 (12) | 62.3 (8) | 14.5 (9) |
| Block high | 23.2 (11) | 9.6 (10) | 39.6 (11) | 13.0 (10) |
| Slip | 28.7 (10) | 6.0 (14) | 35.0 (14) | 12.6 (11) |
| Roll | 22.1 (12) | 11.4 (9) | 39.8 (10) | 12.3 (12) |
| Step back | 20.5 (14) | 8.3 (11) | 37.7 (12) | 11.1 (13) |
| Tie up | 36.5 (9) | 17.2 (6) | 51.3 (9) | 24.6 (5) |
| Feint | 20.8 (13) | 7.0 (13) | 37.3 (13) | 10.5 (14) |
| Check hook | 84.0 (2) | 19.4 (3) | 83.8 (2) | 41.7 (2) |
