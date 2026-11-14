# LANDREACH1 step 1 - the landed cross on the game camera (S465, Claude)

Run: `tools/hit_frame_film.gd -- <out> jabs=0 crosses=2 uppercuts=0 seed=4242 noclash` on the hidden desktop, 960x540, 60 fps,
main at ff804573 (the S465 glove clash clearance switched off with `noclash`, so this is the shipped reach).
Frames: docs/mockups/s465/landreach/00_cross, 01_cross; hit frames side by side: docs/mockups/s465/landreach_cross_hits.png.

| Punch | Clip | Contact | Glove off the face at the hit frame |
|---|---|---|---|
| 00 cross (blue onto red) | pro_right_cross_b | 0.517 | 0.016 m - lands |
| 01 cross (red onto blue) | pro_right_cross_c | 0.400 | 0.165 m - the block_meet ruler's red case |

What the camera shows: in 01 the glove covers her mouth on the broadcast angle, so the eye reads a landed cross although the
glove front is 16.5 cm off the face point. The gap is along the camera's depth. So both readings of the S464 bisect hold
partly: the game camera hides it at this angle, but a side angle or a close-up (the 1.5 s big-shot close-up) would show it.
Not closed by this page: one landed of two is short.

Next (step 2, the fix's own brief): which of the POWER1 stack (ReachLimit 0.30 m cap / ReachDrive) holds clip _c's contact
at 0.400 short; film the same seed's punch from the side camera (hit_frame_film `_side_cam`) to see the gap, and let the
operator judge the broadcast still first.

# LANDREACH1 step 2 - the cause and the fix (S466, Claude)

## Bisect (worktree wt/LEAN_BISECT2, block_meet_test headless through godot_slot, CTRL_LANDED rear-hand rows)
| Commit | What | failures | rear cross to_face |
|---|---|---|---|
| 4b5ae5ed .. 1bdde793 | POWER1 step 1, step 2 wip | 2-3 | 0.01-0.05 |
| e0ed7035 | merge before d258cab0 | 0 | 0.008-0.015 |
| d258cab0 | POWER1 step 2 review round 1 | 11 | 0.08-0.16 |
| d258cab0 + its old tables (clip_contact/recovery/travel/punch_form) | data ruled out | 11 | 0.08-0.17 |
| d258cab0 + its old BeatClips.recovery | ruled out | 11 | 0.08-0.17 |
On main, also ruled out: the 0.30 m cap off (`-- nopunchrange`: worse), the chest lean at 30 deg (0.18 -> 0.15), full reach weight to contact,
`-- nopunchweight`, `-- norigcarry`, `-- nostopatrange` (all 15-20 cm short).

## Cause
d258cab0's `_note_shown` resets the landed glove's hit point to the glove AS DRAWN on the hit frame ("1-3 cm short of her face
point, or past it"), and the carry runs on from there. The rear hand was 13-19 cm short on that frame, so the hit point moved to
the short spot and the reach never closed the gap.

## Fix (ReachLimit.carry_base, SHOWN_M 0.02; PunchReach one line)
For the rear cross and rear hook only, the drawn glove is the carry's start only within 2 cm of the face point; further off, the
face point (the reach pulls the glove in). `-- nopunchrange` keeps the old rule (control arm).
| Ruler | main before | v2 (every punch, 2 cm) | shipped (rear cross + rear hook) |
|---|---|---|---|
| block_meet failures | 9 | 2 | 5 (rear hands 0.03-0.06 m, were 0.13-0.19; the rest are lead jab/hooks 5-9 cm, as before) |
| hit_frame failures | 11 | 14 (+4 THROUGH: lead jab/hooks, an uppercut carried 0.12-0.27 m through) | 10 |
| hit_carry failures | 34-38 (noise) | 36 | 32 |
Tried and dropped: SHOWN_M 0.04 (block_meet 4); the face only when short ALONG the punch line (block_meet 8: the rear glove is
off to the side, not short). Open: lead hooks 5-9 cm off (CTRL_LANDED), the move card partner (move_tip).
