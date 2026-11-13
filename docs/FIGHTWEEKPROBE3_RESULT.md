# FIGHTWEEKPROBE3 - the fight week's load stop over a season (S451)

A measurement only, no rule changes. Built by Claude in S451 for AMATEURWEEK1 v5 (Kalli SQ60's first item: "run the season before
the build and put it on the box").

## How
- `tools/career_harness.gd -- n=150 weeks=52 policies=sensible week=<rest|tick|through|coach>`: four runs, the same 150 careers (seeded
  by index) in each, the harness's sensible player, FireLevel ON. Model: `tools/harness_fightweek.gd`. Summary: `python
  tools/fightweek_season_sum.py <dir>` (paired by career).
- The game's own week before a bout is its TAPER (light), which v5 calls Tick over. Around it, on fight day, the stop sets:
  - BANKED: the gains since the snapshot (the first stop 8 days or fewer out), scaled x0.4 for Rest up, x1.0 for Tick over and x2.0
    for Train through. This covers stats AND move mastery.
  - TANK: the game's own tank off (BoutRules.tank_parts_for) plus 0, 6 or 12.
  - ROUND 1: Rest up starts flat at 2.0 (bout["r1_flat"]).
  - CARRY: Train through adds 6 tiredness after the bout.
- The coach's pick: tired over 50 -> Rest up; an opponent with more wins -> Tick over; else Train through.
- NOT modelled, so it reads as zero here: the load-spike injury risk of Train through and v5's late-sparring injury roll. The game's
  own weekly injury roll runs as usual.
- Booking is today's (AmateurBooking, 8-12 weeks' lead, camps): about 5.5 bouts a season, not v5's 9-11.

## Result
```
FIGHTWEEKPROBE3 - a 52-week season, the sensible player, fight-week stop by habit
arm                        n  bouts   win %  inj bout inj train stat end closed
always Rest up           150    833    55.2        60        54    478.8      0
always Tick over         150    830    61.1        54        54    480.1      0
always Train through     150    830    62.5        54        54    481.8      0
the coach's pick         150    826    61.3        57        53    480.5      0

PAIRED against the coach's pick (same careers): wins per career, win share per career, stat points
  always Rest up         n=150  wins -0.31 +-0.11 a season | win share -6.1 +-1.7 in 100 | stats -1.7 +-0.3
  always Tick over       n=150  wins +0.01 +-0.07 a season | win share -0.2 +-0.8 in 100 | stats -0.4 +-0.1
  always Train through   n=150  wins +0.09 +-0.09 a season | win share +1.2 +-1.6 in 100 | stats +1.3 +-0.1
```
All four arms ran the full 150 careers.

## What it says
1. ALWAYS REST UP COSTS ABOUT 6 WINS IN 100 OVER A SEASON (paired: -6.1 +-1.7 against the coach's pick; 55.2 % against 61-62 %).
   The cost is the flat round 1, NOT banked work: stat totals at the season's end differ by under 3 points of about 480. A one-night
   flat at 2.0 cost 2-3 (FIGHTWEEKPROBE2), so the season gap is about twice the single-night price.
2. TRAIN THROUGH HAS NO SEASON COST TODAY: injuries are equal across the arms (54 training, 54 bout), and +6 tiredness carried changes
   nothing measurable. Always Train through sits level with the coach's pick (+1.2 +-2.1). Kalli's point 8 is confirmed by
   measurement. The v5 rules that give it a cost (the load-ratio spike for the week, x1.5 late sparring) must be BUILT, and this
   probe re-run with them, before the build freezes. The target: always-Train-through finishes 2-4 behind the pick.
3. THE BANKED SHARE IS TOO SMALL TO SEE: a full week against a fifth moves the season's stat total by about 3 points. The week's weight
   is tonight's sharpness, not what it banks. v5's BANKED row must show it honestly ("+1 to +2 stat points") and not promise more.
4. The season gap, best against laziest (the coach's pick against always Rest up), is about 6 in 100: inside v4's 4-8 band and below
   its 8-12 target.
