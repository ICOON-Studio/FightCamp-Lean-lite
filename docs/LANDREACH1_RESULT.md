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
