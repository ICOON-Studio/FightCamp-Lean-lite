# REMEMBER1 RESULT - the rival gym's corner remembers: FAIL on two bars of four (S537, DEPTH35 change 5)

**Probe:** tools/remember_probe.gd (greybox; no game file changed). Map: ops/research/DESIGN_REMEMBER1.md.
**Rule probed:** in an amateur rematch the rival's corner brings the pro read (ProRead.target of her last two bouts; the
price is the game's own ProReadWire.edge, READ_EDGE 6). The pick = the player's answer before the rematch.
**Population:** 10 pairings that all differ: Lucy x3 (wlw), Kira x3 (wfw), Samira x2 (www), Tess x2 (wmw) against rivals of
their own division (press, counter and range games); each boxer her own two-combination book and punches. 150 dice a cell,
the same dice in every arm, 3 rounds, no shouts. The tape = her first two bouts against that rival on the plain plan.
**Arms:** unread (control) / keep (the laziest: same plan, read) / drop the read line / swap (a new best-answer line learned
Usable at 35 in its place) / second (her other line at Sharp 65: the corner splits) / feint (a feint line added) / both.

## 1. Result (wins in 100, each cell +-8; the means +-2.5, paired tighter)
| Cell | read line | unread | keep | drop | swap | second | feint | both | read takes | best |
|---|---|---|---|---|---|---|---|---|---|---|
| Lucy v Ortega (press) | 1-1 | 64.7 | 62.0 | 64.0 | 65.3 | 64.7 | 62.0 | 64.0 | 2.7 | swap |
| Lucy v Nair (counter) | 1-1 | 44.0 | 40.7 | 45.3 | 48.7 | 43.3 | 41.3 | 43.3 | 3.3 | swap |
| Lucy v Doyle (press) | 1-1 | 39.3 | 35.3 | 39.3 | 41.3 | 36.7 | 37.3 | 36.7 | 4.0 | swap |
| Kira v Marsh (press) | 1-1-2 | 66.0 | 65.3 | 66.0 | 68.0 | 65.3 | 65.3 | 66.0 | 0.7 | swap |
| Kira v Adeyemi (counter) | 1-1-2 | 33.3 | 30.7 | 29.3 | 31.3 | 32.7 | 32.7 | 33.3 | 2.7 | both |
| Kira v Kowalski (press) | 1-2 | 32.0 | 27.3 | 28.7 | 34.0 | 31.3 | 28.0 | 31.3 | 4.7 | swap |
| Samira v Okoro (range) | 3b-3 | 52.0 | 48.0 | 52.7 | 56.0 | 53.3 | 50.7 | 54.0 | 4.0 | swap |
| Samira v Finch (press) | 3b-3 | 8.0 | 8.0 | 7.3 | 9.3 | 9.3 | 9.3 | 10.7 | 0.0 | both |
| Tess v Croft (press) | 1-2-3b | 49.3 | 47.3 | 49.3 | 52.0 | 48.7 | 47.3 | 48.7 | 2.0 | swap |
| Tess v Byrne (range) | 1-2-3b | 34.7 | 33.3 | 35.3 | 40.7 | 34.7 | 34.7 | 34.7 | 1.3 | swap |
| **Mean** | | 42.33 | 39.80 | 41.73 | 44.67 | 42.00 | 40.87 | 42.27 | 2.53 | |

Own unread rows: second weapon unread 43.00 (so the split still costs 1.0), feint unread 42.27 (the feint still costs 1.4).

| Bar | Result |
|---|---|
| 1 moves the result (unread - keep, needs 3) | 2.53 **FAIL** |
| 2 no pick best in more than 6 of 10 cells | swap 8, both 2 **FAIL** |
| 3 best pick vs the laziest (needs 3) | swap - keep = 4.87 pass |
| 4 a counter wins back half of what the read takes | swap +4.87 of 2.53; second + feint +2.47 of 2.53 (98%); 9 cells of 10 pass |

**VERDICT REMEMBER1 = FAIL.** Not sent to critics. The counter exists (bar 4 passes, which READBACK1 and READ1 could not
show: second weapon + feint stacked wins back nearly all of it); the read itself and the spread of answers fail.

## 2. Which levers broke
1. **The read is too cheap in a 3-round amateur bout: 2.5 wins in 100** (READ1's pro bout, 4 rounds, one boxer: 5.8). At
   READ_EDGE 6 a careless rematch is barely worse than a first meeting, so there is no reason to act.
2. **"Learn a new best line" is one answer for everything.** Swap beats even the UNREAD plan (44.67 against 42.33): it is
   not answering the read, it is simply a better plan, because every boxer here still has a best answer she does not hold.
   Until a boxer's book is full the read changes nothing about what she should drill.
3. Dropping the line wins back 1.9 of 2.5 (the line is worth less than its read price: READBACK1's finding does not carry
   over to this read), so "leave it at home" is a free second-best everywhere.

## 3. What would have to move (not done here)
- READ_EDGE for a rematch about 10 to 12 (READ1's sweep: 10 takes 6.3, 12 takes 8.3 in a pro bout; the amateur size needs
  its own sweep, and the probe cannot change the constant without touching game code).
- Measure on boxers who already hold every best answer to the rival's game (a second-season book), where swap has nothing
  new to bring: then the choice is keep / drop / second weapon / feint, and bar 2 can be judged fairly.
- Make the read line worth keeping: today the most-fired line is not the most valuable one, so dropping it is nearly free.
  The corner should wait for the line that WON most (ProReadWire.close already records won_in_read), not the one fired most.
Recommendation: do not build REMEMBER1 as mapped. Next step is a v2 map with those three changes and a re-probe.

## 4. Limits
The read is set right after "start", so round 1's first 30 seconds are unread (1 exchange in 18): the read's true price is
about 5% higher than measured. No shouts, the corner's automatic call. "Swap" assumes the pad weeks to learn the line were
there (2 to 3 weeks, docs/PADHANDS1_RESULT.md controls). The tape is two bouts on fixed dice. The ladder read is not probed.
Raw output: E:\FightCamp\tmp\d35\remember_full.txt (not in the repo).
