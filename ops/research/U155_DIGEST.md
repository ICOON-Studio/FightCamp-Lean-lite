# U155 digest — arena scale and bounds

**Root cause (Part 1):** the live room drew `mma_cage_gym_6m` (6 m flats) while the operator expects the UFC 30 ft (9.14 m) cage; the octagon deck also used `top_radius = contest/2`, which is the apothem for an N-gon prism in Godot, shrinking flats ~7.6% further. **Fix:** MMA live room uses `mma_cage_ufc_30ft`; `ArenaRig` sets circumradius `(contest/2)/cos(π/n)` for N-gon decks/posts/fence alignment.

**Root cause (Part 2):** centre clamp left feet/hips outside the painted floor on kicks; **fix:** rate-limited `_contest_clamp_limbs` on octagon bouts (hips/feet/toes).

**Part 3:** report only — 45 frames >3 cm render overlap (worst 0.229 m at ~4 s); not fixed here.

**Gate:** `run_tests.py --only ring_space,arena,fight_world,fight_room_no_teleport` → 10/10; `fight_metres` hang/timeout (known, Q144).

## Part 1 — scale (seed 92012, MMA)

- contest meta (flat-to-flat): 9.144 m (UFC 30 ft = 9.14 m)
- canvas mesh flat-to-flat (world): 9.144 m
- _contest_half_m (apothem): 4.572 m
- _arena_half_m: 4.272 m (= contest_half - ROPE_BODY_MARGIN 0.30)
- fighter A posed height: 1.489 m
- fighter B posed height: 1.496 m
- mesh_width / mean_fighter_height: 6.13 (target ~5)

## Part 2 — bounds at 52 s

- frame 1560 (t=52.0s):
  A Hips xz=(1.350, 0.394) outside=0.0000 m root=(1.387, 0.401)
  A LeftFoot xz=(1.274, 0.433) outside=0.0000 m root=(1.387, 0.401)
  A RightFoot xz=(1.596, 0.406) outside=0.0000 m root=(1.387, 0.401)
  B Hips xz=(0.592, 0.131) outside=0.0000 m root=(0.558, 0.131)
  B LeftFoot xz=(0.762, 0.037) outside=0.0000 m root=(0.558, 0.131)
  B RightFoot xz=(0.432, 0.189) outside=0.0000 m root=(0.558, 0.131)
- max limb outside contest (whole take): 0.0000 m

## Part 3 — clipping (>3 cm render overlap, standing)

- frames_over: 45 / 1800
- longest_run_s: 0.200
- worst: t=4.03s depth=0.229 m clips= | 
