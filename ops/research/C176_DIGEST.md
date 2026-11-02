# C176 digest

Implemented a presentation-only corner walkout in `FightWorldLiveScreen.gd`.
The existing engine state is initialized exactly as before; the room captures
its first engine sample, holds both fighters at opposite square/cage corners for
1.5 seconds, then uses the existing `FightStagePlayer.walk_at` locomotion at
1.2 m/s to reach those unchanged engine start positions. `walkout` defaults on
for the game and off for `--script` callers unless explicitly supplied.

Added `fight_room_walkout_test.gd` for the room's boxing and MMA populations.
It checks corner placement, canvas bounds, speed, arrival gap, and equal beat
counts with walkout on and off.

Round 2 fixed a Y-axis interpolation defect: the walkout target now keeps each
body's `Stage.mount` height while moving only in X/Z, including after arrival.
The new per-frame witness failed on 4335d093 at boxing frame 45 (2.140/2.180
falling toward zero) and now passes through post-arrival frames. Gates: parse
`CHECK total=2 fails=0`; room `SUITE total=3 fails=0`; world `SUITE total=6
fails=0`; ring bounds `checks=3 failures=0`.
