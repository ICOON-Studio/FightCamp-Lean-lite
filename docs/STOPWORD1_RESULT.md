# STOPWORD1 Result - the Ask card's stoppage word

Probe run: 2026-11-18T02:03:45. 60 bouts an asked gap, seeds off 4421, 960 real bouts in all.

The card says the stoppage chance IN WORDS ONLY (ASKFIGHT_MAP_S441.md s4): **unlikely / possible / a real risk**. A coach looks at the other boxer's level and record and says "he won't stop you", "he could", "he can really hurt you" - so this probe fights many real bouts at each rating gap and counts how often OUR boxer is stopped. The chance edges are the brief's: under 8% unlikely, 8-20% possible, over 20% a real risk.

## Population

The TEST CLUB (scripts/state/TestClub.gd), exactly as it writes them - no ability jitter, no camp, no injury, no ko_history, fresh at every bell:

| boxer | class | fight power | chin | morale | bouts | pool |
|---|---|---|---|---|---|---|
| Lucy Jackson | wlw (Lightweight, women's amateur) | 59.93 | 66.0 | 60.0 | 4 | 11 names |
| Kira Mensah | wfw (Featherweight, women's amateur) | 58.67 | 52.0 | 60.0 | 1 | 5 names |
| Josh Harper | mww (Welterweight, men's amateur) | 58.42 | 64.0 | 60.0 | 6 | 4 names |

Opponents: the real named amateurs of the boxer's OWN weight class and sex that the career holds (Data.OPPONENTS + Data.MISMATCH + Data.RIVALS for wlw, Data.DIVISION_RIVALS for the rest). Ratings and records are the career's, not Data's raw table: the TEST CLUB's first week runs a club show and Region.record nudges a rival's rating and record. A class's pool is small - 4 to 11 names - and no opponent is synthesized, so no bout ever pairs two identical fighters. The pool is put back after every bout: no record or rating drifts across the 60.

## Method

- The game's real bout: `Bouts.fight_step` to the end, ask_probe2's loop (tape, every live shout, the auto corner, the end). Three rounds, the amateur bout.
- The seven asked gaps [-15.0, -10.0, -5.0, 0.0, 5.0, 10.0, 15.0] are dealt **far first**, each taking the nearest opponent still available (a tie by name). So +15 reaches the top of the pool, and every name a boxer meets is distinct. A gap the spent pool cannot answer is reported n=0, never filled with a repeat.
- gap = opponent rating minus our boxer's `BoutRules.fight_power(stats, {}, 0, "")` - the same gap AskFlow.teach_word reads.
- **Every bout's REAL gap is recorded and the tables bucket by it**, not by the gap asked for (the brief's trap).
- our stopped = the outcome is a loss and `Bouts.stopped(m)` is not empty; their stopped = a win and a stoppage; decision = neither side stopped. Dice: `c.day = 200000 + 4421 * 104729 + (boxer * 7 + gap) * 60 + bout`.
- card:yes = the opponent is a legal novice match for that boxer today (AmateurBooking.experience_match_ok), so AskBout.answers can offer it; card:no = past the novice rule, measured for the curve but not yet reachable on a card.

## Asked gap -> the opponent it reached

| boxer | asked | opponent | rating | REAL gap | n | our stopped % | their stopped % | decisions % | card |
|---|---|---|---|---|---|---|---|---|---|
| Lucy Jackson | -15.0 | Jade Cooper | 56.8 | -2.93 | 60 | 1.7 | 1.7 | 96.7 | yes |
| Lucy Jackson | -10.0 | Megan Hughes | 58.5 | -1.43 | 60 | 0.0 | 6.7 | 93.3 | yes |
| Lucy Jackson | -5.0 | Holly Price | 59.0 | -0.93 | 60 | 0.0 | 1.7 | 98.3 | yes |
| Lucy Jackson | +0.0 | Aisha Rahman | 60.5 | +0.57 | 60 | 1.7 | 3.3 | 95.0 | yes |
| Lucy Jackson | +5.0 | Sophie Turner | 64.0 | +4.07 | 60 | 1.7 | 1.7 | 96.7 | no |
| Lucy Jackson | +10.0 | Erin Doyle | 65.5 | +5.57 | 60 | 6.7 | 5.0 | 88.3 | yes |
| Lucy Jackson | +15.0 | Dana Whitfield | 72.0 | +12.07 | 60 | 11.7 | 0.0 | 88.3 | no |
| Kira Mensah | -15.0 | Holly Marsh | 58.3 | -0.67 | 60 | 10.0 | 6.7 | 83.3 | yes |
| Kira Mensah | -10.0 | Megan Price | 58.5 | -0.17 | 60 | 11.7 | 0.0 | 88.3 | yes |
| Kira Mensah | -5.0 | Grace Adeyemi | 61.0 | +2.33 | 60 | 23.3 | 0.0 | 76.7 | yes |
| Kira Mensah | +0.0 | _none left_ | - | - | 0 | - | - | - | - |
| Kira Mensah | +5.0 | _none left_ | - | - | 0 | - | - | - | - |
| Kira Mensah | +10.0 | Nina Kowalski | 63.0 | +4.33 | 60 | 13.3 | 0.0 | 86.7 | yes |
| Kira Mensah | +15.0 | Bethany Cole | 70.0 | +11.33 | 60 | 75.0 | 0.0 | 25.0 | no |
| Josh Harper | -15.0 | Ryan McBride | 52.8 | -5.42 | 60 | 1.7 | 5.0 | 93.3 | yes |
| Josh Harper | -10.0 | Jordan Ashby | 58.0 | -0.42 | 60 | 5.0 | 3.3 | 91.7 | no |
| Josh Harper | -5.0 | _none left_ | - | - | 0 | - | - | - | - |
| Josh Harper | +0.0 | _none left_ | - | - | 0 | - | - | - | - |
| Josh Harper | +5.0 | _none left_ | - | - | 0 | - | - | - | - |
| Josh Harper | +10.0 | Samir Haddad | 61.0 | +2.58 | 60 | 8.3 | 0.0 | 91.7 | no |
| Josh Harper | +15.0 | Darnell Okafor | 69.0 | +10.58 | 60 | 38.3 | 0.0 | 61.7 | no |

## The table: REAL gap -> the chance (all three boxers pooled)

```
  real gap     n   ours%  theirs%   dec%  band(chance)   StopWord.word
     -5.42    60     1.7     5.0    93.3  unlikely      unlikely
     -2.93    60     1.7     1.7    96.7  unlikely      unlikely
     -1.43    60     0.0     6.7    93.3  unlikely      unlikely
     -0.93    60     0.0     1.7    98.3  unlikely      unlikely
     -0.67    60    10.0     6.7    83.3  possible      unlikely
     -0.42    60     5.0     3.3    91.7  unlikely      unlikely
     -0.17    60    11.7     0.0    88.3  possible      unlikely
     +0.57    60     1.7     3.3    95.0  unlikely      possible
     +2.33    60    23.3     0.0    76.7  a real risk   possible
     +2.58    60     8.3     0.0    91.7  possible      possible
     +4.07    60     1.7     1.7    96.7  unlikely      possible
     +4.33    60    13.3     0.0    86.7  possible      possible
     +5.57    60     6.7     5.0    88.3  unlikely      possible
    +10.58    60    38.3     0.0    61.7  a real risk   a real risk
    +11.33    60    75.0     0.0    25.0  a real risk   a real risk
    +12.07    60    11.7     0.0    88.3  possible      a real risk
```

n=60 a row: one boxer, one opponent, 60 bouts. The standard error on a 10% chance at n=60 is about 3.9 points, so one row cannot place an edge. The 2.5-point bins:

```
  bin              mean gap    n   ours%  theirs%   dec%  band(chance)
  [  -7.5,  -5.0)     -5.42   60     1.7     5.0    93.3  unlikely
  [  -5.0,  -2.5)     -2.93   60     1.7     1.7    96.7  unlikely
  [  -2.5,  +0.0)     -0.72  300     5.3     3.7    91.0  unlikely
  [  +0.0,  +2.5)     +1.45  120    12.5     1.7    85.8  possible
  [  +2.5,  +5.0)     +3.66  180     7.8     0.6    91.7  unlikely
  [  +5.0,  +7.5)     +5.57   60     6.7     5.0    88.3  unlikely
  [ +10.0, +12.5)    +11.33  180    41.7     0.0    58.3  a real risk
```

## The monotone blocks - the table the edges are read off

The raw rows are NOT monotone: the three boxers' chins differ (Lucy 66, Kira 52, Josh 64), so which boxer lands in a bin moves it as much as the gap does. A monotone word(gap) cannot honour every raw row. The bins are therefore pooled into monotone blocks - a bin whose our-stopped chance is lower than the block before it joins that block (pool adjacent violators) - and the edges are read off the blocks:

```
  block (REAL gap)   mean     n   ours%  theirs%   dec%  band(chance)   StopWord.word
  [  -7.5,  -5.0)    -5.42    60     1.7     5.0    93.3  unlikely      unlikely
  [  -5.0,  -2.5)    -2.93    60     1.7     1.7    96.7  unlikely      unlikely
  [  -2.5,  +0.0)    -0.72   300     5.3     3.7    91.0  unlikely      unlikely
  [  +0.0,  +7.5)    +3.24   360     9.2     1.7    89.2  possible      possible
  [ +10.0, +12.5)   +11.33   180    41.7     0.0    58.3  a real risk   a real risk
```

Stoppage kinds over the 960 bouts: { "KO": 15, "RSC": 132 }.

## The bands

- the 8% edge: midway between the last gap below (-0.17) and the first at/over (+0.57) -> **+0.20**.
- the 20% edge: midway between the last gap below (+5.57) and the first at/over (+10.58) -> **+8.07**.

`scripts/rules/StopWord.gd` (pure, no preloads) carries the rating edges, rounded to the nearest half point so the card's cut is a readable number and still separates every block:

```
const CHANCE_POSSIBLE := 0.08   # the brief's chance edge, on OUR boxer being stopped
const CHANCE_RISK := 0.20
const POSSIBLE_GAP := +0.00    # rating points: below this, unlikely
const RISK_GAP := +8.00        # rating points: at or above this, a real risk
```

The measured blocks reach: unlikely (1.7%, 1.7%, 5.3%); possible (9.2%); a real risk (41.7%).

**Every measured gap against its block's band: 0 disagreements of 16 rows.**

7 raw rows disagree with their OWN chance band, and the rule cannot honour them without breaking monotonicity. They are the chin confound, not a bug in the rule:

- REAL gap -0.67: the measured 10.0% says **possible**, StopWord.word says **unlikely**
- REAL gap -0.17: the measured 11.7% says **possible**, StopWord.word says **unlikely**
- REAL gap +0.57: the measured 1.7% says **unlikely**, StopWord.word says **possible**
- REAL gap +2.33: the measured 23.3% says **a real risk**, StopWord.word says **possible**
- REAL gap +4.07: the measured 1.7% says **unlikely**, StopWord.word says **possible**
- REAL gap +5.57: the measured 6.7% says **unlikely**, StopWord.word says **possible**
- REAL gap +12.07: the measured 11.7% says **possible**, StopWord.word says **a real risk**

## What this means for the card

The word is a POPULATION read on the gap, not a per-boxer read. Kira (chin 52, "fast hands, thin chin") is stopped 10.0% and 11.7% at gaps of -0.67 and -0.17 - already "possible" against an opponent rated level with her - while Lucy (chin 66) is stopped 1.7% at +4.07. A thin-chinned boxer meets the risk sooner than the gap alone says; a thick-chinned one later. Wiring the word into AskFlow should keep that in mind: the card's word is the coach's read on the OTHER boxer's level, which is what the map asks for, not a promise about this boxer's chin.

## The trap

A weight class holds only 4-11 amateurs, so at a big asked gap the nearest available opponent is far from the gap asked for: every table above is bucketed by the REAL gap of each bout, never by the asked one. Where the pool runs out the asked gap is left unmeasured (n=0) rather than repeated. No measured gap falls between +5.57 and +10.58 - no amateur in any of the three classes is rated there - so the upper edge sits in that hole.

Reproduce: `python ops/Tools/godot_slot.py run --who stopword1 -- <godot> --headless --audio-driver Dummy --fixed-fps 60 --path . --log-file E:/FightCamp/tmp/stopword1.log --script res://tools/stop_word_probe.gd -- bouts=60`
