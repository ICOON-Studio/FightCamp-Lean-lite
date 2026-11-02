# TASK U203 - CHOP3: the gloves stop popping (Cursor, S133)

Model: composer-2.5. Worktree `D:/FightCamp/wt/U201` re-branched `cursor/u203-hand-pops` from master.

## Why
Operator 2026-09-30 on the fight recording: "the video is so choppy". S133 (22a40ccf) fixed the ROOT hitches (contact
push ratchet, take-end lurch). `tools/s133_chop_probe.gd -- as_game` now reads HITCHES 35 / POPS 103 over 30 s, and the
HANDS carry most of them (per point: LeftHand/RightHand 10-16 pops each vs Root 7-13). A pop = a point that moves > 5 cm
one frame and straight back the next. You know this code: U196-U198 were yours.

## Prior research
`S133_DIGEST.md` section 6 (the method), `S132_DIGEST.md` (hand writers, head stop, BUL1), `S131_DIGEST.md`
(`hands_smooth_in_whole`), `U198_DIGEST.md`. The room has a per-stage hook: `live.debug_stage_observer` (Callable(stage))
- see how S133 used it (the digest) to find WHICH pass writes the pop.

## What would a human do?
An animation programmer: record the hand position after every room stage on a pop frame, find the pass that moves the
glove out and the pass that moves it back, then make the two agree (carry the correction, or rate-limit it) - never
hide it with a blanket smoothing filter that would also blur real punches.

## Prefab check
None - our room code. Measure with the existing probes; build nothing new except your trace.

## Owned files
`Godot/scripts/FightWorldLiveScreen.gd` (5600+ lines - never read whole; sed -n windows), `Godot/scripts/FightStagePlayer.gd`
(hand writer / `finish_hand_frame` / `settle_hand_offsets` windows only), `Godot/tools/s133_chop_probe.gd` (you may add
a per-point pop list), NEW `Godot/tools/u203_hand_trace.gd`, `research/U203_DIGEST.md`.
Every change behind its own room switch, game ON / `--script` OFF (the pattern of `contact_push_carry`).

## Gates (all on seed 92012, as_game)
1. `tools/s133_chop_probe.gd -- as_game`: hand pops (4 hand points) at least halve from today's ~54, total hitches do
   not rise; A/B with `off=<your switch>`.
2. `tools/s131_bullet_probe.gd -- offset=1 shuffle=1 as_game`: glove frames > 25 m/s stay 0, > 15 m/s stay <= 3.
3. `tools/s133_facing_split_probe.gd -- as_game`: LANDED glove-to-target at contact p50 not worse than 0.26 m.
4. `python Godot/tools/run_tests.py --jobs 2 --only fight_contact_stop,fight_reaction_whole,fight_room_no_teleport,fight_strike_whole,fight_world_live,fight_body_overlap`
   (fight_body_overlap was red before - report whether you changed it).
Parse gate before any run: `python Godot/tools/check_scripts.py <touched .gd>`.

## Deliver
Commit, `git push -u origin cursor/u203-hand-pops`, 12-line digest with before/after numbers of all three probes.

## The one trap
A smoothing filter on the hands lowers the pop count AND softens real punches (the bullet probe's glove speeds drop, the
glove misses its target). Fix the pass that disagrees; prove gate 3 did not get worse.
