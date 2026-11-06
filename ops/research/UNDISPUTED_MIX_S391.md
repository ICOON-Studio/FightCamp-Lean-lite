# How Undisputed mixes movement, and what it means for ours (S391)

Operator: "did you also checked how it mixes the animartions , dodges etc", then "keep doing this research ahead to anticipate issues".
Read-only on his install, names and numbers only, nothing copied. Raw output: E:/FightCamp/tmp/undisputed_study/out/mix_S391.json.
Earlier passes: UNDISPUTED_STUDY_S254.md, E:/FightCamp/tmp/undisputed_study/footwork_S381.md.

## What was read
- Feet and body: motion matching over long takes, inertial blending, no plain crossfades (S381).
- Weave: one 12-clip pad per moveset, positions +-0.2 / +-0.5 / +-0.7, 0.83 s loops. Body centre barely moves inside a loop (under 1.5 cm), so the lean is the pose held. The offset of each pose from guard was NOT measured.
- Blend times, "MxM Default Variables": punch 0.15 s, slip 0.15 s, normal 0.30 s, block weave 0.45 s, weave 0.5 s.
- Body masks: Block = body, head, arms, fingers (no legs). BodyReaction = body, head, legs (no arms). HeadReaction = body and head only. WeaveBlock = whole body. Masks exist; how they are used at runtime is NOT confirmed. It reads as hits and blocks laid over the footwork, not replacing it.
- Hand IK: the database carries LH_IK_Smooth and RH_IK_Smooth curves, likely holding gloves through blends. Not confirmed.
- Slips are their own moves. Side slip 0.65-0.68 s, body drops ~19 cm at 0.37-0.45 s, ~5 cm sideways. Down slip drops ~30 cm. A slip is a level change.
- Dodges are steps: 0.45-0.75 m in 0.5-1.0 s.
- AI (tutorial settings): reaction time 0.10 s for block, dodge, slip, weave. Named settings: chance of each reaction, a post-weave counter chance, a minimum time between weave direction changes. Hook weave-out chance 0.5, uppercut 0.4.

## What it changed in ours
- GuardWeave (leaning) only runs between punches. BeatFire already gives every punch that does not land a defence clip, and a head leaving a punch that lands would read as a bug. My first version reacted to every punch: removed.
- Hip dip raised 7 cm to 12 cm.
- Single step and pivot clips dropped: 0 of 17 reached 7 blind (ops list below), and Undisputed's in-game databases do not use its step clips either.

## Measured in our fight (S391, about 200 s per arm, film tool log)
| | no weave | weave v1 |
| --- | --- | --- |
| body moving | 61-64 % of frames | 61-64 % |
| travel | 107-108 m | 102 m in 190 s |
| head over hips, side, p5-p95 | 7 cm | 14.5 cm |
They already move more than the 53-56 % real figure. It does not read as movement because the body glides under a guard pose.

## Blind clip scores (17 owned Mixamo clips in the fight stack)
0 at 7. 6: bouncing_boxing_idle, short_boxing_step_backward, boxing_left_side_step_walk. 5-5.5: the other side steps. 4-5: idles, step forward. 3-3.5: pivots. 2: dodge advance.
Repeat fault: our guard is high and square, the clips side-on with gloves lower, so every join swings hands and torso in 0.2-0.3 s. Part of that may be the test: GuardTuck only runs on its listed clips, and these were not listed. Unproved.

## Issues to expect
1. Our defence clips may be shallower or quicker than 19 cm over 0.65 s. Not measured yet.
2. Our built footwork is step-drag; Undisputed's real steps are gather-and-reach pairs, trailing foot first. Plan: both, picked per fighter.
3. No inertial blending here, so joins between weave and clips can pop. Blend numbers above are the target.
4. Hit reactions replace the whole body, so the feet stop. Masked reactions over the footwork are the likely big win.
