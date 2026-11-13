# Ailive Fab pack (owned, Downloads/boxing.zip): punch speed, stance and guard, measured (S447)

Owner S447: "also check how punch speed is affected" (after "you told me to buy that, so why should i trust you and buy the
2 other packs ?"). Measured headless on the six punch FBX files as shipped (FBXDocument at runtime, bone tracks sampled at
60 Hz, hand bone, scaled to a 1.62 m head height; probe: scratchpad tools/fbx_speed.gd, copy kept at tools/fbx_speed_probe.gd).

| Clip | Punching hand top speed | Our band | Feet apart: start / at the punch | Other hand below head bone at the punch |
|---|---|---|---|---|
| Jab (Punch_with_Left_Hand) | 4.7 m/s | 6-8 | 0.44 / 1.06 m | 0.13 m (at the chin) |
| Cross (Punch_with_Right_Hand) | 6.3 m/s | 7-9 | 0.45 / 1.01 m | 0.08 m |
| Lead hook | 11.0 m/s | 7-9 | 0.46 / 1.18 m | 0.07 m |
| Rear hook | 7.7 m/s | 7-9 | 0.45 / 1.09 m | -0.05 m (above the head) |
| Lead uppercut | 9.6 m/s | none | 0.41 / 1.12 m | 0.08 m |
| Rear uppercut | 8.6 m/s | none | 0.46 / 0.92 m | -0.12 m (above the head) |

Our own clips for comparison (CROSS_POWER_S439): glove face 4.4-5.4 m/s before POWER1's drive.

Read: the hooks and uppercuts are FAST (7.7-11 m/s, our clips' problem was the opposite) and the guard hand stays at the chin
on the lead-hand punches. But every clip starts from a relaxed stand (hands 0.77 m below the head, feet 0.45 m) and LUNGES
into a stance 0.9-1.2 m wide for the punch - the same width that dropped the footwork clip in S381 - and both rear-hand
punches lift the lead glove above the head (our rule: at most 0.03 m). The straight punches are as slow as ours.
Verdict: not usable as is; the speed of the hooks alone does not pay for the lunge. The probe runs on any FBX: run it on
the next packs the day they are bought, BEFORE any retarget work. Before buying, only the sellers' preview videos can be
judged (frame timing gives a rough speed; stance and guard are visible).

## All 10 clips on our boxer, filmed (S447, owner: "can you try them all ?", "do you have the original clip next to ours ?")
Baked with tools/owned_mocap_bake.gd batch (UE5 Manny rig read directly, 0 errors) into assets/anim/baked/ailive_trial/
(not committed, not wired), filmed pure with tools/owned_mocap_film.gd view=-90 on mh_boxer_10 beside our matching clip.
Side-by-side films + stills: docs/mockups/s447/ailive_vs_ours/ (Ailive left, ours right); review board 2026-11-13_0920.
S381 had kept NO picture of what it dropped - these are the first side-by-sides.
Claude's eyes at the contact frames: the Ailive punches are more athletic than ours - the jab is a real stepping jab with the
rear glove at the chin; our lead hook is thrown with a near-straight arm at shoulder height (reads like a cross) and our jab
frame shows both gloves forward. But every Ailive punch starts from a relaxed stand and steps into a very wide, deep stance
(the rear hook drops the back knee nearly to the floor). The owner's point stands: speed and glove height are things our code
already corrects; the stance depth is the capture's own. Use, if he likes them: cut guard-to-guard around the contact (S273
plan) for a STEPPING take of each punch, the S430 stepping route.
