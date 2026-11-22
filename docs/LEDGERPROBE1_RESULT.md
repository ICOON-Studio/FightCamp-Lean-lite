# LEDGERPROBE1 - the contract tab: is keep / cut the stipend / release a real choice? (S538)

**Verdict: FAIL.** The three options are a real choice (no option wins everywhere), but the boxer's books do not help make it:
a player who reads them does no better than one who gives every boxer the same answer (-$197 ± $159), and the best
option never changes with what the books say. The tab has nothing to tell him. No v6; LEDGER1 goes to the owner as "drop it" (free hand, S534).

Task: ops/research/TASK_LEDGERPROBE1.md. Probe: tools/ledgerprobe1.gd (measurement only, nothing under scripts/ changed; the
options call the game's own GymSpend.set_stipend and Leaving.let_go on a copy of the career).

## What was played
- 231 decisions on 108 different boxers (every boxer's stats moved by a seeded -5..+5 and potential by -8..+8), in 40
  careers of 104 weeks: 5 club kinds (fresh, debt, backed, short = fresh on 4 weeks of costs, test = the test club) x 2 seed
  sets (4421, 9001) x 4 careers.
- A decision = the Monday the tab would be opened: an amateur on the full stipend after two losses in a row (53), an
  amateur on the full stipend while cash is under 4 weeks of costs (75), a professional after the first pro bout
  (103; the stipend cannot be cut for a pro, so Keep or Release).
- Each decision is played from the same copied state once per option, then the same careful owner for 52 weeks. Read at +26
  and +52 weeks: club cash net of the loan, the club's wins, reputation.
- Copy check: Keep from the copy equals the base career 26 weeks on in 139 of 141 checks (2 misses, one career each in
  fresh/9001 and backed/9001; not enough to move a result).
- No club closed in any arm.

## The table
| moment (units) | option | cash +26 wk | cash +52 wk | vs Keep at +52 (± error) | club wins per 100 bouts +26 / +52 | reputation +26 / +52 | he is still in the club at +52 | best for this boxer |
|---|---|---|---|---|---|---|---|---|
| After two losses in a row (amateur) (53) | Keep | $13,450 | $16,033 | - | 58.3 / 64.9 | 48.4 / 87.3 | 53 of 53 | 4 of 53 |
| After two losses in a row (amateur) (53) | Cut the stipend | $18,398 | $19,267 | $3,234 ± $520 | 55.6 / 62.3 | 45.2 / 81.4 | 19 of 53 | 28 of 53 |
| After two losses in a row (amateur) (53) | Release | $15,746 | $18,126 | $2,093 ± $358 | 64.4 / 67.9 | 47.2 / 78.8 | 0 of 53 | 21 of 53 |
| Cash under 4 weeks of costs (amateur) (75) | Keep | $11,212 | $11,400 | - | 59.8 / 66.9 | 51 / 84.2 | 75 of 75 | 17 of 75 |
| Cash under 4 weeks of costs (amateur) (75) | Cut the stipend | $14,243 | $12,053 | $652 ± $433 | 58 / 64.6 | 50.5 / 82 | 49 of 75 | 27 of 75 |
| Cash under 4 weeks of costs (amateur) (75) | Release | $11,937 | $11,775 | $375 ± $562 | 67.6 / 69.8 | 50.2 / 77.7 | 0 of 75 | 31 of 75 |
| After the first pro bout (103) | Keep | $17,025 | $26,436 | - | 74.5 / 74.6 | 95.2 / 121.6 | 103 of 103 | 77 of 103 |
| After the first pro bout (103) | Release | $15,458 | $23,270 | -$3,167 ± $463 | 73.2 / 72.3 | 89.7 / 113.4 | 0 of 103 | 26 of 103 |

"Best for this boxer" = how often the option ended with the most cash at +52 weeks for that one decision.

## Bar (a): no option best in every cell - PASS
Cash at +52 weeks by moment and club kind (cells with 3+ decisions). Best in 14 cells: Keep 7, Cut 3, Release 4
(the limit was 60% for one option; the top one has 50%).

| moment | club | units | Keep | Cut | Release | best |
|---|---|---|---|---|---|---|
| LOSS | fresh | 15 | $8,382 | $11,681 | $12,065 | **Release** |
| LOSS | debt | 6 | $40,973 | $48,081 | $43,802 | **Cut the stipend** |
| LOSS | backed | 15 | $10,908 | $14,781 | $11,594 | **Cut the stipend** |
| LOSS | short | 2 | - | - | - | too few |
| LOSS | test | 15 | $16,095 | $17,511 | $17,830 | **Release** |
| SQUEEZE | fresh | 24 | $4,026 | $6,833 | $7,059 | **Release** |
| SQUEEZE | debt | 14 | $17,141 | $18,089 | $14,863 | **Cut the stipend** |
| SQUEEZE | backed | 7 | $19,612 | $18,436 | $17,229 | **Keep** |
| SQUEEZE | short | 13 | $12,612 | $10,699 | $12,192 | **Keep** |
| SQUEEZE | test | 17 | $12,776 | $12,857 | $13,326 | **Release** |
| PRO | fresh | 24 | $21,458 | not legal | $18,476 | **Keep** |
| PRO | debt | 15 | $40,312 | not legal | $35,624 | **Keep** |
| PRO | backed | 24 | $21,561 | not legal | $17,615 | **Keep** |
| PRO | short | 16 | $37,143 | not legal | $34,735 | **Keep** |
| PRO | test | 24 | $20,479 | not legal | $18,353 | **Keep** |

- For an amateur the three options trade places by club; the cut pays $3,234 after a loss run and only $652 ± $433 in a
  squeeze, and it is not free: after the cut 34 of 53 (loss run) and 26 of 75 (squeeze) were gone from the club a year on,
  and the club lost 5.9 / 2.2 reputation and 2.6 / 2.3 wins per 100.
- For a pro, Keep wins all 5 cells: releasing costs $3,167 ± $463 and 8.2 reputation. The release fee was $500
  (the floor) in all 103 of 103 decisions. "Fee now against the share he brings" is not a choice at this moment.

## Bar (b): the player who reads the books beats the blind one by more than the error - FAIL
Each rule was fitted on one seed set and scored on the other (cash at +52 weeks, all 231 decisions).

| moment (units) | blind: one answer for all | blind: reads the win record | reads the books |
|---|---|---|---|
| After two losses in a row (amateur) (53) | $19,267 | $19,193 | $19,255 |
| Cash under 4 weeks of costs (amateur) (75) | $12,053 | $12,161 | $11,840 |
| After the first pro bout (103) | $26,436 | $26,370 | $26,155 |

- Reads the books against one answer for all: **-$197 ± $159** (needed: more than +$318).
- Reads the books against reads the win record: **-$186 ± $149** (needed: more than +$298).
- The rules the books suggested did not even agree between the two halves (squeeze: "release the worst earners, keep the
  rest" on one, "cut the worst earners" on the other). That is a rule fitted to noise.

## Bar (c): the best option flips on something the tab shows - FAIL
Split each moment's decisions at the median of one number; a flip = a different best option in each half, each by more than
its error.

| moment | split at the median of | lower half: best | upper half: best | lower half margin ± error | upper half margin ± error | flips |
|---|---|---|---|---|---|---|
| LOSS | his books (net a week; a pro: the year's take) (-168.2) | Cut the stipend | Cut the stipend | - | - | no |
| LOSS | his win record (0.4) | Cut the stipend | Cut the stipend | - | - | no |
| LOSS | club cash in weeks of costs (6.1) | Release | Cut the stipend | $555 ± $519 | $2,344 ± $718 | **yes** |
| LOSS | his loyalty (76) | Cut the stipend | Cut the stipend | - | - | no |
| LOSS | release fee | - | - | - | - | no spread: the same for everyone (0) |
| LOSS | free places | - | - | - | - | no spread: the same for everyone (0) |
| LOSS | boxers in the club (3) | Cut the stipend | Cut the stipend | - | - | no |
| LOSS | weeks he has been here (13) | Cut the stipend | Cut the stipend | - | - | no |
| LOSS | club reputation (15) | Cut the stipend | Cut the stipend | - | - | no |
| LOSS | his age | - | - | - | - | no spread: the same for everyone (18) |
| LOSS | his potential (hidden from the player) (84) | Cut the stipend | Cut the stipend | - | - | no |
| LOSS | his ability (stat average) (62) | Cut the stipend | Cut the stipend | - | - | no |
| SQUEEZE | his books (net a week; a pro: the year's take) (-175) | Cut the stipend | Cut the stipend | - | - | no |
| SQUEEZE | his win record (0.67) | Cut the stipend | Release | $1,223 ± $564 | $596 ± $597 | no |
| SQUEEZE | club cash in weeks of costs (3.6) | Cut the stipend | Cut the stipend | - | - | no |
| SQUEEZE | his loyalty (76) | Release | Cut the stipend | $197 ± $762 | $692 ± $428 | no |
| SQUEEZE | release fee | - | - | - | - | no spread: the same for everyone (0) |
| SQUEEZE | free places | - | - | - | - | no spread: the same for everyone (0) |
| SQUEEZE | boxers in the club (3) | Keep | Cut the stipend | $1,155 ± $893 | $1,402 ± $455 | **yes** |
| SQUEEZE | weeks he has been here (12) | Cut the stipend | Keep | $2,118 ± $578 | $631 ± $567 | **yes** |
| SQUEEZE | club reputation (20) | Release | Keep | $1,904 ± $842 | $963 ± $697 | **yes** |
| SQUEEZE | his age | - | - | - | - | no spread: the same for everyone (18) |
| SQUEEZE | his potential (hidden from the player) (86) | Cut the stipend | Cut the stipend | - | - | no |
| SQUEEZE | his ability (stat average) (63.8) | Release | Keep | $2,588 ± $525 | $1,780 ± $856 | **yes** |
| PRO | his books (net a week; a pro: the year's take) (450) | Keep | Keep | - | - | no |
| PRO | his win record (0.7) | Keep | Keep | - | - | no |
| PRO | club cash in weeks of costs (5.6) | Keep | Keep | - | - | no |
| PRO | his loyalty (82) | Keep | Keep | - | - | no |
| PRO | release fee | - | - | - | - | no spread: the same for everyone (500) |
| PRO | free places | - | - | - | - | no spread: the same for everyone (0) |
| PRO | boxers in the club (3) | Keep | Keep | - | - | no |
| PRO | weeks he has been here (47) | Keep | Keep | - | - | no |
| PRO | club reputation (68) | Keep | Keep | - | - | no |
| PRO | his age (20) | Keep | Keep | - | - | no |
| PRO | his potential (hidden from the player) (86) | Keep | Keep | - | - | no |
| PRO | his ability (stat average) (68.8) | Keep | Keep | - | - | no |

- On the boxer's books: no flip in any of the three moments.
- Five flips on other numbers (club cash, roster size, time here, reputation, his ability). They are 5 of 27 looks, so some
  are chance; and none of them is the ledger. They are things the Office and the fighter page already show.

## Why
**Every boxer's books say the same thing.** The stipend is a flat $250 a week and an amateur bout pays a flat $450, so:
- amateur net a week: -180.8 to -153.6 for 8 in 10 boxers after a loss run, -193.7 to -160 in a squeeze;
- a new pro's take for the year: $425 to $469; release fee $500 for all of them.
What actually decides the outcome is the future (does he turn pro, does he leave after the cut, how many bouts he gets), and
the past cash does not predict it: the link between the books and the gain from cutting is -0.16 / -0.15 (0 = no link,
1 = a full one), too weak to act on.
The choice itself has stakes (the best option for one boxer beats the one-answer rule by $893 after a loss run,
$1,770 in a squeeze, $412 for a pro), but nothing on the tab says which boxer is which.

## What would have to be true for the choice to exist
1. **Boxers must cost and earn differently.** A stipend that differs per boxer (asked for at signing, or raised by wins) and
   bout money that differs (ticket cut by his following, not a flat $450). DEPTHPRICE1B already tried "+$50 a week per win"
   and it failed; the per-boxer following is the untested one.
2. **The books must look forward, not back.** The useful line is "what he is likely to bring next year" (how close the pro
   call is, his purse ladder, his draw), with past cash beside it. That is a forecast page, not a ledger.
3. **Release must pay or cost something that varies.** A fee above the $500 floor (a pro with a year of purses, a ranked
   amateur another club pays for) and a waiting prospect who takes the place. This probe did not reach a pro with a full year
   of purses (104-week careers, moment = the first pro bout); the fee-against-share trade there is still unmeasured.
4. Until 1-3 exist, keep / cut / release is better served by what is already on screen: the stipend switch on the fighter
   page and the cash warning in the Office (the flips above are on club cash and roster size).

## Note on the earlier paper score
ops/research/DESIGN_LEDGER1_V6.md (S531) already exists and Arena scored it depth 9 / play 8 on paper. This probe is the
measurement that map never had; it fails, the same pattern as the five maps in DEPTH_AUDIT (passed on paper, failed measured).
That file is left as it is; no new v6 and no critic brief were written.

## Run
`python ops/Tools/godot_slot.py run --who ledgerprobe1 -- <godot.exe> --headless --audio-driver Dummy --fixed-fps 60 --path .
--script res://tools/ledgerprobe1.gd -- kinds=<kind> seeds=<set>` (10 runs, 5 to 16 minutes each, about 1 h 45 min in all;
one "LP1 {json}" line a decision). Raw lines: E:/FightCamp/tmp/ledgerprobe1/*.log (outside the repo).
