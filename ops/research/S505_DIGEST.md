# S505 digest (2026-11-17) - fight week day 10: cross steps back from the shown body, head jumps split by layer

## Fight motion (base film s504o; films E:/FightCamp/tmp/fightweek/s505a-c, 180 s seed 7, log only)
- IDLEIN1 collected (Qwen PR 340, closed): StandOff.idle_inside; MY brief's phase filter ("fight") read nothing - the
  film's phase is the range or "rest"; fixed to "not rest" + a test. s504o: idle inside 1.0 m = 70 frames (2.3 s of
  180 s), longest 0.6 s. No stand-off: no fight change.
- CROSS STEP BACK (bcd3d0d42): `-- placedebug` (RingPlace) showed the knocked boxer's place running 7-14 cm AHEAD of his
  shown feet toward the hitter on 5 of 49 knocks (he was stepping in): the 14 cm knock only brought the place back to
  where the body already stood - no lag, no rock (s505a 133.3 s: body 1.8 cm). HitStep now adds that lead to the step on
  the knock's first frame (inside the ropes' room; the rock cap stays sized on the blow). `-- placebase` = control.
  s505b: cross back 12.9 -> 14.2 cm, head jumps 80 -> 77, worst 27.6 -> 20.8 cm.
- TRUNKTAP (`-- trunktap`, tools/trunk_tap.gd + trunk_tap_report.py): a tap after every layer PopCapPre..PopCap splits
  each head-from-hips jump by layer. All jumps over 12 cm: HitSnap 42% (reactions - free by design), the clip 36%,
  PunchReach 21%. On JAB frames: PunchReach 45%, the clip 46%.
- PunchReach LEAN_RATE settable (`-- leanrate=`). s505c at 2.5 (was 4.0): head jumps 77 -> 63 (inside clips 52 -> 39),
  heads in bodies 112 -> 66, beats identical (126 asked, 43 landed). BUT block_catch 4 -> 6 and hit_frame 6 -> 7
  failures (both red at 4.0): default stays 4.0; Qwen LEANRED1 (running) measures each failing check per layer.
- PUNCHEND3 collected (Qwen, as is): PunchEnd in her chest frame (film log now has Chest, UpperChest, Neck, both
  shoulders). s505b: home_p50 3 (ring axes 4); after CONTACT the hand takes p50 25 frames - 0 of 35 landed punches home
  within 4 frames. That is the critics' "hands home in 4 frames" item, now measured honestly: next fix.
- Ziva COACHNECK2 (it had waited for a "go" since S501): PR 341, neck vs chest 44.8 -> 19.8 deg (ok), head ahead 7.1 ->
  2.7 cm; stills on the review board - merge after the owner's look. `-- nocoachneck` = control.

## Operator this session
- "the game run but its not responding" (Training pin): Training opens in 80 ms on the test club (tools/
  training_open_probe.gd). The freeze was MY 18 GB cache move writing to E: while he played (see PC below).
- "why i cannot switch fighter in the training screen" / "it doesnt switch to ana": boxer cards did switch (real clicks,
  hidden desktop) but showed no hover; Ana (BJJ) was locked by design. Now: boxer cards light up + tooltip; Ana's card
  opens her page (WHAT THE CLASSES DRILL). Exported 09:41.
- "make space on c": temp/pip/npm/uv caches + old Claude scratch dirs 6.0 GB, Downloads duplicates 2.3 GB (his yes):
  C: 6.4 -> 15.0 GB free. MISTAKES, both corrected to him: (1) `.cache\eyes` was already a junction to E:\eyes_cache - my
  "move to E:" moved it from one E: folder to another (all 18.2 GB restored, nothing lost; that E: write froze his game);
  (2) I reported iCloudPhotos as 191.5 GB - 3,286 of 3,288 are cloud placeholders (~0 GB on disk). He asked to delete
  them: NOT done - it is iCloud's live sync folder (deleting there deletes from iCloud). Where C: really goes: user-folder
  apps ~155, Program Files 103 (Epic/UE 5.8 37, Unity 15), pagefile 57, ProgramData 48. Unity looks unused (asked).
- He objected to "your project rules forbid scanning the whole drive": the line is WORKFLOW s4, written by a Claude
  session after S92 (from his "i do not want this to happen ever again"), not his words. Told him so; offered removal.
- Q-266 on the board: where did he see "goose could not install godot".

## Next
1. LEANRED1 (docs/LEANRED1_RESULT.md): 2.5 everywhere adds 4 reds, all crosses/hooks (a left hook carries 31 cm past
   the face, was 7). Built `-- jabrate=` (slower lean on jabs only, default 4.0). Its tests could NOT be judged: with the
   owner playing ArcheAge, block_catch read 9 failures even at the old rate (4 this morning) - frame timing. Measure
   jabrate=2.5 (block_catch, hit_frame, a 180 s film) on an IDLE PC.
2. Hands home after contact: traced in the chest frame (s505b jabs at 211, 595, 1011): the hand comes from ~55 cm to
   ~15 cm of the pre-punch guard in 4-6 frames, then sits 10-17 cm off it through the idle that follows - the guard
   itself is elsewhere after the punch (GuardTuck pump / inside guard). contact_home p50 25 is mostly PunchEnd's 8 cm
   bar against a moving guard. Next: judge on the r11 sheets whether 15 cm off the old guard reads as "arm left out";
   if not, PunchEnd's home = the guard of the idle AFTER the punch.
3. Film r11 (--write-movie 1920x1080, film_sheets) + two NEW blind critics (briefs in E:/FightCamp/tmp/fightweek/
   r11blind, sheet times to set from the r11 film). Only when the owner is not playing.
4. Merge PR 341 after his look.
