# Notes from S538's own CARDSCOPE5 worker (it stopped when the S539 worker took the folder; relayed by S538, 2026-11-23)

1. The tuner's pilot table went stale while numbers changed - fixed with `resetFit`; earlier sizing and probes disagreed for that reason.
2. Pilot weights held 10 / wind 2 beat the old pilot by ~10 points and fixed P10 for BJJ - re-size after.
3. The round-4 blind judge cannot tell a kick from a punch or where an action is laid (55.5% on it; 87.4% on a per-action judge;
   bar 90). State that in the result, do not hide it.
4. Its last sizing (on stale code): P5 clause 1 100% of 3,692 held turns, holds finish 21.9%; P6 mechanic-off changes the turn
   58-98% in all 7 arts; P4 7x7 had 7 of 21 cells outside 40-60.

Mechanics it wrote: boxing - jab steps in / punch behind punch 1 cheaper / short punches in clinch; kickboxing - kicks from punch
range, mixed kind 1 cheaper, low kick makes steps dearer, no takedowns; karate - blitz in-out, cannot be held by a grip; judo - no
throw without grip; wrestling - shot from any range, stuffed shot chains; BJJ - sits to guard and attacks from underneath; sambo -
throw behind own punch, lock in the same volley; hold - break price rises 1 a turn, pin scores every turn.
