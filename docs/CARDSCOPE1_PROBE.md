# CARDSCOPE1 - the bot probe of the card game scope (S537)

Design: `ops/research/DESIGN_CARDGAME_SCOPE.md`. Greybox: `proto/cardscope/` (plain node, no page, no Godot).
`node proto/cardscope/engine.test.mjs` -> RESULT: PASS - all 32 checks green.
`node proto/cardscope/probe.mjs ladder 2`, `info 2`, `cards 2`, then `report` print the table below.

## Verdict: FAIL on one core bar (6 of 7 core, 6 of 11 supporting)

The exchange itself passes: reading beats every fixed line, thinking beats damage-chasing, fights are close, a third
turn late, stoppages are honest, the run has real picks. The card pool fails: two cards are right against everybody
(Cross counter, Tie up) and one is wrong against everybody (Feint). Causes and owners: section 6 of the design page.

## How it was run

- Bots in the player's chair: random; the best of all 3,375 fixed three-card lines (searched, then re-measured on fresh
  seeds); greedy (sees the face-up cards, most damage now); reader (public information only); all-seeing (the reader
  shown the hidden card: a ceiling, not a legal player).
- Population: 4 player boxers x 4 opponent boxers from other clubs, one of each style, all different in cards and numbers,
  never the same boxer on both sides; 500 bouts a pair a bot (8,000 a bot); card table 3,000 bouts a cell; 1,200 runs.
- The bars were written and committed (e06a8f4d6) before the first run and not edited afterwards.
- Three measured runs: as written; one resize (numbers only); one design change. Between runs the sizes were chosen on
  separate seeds (300000 and up) looking at win rate, stoppages, one-sided and late shares; each bar table ran on the
  probe's own seeds. No fourth run.
- Bots are not people: nothing below says a person enjoys it.

## Run 3 - the design as it stands (after the design change)

Population: 4 player boxers x 4 opponents (16 pairs), regional class, 500 bouts a pair. Card table: neutral 12-card deck + 2 copies of one card v each opponent boxer, reader, 3000 bouts a cell. Run: 1200 runs of 8 bouts.

| # | Bar | Result | Measured |
|---|---|---|---|
| B1 (core) | Reading beats a fixed line (15+) | **PASS** | reader 63.0% v best fixed line 0.0% = +63.0 (- / - / -) |
| B2 (core) | Thinking beats not thinking (30+) | **PASS** | reader 63.0% v random 0.0% = +63.0 |
| B3 (core) | No line that needs no reading (best fixed under 45%, 10+ under the reader) | **PASS** | best fixed 0.0% on fresh seeds (screen best 0.0%) |
| B4 (core) | Close fights (one-sided under 35%) | **PASS** | 12.3% one-sided |
| B5 (core) | Decided late (30%+ won from level or behind after round 2) | **PASS** | 31.4% |
| B6 (core) | Every card has a matchup (top four v one style, bottom half v another) | **FAIL** | no matchup swing: Cross, Lead hook, Body hook, Uppercut, Cross counter, Block high, Roll, Step back, Tie up, Feint |
| B7 (core) | The run has choices (3+ wide offers a run; informed picks beat random picks) | **PASS** | 7.64 wide offers of 7.72 a run; bouts won: informed 76.9%, random pick 58.9%, no pick 56.9%; wins a run 5.93 v 3.91 |
| B8 | A ladder of skill (random < fixed < greedy < reader < all-seeing; reader 8+ over greedy) | **FAIL** | 0.0 / 0.0 / 38.9 / 63.0 / 80.0 |
| B9 | The hidden card is a bet, not the game (all-seeing 5 to 20 over the reader) | **PASS** | +17.0 |
| B10 | Showing beats guessing (reader lead over random 10+ bigger with 2 shown than with 0) | **PASS** | lead over random with 0 / 1 / 2 / 3 cards shown: 11.0 / 26.0 / 55.4 / 80.1 |
| B11 | Stoppages 10-25%, knockdowns 0.3-1.0 a bout, round-1 stoppages under 3% | **PASS** | 10.8% stopped, 0.52 knockdowns a bout, 0.0% in round 1 |
| B12 | No blanks (no punch lands in under 15% of exchanges; dead beats under 25%) | **PASS** | 4.0% of exchanges, 13.0% of beats |
| B13 | No dead card, no card for everything (3%+ where held, none over 30%) | **PASS** | share of cards played: Jab 24.5, Body jab 3.2, Cross 15.6, Lead hook 14.0, Body hook 2.9, Uppercut 1.9, Cross counter 2.4, Block high 18.7, Slip 7.9, Roll 2.8, Step back 2.0, Tie up 2.3, Feint 1.6 |
| B14 | Split cards (15%+ of points decisions) | **PASS** | 49.9% |
| B15 | Film and counting pay (habits known 4+, counting 3+) | **FAIL** | film +1.7, counting +-1.0, watching his patterns +1.3 (reader 63.0%) |
| B16 | He reads you back (best fixed line loses 8+ to the adapting opponent) | **FAIL** | fixed line 0.0% v a non-adapting opponent, 0.0% v the adapting one; a reader who always blocks high on the hidden card: 34.3% v 41.4% |
| B17 | The corner is a decision (informed 3+ over random; each card 15%+ of informed picks) | **FAIL** | informed 63.0%, random 61.4%, always water 62.3%, ice 57.0%, watch him 55.5%; informed picks water 2.2%, ice 39.0%, watch him 58.8% |
| B18 | Styles (every pair 40-90% for the reader) | **FAIL** | lowest 28.4%, highest 100.0% |

Core bars: 6 of 7 pass. Supporting bars: 6 of 11 pass. Verdict: **FAIL**.

Reader by pair (player style v opponent style): out v out 69.6, out v press 62.2, out v counter 67.8, out v volume 100.0, press v out 42.2, press v press 54.0, press v counter 75.8, press v volume 49.2, counter v out 91.4, counter v press 28.4, counter v counter 82.8, counter v volume 53.8, volume v out 54.0, volume v press 66.8, volume v counter 38.8, volume v volume 71.8

Opponent class (greedy / reader): novice 95.9 / 97.5, open class 54.9 / 76.9, regional 39.0 / 64.1, title 27.3 / 44.2, professional 14.3 / 27.0

Cards shown 0 / 1 / 2 / 3 - random, greedy, reader, all-seeing: [0] 0.0, 7.8, 11.0, 82.4  [1] 0.1, 17.0, 26.1, 80.8  [2] 0.1, 38.8, 55.5, 81.8  [3] 0.0, 67.2, 80.1, 80.1

Best fixed lines found: - / - / - 0.0%; - / - / Jab 0.0%; - / - / Body jab 0.0%; - / - / Cross 0.0%; - / - / Lead hook 0.0%; - / - / Body hook 0.0%

What two more copies of a card are worth (reader win %, neutral deck alone: out 36.5, press 34.1, counter 67.6, volume 22.2):

| card | v out | v press | v counter | v volume |
|---|---:|---:|---:|---:|
| Jab | 25.2 (8) | 49.4 (3) | 58.0 (8) | 37.5 (4) |
| Body jab | 40.0 (5) | 60.7 (1) | 61.5 (7) | 28.7 (6) |
| Cross | 26.0 (7) | 21.4 (9) | 41.6 (12) | 30.7 (5) |
| Lead hook | 23.8 (10) | 25.3 (8) | 62.2 (6) | 27.4 (7) |
| Body hook | 24.4 (9) | 19.9 (10) | 57.3 (9) | 5.8 (12) |
| Uppercut | 19.7 (11) | 15.2 (12) | 47.7 (11) | 18.3 (8) |
| Cross counter | 98.3 (1) | 48.2 (4) | 94.7 (1) | 80.4 (1) |
| Block high | 55.1 (4) | 47.6 (5) | 80.4 (3) | 42.2 (3) |
| Slip | 59.5 (3) | 15.8 (11) | 74.5 (4) | 14.1 (9) |
| Roll | 13.3 (13) | 30.4 (6) | 48.8 (10) | 8.6 (10) |
| Step back | 35.4 (6) | 28.4 (7) | 68.9 (5) | 7.7 (11) |
| Tie up | 67.7 (2) | 60.3 (2) | 83.6 (2) | 71.9 (2) |
| Feint | 13.7 (12) | 13.4 (13) | 38.9 (13) | 4.7 (13) |

## Run 2 - after the one resize (numbers only)

Changed from run 1: damage doubled for finer steps; a block stops 4 (it stopped nearly everything); slip, roll and step
back cost 2; knockdown line and head points sized from measured damage (a normal exchange does about 10, one in twenty
does 20); the opponent better on paper (more wind, heavier hands).

Population: 4 player boxers x 4 opponents (16 pairs), regional class, 500 bouts a pair. Card table: neutral 12-card deck + 2 copies of one card v each opponent boxer, reader, 3000 bouts a cell. Run: 1200 runs of 8 bouts.

| # | Bar | Result | Measured |
|---|---|---|---|
| B1 (core) | Reading beats a fixed line (15+) | **PASS** | reader 66.8% v best fixed line 0.0% = +66.8 (Cross / Slip / Cross counter) |
| B2 (core) | Thinking beats not thinking (30+) | **PASS** | reader 66.8% v random 0.1% = +66.7 |
| B3 (core) | No line that needs no reading (best fixed under 45%, 10+ under the reader) | **PASS** | best fixed 0.0% on fresh seeds (screen best 0.0%) |
| B4 (core) | Close fights (one-sided under 35%) | **PASS** | 29.2% one-sided |
| B5 (core) | Decided late (30%+ won from level or behind after round 2) | **FAIL** | 21.4% |
| B6 (core) | Every card has a matchup (top four v one style, bottom half v another) | **FAIL** | no matchup swing: Lead hook, Body hook, Cross counter, Block high, Tie up, Feint |
| B7 (core) | The run has choices (3+ wide offers a run; informed picks beat random picks) | **PASS** | 6.3 wide offers of 7.79 a run; bouts won: informed 79.3%, random pick 68.5%, no pick 65.5%; wins a run 6.18 v 5.07 |
| B8 | A ladder of skill (random < fixed < greedy < reader < all-seeing; reader 8+ over greedy) | **FAIL** | 0.1 / 0.0 / 45.7 / 66.8 / 79.0 |
| B9 | The hidden card is a bet, not the game (all-seeing 5 to 20 over the reader) | **PASS** | +12.2 |
| B10 | Showing beats guessing (reader lead over random 10+ bigger with 2 shown than with 0) | **PASS** | lead over random with 0 / 1 / 2 / 3 cards shown: 15.0 / 38.8 / 64.2 / 78.5 |
| B11 | Stoppages 10-25%, knockdowns 0.3-1.0 a bout, round-1 stoppages under 3% | **PASS** | 10.3% stopped, 0.60 knockdowns a bout, 0.0% in round 1 |
| B12 | No blanks (no punch lands in under 15% of exchanges; dead beats under 25%) | **PASS** | 3.9% of exchanges, 16.8% of beats |
| B13 | No dead card, no card for everything (3%+ where held, none over 30%) | **PASS** | share of cards played: Jab 22.4, Body jab 2.9, Cross 16.8, Lead hook 14.3, Body hook 3.4, Uppercut 2.3, Cross counter 2.7, Block high 16.9, Slip 8.1, Roll 3.0, Step back 2.5, Tie up 2.4, Feint 2.3 |
| B14 | Split cards (15%+ of points decisions) | **PASS** | 43.6% |
| B15 | Film and counting pay (habits known 4+, counting 3+) | **FAIL** | film +1.9, counting +-0.7, watching his patterns +1.7 (reader 66.8%) |
| B16 | He reads you back (best fixed line loses 8+ to the adapting opponent) | **FAIL** | fixed line 0.0% v a non-adapting opponent, 0.0% v the adapting one; a reader who always blocks high on the hidden card: 48.4% v 51.0% |
| B17 | The corner is a decision (informed 3+ over random; each card 15%+ of informed picks) | **FAIL** | informed 66.8%, random 65.0%, always water 63.0%, ice 65.9%, watch him 66.1%; informed picks water 6.8%, ice 28.6%, watch him 64.6% |
| B18 | Styles (every pair 40-90% for the reader) | **FAIL** | lowest 6.8%, highest 100.0% |

Core bars: 5 of 7 pass. Supporting bars: 6 of 11 pass. Verdict: **FAIL**.

Reader by pair (player style v opponent style): out v out 100.0, out v press 82.8, out v counter 83.4, out v volume 97.0, press v out 99.6, press v press 29.0, press v counter 89.0, press v volume 6.8, counter v out 100.0, counter v press 21.4, counter v counter 95.6, counter v volume 64.4, volume v out 100.0, volume v press 36.6, volume v counter 52.0, volume v volume 10.8

Opponent class (greedy / reader): novice 100.0 / 99.9, open class 68.1 / 85.3, regional 45.8 / 67.2, title 36.7 / 56.1, professional 26.0 / 48.7

Cards shown 0 / 1 / 2 / 3 - random, greedy, reader, all-seeing: [0] 0.1, 5.7, 15.1, 80.5  [1] 0.1, 22.8, 38.9, 79.4  [2] 0.1, 45.3, 64.3, 79.7  [3] 0.1, 67.4, 78.6, 78.6

Best fixed lines found: Cross / Slip / Cross counter 0.0%; - / - / - 0.0%; - / - / Jab 0.0%; - / - / Body jab 0.0%; - / - / Cross 0.0%; - / - / Lead hook 0.0%

What two more copies of a card are worth (reader win %, neutral deck alone: out 99.5, press 17.8, counter 77.4, volume 2.5):

| card | v out | v press | v counter | v volume |
|---|---:|---:|---:|---:|
| Jab | 93.3 (11) | 30.7 (4) | 61.2 (10) | 3.0 (8) |
| Body jab | 98.3 (9) | 40.4 (2) | 65.0 (8) | 2.0 (10) |
| Cross | 98.7 (7) | 9.1 (10) | 55.6 (12) | 5.2 (4) |
| Lead hook | 98.5 (8) | 12.2 (8) | 84.8 (5) | 4.6 (5) |
| Body hook | 99.2 (5) | 10.9 (9) | 84.5 (6) | 0.7 (12) |
| Uppercut | 99.5 (3) | 5.5 (13) | 80.8 (7) | 2.7 (9) |
| Cross counter | 100.0 (1) | 58.0 (1) | 98.3 (1) | 85.3 (1) |
| Block high | 98.1 (10) | 23.9 (5) | 60.2 (11) | 2.0 (11) |
| Slip | 99.8 (2) | 6.4 (11) | 91.4 (2) | 4.6 (6) |
| Roll | 88.5 (13) | 15.9 (6) | 61.4 (9) | 7.9 (3) |
| Step back | 99.2 (6) | 15.2 (7) | 89.7 (3) | 4.4 (7) |
| Tie up | 99.4 (4) | 33.1 (3) | 87.8 (4) | 11.4 (2) |
| Feint | 91.5 (12) | 6.0 (12) | 53.8 (13) | 0.5 (13) |

## Run 1 - the design as first written

Population: 4 player boxers x 4 opponents (16 pairs), regional class, 500 bouts a pair. Card table: neutral 12-card deck + 2 copies of one card v each opponent boxer, reader, 3000 bouts a cell. Run: 1200 runs of 8 bouts.

| # | Bar | Result | Measured |
|---|---|---|---|
| B1 (core) | Reading beats a fixed line (15+) | **PASS** | reader 99.9% v best fixed line 1.0% = +98.9 (Jab / Cross / Lead hook) |
| B2 (core) | Thinking beats not thinking (30+) | **PASS** | reader 99.9% v random 4.3% = +95.6 |
| B3 (core) | No line that needs no reading (best fixed under 45%, 10+ under the reader) | **PASS** | best fixed 1.0% on fresh seeds (screen best 1.0%) |
| B4 (core) | Close fights (one-sided under 35%) | **FAIL** | 74.7% one-sided |
| B5 (core) | Decided late (30%+ won from level or behind after round 2) | **FAIL** | 0.4% |
| B6 (core) | Every card has a matchup (top four v one style, bottom half v another) | **FAIL** | no matchup swing: Body hook, Uppercut, Roll, Tie up, Feint |
| B7 (core) | The run has choices (3+ wide offers a run; informed picks beat random picks) | **FAIL** | 0.65 wide offers of 8 a run; bouts won: informed 99.8%, random pick 99.0%, no pick 99.4%; wins a run 7.98 v 7.92 |
| B8 | A ladder of skill (random < fixed < greedy < reader < all-seeing; reader 8+ over greedy) | **FAIL** | 4.3 / 1.0 / 97.8 / 99.9 / 100.0 |
| B9 | The hidden card is a bet, not the game (all-seeing 5 to 20 over the reader) | **FAIL** | +0.1 |
| B10 | Showing beats guessing (reader lead over random 10+ bigger with 2 shown than with 0) | **PASS** | lead over random with 0 / 1 / 2 / 3 cards shown: 69.8 / 91.8 / 95.5 / 95.7 |
| B11 | Stoppages 10-25%, knockdowns 0.3-1.0 a bout, round-1 stoppages under 3% | **FAIL** | 91.9% stopped, 2.38 knockdowns a bout, 1.0% in round 1 |
| B12 | No blanks (no punch lands in under 15% of exchanges; dead beats under 25%) | **PASS** | 4.2% of exchanges, 18.6% of beats |
| B13 | No dead card, no card for everything (3%+ where held, none over 30%) | **PASS** | share of cards played: Jab 24.6, Body jab 3.0, Cross 18.9, Lead hook 16.1, Body hook 3.1, Uppercut 2.9, Cross counter 2.8, Block high 11.3, Slip 8.4, Roll 2.1, Step back 1.6, Tie up 2.1, Feint 3.0 |
| B14 | Split cards (15%+ of points decisions) | **FAIL** | 2.5% |
| B15 | Film and counting pay (habits known 4+, counting 3+) | **FAIL** | film +0.0, counting +0.0, watching his patterns +0.1 (reader 99.9%) |
| B16 | He reads you back (best fixed line loses 8+ to the adapting opponent) | **FAIL** | fixed line 1.6% v a non-adapting opponent, 1.0% v the adapting one; a reader who always blocks high on the hidden card: 99.7% v 99.5% |
| B17 | The corner is a decision (informed 3+ over random; each card 15%+ of informed picks) | **FAIL** | informed 99.9%, random 99.8%, always water 99.7%, ice 99.9%, watch him 99.9%; informed picks water 3.4%, ice 8.0%, watch him 88.6% |
| B18 | Styles (every pair 40-90% for the reader) | **FAIL** | lowest 98.6%, highest 100.0% |

Core bars: 3 of 7 pass. Supporting bars: 3 of 11 pass. Verdict: **FAIL**.

Reader by pair (player style v opponent style): out v out 100.0, out v press 100.0, out v counter 100.0, out v volume 100.0, press v out 98.6, press v press 100.0, press v counter 100.0, press v volume 100.0, counter v out 100.0, counter v press 100.0, counter v counter 100.0, counter v volume 100.0, volume v out 99.6, volume v press 100.0, volume v counter 100.0, volume v volume 100.0

Opponent class (greedy / reader): novice 100.0 / 100.0, open class 98.9 / 99.9, regional 98.2 / 99.9, title 97.4 / 99.9, professional 70.6 / 96.5

Cards shown 0 / 1 / 2 / 3 - random, greedy, reader, all-seeing: [0] 4.1, 47.9, 73.9, 100.0  [1] 3.9, 78.8, 95.7, 100.0  [2] 4.3, 97.6, 99.8, 100.0  [3] 4.3, 100.0, 100.0, 100.0

Best fixed lines found: Jab / Cross / Lead hook 0.9%; Cross / Jab / Lead hook 0.4%; - / Jab / Cross 0.0%; Jab / Cross / Cross 0.0%; - / - / - 0.0%; - / - / Jab 0.0%

What two more copies of a card are worth (reader win %, neutral deck alone: out 99.5, press 100.0, counter 100.0, volume 100.0):

| card | v out | v press | v counter | v volume |
|---|---:|---:|---:|---:|
| Jab | 96.6 (11) | 100.0 (1) | 99.9 (9) | 100.0 (1) |
| Body jab | 99.0 (7) | 100.0 (2) | 99.9 (10) | 100.0 (2) |
| Cross | 98.7 (10) | 100.0 (3) | 99.9 (11) | 100.0 (3) |
| Lead hook | 99.0 (8) | 100.0 (4) | 100.0 (1) | 100.0 (4) |
| Body hook | 98.8 (9) | 100.0 (5) | 99.9 (12) | 99.7 (12) |
| Uppercut | 100.0 (1) | 100.0 (6) | 100.0 (2) | 100.0 (5) |
| Cross counter | 100.0 (2) | 100.0 (7) | 100.0 (3) | 100.0 (6) |
| Block high | 99.3 (6) | 100.0 (8) | 100.0 (4) | 100.0 (7) |
| Slip | 100.0 (3) | 100.0 (9) | 100.0 (5) | 100.0 (8) |
| Roll | 94.5 (13) | 100.0 (10) | 100.0 (6) | 100.0 (9) |
| Step back | 99.4 (4) | 100.0 (11) | 100.0 (7) | 100.0 (10) |
| Tie up | 99.4 (5) | 100.0 (12) | 100.0 (8) | 100.0 (11) |
| Feint | 95.8 (12) | 100.0 (13) | 99.9 (13) | 99.2 (13) |
