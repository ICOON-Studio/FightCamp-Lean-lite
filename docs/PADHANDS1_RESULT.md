# PADHANDS1 RESULT - the coach's one-to-ones: FAIL (S537, DEPTH35 change 3)

**Probe:** tools/padhands_probe.gd (greybox; no game file changed). Map: ops/research/DESIGN_PADHANDS1.md.
**Rule probed:** everyone keeps full pad nights (owner Q-S294-242 "No, never short", Q-S294-260 "full pads, no sharing"); on
top the coach has 2 one-to-one sessions a week, 120 drill units each, on one card of one boxer. The pick = who gets them.
**Population:** 4 club boxers who all differ (Lucy wlw, Kira wfw, Samira www, Tess wmw: Data.lucy + Data.PROSPECTS), each her
own two book combinations, start mastery and punches (seeded per cell); opponents of her own division (Data.OPPONENTS +
RIVALS, Data.DIVISION_RIVALS, rating under 70); 10 cells = 10 seeded calendars of 10 weeks, a bout every 3 to 5 weeks each
(7 to 10 bouts a cell); 40 dice a bout, the same dice in every arm. Drilling = PadWeek.run_week + PadWeek.drill; the answer
to learn = PlanFight.ANSWERS for OppFile.main_game; the bout = Bouts.fight_step "sim" (FireLevel on). Coach pads 74.

## 1. Controls first (100 dice a cell, each +-5)
| Asked | Answer |
|---|---|
| The answer for THIS opponent not in her hands / Usable / Sharp (7 pairings) | Usable over absent: +4, 0, -4, +2, +6, +3, +9 (mean about +3); Sharp over Usable: 0 to +4 |
| A new two-punch answer from 0, normal week (answer on 2 of 3 pad nights) | 27 after week 1, Usable in week 2 |
| The same with both one-to-ones | 33 after week 1: Usable one week sooner |
| A new three-punch answer | Usable in week 3; with both one-to-ones week 2 |
| One session near her cap | +0 to +1 |

## 2. The arms (wins in 100 club bouts, mean of 10 cells)
| Bouts known | none | all (8 sessions, upper bound) | coach (laziest) | even | star | gap | bell | under |
|---|---|---|---|---|---|---|---|---|
| 2 to 4 weeks ahead (the code, AmateurBooking) | 40.35 | 40.45 | 40.39 | 40.39 | 40.35 | 40.42 | 40.42 | 40.35 |
| 1 to 2 weeks ahead (the S428 scope's fight week) | 40.55 | 40.80 | 40.61 | 40.58 | 40.55 | 40.58 | 40.61 | 40.71 |

| Bar | 2-4 weeks | 1-2 weeks |
|---|---|---|
| 1 moves the result (all - none, needs 3) | 0.09 FAIL | 0.25 FAIL |
| 2 no pick best in more than 6 of 10 cells | FAIL: 6 to 8 cells are a dead tie of every pick | FAIL: 6 cells a dead tie |
| 3 best pick vs the laziest (needs 3) | 0.03 FAIL | 0.09 FAIL |

**VERDICT PADHANDS1 = FAIL.** Not sent to critics.

## 3. Which lever broke
The hands have nothing to buy. Three reasons, all from the game's own numbers:
1. With full pads for everyone the normal week already brings a new answer to Usable in 2 weeks, and a bout is known 2 to 4
   weeks ahead. The session only matters for a three-punch answer on the shortest notice.
2. Most boxers already hold a "best" answer to most games (1-1 and 1-2 answer press, counter and range), so most weeks
   there is no answer to learn at all: in 6 to 8 cells of 10 every arm is identical to the last bout.
3. What is left to buy is Usable to Sharp, worth 0 to 4 wins in 100 on one bout, and a club boxer's cap (weakest punch,
   technique) puts Sharp out of reach of one or two sessions.
Even giving every boxer every session (four times the hands) moves the club 0.1 to 0.25 wins in 100.

## 4. What would have to move (not done here)
- The owner's "never short" removes the only version that measured as scarce (R55, S425: the coach's hands worth one week on
  a card). Under his ruling the currency cannot be pad minutes.
- For hands to be a currency the ANSWER must be worth more and take longer: an opponent-specific answer worth 8+ wins in
  100 (today about 3) that needs 3+ weeks of pads against 2 to 4 weeks of notice. That is change 2's territory (the
  exchange reads place and cover) plus the answer table, not a new deal screen.
- Or the hands buy something that is not mastery (the corner on fight night, a rehearsal of the plan). Unmeasured.
Recommendation: do not build PADHANDS1; do not send the map to critics. Re-probe after change 2 lands.

## 5. Limits
40 dice a bout (each bout +-15, but the arms share dice and most states are identical, so differences are exact where
shown as 0.0). One-to-ones always go on her card nearest a tier line. No loyalty, no injuries, no camp. The plan on the
night is every Usable line that does not walk into the opponent's game plus two steps.
Raw output: E:\FightCamp\tmp\d35\padhands_24.txt, padhands_12.txt, padhands_controls.txt (not in the repo).
