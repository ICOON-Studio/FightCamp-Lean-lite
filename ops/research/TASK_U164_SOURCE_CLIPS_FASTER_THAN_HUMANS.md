# TASK_U164 - are the bought strike clips faster than real humans? (Cursor, research + tool, then a grounded fix)

Model: Composer, medium, `-p --force --trust`. Owner: cursor. Assigned S66, 2026-09-24.

## Why
The operator on take two: kicks "like bullets"; on take three (verbatim): "still some moves are being executed extremely
fast". Your U160 r4 / U162 / U163 r3 proved our playback is FAITHFUL (retarget 0.88x source, kicks 0.97x source on the
kicking foot). But U163 r3 also found the vendor `kickboxing_body_kick` foot peaks at 24.3 m/s, while roundhouse studies
report ~10-17 m/s (Gavagan & Sayers ~14.7 m/s; Falco et al. 2009). If the SOURCE is faster than a human, the operator is
right and playing it faithfully is the defect. CLAUDE.md: ground every realism rule in real studies FIRST, print the
study beside the number.

## Part 1 - the literature table (cite every row)
Peak linear velocity of the striking effector for: jab, cross/straight, hook, uppercut (fist/wrist), elbow, knee,
roundhouse/body kick, low kick, front kick/teep, side kick, spinning back kick - elite and amateur where both exist,
the measurement method (mocap / IMU / video), and n. NOT FOUND rather than invent.

## Part 2 - the census
For every bound strike clip (124): the STRIKING effector's world peak in the vendor clip (the effector that travels to
the target - prove which foot/hand, never the support limb: U163's lesson), class, and the ratio to the literature's
range for that class. Flag every clip above the real range's top, with the amount.

## Part 3 - the grounded fix, behind a switch `human_speed_tempo` (default OFF)
For flagged clips, a per-clip tempo that brings the effector peak to the top of the real range for its class (never
below it), applied in the playback path you already own. Print before/after beside the study. Then a 10 s side-by-side
OFF | ON on seed 92012 at a kick (`research/_captures/watch_loop/u164_human_speed_ab.mp4`, MP4 < 50 MB, via
`Tools\godot_hidden.ps1` + `tools/record_room.gd`), opened as a contact sheet before reporting - the operator's eye decides.

## Owned files
A new `Godot/tools/u164_source_speed_census.gd`, a new `Godot/assets/data/strike_speed_anchors.json` (the literature table,
every row with a citation), `scripts/FightStagePlayer.gd` (the per-clip tempo only), `scripts/FightWorldLiveScreen.gd`
(the switch only), a new `tests/fight_human_speed_test.gd` (ON: every flagged clip's peak inside its class range; OFF
byte-identical; mutants caught), `research/U164_DIGEST.md`.

## Gate (tier: scripts edited)
Parse gate; the new test with mutants; `--only fight_stage`, `--only fight_strike`, `--only fight_world` (one `--only`
per invocation). Branch `cursor/u164-human-speed` off `origin/master`, merging your `cursor/u163-take-four-kicks-hands`
first. Commit, push, `agent_comms.py send --from cursor --to claude --topic U164`. Do NOT edit HANDOFF.md.
Trap: a study's peak is measured on a specific point (toe, ankle, malleolus, fist) - compare the same point, and say which.

## REVIEW NOTES ON ROUND 1 FROM A STALE SESSION (S66, written after S68 had already collected U164 - NOT an assignment; the live session decides whether any of it still applies)
Concerns about round 1 (`2b7e4cde`, merged OFF by S68):
1. It took the effector from `clip_phases.json` - which names the PLANT foot for `kickboxing_body_kick` (your own U163 r3
   proved it: plant 2.47 m/s, striker 24.30 m/s) - so that kick came out "not flagged". Use U163 r3's
   `vendor_kick_foot_audit` / `kicking_foot_for_role` (both feet, the one that travels to target height), and the
   same idea for hands (the hand that travels to the target). Do not read the effector from clip_phases.json.
2. A 36.86 m/s overhand fist is not a human punch and probably not the arm either: say whether the vendor world peak
   includes ROOT MOTION / whole-body travel (a `_RootMotion` twin, a stepping entry). Studies measure the fist relative
   to the ground with the body's own motion included, so decide which is comparable, measure that, and state it.
3. `run_tests.py --only fight_strike` is 3/1 - `fight_strike_speed_test` now fails under the runner (`!is_inside_tree`).
   A runner red is a red; fix it.
4. The tempo floor 0.25 would play a clip at a quarter speed - if a clip needs < 0.6 to reach the real range, the clip
   is the wrong clip for the technique, not a tempo problem: flag it for re-binding instead of slowing it.
Same owned files and gate; digest under `## Round 2`. Trap: the same point the study measured, never the support limb.
