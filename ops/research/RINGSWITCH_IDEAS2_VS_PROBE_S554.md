# Kalli's and John's ideas on Ring Switches as it plays today, read against the S554 probe

Asked S554 (SQ329 Kalli, SQ330 John; `RINGSWITCH_IDEAS2_BRIEF.md` gave them the rules and our measurements, NOT the body
jab finding). Both answers landed the same session: `RINGSWITCH_IDEAS2_BRIEF_KALLI.md`, `_JOHN.md`. Nothing here is built.

## Three sources, one first change: the body jab
Both seats, independently, put a BODY JAB first (lead hand, reaches Long and Mid, stopped by the lead hand held LOW).
The S554 probe had found the same thing before their answers came. They differ only in what it does when it lands:

| Version | What a landed body jab does | Sensible player's wins v Jabber / Slugger / Body Snatcher | His stamina bar at the end v the Jabber |
|---|---|---|---|
| today, no body jab | - | 97-98% / 78-79% / 78-80% | 7.9 of 8 |
| Claude's probe | keeps him out next beat | 60-61% / 75% / 80-82% | 8.0 |
| Kalli | shortens his stamina bar, does NOT keep him out | 66% / 75-79% / 77-80% | 4.3 |
| John | shortens the bar AND keeps him out, but never two beats running (either jab) | 66-67% / 75-76% / 81% | 4.4 |

`proto/twohands/tools/probe_body_jab_variants.mjs`, 400 bouts a man, seeds 1 and 2. All three do the job (the Jabber
stops being a walk-over, the other two opponents are untouched). Kalli's reason for her version is the best design
argument: "the head jab wins position and the body jab wins the long fight", so the right guess changes with the
stamina bar and it is not a coin flip. John's cap (no keep-out two beats running) answers the lazy plan "jab, jab, jab at
Long". Recommended build: John's version (it contains Kalli's and adds the cap). Limits of the measure: the bot answers
the man's LAST beat, so a player who reads the mix does better than 66%; stoppages against the Jabber fall to 3-4%.
It still needs an authored take (docs/HOLDTAKES1_RESULT.md).

## What else both proposed (two seats agreeing, in their order)
| Idea | Kalli | John | What it would fix |
|---|---|---|---|
| HURT: a big punch landing as a counter leaves him hurt next beat; the clinch is how he survives | 3 | 2 | bouts end early; the clinch and the counter get a job |
| CIRCLE OFF: a feet choice, 2 stamina, his step in is wasted, one square of ground back, not twice running | 2 | 4 | out-boxing can win; nobody just walks to the ropes |
| ONE QUESTION PER OPPONENT: one rule of its own each (Slugger hits harder, Body Snatcher takes 2 off the bar ...) | 4 | 3 (+ a second plan in round 3 when behind) | the three opponents ask different things |

## One seat each
- Kalli 5: a FEINT FREEZES A HELD HAND for your first punch next beat (a third choice at Long: jab beats the open
  walk-in, the high guard beats the jab, the feint beats the high guard).
- John 5: BLOCKS ARE NOT FREE: a held hand gives stamina back only if nothing hit it; a big punch blocked costs the
  blocker 1 stamina.

## The guard bar (the owner's open call)
- Kalli: CUT IT. "It never broke in 1,800 bouts, so it's a bar that does nothing."
- John: does not name it, but his idea 5 is a rebuild of it on the stamina bar (a block costs stamina, no third bar).
So both point the same way: no separate guard bar. The owner decides.

## Sources and checks
The fights and fighters they name (Mayweather's and Whitaker's body jab, Lomachenko's pivot, Gatti v Ward round 9, Fury v
Wilder 3, Usyk v Fury 1 round 9, Hopkins's feints) are given from their memory and not re-checked: nothing rests on them.
Kalli's "no single bot plan wins 70% against all three" is her own target, said as such.
