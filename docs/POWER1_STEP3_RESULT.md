# POWER1 step 3 - the drive is fast (result, review round 2)

Written last, from the final runs on branch claude/power1 (main 0e471941 merged in first; no clip table or reach file of
main's changed). The 3D fight still decides nothing: no file under scripts/rules or scripts/state changed, and every
punch lands at the same moment of the fight as before.

## What the review found, and what changed

1. **The speed band was not met (whole-body drive).** The body no longer plays faster at all. The drive is now the
   punching arm's alone, put on by the landing reach (scripts/fight3d/ReachDrive.gd, called from PunchReach):
   - **Hold:** until the drive, the glove keeps a little off her face (a soft floor, so it eases and keeps creeping), but
     never further out than it was when the punch started.
   - **Drive:** the last 0.08 s before the contact, the glove goes from where it is shown, at the speed it has, onto her
     face on a path that is still speeding up when it gets there, at the end speed in assets/data/punch_pace.json
     (`drive_v`, chosen per punch by tools/punch_pace.gd to put the glove's top in its band).
   - The contact stays the clip's, so no timer moves; the legs, hips and trunk play the clip at its pace.
   Tried first and dropped, measured: playing the arm's own keys on a clock that waits and catches up barely moved the
   glove (cross b 4.2 -> 3.6-5.1 m/s) and made the hand start 0.3-0.4 s late; starting the drive only when an even push
   fits never started in time; ending the drive a frame early made the glove sit on her face before the hit.
2. **Blocks set late.** The block is now timed from the beat itself (she may raise it while the other still stands in her
   guard), a frame early, and when even that is too late it starts part-way into the cover-up. A punch refused or cut off
   still shows no block. New ruler tests/block_set_test.gd plays blocked punches through BeatFire itself.
3. **The plain cross went through her head after the hit.** The reach now lets go only as fast as the clip's own glove
   comes back near the carry point (the clip's glove is still 0.3-0.5 m past her face when the old weight ran out).
4. **Starts in the middle of a load.** The later start now stops where the trunk is under 25 % of its top speed (was
   50 %): every start is at 0-24 % (was up to 49 %). Cross b now starts at 0 (was 0.226 s).
5. **Fold wait.** Her guard wait is added after a body-shot fold's wait, so a fold can no longer swallow it.

## The rulers (final runs)

**tests/punch_speed_test.gd** (band jab 6-8, cross and hooks 7-9 m/s; FIRST hand moves within 0.13 s; POP no bone steps
more than 1.5x its old worst; SYNC on contact when the hit's timer fires):
- Review's code (beeea8f2): `failures=30` (23 SPEED, 3 FIRST, 4 POP). Control arm `-- nofastdrive` now: `failures=39`
  (26 SPEED, 13 FIRST).
- Now: `failures=43` (14 SPEED, 16 FIRST, 13 POP, 0 SYNC; all 37 SYNC pass).
- SPEED, jabs and crosses: **11 of 16 in band** (beeea8f2: 1 of 16). Plain jab 2.1 -> 6.6, jab b 2.5 -> 6.5, jab hurt
  4.8 -> 7.1, plain cross 3.1 -> 7.4, cross b 4.2 -> 7.9, cross c 3.6 -> 8.1. Still short: jab a 4.9, jab c 5.1, cross a
  5.8, cross hurt 6.9, cross hard_ft 6.0 (the hand would start later than undriven, so the tool chose less).
- Hooks: 9 still over their band (9-18.7 m/s, the clips' own swing; not slowed) and left hook hurt 6.6. As before.
- POP: all 13 failures are the punching arm's own bones (hand, forearm), 1.5-3.1x: that is the drive. Outside the
  punching arm no bone steps more than 1.06x its old worst (beeea8f2: legs and hips at 1.50-1.53x). The bar was not moved.
- FIRST: 16 (beeea8f2: 3). With a faster top, the 15 % "hand moves" line is higher, and the hold slows the glove under it
  before the drive: cross b 0.300 s, cross ft 0.333, cross hurt_ft 0.283, jab hard 0.200, jab ft 0.167, plus the three
  pre-existing (left hook ft, left hook hurt, left uppercut) and the hooks and uppercuts whose start moved earlier with the
  25 % load rule.
- A live "through the join" check was built and dropped: it read up to 4.4x on punches whose start did not change (feet
  and the other hand differ run to run, even with the guard seeded).

**tests/block_set_test.gd**: red on beeea8f2 `BLOCK_SET failures=7` (plain jab's block 0.167 s in at the glove's arrival,
cross b 0.183, bar 0.232); now `BLOCK_SET failures=0` (one earlier run without the one-frame margin read two blocks at
0.217 s: both timers round to whole frames).

**tests/hit_carry_test.gd -- only=pro_right_cross** (twice each): beeea8f2 carry 0.388 / 0.402 m, biggest step 0.291 /
0.306 m (`failures=3` both); now carry 0.085 m, biggest step 0.057 / 0.059 m (CARRY and the step pass). Still red: SMOOTH
"changes direction 5 times" (4-8 mm flutters while carrying; 3-5 on the control arm too).
Full run: `failures=38` (control arm 39).

**Also run, final code:** beat_tally `BEAT_TALLY_TEST failures=0`, sound_sync `SOUND_SYNC checks=30 failures=0`,
fight_feel `FIGHT_FEEL failures=0`. block_meet_test: `BLOCK_MEET failures=11`, all CTRL_LANDED (landed glove 0.07-0.23 m
off her face at its contact frame); see below.

## What does not hold (reported, not fitted)

1. **The fight's spacing is the wall.** Pelvis to pelvis is 0.93-0.99 m (REFERENCE_DISTANCES_S439.md: a shipped game
   fights at 1.05-1.35 m). At guard the lead glove is 0.08-0.14 m and the rear glove 0.23-0.36 m off her face. A glove read
   at 7-9 m/s over two frames covers 0.23-0.30 m in them: nearly the whole way. So a fast glove here either holds back and
   snaps (what this does: FIRST suffers) or stays slow. Standing them 10-15 cm further apart would give the drive room.
   That is the lead's call (it touches every punch's reach and the step-in).
2. **In the played fight the last two frames of the drive can draw as one.** The hit's timer fires one to two frames
   early and the hit puts the clip on its contact (film below). Ending the drive early was measured worse.
3. **POP and the arm:** a 1.5x per-bone bar cannot hold for the punching arm while its glove goes from 2-4 m/s to 7-8 m/s.
   The lead should decide whether POP covers the punching arm.
4. **Hooks** stay over their band; this round did not slow anything.
5. **block_meet_test is red (11 CTRL_LANDED), and was before this round:** with beeea8f2's files put back for one run it
   gives the same `BLOCK_MEET failures=11` with the same numbers (landed glove 0.06-0.23 m off her face at its contact
   frame). Not from this round; it needs its own look (step 2's carry or the contact move are the likely source).

## Films (seed 4242, same beats both: `before` = `-- nofastdrive`, `after` = this round)

Frames under the scratchpad folders film3_before and film3_after (00 cross b, 01 jab, 02 cross c, 03 jab, 04 cross b;
hits.txt gives the glove's speed and distance to her face every drawn frame). The last three drawn frames before the hit:
- before: cross b 4.1 / 4.0 / 3.3 m/s, jab 3.5 / 4.2 / 4.8, cross c 4.3 / 3.8 / 1.9, jab 1.2 / 2.2 / 3.7, cross b 7.7 /
  7.7 / 9.0. The glove comes in over several frames.
- after: cross b 3.7 / 5.4 / 13.6, jab 0.6 / 3.4 / 13.3, cross c 1.2 / 0.8 / 16.6, jab 0.4 / 2.8 / 16.0, cross b 2.9 /
  6.3 / 20.0. **The glove eases, then covers its last 0.20-0.31 m in one drawn frame.** The jab still eases back 4-6 cm
  from where it had crept to (it started further out, and the hold allows that).
- Looked at frame by frame (04 cross, f16-f19): at this size, with her guard in front, the jump is not readable as a jump;
  the numbers are. PunchRange.record now reads the glove 0.15-0.17 m off her face on three of the five hits (before:
  0.006-0.037) because it reads the glove before the hit puts the clip on its contact.

**My read: the offline ruler is met for most straights, the played fight is not better yet.** The one-frame jump comes
from how the hit is fired (a timer one frame early, then the clip is put on its contact, skipping one or two frames of the
drive). The fix I would build next: fire the hit on the frame the clip reaches its contact (the reach already knows it)
instead of a timer that leads it, so the drive's last frames are all drawn. That moves no rule and no beat, only which
drawn frame the hit lands on (within a frame). It needs the lead's yes because it touches every punch's hit timing.
